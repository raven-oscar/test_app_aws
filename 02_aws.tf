resource "aws_codedeploy_app" "test_app" {
  name             = "test_app"
  compute_platform = "Server"
}
resource "aws_sns_topic" "test_app" {
  name = "test_app"
}


resource "aws_launch_configuration" "test_app" {
  name_prefix                 = "test-app-"
  image_id                    = var.ImageId
  iam_instance_profile        = aws_iam_instance_profile.ec2_cd_instance_profile.name
  instance_type               = "t2.micro"
  key_name                    = "raven"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "test_app" {
  name                 = "test-app"
  launch_configuration = aws_launch_configuration.test_app.name
  min_size             = 3
  desired_capacity     = 3
  max_size             = 5
  health_check_type    = "EC2"
  target_group_arns = [
    aws_lb_target_group.test_app.arn
  ]
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = [
    aws_subnet.app_subnet_c1a.id,
    aws_subnet.app_subnet_c1b.id,
    aws_subnet.app_subnet_c1c.id
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_codedeploy_deployment_config" "test_app" {
  deployment_config_name = "CodeDeployDefault2.EC2AllAtOnce"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "test_app_dg1" {
  app_name              = aws_codedeploy_app.test_app.name
  deployment_group_name = "test_app"
  service_role_arn      = aws_iam_role.devops_codedeploy_role.arn


  trigger_configuration {
    trigger_events = ["DeploymentFailure", "DeploymentSuccess", "DeploymentFailure", "DeploymentStop",
    "InstanceStart", "InstanceSuccess", "InstanceFailure"]
    trigger_name       = "event-trigger"
    trigger_target_arn = aws_sns_topic.test_app.arn
  }

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }


  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.test_app.name
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [aws_autoscaling_group.test_app.id]
}