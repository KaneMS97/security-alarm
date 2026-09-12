resource "aws_cloudwatch_event_rule" "guardduty_rule" {
  name        = "guardduty-error"
  description = "Send alert in response to GuardDuty Finiding"

  event_pattern = jsonencode({
    detail-type = [
      "GuardDuty Finding"
    ]

    source = [
      "aws.guardduty"
    ]
  })
}

resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  datasources {
    s3_logs {
      enable = true
    }
  }
}

data "archive_file" "logs" {
  type        = "zip"
  source_file = "lambda/responder.py"
  output_path = "lambda/responder.zip"
}