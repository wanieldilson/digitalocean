resource "digitalocean_kubernetes_cluster" "this" {
  name   = "wanielnetes"
  region = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.8-do.1"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}