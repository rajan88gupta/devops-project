module "vpc" {
    source = "./vpc"
  
}

module "ec2instance" {
    source = "./ec2instance"
  sn= module.vpc.pb_sn
  sg= module.vpc.sg
}