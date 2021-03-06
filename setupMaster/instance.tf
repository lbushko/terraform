resource "aws_instance" "host" {
  ami                           = "${var.aws_ami_id}"
  instance_type                 = "${var.aws_instance_type}"
  count                         = "1"
  associate_public_ip_address   = "true"
  key_name                      = "${var.key_name}"
  security_groups               = ["${aws_security_group.qa_jmeterLoadlb.id}"]
  subnet_id                     = "${aws_subnet.qa_loadPubSN0-0.id}"
  tags { Name                   = "${var.aws_instance_name}" }

  provisioner "file" {
    source = "../testName.jmx"
    destination = "/home/ec2-user/testName.jmx"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("C:\\Users\\lbushko\\Desktop\\terraform\\.ssh\\keyLoadlb")}"
      host = "${self.public_ip}"
    }
  }

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("C:\\Users\\lbushko\\Desktop\\terraform\\.ssh\\keyLoadlb")}"
      host = "${self.public_ip}"
    }

    inline = [
              "sudo yum update -y",
              "sudo yum install -y docker",
              "sudo service docker start",
              "sudo usermod -a -G docker ec2-user",
              "sudo docker run -dit --name master -p 60000:60000 lbushko/jmeter:jmeter-master /bin/bash",
              "sudo docker cp testName.jmx master:/jmeter/apache-jmeter-3.2/bin/testName.jmx",
              "sudo docker exec -it master /bin/bash /jmeter/apache-jmeter-3.2/bin/jmeter -n -t /jmeter/apache-jmeter-3.2/bin/testName.jmx -Djava.rmi.server.hostname=${self.public_ip} -Dclient.rmi.localport=60000 -R${var.slave01IP},${var.slave02IP},${var.slave03IP} -l /jmeter/apache-jmeter-3.2/bin/reportJmeter.jtl",
              "sudo docker cp master:/jmeter/apache-jmeter-3.2/bin/reportJmeter.jtl reportJmeter.jtl"
    ]
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=no -i C:\\Users\\lbushko\\Desktop\\terraform\\.ssh\\keyLoadlb ec2-user@${self.public_ip}:/home/ec2-user/reportJmeter.jtl C:\\Users\\lbushko\\Desktop\\terraform\\reportJmeter.jtl"
  }

}