output "activation_code_arn" {
  value = aws_ssm_parameter.activation_code_default.arn
}

output "activation_id_arn" {
  value = aws_ssm_parameter.activation_id_default.arn
}