provider nsxt {
  allow_unverified_ssl = var.allow_unverified_ssl
}

data nsxt_edge_cluster "prod" {
  display_name = var.edge_cluster_name
}

data nsxt_logical_tier0_router "prod" {
  display_name = "t0-router"
}

resource nsxt_logical_router_link_port_on_tier0 "prod_web" {
  description       = ""
  display_name      = "prod_web"
  logical_router_id = data.nsxt_logical_tier0_router.prod.id
}

resource nsxt_logical_router_link_port_on_tier1 "prod_web" {
  description                   = ""
  display_name                  = "prod_web"
  logical_router_id             = nsxt_logical_tier1_router.prod_web.id
  linked_logical_router_port_id = nsxt_logical_router_link_port_on_tier0.prod_web.id
}

resource nsxt_logical_tier1_router "prod_web" {
  description                 = "Production Web"
  display_name                = "prod_web"
  failover_mode               = "PREEMPTIVE"
  edge_cluster_id             = data.nsxt_edge_cluster.prod.id
  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_static_routes     = true
  advertise_nat_routes        = true
  advertise_lb_vip_routes     = true
  advertise_lb_snat_ip_routes = false
}

resource "nsxt_logical_router_downlink_port" "prod_web" {
  description                   = ""
  display_name                  = "prod_web"
  logical_router_id             = nsxt_logical_tier1_router.prod_web.id
  linked_logical_switch_port_id = nsxt_logical_port.prod_web.id
  ip_address                    = "10.0.30.1/24"
}