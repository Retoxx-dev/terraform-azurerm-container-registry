#################################################################
# GENERAL
#################################################################

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Kubernetes Cluster."
}

variable "location" {
  type        = string
  description = "(Required) The location in which to create the Kubernetes Cluster."
}

#################################################################
# CONTAINER REGISTRY
#################################################################

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
}

variable "sku" {
  type        = string
  description = "(Required) The SKU name of the container registry. Possible values are `Basic`, `Standard` and `Premium`."
}

variable "admin_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = null
}

variable "georeplications" {
  type = list(object({
    location                  = string
    regional_endpoint_enabled = optional(bool, null)
    zone_redundancy_enabled   = optional(bool, null)
    tags                      = optional(map(string), {})
  }))
  description = "(Optional) Specifies the georeplication configuration for the resource."
  default     = null
}

variable "network_rule_sets" {
  type = list(object({
    default_action = optional(string, "Allow")
    ip_rules = optional(list(object({
      action   = string
      ip_range = string
    })), [])
    virtual_networks = optional(list(object({
      action    = string
      subnet_id = string
    })), [])
  }))
  description = "(Optional) Specifies the network rule set configuration for the resource."
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to true."
  default     = true
}

variable "quarantine_policy_enabled" {
  type        = bool
  description = "(Optional) Boolean value that indicates whether quarantine policy is enabled."
  default     = null
}

variable "retention_policy" {
  type = object({
    days    = optional(number, 7)
    enabled = optional(bool, null)
  })
  description = "(Optional) Specifies the retention policy configuration for the resource."
  default     = null
}

variable "trust_policy" {
  type = object({
    enabled = optional(bool, false)
  })
  description = "(Optional) Specifies the trust policy configuration for the resource."
  default     = null
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "export_policy_enabled" {
  type        = bool
  description = "(Optional) Boolean value that indicates whether export policy is enabled. Defaults to true. In order to set it to false, make sure the public_network_access_enabled is also set to false."
  default     = true
}

variable "identity" {
  type = object({
    type         = string
    name         = string
    identity_ids = optional(list(string), [])
    tags = optional(map(string), null)
  })
  description = "(Optional) Specifies the identity configuration for the resource."
  default     = null
}

variable "encryption" {
  type = object({
    enabled            = optional(bool, null)
    key_vault_key_id   = string
    identity_client_id = string
  })
  description = "(Optional) Specifies the encryption configuration for the resource."
  default     = null
}

variable "anonymous_pull_enabled" {
  type        = bool
  description = "(Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU."
  default     = null
}

variable "data_endpoint_enabled" {
  type        = bool
  description = " (Optional) Whether to enable dedicated data endpoints for this Container Registry? This is only supported on resources with the Premium SKU."
  default     = null
}

variable "network_rule_bypass_option" {
  type        = string
  description = "(Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices."
  default     = null
}

#################################################################
# DIAGNOTIC SETTINGS
#################################################################
variable "diagnostic_settings" {
  type = object({
    name                           = string
    eventhub_name                  = optional(string, null)
    eventhub_authorization_rule_id = optional(string, null)
    log_analytics_workspace_id     = optional(string, null)
    storage_account_id             = optional(string, null)
    log_analytics_destination_type = optional(string, null)
    partner_solution_id            = optional(string, null)

    enabled_log = optional(object({
      category       = optional(string, null)
      category_group = optional(string, null)

      retention_policy = optional(object({
        enabled = optional(bool, null)
        days    = optional(number, null)
      }), null)
    }), null)

    metrics = optional(object({
      category = optional(string, null)
      enabled  = optional(bool, null)
      retention_policy = optional(object({
        enabled = optional(bool, null)
        days    = optional(number, null)
      }), null)
    }), null)
  })
  description = "(Optional) A diagnostic_settings block."
  default     = null
}
