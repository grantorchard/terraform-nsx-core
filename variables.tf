variable allow_unverified_ssl {
  type = string
  default = true
}

variable edge_cluster_name {
  type = string
}

variable description {
  type = string
  default = "Provisioned by Terraform Enterprise. DO NOT modify via the UI."
}

variable name {
  type = string
  default = ""
  description = "The name that will be used for provisioning of all components. Per our standard this should be %environment%_%app% (prod_web)."
}