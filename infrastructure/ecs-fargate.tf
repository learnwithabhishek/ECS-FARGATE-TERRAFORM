resource "aws_ecs_cluster" "production-fargate-cluster" {
  name = "Production-fargate-cluster"
}

resource "aws_ecs_task_definition" "todo-app-task-definition" {
  container_definitions    = templatefile("./task_definition.json", {
    task_definition_name   = var.ecs_service_name
    ecs_service_name       = var.ecs_service_name
    app_profile            = "todo-app"
    docker_image_url       = var.docker_image_url
    memory                 = var.memory
    region                 = var.region
  } )
  family                   = var.ecs_service_name
  cpu                      = 256
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.fargate_iam_role.arn
  task_role_arn            = aws_iam_role.fargate_iam_role.arn
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  task_definition = var.ecs_service_name
  desired_count   = var.desired_task_number
  cluster         = aws_ecs_cluster.production-fargate-cluster.name
  launch_type     = "FARGATE"

  network_configuration {
    subnets           = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id, aws_subnet.private-subnet-3.id]
    security_groups   = [aws_security_group.app_security_group.id]
    assign_public_ip  = false
  }

  load_balancer {
    container_name   = var.ecs_service_name
    container_port   = 8000
    target_group_arn = aws_alb_target_group.ecs_default_tg.arn
  }
}

resource "aws_cloudwatch_log_group" "todo-app_log_group" {
  name = "${var.ecs_service_name}-LogGroup"
}