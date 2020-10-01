terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.8.0"
    }
    mysql = {
      source = "terraform-providers/mysql"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "ec2_example" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
}

resource "aws_ecs_cluster" "app" {
  name = "ecs_cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ecs_cluster"
  requires_compatibilities = ["EC2"]
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "dash_app",
    "image": "372063237374.dkr.ecr.us-west-2.amazonaws.com/pushpak:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8050
      }
    ]
  }
]
DEFINITION
}

# Add database stuff later
/*
resource "aws_db_instance" "mysql_example" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
}

# Configure the MySQL provider based on the outcome of
# creating the aws_db_instance.
provider "mysql" {
  endpoint = "${aws_db_instance.default.endpoint}"
  username = "${aws_db_instance.default.username}"
  password = "${aws_db_instance.default.password}"
}
*/
