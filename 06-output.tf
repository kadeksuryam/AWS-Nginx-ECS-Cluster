data "aws_lb" "ecs_alb" {
  arn = aws_lb.ecs_alb.arn
}

output "aws_lb_hostname" {
  value = data.aws_lb.ecs_alb.dns_name
}
