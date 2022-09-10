terraform {
  required_providers {
    digitalocean = {
<<<<<<< HEAD
      source = "digitalocean/digitalocean"
      version = "2.17.0"
=======
      source  = "digitalocean/digitalocean"
      version = "2.0.1"
>>>>>>> origin/feature/media_server_v2
    }
  }
}

provider "digitalocean" {
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.pub_key_name
}


resource "digitalocean_droplet" "dsiprouter" {
  name     = "${var.dsiprouter_prefix}-dsip-${var.branch}${count.index}"
  count    = var.number_of_environments
  region   = "nyc1"
  size     = "1gb"
  image    = var.image
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.fingerprint]

<<<<<<< HEAD
        connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key_path)
        timeout = "5m"
        }

        provisioner "remote-exec" {
          inline = [
	"apt-get update -y && apt-get install -y git && cd /opt && git clone https://github.com/dOpensource/dsiprouter.git -b ${var.branch} && cd dsiprouter && ./dsiprouter.sh install -all && ${var.additional_commands}"
        ]
      }
=======
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key_path)
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update -y && sleep 30s && apt-get dist-upgrade -y && apt-get install -y git && cd /opt && git clone https://github.com/dOpensource/dsiprouter.git -b ${var.branch} && cd dsiprouter && ./dsiprouter.sh install -all"
    ]
  }
>>>>>>> origin/feature/media_server_v2
}
