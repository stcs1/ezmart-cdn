import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["ezmart-products"])

def lambda_handler(event, context):

    body = json.loads(event["body"])

    product = {
        "productId": body["productId"],
        "name": body["name"],
        "category": body["category"],
        "price": body["price"]
    }

    table.put_item(Item=product)

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Product added successfully"
        })
    }