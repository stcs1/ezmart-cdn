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
Will add references to lambda and other aws documentations later.


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

Command to write batch-items from products.json file to aws dyanamodb
 aws dynamodb batch-write-item `             
>>   --request-items file://C:\Users\zahid\src\projects\ezmart\cdn-lambda-dyanamodb\products.json


Steps to add users to my frontend UI

To add users who can log in to your EZMart website, the best AWS-native approach is:

Frontend (HTML/JS on S3 + CloudFront)

Authentication service

Backend API

Database for user profiles

For your current setup (S3 static website + CloudFront + DynamoDB + Lambda), the easiest and most scalable solution is:

Use  Amazon Cognito for login/signup

Use  API Gateway +  AWS Lambda for backend APIs

Store user data in  Amazon DynamoDB

Recommended Architecture

https://images.openai.com/static-rsc-4/VlRSXD6U_kFUUYLyiQRKMxbPHjz7imQg20OK5r8RyrI2NlJsoPbH1R_8xBJ7ehBtmnuwAIMFbG4JocuHdI9eHIsPX6rh8vErhbMfP7qS1TX-t-eO6So8l4O8hleK09T7hIKzawiJuudYXFNnDkZwQ4ilvqyyBYIl83hUwcsuh7cXg4Gldj7VOJE7-kpOyM8q?purpose=fullsize

https://images.openai.com/static-rsc-4/bS1X6rA8_tqZDTH5hUTYbruG-_YkrV0zEpjhO2rEvktPYUEb_ZTCEUxZPdNd35BRQ1TjqCVs7T8rH6lT42QKPQcE2kVnYQUEnw4imV9pH0ESFwG2pVZKBfxCUrJoV9L4pLB7doHD0NoHTd71E9PG5bMHEKE5tywPiefUKv_teafJfrgB65YcIFhcS2ovNNJE?purpose=fullsize

https://images.openai.com/static-rsc-4/eXosG8bNNOwxUiEAe9RWXtliQzQyO3scKKeTTRzbvyLJs4UKC68YTiDDxjBMUijniA6nU_hptDYm7PzhMrkVE05XHvvFRXxTnfXk0KJf948KaDpFZP68_k3I-BT1IGP9d8nGPGmXL1T9yHwtZ3gDPCx3Dn5ZoWRfkV3Rp98XNclOEjVaq3lxYuLnN9OoVwNV?purpose=fullsize
6
Flow:

User → CloudFront → S3 Website
                    ↓
               Login Form
                    ↓
              Amazon Cognito
                    ↓
          JWT Access Token Returned
                    ↓
        API Gateway + Lambda
                    ↓
               DynamoDB
Step 1 — Create a Cognito User Pool
Go to:

Amazon Cognito Console

Then:

Create User Pool

Choose:

Email login

Password login

Configure:

Username = email

Password policy

Create App Client

Enable:

ALLOW_USER_PASSWORD_AUTH

Save:

User Pool ID

App Client ID

Example:

User Pool ID:
us-east-1_abc123

App Client ID:
4h6exampleclientid
Step 2 — Add Login HTML
Example login page:

<!DOCTYPE html>
<html>
<head>
  <title>EZMart Login</title>
</head>
<body>

<h2>Login</h2>

<input type="email" id="email" placeholder="Email">
<input type="password" id="password" placeholder="Password">

<button onclick="login()">Login</button>

<script src="https://cdn.jsdelivr.net/npm/amazon-cognito-identity-js@6.3.6/dist/amazon-cognito-identity.min.js"></script>

<script>
const poolData = {
  UserPoolId: 'us-east-1_abc123',
  ClientId: '4h6exampleclientid'
};

const userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

function login() {

  const authenticationData = {
    Username: document.getElementById("email").value,
    Password: document.getElementById("password").value
  };

  const authenticationDetails =
    new AmazonCognitoIdentity.AuthenticationDetails(authenticationData);

  const userData = {
    Username: document.getElementById("email").value,
    Pool: userPool
  };

  const cognitoUser =
    new AmazonCognitoIdentity.CognitoUser(userData);

  cognitoUser.authenticateUser(authenticationDetails, {

    onSuccess: function(result) {

      const token = result.getIdToken().getJwtToken();

      localStorage.setItem("token", token);

      alert("Login successful!");
    },

    onFailure: function(err) {
      alert(err.message || JSON.stringify(err));
    }
  });
}
</script>
</body>
</html>
Upload this to your S3 bucket.

Step 3 — Add Signup Page
Example:

<input type="email" id="email">
<input type="password" id="password">

<button onclick="signup()">Create Account</button>
JS:

function signup() {

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  userPool.signUp(email, password, [], null, function(err, result) {

    if (err) {
      alert(err.message || JSON.stringify(err));
      return;
    }

    alert("Signup successful!");
  });
}
Step 4 — Protect Your APIs
When calling Lambda APIs:

fetch("https://YOUR_API.execute-api.us-east-1.amazonaws.com/prod/products", {

  headers: {
    Authorization: localStorage.getItem("token")
  }
});
Then configure:

API Gateway Authorizer

Cognito User Pool Authorizer

This ensures only logged-in users can access your APIs.

Step 5 — Store User Profiles in DynamoDB
Example table:

ezmart-users
Structure:

userId	email	createdAt
123		2026-05-29
Recommended Features
You can later add:

Password reset

Email verification

Google login

Facebook login

Admin dashboard

Seller accounts

Buyer accounts

JWT session expiration

MFA authentication

Cheapest AWS Setup
Your cheapest production setup:

Service	Purpose
S3	Host frontend
CloudFront	CDN
Cognito	Authentication
API Gateway	APIs
Lambda	Backend
DynamoDB	User/product data
This is fully serverless and scales automatically.

Alternative (Not Recommended)
You could also:

Store usernames/passwords in DynamoDB

Build login manually in Lambda

But this is:

Less secure

Harder to maintain

Dangerous if passwords are stored improperly

Cognito is much safer.

Best Production Setup for EZMart

https://images.openai.com/static-rsc-4/U76RVh_58wrpl-dX92HIzn60r_hmoNrdaDaKwnmXmbpplummO8UjXDpSwRjy0jeAAlIQH6JMw0gyqfCNlHbFUNOfQg_JY_1xTDvSCZ__U7hAz3MtTNDKttT12srdtAX9woMidmYbDAyobDNBP6QRKgmHHQYQ76x79TmBRWjbwgG09YUBMvoWT3uP4MNBEsB7?purpose=fullsize

https://images.openai.com/static-rsc-4/i1C-pQrdi6pZSwqXB7KRX695j-9FO15I23htiSrhZjzbCoHrfUxuADmBZUgvikupi89UGizDmkZLNTixm8dPT62Qyml38yO-bFuY8A0-ov5CLV6g-gokG1UDHLggsHKmibRSb8ATkCkenxreMBegeUh8TqXsnWSOVqgMYX1z7lauD-5gG63kD8E30q6Kf-18?purpose=fullsize

https://images.openai.com/static-rsc-4/OCTzOtRZPtrkpujnZ7G0WhwJfJdvFOZYh00Q33ZbGxSbQo067rOOTmYYmQ0xx8DD49kmAErJz0lXp3C1Teneg20dC-ZsKXG2XB19YL26MDjOlds7xbGcf6j-DMX_qOm20HKXm85fL8OAj9rjLC-MbfIdkf6HDwm6Hq-qAynoYjMB6_PMmLneaYSCpPUSSbRm?purpose=fullsize
5
Recommended stack:

Frontend:
S3 + CloudFront

Authentication:
Cognito

Backend:
API Gateway + Lambda

Database:
DynamoDB
This is essentially how modern serverless applications are built on .



To Create a user Registration Page. Follow the steps below
For EZMart

If you're building EZMart, you could create a registration page:

Name
Email
Password
Phone
Address

and store:

{
  "user_id": "uuid",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "3025551234",
  "created_at": "2026-05-31T12:00:00Z"
}

If you already have your CloudFront + S3 + Lambda + DynamoDB setup running, I can generate the complete Terraform code for:

DynamoDB users table
Lambda function
API Gateway
Registration HTML page
Login page

that plugs directly into your existing EZMart infrastructure.

sure it is already running

Since your CloudFront + S3 + Lambda + DynamoDB environment is already running, you mainly need to add a User Registration API and connect it to your webpage.

DynamoDB Users Table

If you don't already have one:

aws dynamodb create-table \
  --table-name ezmart-users \
  --attribute-definitions AttributeName=user_id,AttributeType=S \
  --key-schema AttributeName=user_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
Lambda Function

Create a Lambda called create-user.

import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ezmart-users')

def lambda_handler(event, context):

    body = json.loads(event['body'])

    user = {
        "user_id": str(uuid.uuid4()),
        "name": body.get("name"),
        "email": body.get("email"),
        "created_at": datetime.utcnow().isoformat()
    }

    table.put_item(Item=user)

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(user)
    }
API Gateway

Create:

POST /users

Example:

https://your-api-id.execute-api.us-east-1.amazonaws.com/prod/users

Integrate it with the Lambda above.

Registration Form

Add this to your index.html or a dedicated register.html.

<div class="register-box">
    <h2>Create Account</h2>

    <input type="text" id="name" placeholder="Full Name">

    <input type="email" id="email" placeholder="Email Address">

    <button onclick="registerUser()">
        Create Account
    </button>

    <p id="status"></p>
</div>
JavaScript

Replace the API URL with your actual endpoint.

<script>
async function registerUser() {

    const name = document.getElementById("name").value;
    const email = document.getElementById("email").value;

    const response = await fetch(
        "https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/prod/users",
        {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                name,
                email
            })
        }
    );

    const data = await response.json();

    document.getElementById("status").innerHTML =
        "Account created successfully!";
}
</script>
If You're Using Terraform

You likely already have resources like:

resource "aws_dynamodb_table" "products" {}
resource "aws_lambda_function" "products_api" {}
resource "aws_api_gateway_rest_api" "api" {}

Add:

resource "aws_dynamodb_table" "users" {
  name         = "ezmart-users"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

Then point your new Lambda at:

environment {
  variables = {
    USERS_TABLE = aws_dynamodb_table.users.name
  }
}

For a production EZMart marketplace, I'd also recommend adding:

Password hashing (never store plain-text passwords).
Email uniqueness (use email as a secondary index or primary key).
User login with JWT tokens.
User profiles.
Product ownership (seller_id on products).
Order history.

A common DynamoDB design is:

Users Table

{
  "user_id": "uuid",
  "email": "john@example.com",
  "name": "John Doe"
}

Products Table

{
  "product_id": "101",
  "seller_id": "user_uuid",
  "name": "iPhone 15"
}

This lets you track which EZMart user owns each product.