variable "aws_regions" {
  type = "map"
  default = {
    virginia    = "us-east-1"
    ohio        = "us-east-2"
    california  = "us-west-1"
    oregon      = "us-west-2"
  }
  description   = "AWS Regions set-up"
}

variable "aws_amis" {
  type = "map"
  default = {
    virginia    = ""
    ohio        = "ami-4191b524"
    california  = "ami-7a85a01a"
    oregon      = "ami-4836a428"
  }
  description   = "Ami id according to region"
}

variable "aws_instances_names" {
  type = "map"
  default = {
    "slave01"   = "qa_jmeter_slave01"
    "slave02"   = "qa_jmeter_slave02"
    "slave03"   = "qa_jmeter_slave03"
    "master"    = "qa_jmeter_master"
  }
  description   = "EC2 instance names"
}