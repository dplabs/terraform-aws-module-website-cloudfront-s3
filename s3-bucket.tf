module "website_s3_bucket" {
  source = "github.com/dplabs/terraform-module-s3-bucket"
  #source = "../terraform-module-s3-bucket"

  domain_name = var.domain
  redirect_to = var.target_domain

  tags = local.common_tags
}
