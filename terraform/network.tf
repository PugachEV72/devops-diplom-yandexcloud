resource "yandex_vpc_network" "main_network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet_different_zones" {
  count          = 3
  name           = "subnet-${var.subnet-zones[count.index]}"
  zone           = "${var.subnet-zones[count.index]}"
  network_id     = yandex_vpc_network.main_network.id
  v4_cidr_blocks = [ "${var.cidr.stage[count.index]}" ]
}

