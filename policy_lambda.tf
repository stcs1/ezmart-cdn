# resource "aws_iam_role_policy" "lambda_dynamodb" {
#   name = "lambda-dynamodb-policy"
#   role = aws_iam_role.lambda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "dynamodb:Scan",
#           "dynamodb:GetItem",
#           "dynamodb:PutItem"
#         ]
#         Effect   = "Allow"
#         Resource = aws_dynamodb_table.products.arn
#       }
#     ]
#   })
# }

resource "aws_iam_role" "lambda_basic" {
  name = "ezmart-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "ezmart-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.products.arn
      }
    ]
  })
}
