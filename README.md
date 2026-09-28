# Self-Healing EC2 Infrastructure

Automated failure detection and self-recovery for an Nginx service on AWS EC2 — using CloudWatch, SNS, Lambda, and SSM, with no manual intervention needed.

## Problem
Servers fail. Manually detecting and restarting a crashed service means downtime and depends on a human being available. This project builds a system that detects the failure and fixes itself within minutes.

## Architecture

EC2 (Nginx) → Cron health-check script → CloudWatch custom metric
→ CloudWatch Alarm → SNS → Lambda → AWS SSM → Nginx auto-restarted
→ Email notification sent

## How it works
1. A Bash script (`healthcheck.sh`) runs every minute via cron, checking if Nginx is active, and pushes a custom metric (1 = healthy, 0 = down) to CloudWatch.
2. A CloudWatch Alarm watches this metric and triggers if it drops to 0 for 2 consecutive checks.
3. The alarm publishes to an SNS topic, which has two subscribers: an email alert and a Lambda function.
4. The Lambda function (`lambda_function.py`) uses AWS SSM to remotely run a command on the EC2 instance, restarting Nginx — without needing SSH keys or manual access.
5. The system recovers automatically, typically within 2-3 minutes of failure.

## Tech Used
- AWS EC2, CloudWatch, SNS, Lambda, Systems Manager (SSM), IAM
- Bash, Python (boto3)




## What I'd add next
- Replace the failed instance via an Auto Scaling Group instead of just restarting a service
- Slack notifications alongside email
- Extend health checks to monitor multiple services

## Files
- `healthcheck.sh` — health-check script run via cron
- `lambda_function.py` — remediation Lambda function
