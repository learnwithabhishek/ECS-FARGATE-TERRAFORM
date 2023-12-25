resource "aws_security_group" "ecs_alb_security_group" {
  name   = "${var.ecs_cluster_name}-ALB-SG"
  vpc_id = aws_vpc.production-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "${var.ecs_service_name}-SG"
  description = "Security group for todo app deployed on fargate-ecs cluster"
  vpc_id = aws_vpc.production-vpc.id
  ingress {
    from_port   = 8000
    protocol    = "TCP"
    to_port     = 8000
    #cidr_blocks = [aws_vpc.production-vpc.cidr_block]
    security_groups = [aws_security_group.ecs_alb_security_group.id]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ecs_service_name}-SG"
  }

}