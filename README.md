# AWS Website module

Terraform module that creates the required infrastructure in AWS to host a website, including:

- S3 bucket
- Cloudfront distribution
- Route53 DNS records
- SSL Certificates

## Usage

```
```

## Input parameters

| Parameter name | Description | Type | Default | Required |
| -------------- | ----------- |:----:|:-------:|:--------:|
| `domain` | | `string` | | yes |
| `route53_zone_name` | | `string` | | yes |
| `target_domain` | | `string` | | no |
| `tags` | | `string[]` | `[]` | no |

## Output parameters

| Parameter name | Description | Type |
| -------------- | ----------- |:----:|

## Authors

Module is maintained by [Daniel Pecos Martínez](https://github.com/dpecos) with help from [these awesome contributors](https://github.com/dplabs/terraform-module-website-cloudfront-s3/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](/LICENSE) for full details.
