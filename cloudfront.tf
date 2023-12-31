resource "aws_cloudfront_origin_access_identity" "s3_access_identy" {
  comment = module.website_s3_bucket.s3_bucket_regional_domain_name
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled         = true
  count           = var.target_domain == null || var.cloudfront_distribution_for_redirection ? 1 : 0
  is_ipv6_enabled = true

  default_root_object = "index.html"

  aliases = [module.website_s3_bucket.s3_bucket]
  comment = var.target_domain != null ? "${var.domain} (redirecting to ${var.target_domain})" : "${var.domain} (S3 bucket)"

  # This type of origin does not resolve the index.html file for URLs not including it (aside from root level)
  # origin {
  #   domain_name = module.website_s3_bucket.s3_bucket_regional_domain_name
  #   origin_id   = "S3.${module.website_s3_bucket.s3_bucket}"
  #
  #   s3_origin_config {
  #     origin_access_identity = aws_cloudfront_origin_access_identity.s3_access_identy.cloudfront_access_identity_path
  #   }
  # }

  origin {
    domain_name = module.website_s3_bucket.s3_bucket_website_endpoint
    origin_id   = "S3.${module.website_s3_bucket.s3_bucket}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }


  # to enable virtual paths
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3.${module.website_s3_bucket.s3_bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
      headers = ["Origin"]
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
    compress    = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.default.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(local.common_tags, { Type = "website" })
}
