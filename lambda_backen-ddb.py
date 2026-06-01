import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ezmart-users')

def lambda_handler(event, context):

    body = json.loads(event['body'])

    user = {
        "user_id": str(uuid.uuid4()),
        "name": body['name'],
        "email": body['email']
    }

    table.put_item(Item=user)

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps({
            "message": "User created",
            "user": user
        })
    }