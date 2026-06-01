import json
import os
import boto3
from decimal import Decimal

# Initialize DynamoDB

dynamodb = boto3.resource("dynamodb")

TABLE_NAME = os.environ.get("TABLE_NAME", "ezmart-products")
table = dynamodb.Table(TABLE_NAME)

class DecimalEncoder(json.JSONEncoder):
def default(self, obj):
if isinstance(obj, Decimal):
return float(obj)
return super().default(obj)

def lambda_handler(event, context):

```
try:

    http_method = event.get("httpMethod", "GET")

    # Get all products
    if http_method == "GET":

        response = table.scan()

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "*"
            },
            "body": json.dumps(
                response.get("Items", []),
                cls=DecimalEncoder
            )
        }

    return {
        "statusCode": 405,
        "body": json.dumps({
            "message": "Method not allowed"
        })
    }

except Exception as e:

    return {
        "statusCode": 500,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps({
            "error": str(e)
        })
    }
