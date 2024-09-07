resource "aws_route53_zone" "example" {
  name = "example.com." # Replace with your domain
}

# Create an Application Load Balancer in the public subnets
resource "aws_lb" "public_lb" {
  name               = "public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [
    aws_subnet.public-eu-central-1a.id,
    aws_subnet.public-eu-central-1b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "public-lb"
  }
}

# Create a Route 53 alias record to point to the load balancer
resource "aws_route53_record" "public_lb_record" {
  zone_id = aws_route53_zone.example.id
  name    = "app.example.com."  # Replace with your desired subdomain
  type    = "A"

  alias {
    name                   = aws_lb.public_lb.dns_name
    zone_id                = aws_lb.public_lb.zone_id
    evaluate_target_health = true
  }
}