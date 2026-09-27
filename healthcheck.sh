#!/bin/bash
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

if systemctl is-active --quiet nginx; then
  VALUE=1
else
  VALUE=0
fi

aws cloudwatch put-metric-data --metric-name NginxHealth --namespace CustomApp --value $VALUE --dimensions InstanceId=$INSTANCE_ID
