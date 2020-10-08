resource "aws_route53_record" "main" {
  zone_id = var.route53_zone_id
  name    = "pushpakjha.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.pushpakjha-ip.public_ip]
}

resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = "www.pushpakjha.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.pushpakjha-ip.public_ip]
}