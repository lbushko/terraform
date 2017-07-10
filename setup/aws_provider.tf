provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  token       = "${var.aws_security_token}"
  region      = "${var.aws_region_name}"
}