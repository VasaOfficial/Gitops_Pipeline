resource "aws_launch_configuration" "lc" {
  name          = "main-lc"
  image_id      = "ami-12345678"  # Replace with a valid AMI ID
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.lc.id
  vpc_zone_identifier  = aws_subnet.private[*].id
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity

  tag {
    key                 = "Name"
    value               = "autoscaling-ec2"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [aws_lb_target_group.tg.arn]
}
