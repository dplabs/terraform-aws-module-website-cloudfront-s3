variable "domain" {
  description = "Domain name to deploy"
  type        = string
}

variable "target_domain" {
  description = "Domain name to redirect to"
  type        = string
  default     = null
}

variable "route53_zone_name" {
  description = "Name of the Route53 zone hosting this domain"
  type        = string
}

variable "tags" {
  description = "Tags to set for all resources"
  type        = map(string)
}
