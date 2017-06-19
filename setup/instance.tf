resource "aws_instance" "host" {
  ami                           = "${var.aws_ami_id}"
  instance_type                 = "${var.aws_instance_type}"
  count                         = "1"
  associate_public_ip_address   = "true"
  key_name                      = "${var.key_name}"
  security_groups               = ["${aws_security_group.qa_jmeterLoadlb.id}"]
  subnet_id                     = "${aws_subnet.qa_loadPubSN0-0.id}"
  tags { Name                   = "${var.aws_instance_name}" }

  provisioner "remote-exec" {
    inline = [
              "sudo yum update -y",
              "sudo yum install -y docker",
              "sudo service docker start",
              "sudo usermod -a -G docker ec2-user",
              "sudo docker run -dit -e LOCALIP=${self.public_ip} -p 1099:1099 -p 50000:50000 lbushko/jmeter:jmeter-serverAWS /bin/bash",
      ]
    connection {
      user = "ec2-user"
      private_key = "C:\\Users\\lbushko\\Desktop\\terraform_XXX\\.ssh\\keyLoadlb"
      host = "${self.public_ip}"
    }
  }
}