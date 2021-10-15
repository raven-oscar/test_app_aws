source "amazon-ebs" "ubuntu" {
  ami_name       = "app-v1-0-0"
  instance_type  = "t2.micro"

  region     = "eu-central-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-*-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
      "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file           = "../ansible/code-deploy.yml"
    user                    = "ubuntu"
    ssh_authorized_key_file = "/home/raven/.ssh/id_rsa.pub"
    keep_inventory_file = false
    use_proxy = false
  }
}