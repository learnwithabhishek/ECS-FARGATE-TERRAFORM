resource "aws_alb" "ecs_cluster_alb" {
  name               = "${var.ecs_cluster_name}-Alb"
  internal           = false
  security_groups    = [aws_security_group.ecs_alb_security_group.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]
  tags = {
    Name = "${var.ecs_cluster_name}-ALB"
  }
}

resource "aws_alb_target_group" "ecs_default_tg" {
 name     = "${var.ecs_cluster_name}-tg"
 port     = 8000
 protocol = "HTTP"
 vpc_id   = aws_vpc.production-vpc.id
 target_type = "ip"

 tags = {
   Name = "${var.ecs_cluster_name}-tg"
 }
}

resource "aws_alb_listener" "ecs-alb-https-listener" {
 load_balancer_arn = aws_alb.ecs_cluster_alb.arn
 port              = "80"
 protocol          = "HTTP"
 default_action {
   type             = "forward"
   target_group_arn = aws_alb_target_group.ecs_default_tg.arn
 }
 depends_on = [ aws_alb_target_group.ecs_default_tg ]
}
