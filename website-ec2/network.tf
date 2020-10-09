//vpc.tf
resource "aws_vpc" "pushpakjha-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "pushpakjha-vpc"
  }
}

//subnets.tf
resource "aws_subnet" "subnet-uno" {
  cidr_block = cidrsubnet(aws_vpc.pushpakjha-vpc.cidr_block, 3, 1)
  vpc_id = aws_vpc.pushpakjha-vpc.id
  availability_zone = "us-west-2a"
}

resource "aws_route_table" "pushpakjha-route-table" {
  vpc_id = aws_vpc.pushpakjha-vpc.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pushpakjha-gw.id
  }
tags = {
    Name = "pushpakjha-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet-uno.id
  route_table_id = aws_route_table.pushpakjha-route-table.id
}


//security.tf
resource "aws_security_group" "ingress-all" {
// name = "allow-all-sg"
vpc_id = aws_vpc.pushpakjha-vpc.id
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
        to_port = 22
        protocol = "tcp"
      }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

//eip.tf
resource "aws_eip" "pushpakjha-ip" {
  instance = aws_instance.pushpakjha-ec2.id
  vpc      = true
}

//gateways.tf
resource "aws_internet_gateway" "pushpakjha-gw" {
  vpc_id = aws_vpc.pushpakjha-vpc.id
tags = {
    Name = "pushpakjha-gw"
  }
}