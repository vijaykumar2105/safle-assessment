resource "aws_lb" "safle_lb" {
  name               = "safle-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.safle_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet1.id]
}

resource "aws_lb_target_group" "safle_tg" {
  name     = "safle-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.safle.id
}

resource "aws_lb_listener" "safle_listener" {
  load_balancer_arn = aws_lb.safle_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.safle_tg.arn
  }
}