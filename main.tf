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


resource "aws_instance" "app_server" {
  ami           = "ami-019374baf467d6601"
  instance_type = "t2.micro"

  tags = {
    Name = "DerricksAppServer"
  }
}

output "instance_instance_state" {
  description = "Public IP Address of the EC2 instance"
  value = aws_instance.app_server.instance_state
}

output "instance_instance_type" {
  description = "Public IP Address of the EC2 instance"
  value = aws_instance.app_server.instance_type
}