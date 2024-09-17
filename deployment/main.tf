data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_role" {
  name = "iam_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_function" {
  type = "zip"
  source_dir = "${path.module}/../src"
  output_path = "handler.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename = "handler.zip"
  function_name = "python_terraform_lambda"
  role = aws_iam_role.iam_role.arn
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime = "python3.12"
  handler = "handler.lambda_handler"
}
