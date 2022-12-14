resource "aws_iam_role" "ecs_autoscale_role" {
  name = "ecs_autoscale_role"

  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "application-autoscaling.amazonaws.com"
            },
            "Effect": "Allow"
            }
        ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale_policy_attachment" {
  role       = aws_iam_role.ecs_autoscale_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_appautoscaling_target" "ecs_target" {
  min_capacity       = 1
  max_capacity       = 10
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
}

resource "aws_appautoscaling_policy" "ecs_target_request_count" {
  name               = "ecs-target-request-count"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "app/${aws_lb.ecs_alb.name}/${basename("${aws_lb.ecs_alb.id}")}/targetgroup/${aws_lb_target_group.ecs_alb_tg.name}/${basename("${aws_lb_target_group.ecs_alb_tg.id}")}"
    }
    target_value = 10
  }
}
