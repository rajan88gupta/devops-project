
# Security Group
resource "aws_security_group" "app_sg" {
  name = "app-sg"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["122.63.130.176/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami           = "ami-01b14b7ad41e17ba4" # Amazon Linux 2 (update if needed)
  instance_type = "t2.micro"

  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -a -G docker ec2-user

              # Login to ECR
              aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 882127294927.dkr.ecr.us-east-		1.amazonaws.com/advanced-devops-app
              # Pull image
              docker pull 882127294927.dkr.ecr.us-east-1.amazonaws.com/advanced-devops-app:latest

              # Run container
              docker run -d -p 5000:5000 882127294927.dkr.ecr.us-east-1.amazonaws.com/advanced-devops-app:latest
              EOF

  tags = {
    Name = "DevOps-App-Server"
  }
}
