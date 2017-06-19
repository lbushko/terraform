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
    source = "../flightFX_API_load.jmx"
    destination = "/home/ec2-user/flightFX_API_load.jmx"

    connection {
      user = "ec2-user"
      private_key = "C:\\Users\\lbushko\\Desktop\\terraform_XXX\\.ssh\\keyLoadlb"
      host = "${self.public_ip}"
    }
  }

  provisioner "remote-exec" {

    connection {
      user = "ec2-user"
      private_key = "C:\\Users\\lbushko\\Desktop\\terraform_XXX\\.ssh\\keyLoadlb"
      host = "${self.public_ip}"
    }

    inline = [
              "sudo yum update -y",
              "sudo yum install -y docker",
              "sudo service docker start",
              "sudo usermod -a -G docker ec2-user",
              "sudo docker run -dit --name master -p 60000:60000 lbushko/jmeter:jmeter-master /bin/bash",
              "sudo docker cp flightFX_API_load.jmx master:/jmeter/apache-jmeter-3.2/bin/flightFX_API_load.jmx",
              "sudo docker exec -it master /bin/bash",
              "cd /jmeter/apache-jmeter-3.2/bin/",
              "./jmeter -n -t flightFX_API_load.jmx -Djava.rmi.server.hostname=${self.public_ip} -Dclient.rmi.localport=60000 -R${var.slavesIPs} -l ‘reportJmeter.jtl’",
              "exit",
              "sudo docker cp master:/jmeter/apache-jmeter-3.2/bin/reportJmeter.jtl reportJmeter.jtl"
    ]
  }

  provisioner "file" {
    source = "/home/ec2-user/reportJmeter.jtl"
    destination = "../reportJmeter.jtl"

    connection {
      user = "ec2-user"
      private_key = "C:\\Users\\lbushko\\Desktop\\terraform_XXX\\.ssh\\keyLoadlb"
      host = "${self.public_ip}"
    }
  }
}