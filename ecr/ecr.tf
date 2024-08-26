
resource "aws_ecr_repository" "unicorn_api_ecr" {
  name                 = "unicorn-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "unicorn_api_ecr_uri" {
  description = "The uri of the unicorn api ecr repository"
  value       = aws_ecr_repository.unicorn_api_ecr.repository_url
}
