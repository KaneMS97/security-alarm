data "archive_file" "logs" {
  type        = "zip"
  source_file = "lambda/responder.py"
  output_path = "lambda/responder.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.logs.output_path
  function_name    = "lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "responder.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.logs.output_base64sha256
  environment {
    variables = {
      QUARANTINE_SG_ID = aws_security_group.quarantine.id
    }
  }
}

resource "aws_cloudwatch_event_target" "lambda_event" {
  target_id = "Test"
  rule      = aws_cloudwatch_event_rule.guardduty_rule.name
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "lambda_permissions" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty_rule.arn
}