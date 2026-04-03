variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  # Amazon Linux 2 AMI
  default = "ami-01b14b7ad41e17ba4"
}

variable "my_ip" {
  # Your current IP for SSH access
  default = "122.63.130.176/32"
}

variable "ecr_repo" {
  default = "882127294927.dkr.ecr.us-east-1.amazonaws.com/advanced-devops-app"
}
