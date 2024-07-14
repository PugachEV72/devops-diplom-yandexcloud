resource "yandex_compute_instance" "cluster-k8s" {  
  count   = 3
  name                      = "node-${count.index}"
  zone                      = "${var.subnet-zones[count.index]}"
  hostname                  = "node-${count.index}"
  platform_id = "standard-v3"
  allow_stopping_for_update = true
  labels = {
    index = "${count.index}"
  } 
 
  scheduling_policy {
  preemptible = true
  }

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.ubuntu-2004-lts}"
      type        = "network-ssd"
      size        = "50"
    }
  }

  network_interface {
    
    subnet_id  = "${yandex_vpc_subnet.subnet_different_zones[count.index].id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
