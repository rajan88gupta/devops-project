
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "main-vpc" }
}

# Create a Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "main-subnet" }
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow SSH and App Port"
  vpc_id      = aws_vpc.main.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # App access (Port 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "DevOps-App-SG" }
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
 

  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    yum install docker -y
    service docker start
    usermod -a -G docker ec2-user

    # Login to ECR
    aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_repo}
    
    # Pull and run container
    docker pull ${var.ecr_repo}:latest
    docker run -d -p 5000:5000 ${var.ecr_repo}:latest
  EOT

  tags = { Name = "DevOps-App-Server" }
}
