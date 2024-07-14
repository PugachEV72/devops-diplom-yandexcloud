resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = [for i in yandex_compute_instance.cluster-k8s : i]
    }
  )

  filename = "${abspath(path.module)}/hosts.cfg"
}
