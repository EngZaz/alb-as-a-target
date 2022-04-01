resource "aws_lb" "alb" {
  name               = "alb"
  internal = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = [aws_subnet.private-01.id, aws_subnet.private-02.id]

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "alb-tg-http" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.provider.id
   health_check {
      path                = "/"
      protocol            = "HTTP"
      matcher             = "200"
      interval            = 15
      timeout             = 3
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on = [
    aws_lb_target_group.alb-tg-http
  ]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-http.arn
  }
}

resource "aws_lb_target_group_attachment" "alb-tg-attachment" {
  target_group_arn = aws_lb_target_group.alb-tg-http.arn
  target_id        = aws_instance.web.id
  port             = aws_lb_listener.alb-listener.port
}

resource "aws_lb" "nlb" {
  name               = "test-lb-tf"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.private-01.id, aws_subnet.private-02.id]
  depends_on = [
    aws_lb.alb
  ]
  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "nlb-tg" {
  name        = "nlb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.provider.id

}


resource "aws_lb_target_group_attachment" "nlb-attachment" {
  target_group_arn = aws_lb_target_group.nlb-tg.arn
  target_id        = aws_lb.alb.arn
  port             = aws_lb_listener.nlb-listener.port
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}

# Generate a random string to add it to the name of the Target Group
# resource "random_string" "alb_prefix" {
#   length  = 4
#   upper   = false
#   special = false
# }
