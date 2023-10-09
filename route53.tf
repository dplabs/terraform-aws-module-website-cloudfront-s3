data "aws_route53_zone" "main" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = module.website_s3_bucket.s3_bucket
  type    = "A"

  alias {
    name                   = var.target_domain == null ? aws_cloudfront_distribution.s3_distribution.domain_name : aws_cloudfront_distribution.s3_distribution_redirection.domain_name
    zone_id                = var.target_domain == null ? aws_cloudfront_distribution.s3_distribution.hosted_zone_id : aws_cloudfront_distribution.s3_distribution_redirection.hosted_zone_id
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
