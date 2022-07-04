resource "aws_autoscaling_group" "eng114_bogdana" {
  name = "${aws_launch_configuration.eng114_bogdana.name}-asg"

  min_size             = 1
  desired_capacity     = 1
  max_size             = 2

  health_check_type    = "ELB"
  load_balancers = [
    aws_elb.web_elb.id
  ]

  launch_configuration = aws_launch_configuration.eng114_bogdana.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    aws_subnet.public_eu_west_1c.id,
    aws_subnet.private_eu_west_1c.id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "eng114_bogdana"
    propagate_at_launch = true
  }

}

