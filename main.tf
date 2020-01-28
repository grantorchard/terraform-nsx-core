provider nsxt {
  allow_unverified_ssl = var.allow_unverified_ssl
}

data nsxt_edge_cluster "this" {
  display_name = var.edge_cluster_name
}