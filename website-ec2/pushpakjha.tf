terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "pushpakjha-ec2" {
  ami           = "ami-0c1ab2d66f996cd4b"
  instance_type = "t2.medium"
  key_name = "pushpakjha_ssh_key"
  subnet_id = aws_subnet.subnet-uno.id
  vpc_security_group_ids = [aws_security_group.ingress-all.id]
  associate_public_ip_address = true
}