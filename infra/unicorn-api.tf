data "aws_ami" "amazon_x86_image" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "^al2023-ami-ecs.*"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "unicorn_vm" {
  ami           = data.aws_ami.amazon_x86_image.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.unicorn_api_security_group.id]
  key_name               = aws_key_pair.key_pair_for_ec2_instance.key_name
  iam_instance_profile   = aws_iam_instance_profile.unicorn_api_iam_profile.name
  user_data              = file("${path.module}/init-unicorn-api.sh")

  tags = {
    Name = "Unicorn"
  }
}

resource "aws_iam_instance_profile" "unicorn_api_iam_profile" {
  name = "unicorn-api-iam-profile"
  role = aws_iam_role.ec2_ecr_readonly_role.name
}

output "unicorn_vm_public_ip" {
  description = "Public IP address of the unicorn vm"
  value       = aws_instance.unicorn_vm.public_ip
}

output "unicorn_vm_public_ipv4_dns_name" {
  description = "Public IPv4 DNS name of the unicorn vm"
  value       = aws_instance.unicorn_vm.public_dns
}

resource "aws_security_group" "unicorn_api_security_group" {
  name = "unicorn-api-security-group"
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_http" {
  security_group_id = aws_security_group.unicorn_api_security_group.id
  description       = "allow ingress via port 80"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_https" {
  security_group_id = aws_security_group.unicorn_api_security_group.id

  description = "allow egress via port 443"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}
