import json
import boto3
import os

ec2 = boto3.client("ec2")
quarantine_sg_id = os.environ["QUARANTINE_SG_ID"]


def lambda_handler(event, context):
    detail = event["detail"]
    finding_type = detail["type"]
    severity = detail["severity"]
    title = detail["title"]
    region = detail["region"]
    resource = detail["resource"]["resourceType"]
    action = detail["service"]["action"]["actionType"]
    auto_quarantine = "false"

    instance_id = detail["resource"]["instanceDetails"]["instanceId"]
    try:
        response = ec2.describe_instances(
            InstanceIds=[instance_id]
            )
    except Exception as error:
        print(f"Unable to investigate instance {instance_id}: {error}")
        return {
            "statusCode": 200,
            "body": "Finding logged but instance could not be investigated"
        }
    tags = response["Reservations"][0]["Instances"][0]["Tags"]

    for tag in tags:
        if tag["Key"] == "AutoQuarantine":
            auto_quarantine = tag["Value"]
    try:
        if auto_quarantine == "true" and severity >= 7:
            print("Instance is approved for automatic quarantine")

            ec2.modify_instance_attribute(
                InstanceId=instance_id,
                Groups=[quarantine_sg_id]
            )

            print(f"Instance {instance_id} moved to quarantine security group")
        else:
            print("Instance is NOT approved for automatic quarantine")
    except Exception as error:
        print(f"Unable to quarantine instance {instance_id}: {error}")
        return {
            "statusCode": 200,
            "body": "Finding logged but instance action failed"
        }

    print(f"""
        === GUARDDUTY SECURITY FINDING ===
        Finding Type: {finding_type}
        Severity: {severity}
        Title: {title}
        Region: {region}
        Resource: {resource}
        Action: {action}
        AutoQuarantine: {auto_quarantine}
        Instance ID: {instance_id}
        """)
    
    return {
        "statusCode": 200,
        "body": "GuardDuty finding received"        
    }

