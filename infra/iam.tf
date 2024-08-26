
resource "aws_iam_role" "ec2_ecr_readonly_role" {
  name               = "ec2-ecr-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  inline_policy {
    name   = "ecr-read-policy"
    policy = data.aws_iam_policy_document.ec2_container_registry_read_only.json
  }
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_container_registry_read_only" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    resources = ["*"]
  }
}
