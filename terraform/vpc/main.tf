#create VPC, Security group, subnet

# Create a VPC
resource "aws_vpc" "Testvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Testvpc"
  }
}

# Create a public subnet
resource "aws_subnet" "pb_sn" {
  vpc_id                  = aws_vpc.Testvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "pb_sn1"
  }
}

# Create a Security Group
resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.Testvpc.id
  name        = "my_sg"
  description = "Public security group allowing SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ✅ fixed: removed leading space
  }

  # App access (Port 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_sg"
  }
}