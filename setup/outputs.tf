output "aws_instance_ip" {
  value = "${aws_instance.host.public_ip}"
}