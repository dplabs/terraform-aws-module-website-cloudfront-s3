data "aws_route53_zone" "main" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = module.website_s3_bucket.s3_bucket
  type    = "A"

  alias {
    name                   = var.target_domain == null ? aws_cloudfront_distribution.s3_distribution[0].domain_name : aws_cloudfront_distribution.s3_distribution_redirection[0].domain_name
    zone_id                = var.target_domain == null ? aws_cloudfront_distribution.s3_distribution[0].hosted_zone_id : aws_cloudfront_distribution.s3_distribution_redirection[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}
