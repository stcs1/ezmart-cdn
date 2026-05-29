# resource "aws_lambda_function" "api" {
#   function_name = "ezmart-api"

#   filename = "lambda.zip"
#   handler  = "index.handler"
#   runtime  = "nodejs20.x"

#   role = aws_iam_role.lambda_role.arn

#   environment {
#     variables = {
#       TABLE_NAME = aws_dynamodb_table.products.name
#     }
#   }
# }