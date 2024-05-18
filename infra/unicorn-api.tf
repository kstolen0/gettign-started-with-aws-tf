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

  tags = {
    Name = "Unicorn"
  }
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

resource "aws_vpc_security_group_ingress_rule" "allow_from_local_device" {
  security_group_id = aws_security_group.unicorn_api_security_group.id
  description       = "allow ingress on any port from my ip"
  cidr_ipv4         = "203.63.152.127/32"
  ip_protocol       = -1
}
