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

# data "aws_ami" "latest-ubuntu" {
#   most_recent = true
#   owners = ["099720109477"] # Canonical

#     filter {
#         name   = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#     }

# }
# resource "aws_instance" "ec2_instance" {
#     # ami           = "${data.aws_ami.latest-ubuntu.id}"
#     ami           = "ami-0c1ab2d66f996cd4b"
#     instance_type = "t2.micro"
#     associate_public_ip_address = true
# }


provider "aws" {
  profile = "default"
  region  = "us-west-2"
}


resource "aws_ecs_cluster" "app" {
  name = "ecs_cluster_app"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "ecs_cluster"
  # memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "dash_app",
    "image": "372063237374.dkr.ecr.us-west-2.amazonaws.com/pushpak:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8050,
        "hostPort": 8081
      }
    ]
  }
]
DEFINITION
}


data "aws_ecs_task_definition" "app" {
  task_definition = "${aws_ecs_task_definition.app.family}"
}


resource "aws_ecs_service" "test-ecs-service" {
  	name            = "test-ecs-service"
  	cluster         = "${aws_ecs_cluster.app.id}"
  	task_definition = "${aws_ecs_task_definition.app.family}:${max("${aws_ecs_task_definition.app.revision}", "${data.aws_ecs_task_definition.app.revision}")}"
  	desired_count   = 2
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
