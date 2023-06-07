resource "aws_security_group" "controlplane" {
  vpc_id = var.vpc_id

  tags = merge({}, var.tags)
}

resource "aws_security_group_rule" "apiserver" {
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  security_group_id = aws_security_group.controlplane.id
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "supervisor" {
  from_port         = 9345
  to_port           = 9345
  protocol          = "tcp"
  security_group_id = aws_security_group.controlplane.id
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  security_group_id = aws_security_group.controlplane.id
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]
}
