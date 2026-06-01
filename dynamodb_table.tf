resource "aws_dynamodb_table" "products" {
  name         = "ezmart-products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "product_id"

  attribute {
    name = "product_id"
    type = "S"
  }
}
# Users table
resource "aws_dynamodb_table" "users" {
  name         = "ezmart-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}