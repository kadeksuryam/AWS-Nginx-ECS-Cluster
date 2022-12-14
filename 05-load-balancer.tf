resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_ecs_subnet[*].id
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "ecs_alb_tg" {
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs_vpc.id

  health_check {
    matcher = "200"
    path    = "/"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }
}
