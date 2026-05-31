resource "aws_lambda_function" "api" {
  function_name = "ezmart-api"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.products.name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_dynamodb
  ]
}
