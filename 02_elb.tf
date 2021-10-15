resource "aws_lb" "test_app" {
  name               = "test-app"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.app_subnet_c1a.id, aws_subnet.app_subnet_c1b.id, aws_subnet.app_subnet_c1c.id]
}

resource "aws_lb_target_group" "test_app" {
  name     = "test-app"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_task.id

  health_check {
    path = "/success"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "test_app" {
  load_balancer_arn = aws_lb.test_app.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.test_app.arn
    type             = "forward"
  }
}
resource "aws_lb_listener_rule" "test_app_rules" {
  listener_arn = aws_lb_listener.test_app.arn

  priority = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_app.arn
  }
  condition {
    path_pattern {
      values = ["/success"]
    }
  }
}