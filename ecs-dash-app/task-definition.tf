data "aws_ecs_task_definition" "dash_app" {
  task_definition = "${aws_ecs_task_definition.dash_app.family}"
}

resource "aws_ecs_task_definition" "dash_app" {
    family                = "hello_world"
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


resource "aws_ecs_service" "test-ecs-service" {
  	name            = "test-ecs-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.test-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.dash_app.family}:${max("${aws_ecs_task_definition.dash_app.revision}", "${data.aws_ecs_task_definition.dash_app.revision}")}"
  	desired_count   = 2

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group.arn}"
    	container_port    = 8050
    	container_name    = "dash_app"
	}
}