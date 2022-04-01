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
  name     = "${var.alb-tg}-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.provider.id
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-http.arn
  }
}

resource "aws_lb_target_group_attachment" "alb-tg-attachment" {
  target_group_arn = aws_lb_target_group.alb-tg-http.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb" "nlb" {
  name               = "test-lb-tf"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.private-01.id, aws_subnet.private-02.id]

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "nlb-tg" {
  name        = "tf-nlb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.provider.id
}

resource "aws_lb_target_group_attachment" "nlb-attachment" {
  target_group_arn = aws_lb_target_group.nlb-tg.arn
  target_id        = aws_lb.alb.arn
  port             = aws_lb_listener.nlb_listener.port
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}