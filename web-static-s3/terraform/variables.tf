
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name, will be combined with a random suffix"
  type        = string
  default     = "static-website"
}

variable "github_repo_url" {
  description = "URL of the GitHub repository containing website files"
  type        = string
}

variable "github_repo_path" {
  description = "Path within the GitHub repository to the website files"
  type        = string
  default     = ""
}

variable "excluded_paths" {
  description = "List of paths to exclude from S3 sync (in addition to .git and .gitignore)"
  type        = list(string)
  default     = []
}


variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"  # Use only North America and Europe
}

variable "cloudfront_min_ttl" {
  description = "Minimum TTL for CloudFront cache"
  type        = number
  default     = 0
}

variable "cloudfront_default_ttl" {
  description = "Default TTL for CloudFront cache"
  type        = number
  default     = 3600  # 1 hour
}

variable "cloudfront_max_ttl" {
  description = "Maximum TTL for CloudFront cache"
  type        = number
  default     = 86400  # 24 hours
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}