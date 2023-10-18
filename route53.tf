data "aws_route53_zone" "main" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "root-a-cloudfront" {
  count = var.target_domain == null ? 1 : 0

  zone_id = data.aws_route53_zone.main.zone_id
  name    = module.website_s3_bucket.s3_bucket
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution[0].domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "root-a-s3-website-redirection" {
  count = var.target_domain == null ? 0 : 1

  zone_id = data.aws_route53_zone.main.zone_id
  name    = module.website_s3_bucket.s3_bucket
  type    = "A"

  alias {
    name                   = module.website_s3_bucket.s3_bucket_website_endpoint
    zone_id                = module.website_s3_bucket.s3_bucket_hosted_zone_id
    evaluate_target_health = false
  }
}
