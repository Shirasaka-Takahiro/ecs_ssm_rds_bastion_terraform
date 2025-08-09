##SSM Parameter for Activation Code
resource "aws_ssm_parameter" "activation_code_default" {
  name        = "/${var.general_config["project"]}/${var.general_config["env"]}/ssm-act-code"
  description = "SSM Parameter for ${var.general_config["env"]} Activation Code"
  type        = "SecureString"
  value       = aws_ssm_activation.default.activation_code
}

##SSM Parameter for Activation ID
resource "aws_ssm_parameter" "activation_id_default" {
  name        = "/${var.general_config["project"]}/${var.general_config["env"]}/ssm-act-id"
  description = "SSM Parameter for ${var.general_config["env"]} Activation ID"
  type        = "SecureString"
  value       = aws_ssm_activation.default.id
}

##SSM Activation
resource "aws_ssm_activation" "default" {
  name               = "${var.general_config["project"]}-${var.general_config["env"]}-activation"
  description        = "SSM Activation for ${var.general_config["env"]}"
  iam_role           = aws_iam_role.activation_role.id
  registration_limit = "100"
  depends_on         = [aws_iam_role_policy_attachment.activation_role_attach]
}

##SSM IAM
data "aws_iam_policy_document" "activation_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "activation_role" {
  name               = "${var.general_config["project"]}-${var.general_config["env"]}-ssm-activation-role"
  assume_role_policy = data.aws_iam_policy_document.activation_assume_role.json
}

resource "aws_iam_role_policy_attachment" "activation_role_attach" {
  role       = aws_iam_role.activation_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}