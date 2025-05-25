# For GitHub integration, we'll use a null resource with local-exec provisioner
resource "null_resource" "github_to_s3_sync" {
  triggers = {
    always_run = "${timestamp()}"  # This will run on every apply
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Clone GitHub repository
      git clone ${var.github_repo_url} repo

      # Create exclusion list based on .gitignore
      EXCLUDE_OPTS=""
      if [ -f "repo/.gitignore" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
          # Skip comments and empty lines
          if [[ $line != \#* && -n $line ]]; then
            # Remove leading/trailing whitespace
            line=$(echo "$line" | xargs)
            # Skip if empty after trimming
            if [ -n "$line" ]; then
              # Add to exclude options
              EXCLUDE_OPTS="$EXCLUDE_OPTS --exclude=\"$line\""
            fi
          fi
        done < repo/.gitignore
      fi

      # Exclude specific folders and files
      EXCLUDE_OPTS="$EXCLUDE_OPTS --exclude=\".git/*\" --exclude=\".gitignore\""

      # Add user-specified exclusions from Terraform variables
      for exclusion in ${join(" ", var.excluded_paths)}; do
        EXCLUDE_OPTS="$EXCLUDE_OPTS --exclude=\"$exclusion\""
      done

      # Sync repository contents to S3, applying exclusions
      eval aws s3 sync repo/${var.github_repo_path} s3://${aws_s3_bucket.website_bucket.bucket}/ --delete $EXCLUDE_OPTS

      # Clean up
      rm -rf repo
    EOT
  }

  depends_on = [aws_s3_bucket.website_bucket, aws_cloudfront_distribution.website_distribution]
}