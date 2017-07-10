variable "aws_region_name" {}
variable "aws_ami_id" {}
variable "aws_instance_name" {}

variable "aws_instance_type" {
  default = "t2.micro" }

variable "aws_access_key" {
  default = "xxx" }

variable "aws_secret_key" {
  default = "xxx"
}

variable "aws_security_token" {
  default = "xxx"
}

variable "key_name" {
  default = "keyLoadlb"
}

variable "slave01IP" {}
variable "slave02IP" {}
variable "slave03IP" {}