resource "aws_route53_zone" "main" {
  name = "example.com"  # Your domain
}

resource "aws_route53_record" "alb_dns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
