data nsxt_policy_edge_cluster "this" {
  display_name = var.edge_cluster_name
}

data nsxt_policy_transport_zone "overlay" {
  display_name = var.tz_overlay_name
}

data nsxt_policy_transport_zone "vlan" {
  display_name = var.tz_vlan_name
}

resource nsxt_policy_vlan_segment "this" {
  display_name        = "uplink segment"
  description         = var.description
  transport_zone_path = data.nsxt_policy_transport_zone.vlan.path
  vlan_ids            = ["0"]

  advanced_config {
    connectivity = "ON"
    local_egress = true
  }
}

resource nsxt_policy_tier0_gateway "this" {
  description               = var.description
  display_name              = "tier0 gateway"
  failover_mode             = "NON_PREEMPTIVE"
  default_rule_logging      = true
  enable_firewall           = true
  force_whitelisting        = false
  ha_mode                   = "ACTIVE_STANDBY"
  internal_transit_subnets  = ["102.64.0.0/16"]
  transit_subnets           = ["101.64.0.0/16"]
  edge_cluster_path         = data.nsxt_policy_edge_cluster.this.path
  
  tag {
    scope = "terraform managed"
    tag   = "true"
  }
}


resource nsxt_policy_tier0_gateway_interface "this" {
  display_name           = "tier0 uplink interface"
  description            = var.description
  type                   = "EXTERNAL"
  gateway_path           = nsxt_policy_tier0_gateway.this.path
  segment_path           = nsxt_policy_vlan_segment.this.path
  subnets                = ["10.0.0.150/24"]
  mtu                    = 1500
}

resource nsxt_policy_static_route "this" {
  display_name = "default route"
  gateway_path = nsxt_policy_tier0_gateway.this.path
  network      = "0.0.0.0/0"

  next_hop {
    admin_distance = "1"
    ip_address     = "10.0.0.1"
  }

  tag {
    scope = "terraform managed"
    tag   = "true"
  }
}