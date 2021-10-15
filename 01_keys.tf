resource "aws_key_pair" "host" {
  key_name   = var.KeyName
  public_key = var.PublicKey
}