data nsxt_policy_edge_cluster "this" {
  display_name = var.edge_cluster_name
}

data nsxt_policy_transport_zone "overlay" {
  display_name = "tz-0"
}

data nsxt_policy_transport_zone "vlan" {
  display_name = "tz-vlan"
}

resource nsxt_policy_vlan_segment "this" {
  display_name        = "uplink"
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
/*
resource nsxt_policy_tier1_gateway "this" {
  description = var.description
  display_name              = "Tier1-gw1"
  nsx_id                    = "predefined_id"
  edge_cluster_path         = data.nsxt_policy_edge_cluster.this.path
  failover_mode             = "PREEMPTIVE"
  default_rule_logging      = "false"
  enable_firewall           = "true"
  enable_standby_relocation = "false"
  force_whitelisting        = "true"
  tier0_path                = nsxt_policy_tier0_gateway.this.path
  route_advertisement_types = [
    "TIER1_STATIC_ROUTES",
    "TIER1_CONNECTED"
  ]
  pool_allocation           = "ROUTING"

  tag {
    scope = "color"
    tag   = "blue"
  }

  route_advertisement_rule {
    name                      = "rule1"
    action                    = "DENY"
    subnets                   = ["20.0.0.0/24", "21.0.0.0/24"]
    prefix_operator           = "GE"
    route_advertisement_types = ["TIER1_CONNECTED"]
  }
}

resource nsxt_policy_tier1_gateway_interface "this" {
  display_name           = "segment1_interface"
  description = var.description
  gateway_path           = data.nsxt_policy_tier1_gateway.gw1.path
  segment_path           = nsxt_policy_vlan_segment.segment1.path
  subnets                = ["12.12.2.13/24"]
  mtu                    = 1500
}

resource nsxt_policy_segment "this" {
    display_name        = "segment1"
    description = var.description
    connectivity_path   = nsxt_policy_tier1_gateway.this.path
    transport_zone_path = data.nsxt_policy_transport_zone.overlay.path

    subnet {
      cidr        = "12.12.2.1/24"
      dhcp_ranges = ["12.12.2.100-12.12.2.160"]

      dhcp_v4_config {
        server_address = "12.12.2.2/24"
        lease_time     = 36000

        dhcp_option_121 {
          network  = "6.6.6.0/24"
          next_hop = "1.1.1.21"
        }

        dhcp_generic_option {
          code = "119"
          values = ["abc"]
        }
      }
    }

    advanced_config {
      connectivity = "ON"
    }
}
*/