# AWS Security Incident Response Lab

## Overview
What the project does and why you built it.

## Architecture
GuardDuty → EventBridge → Lambda → EC2 quarantine
CloudTrail → S3 for investigation/evidence

## Technologies
Terraform, AWS, Python, GuardDuty, CloudTrail, Lambda,
EventBridge, EC2, IAM, S3, VPC

## What I Built
Short explanation of each major component.

## Incident Response Workflow
Detect → Triage → Investigate → Contain → Verify

## Automated Containment
Explain:
- severity >= 7
- AutoQuarantine=true
- DescribeInstances
- quarantine SG
- fail-safe behaviour

## Testing
Show:
- GuardDuty sample finding
- EventBridge triggered Lambda
- Lambda parsed finding
- invalid instance safely failed
- real test instance moved to quarantine SG
- SSH timed out afterwards

## Security Decisions
Least privilege
temporary EC2 credentials
private CloudTrail evidence bucket
explicit opt-in for automatic quarantine
quarantine rather than terminate

## Lessons Learned
IAM permissions
nested GuardDuty JSON
boto3
CloudTrail investigation
security automation safeguards
Terraform troubleshooting

## Future Improvements
SNS/Slack notification
EBS snapshot before quarantine
CloudTrail Lake/SIEM
more granular IAM
support more finding types