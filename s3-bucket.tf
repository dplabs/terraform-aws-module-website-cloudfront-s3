module "website_s3_bucket" {
  source = "github.com/dplabs/terraform-module-private-s3-bucket"

  bucket      = var.domain
  redirect_to = var.target_domain
  tags        = merge(local.common_tags, { Type = var.target_domain == null ? "website" : "website-redirection" })
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "CloudFront"
    actions   = ["s3:GetObject"]
    resources = ["${module.website_s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_access_identy.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "website_s3_bucket" {
  bucket = module.website_s3_bucket.s3_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
