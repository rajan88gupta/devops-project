resource "aws_instance" "server" {
 
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    subnet_id = var.sn
    security_groups = [var.sg]
    key_name = "devops-key"   # 👈 IMPORTANT (same name as AWS key)

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