resource "aws_ecs_cluster" "main" {
  name = "main"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "nginx-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 1024
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "nginx",
      "image"     : "nginx:1.23.1",
      "cpu"       : 256,
      "memory"    : 1024,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "ecs_service" {
  name                 = "nginx-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.ecs_task.id
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private_ecs_subnet[*].id
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_sg.id,
      aws_security_group.lb_sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.ecs_alb_listener
  ]
}
