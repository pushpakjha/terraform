terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

resource "docker_container" "ec2-dash-app" {
  image = "ec2-dash-app:latest"
  name  = "ec2-dash-app"
  restart = "always"
  volumes {
    container_path  = "/app"
    # replace the host_path with full path for your project directory starting from root directory /
    host_path = "/Users/pushpakjha/repos/terraform/ec2-ubuntu/app"
    read_only = false
  }
  ports {
    internal = 8050
    external = 8080
  }
}