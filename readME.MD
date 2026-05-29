EZMart LLC website, a good AWS architecture with Terraform would look like this:

Recommended AWS Architecture
see links below for architecture diagrams

Recommended AWS Architecture

https://images.openai.com/static-rsc-4/XT-mWWYhZVcPpIJ3s6A_p4AC-91z6DgbrqVKhIheI0afXwh4xgRB1tX_1uyUPyoCywb3YDnvq5g7JdGxTYrykVXrfhdg0EtasVbX-5iVTxRggYLoX7YdM4AwS3Tpi52tsjJuWA8QOQVfRbi4GrKal8yPVYTc13YVW6Dm5qYaFXSXioJSOZ2ki0peoHkClvcP?purpose=fullsize

https://images.openai.com/static-rsc-4/BktCNZN-ph4WzbA2A-Zcv8vBJfufUxwS1VpPFMlFq4t2OdWJjuRemJQBsq1jArgdsmPa9rGHBjoxldkoBKmhYsBYC_gdT2-tQFcO6dHbgaGWSqxzAh_LwE3IkoeGtil51h06x_KT2DaO2qgdhPW_XUcDZwfYkUOUCbdgDb-LjpwgBWjlfVy0VEmJmwjbUT4P?purpose=fullsize

https://images.openai.com/static-rsc-4/x5fC9rkJBSJMsI9HOLLT9DrU4clS4r3XNHZERuYp8GAB5ggw3Fo2xZKxUqB4RHswOKeSn93w9x91ZJgHpjVsQJ3vw4H1kq4dVXtAzCfZxLV-Pu2jKdSavWKgVo0pZpzzk83kHkGouSOs08bYzPmleV3Fib7IFtJ9SjO8upXE6HiOe0qixprZ7xcNTzO8h2rw?purpose=fullsize
6
Components
Amazon S3

Hosts your frontend website (HTML/CSS/JS)

Amazon CloudFront (CDN)

Fast global delivery

HTTPS support

Caching

AWS Lambda

Backend logic

Product search

Cart API

Trade Hub API

Amazon API Gateway

Connects frontend to Lambda

Amazon DynamoDB

Stores products, users, carts, trades

Terraform

Creates everything automatically

Suggested Folder Structure
ezmart-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
│
├── modules/
│   ├── s3/
│   ├── cloudfront/
│   ├── lambda/
│   ├── dynamodb/
│   └── api-gateway/
│
└── lambda-code/
    └── index.py
Terraform Example
1. Provider
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
2. S3 Static Website Bucket
resource "aws_s3_bucket" "website" {
  bucket = "ezmart-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}
3. DynamoDB Table
resource "aws_dynamodb_table" "products" {
  name         = "ezmart-products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "product_id"

  attribute {
    name = "product_id"
    type = "S"
  }
}
4. IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "ezmart_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
5. Lambda Function
resource "aws_lambda_function" "api" {
  function_name = "ezmart-api"

  filename      = "lambda.zip"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.products.name
    }
  }
}
6. API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "ezmart-http-api"
  protocol_type = "HTTP"
}
7. CloudFront CDN
resource "aws_cloudfront_distribution" "cdn" {

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "s3Origin"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]

    cached_methods = ["GET", "HEAD"]

    target_origin_id = "s3Origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
Lambda Example (Node.js)
exports.handler = async (event) => {

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: "Welcome to EZMart API"
        })
    };
};
Deployment Commands
terraform init
terraform plan
terraform apply
Estimated Monthly Cost
Service	Approx Cost
S3	Very low
CloudFront CDN	Low
Lambda	Almost free for small traffic
DynamoDB	Low
API Gateway	Low
This architecture is very cost-efficient for a startup marketplace like EZMart LLC.

Recommended Next Features for EZMart
You can later add:

User login

Product uploads

Shopping cart

Trade offers

Stripe payments

Search engine

Admin dashboard

Image uploads

Order tracking

Useful AWS Documentation:

AWS Terraform Provider

AWS CloudFront Documentation

AWS Lambda Documentation

Terraform Documentation



1 / 6
Hosting static website and accessing AWS Data from webpages
Serverless patterns in AWS

Web application - Serverless Applications Lens
AWS Solutions Constructs
Marrying Terraform and Serverless Framework



devopsaddict
Hosting static website and accessing AWS Data from webpages
Components
Amazon S3
Hosts your frontend website (HTML/CSS/JS)
Amazon CloudFront (CDN)
Fast global delivery
HTTPS support
Caching
AWS Lambda
Backend logic
Product search
Cart API
Trade Hub API
Amazon API Gateway
Connects frontend to Lambda
Amazon DynamoDB
Stores products, users, carts, trades
Terraform
Creates everything automatically
Suggested Folder Structure
ezmart-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
│
├── modules/
│   ├── s3/
│   ├── cloudfront/
│   ├── lambda/
│   ├── dynamodb/
│   └── api-gateway/
│
└── lambda-code/
    └── index.py


    Notes:
    command to create a zip file
    Compress-Archive -Path lambda_function.py -DestinationPath lambda.zip

    Suggested DynamoDB Design for EZMart
Products Table
Field	Type
product_id	String
title	String
price	Number
category	String
image_url	String
seller_id	String
Future Python Features You Can Add
Product Search
response = table.scan(
    FilterExpression="contains(title, :q)",
    ExpressionAttributeValues={
        ":q": "laptop"
    }
)
Add Product
aws dynamodb put-item `
    --table-name products `
    --item '{
        "product_id": {"S": "101"},
        "name": {"S": "Laptop"},
        "category": {"S": "Electronics"},
        "price": {"N": "799"},
        "stock": {"N": "25"}
    }'
Recommended Stack for EZMart
Layer	Technology
Frontend	HTML/CSS/JS
CDN	AWS CloudFront
Hosting	S3
Backend	AWS Lambda (Python)
Database	DynamoDB
Infrastructure	Terraform

This is a strong low-cost serverless architecture for a marketplace website.

zip lambda.zip lambda_function.py
bash: zip: command not found

Your system does not have the zip utility installed. You can fix it depending on your operating system.

Ubuntu / Debian
sudo apt update
sudo apt install zip -y

Then create the Lambda package:

zip lambda.zip lambda_function.py
Amazon Linux / RHEL / CentOS
sudo yum install zip -y
macOS

zip is usually already installed.

Check:

zip -v
Windows PowerShell

You can create the ZIP without installing anything:

Compress-Archive -Path lambda_function.py -DestinationPath lambda.zip
Better Lambda Packaging Method

For real projects, use this structure:

lambda/
├── lambda_function.py
├── requirements.txt

Install dependencies:

pip install -r requirements.txt -t .

Then zip everything:

zip -r lambda.zip .
Terraform Tip

Add this so Terraform automatically redeploys Lambda when code changes:

source_code_hash = filebase64sha256("lambda.zip")

Inside your Lambda resource:

resource "aws_lambda_function" "api" {
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  ...
}

This is important because otherwise Terraform may not detect Lambda code updates.

To write to AWS dynamodb powershell script/payload:

Command to write batch-items from .json file to aws dyanamodb
 aws dynamodb batch-write-item `             
>>   --request-items file://C:\Users\zahid\src\projects\ezmart\cdn-lambda-dyanamodb\products.json