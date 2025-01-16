resource "aws_appautoscaling_target" "ecs_service" {
  max_capacity       = var.autoscaler_max_size
  min_capacity       = var.autoscaler_min_size
  resource_id        = "service/${aws_ecs_cluster.safle_cluster.name}/${aws_ecs_service.safle_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_out" {
  name                   = "scale-out"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension     = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace      = aws_appautoscaling_target.ecs_service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 50.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_out_cooldown  = 60
    scale_in_cooldown   = 60
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name                   = "scale-in"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension     = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace      = aws_appautoscaling_target.ecs_service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 80.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_out_cooldown  = 60
    scale_in_cooldown   = 60
  }
}