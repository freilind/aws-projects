
aws_region          = "us-east-1"
bucket_name_prefix  = "s3bck-st-web"
github_repo_url     = "https://github.com/freilind/hanoi.git"
github_repo_path    = ""
cloudfront_price_class = "PriceClass_100"
tags = {
  Environment = "Production"
  Project     = "StaticWebsite"
  Owner       = "DevOps"
}

excluded_paths = [
  "node_modules/*",
  ".vscode/*",
  "README.md",
  "terraform/*"
]
