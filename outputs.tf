output edge_cluster_path {
  value = data.nsxt_policy_edge_cluster.this.path
}

output tier0_path {
  value = nsxt_policy_tier0_gateway.this.path
}

output transport_zone_path {
  value = data.nsxt_policy_transport_zone.overlay.path
}