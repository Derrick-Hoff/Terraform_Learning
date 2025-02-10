 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-2"
}

resource "aws_vpc" "WebSite_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "DerricksAppServer"
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"

  tags = {
    Name = "DerricksAppServer"
  }

  user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y curl wget git vim htop
    sudo yum install -y httpd
    sudo systemctl enable httpd
    sudo systemctl start httpd
  EOT
}

output "instance_instance_state" {
  description = "Public IP Address of the EC2 instance"
  value = aws_instance.app_server.instance_state
}

output "instance_instance_type" {
  description = "Public IP Address of the EC2 instance"
  value = aws_instance.app_server.instance_type
}
