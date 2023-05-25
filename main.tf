# Define Provide values
provider "google" {
  project     = var.project              // Defined in terraform.tfvars
  region      = var.region               // Defined in terraform.tfvars
  credentials = file("credentials.json") // PATH to SA account key to generate resources (Project Owner)
}

# Firewall rule to all port 22
resource "google_compute_firewall" "ssh-allow-firewall" {
  name    = "gritfy-firewall-externalssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}

# Firewall rule to all port 443
resource "google_compute_firewall" "https-allow-firewall" {
  name    = "gritfy-webserver"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["webserver"]
}

# Create a public IP address for devserver google compute instance
resource "google_compute_address" "static" {
  name       = "vm-public-address"
  project    = var.project
  region     = var.region
  depends_on = [google_compute_firewall.ssh-allow-firewall]
}

#Create compute Instance
resource "google_compute_instance" "dev" {
  name         = "devserver"
  machine_type = "f1-micro"
  zone         = "${var.region}-a"
  tags         = ["externalssh", "webserver"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static.address
      type        = "ssh"
      user        = var.user
      timeout     = "500s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "sudo apt update",
      "sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable\"",
      "apt-cache policy docker.io",
      "sudo apt -y install docker.io",
      "git clone https://github.com/javed-shaikh-devops/qbe-demo.git",
      "sudo docker build qbe-demo/. -t qbe-demo",
      "sudo docker run -d -p 443:443 qbe-demo"

    ]
  }
  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = [google_compute_firewall.ssh-allow-firewall, google_compute_firewall.https-allow-firewall]
  service_account {
    email  = var.email
    scopes = ["compute-ro"]
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}