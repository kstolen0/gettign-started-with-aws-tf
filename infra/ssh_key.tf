resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "rsa_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "${path.module}/key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "key_pair_for_ec2_instance" {
  key_name   = "ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
