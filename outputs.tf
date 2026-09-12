output "ec2_public_ip" {
  value = aws_instance.security_ec2.public_ip
}