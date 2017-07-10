module "slave01" {
  source            = "./setup"
  aws_ami_id        = "${var.aws_amis["virginia"]}"
  aws_region_name   = "${var.aws_regions["virginia"]}"
  aws_instance_name = "${var.aws_instances_names["slave01"]}"
}

module "slave02" {
  source            = "./setup"
  aws_ami_id        = "${var.aws_amis["california"]}"
  aws_region_name   = "${var.aws_regions["california"]}"
  aws_instance_name = "${var.aws_instances_names["slave02"]}"
}

module "slave03" {
  source            = "./setup"
  aws_ami_id        = "${var.aws_amis["oregon"]}"
  aws_region_name   = "${var.aws_regions["oregon"]}"
  aws_instance_name = "${var.aws_instances_names["slave03"]}"
}

module "master" {
  source            = "./setupMaster"
  aws_ami_id        = "${var.aws_amis["ohio"]}"
  aws_region_name   = "${var.aws_regions["ohio"]}"
  aws_instance_name = "${var.aws_instances_names["master"]}"
  slave01IP         = "${module.slave01.aws_instance_ip}"
  slave02IP         = "${module.slave02.aws_instance_ip}"
  slave03IP         = "${module.slave03.aws_instance_ip}"
}