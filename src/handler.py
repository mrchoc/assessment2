import json

with open("users.json", "r") as file:
    users = json.load(file)


def lambda_handler(event, context):
    return {"statusCode": 200, "body": json.dumps(users)}
