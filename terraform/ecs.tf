resource "aws_ecs_cluster" "safle_cluster" {
  name = "safle-cluster"
}

resource "aws_ecs_task_definition" "safle_task" {
  family                   = "safle-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "safle-container"
      image = "654654481693.dkr.ecr.us-east-1.amazonaws.com/safle:latest"
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "safle_service" {
  name            = "safle-service"
  cluster         = aws_ecs_cluster.safle_cluster.id
  task_definition = aws_ecs_task_definition.safle_task.arn
  desired_count   = var.autoscaler_min_size

  network_configuration {
    subnets         = [aws_subnet.public_subnet.id]
    security_groups = [aws_security_group.safle_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.safle_tg.arn
    container_name   = "safle-container"
    container_port   = 8000
  }
}