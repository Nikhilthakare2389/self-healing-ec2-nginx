import boto3

def lambda_handler(event, context):
    ssm = boto3.client('ssm')
    response = ssm.send_command(
        InstanceIds=['YOUR-instance-id'],
        DocumentName='AWS-RunShellScript',
        Parameters={'commands': ['sudo systemctl restart nginx']}
    )
    return {
        'statusCode': 200,
        'commandId': response['Command']['CommandId'],
        'status': response['Command']['Status']
    }
