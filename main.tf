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

resource "aws_vpc" "Website_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "DerricksAppServer"
  }
}



# Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.Website_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "DerricksAppSubnet"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Website_vpc.id

  tags = {
    Name = "DerricksInternetGateway"
  }
}




# Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Website_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "DerricksPublicRouteTable"
  }
}


# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.Website_vpc.id

  # Allow SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP for security
  }

  # Allow HTTP Access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DerricksAppServerSecuirtyGroup"
  }
}



resource "aws_instance" "app_server1" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"
  
  subnet_id              = aws_subnet.public_subnet.id # Attach to a public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "DerricksAppServer1"
  }
}


resource "aws_instance" "app_server2" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"

    subnet_id              = aws_subnet.public_subnet.id # Attach to a public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "DerricksAppServer2"
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

resource "aws_key_pair" "EC2_key" {
  key_name = "ec2_key"
  public_key = file("~/.ssh/ec2key.pub")
}
