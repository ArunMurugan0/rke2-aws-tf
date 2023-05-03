#
# Role
#
data "aws_iam_policy_document" "ec2_access" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_policy" "ec2_ebs_policy" {
  name = "ec2_ebs_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeVolumes"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy   = data.aws_iam_policy_document.ec2_access.json
  permissions_boundary = var.permissions_boundary

  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "ec2_ebs_role_policy" {
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ec2_ebs_policy.arn
}

#
# Profile
#
resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
}
