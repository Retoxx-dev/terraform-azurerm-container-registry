#################################################################
# IDENTITY
#################################################################

resource "azurerm_user_assigned_identity" "this" {
  count               = var.identity != null ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.identity.name

  tags = var.identity.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


#################################################################
# CONTAINER REGISTRY
#################################################################
resource "azurerm_container_registry" "this" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.container_registry_sku
  admin_enabled       = var.container_registry_admin_enabled
  tags                = var.container_registry_tags

  dynamic "georeplications" {
    for_each = var.georeplications != null ? var.georeplications : []
    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      tags                      = georeplications.value.tags
    }
  }

  dynamic "network_rule_set" {
    for_each = var.network_rule_sets != null ? var.network_rule_sets : []
    content {
      default_action = network_rule_set.value.default_action

      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rules != null ? network_rule_set.value.ip_rules : []
        content {
          action   = ip_rule.value.action
          ip_range = ip_rule.value.ip_range
        }
      }

      dynamic "virtual_network" {
        for_each = network_rule_set.value.virtual_networks != null ? network_rule_set.value.virtual_networks : []
        content {
          action    = virtual_network.value.action
          subnet_id = virtual_network.value.subnet_id
        }
      }
    }
  }

  public_network_access_enabled = var.public_network_access_enabled

  quarantine_policy_enabled = var.quarantine_policy_enabled

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : []
    content {
      days    = retention_policy.value.days
      enabled = retention_policy.value.enabled
    }
  }

  dynamic "trust_policy" {
    for_each = var.trust_policy != null ? [var.trust_policy] : []
    content {
      enabled = trust_policy.value.enabled
    }
  }

  zone_redundancy_enabled = var.zone_redundancy_enabled

  export_policy_enabled = var.export_policy_enabled

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = var.identity.name != null ? [identity.value.identity_ids] : null
    }
  }

  dynamic "encryption" {
    for_each = var.encryption != null ? [var.identity] : []
    content {
      enabled            = encryption.value.enabled
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }

  anonymous_pull_enabled     = var.anonymous_pull_enabled
  data_endpoint_enabled      = var.data_endpoint_enabled
  network_rule_bypass_option = var.network_rule_bypass_option
}

#################################################################
# DIAGNOSTIC SETTINGS
#################################################################
resource "azurerm_monitor_diagnostic_setting" "this" {
  count                          = var.diagnostic_settings != null ? 1 : 0
  name                           = var.diagnostic_settings.name
  target_resource_id             = azurerm_container_registry.this.id
  eventhub_name                  = var.diagnostic_settings.eventhub_name
  eventhub_authorization_rule_id = var.diagnostic_settings.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.diagnostic_settings.log_analytics_workspace_id
  storage_account_id             = var.diagnostic_settings.storage_account_id

  partner_solution_id = var.diagnostic_settings.partner_solution_id

  log_analytics_destination_type = var.diagnostic_settings.log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = var.diagnostic_settings.enabled_log
    content {
      category       = enabled_log.value.category
      category_group = enabled_log.value.category_group

      retention_policy {
        enabled = enabled_log.value.retention_policy_enabled
        days    = enabled_log.value.retention_policy_days
      }
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_settings.metrics
    content {
      category = metric.value.category
      enabled  = metric.value.enabled

      retention_policy {
        enabled = metric.value.retention_policy_enabled
        days    = metric.value.retention_policy_days
      }
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}
