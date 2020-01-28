provider nsxt {
  allow_unverified_ssl = var.allow_unverified_ssl
}

data nsxt_edge_cluster "prod" {
  display_name = var.edge_cluster_name
}

resource "nsxt_logical_tier0_router" "prod" {
  display_name           = "prod-t0"
  description            = "Production T0 router"
  high_availability_mode = "ACTIVE_STANDBY"
  edge_cluster_id        = data.nsxt_edge_cluster.prod.id
}