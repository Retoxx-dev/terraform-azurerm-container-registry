# terraform-azurerm-container-registry

## Create a docker container registry in Azure

This Terraform module deploys a container registry in Azure with optional diagnostic settings.

-> NOTE: This module can create User Assigned Identity for your cluster, to create one, just specify `identity` variable.

## Usage

### Container Registry with public access disabled
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-terraform-northeu-001"
  location = "northeurope"
}

module "acr" {
  source              = "Retoxx-dev/container-registry/azurerm"
  version             = "1.0.0"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  container_registry_name          = "<container-registry-name>"
  container_registry_sku           = "Basic"
  container_registry_admin_enabled = false
  public_network_access_enabled    = false
}
```


### Container Registry with georeplication
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-terraform-northeu-001"
  location = "northeurope"
}

module "acr" {
  source              = "Retoxx-dev/container-registry/azurerm"
  version             = "1.0.0"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  container_registry_name          = "<container-registry-name>"
  container_registry_sku           = "Basic"
  container_registry_admin_enabled = false
  public_network_access_enabled    = false

  georeplications = [
    {
      location                  = "westeurope"
      regional_endpoint_enabled = true
      zone_redundancy_enabled   = true
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.37 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.33 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anonymous_pull_enabled"></a> [anonymous\_pull\_enabled](#input\_anonymous\_pull\_enabled) | (Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU. | `bool` | `null` | no |
| <a name="input_container_registry_admin_enabled"></a> [container\_registry\_admin\_enabled](#input\_container\_registry\_admin\_enabled) | (Optional) Specifies whether the admin user is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_container_registry_name"></a> [container\_registry\_name](#input\_container\_registry\_name) | (Required) Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_container_registry_sku"></a> [container\_registry\_sku](#input\_container\_registry\_sku) | (Required) The SKU name of the container registry. Possible values are `Basic`, `Standard` and `Premium`. | `string` | n/a | yes |
| <a name="input_container_registry_tags"></a> [container\_registry\_tags](#input\_container\_registry\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_data_endpoint_enabled"></a> [data\_endpoint\_enabled](#input\_data\_endpoint\_enabled) | (Optional) Whether to enable dedicated data endpoints for this Container Registry? This is only supported on resources with the Premium SKU. | `bool` | `null` | no |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | (Optional) A diagnostic\_settings block. | <pre>object({<br>    name                           = string<br>    eventhub_name                  = optional(string, null)<br>    eventhub_authorization_rule_id = optional(string, null)<br>    log_analytics_workspace_id     = optional(string, null)<br>    storage_account_id             = optional(string, null)<br>    log_analytics_destination_type = optional(string, null)<br>    partner_solution_id            = optional(string, null)<br><br>    enabled_log = optional(object({<br>      category       = optional(string, null)<br>      category_group = optional(string, null)<br><br>      retention_policy = optional(object({<br>        enabled = optional(bool, null)<br>        days    = optional(number, null)<br>      }), null)<br>    }), null)<br><br>    metrics = optional(object({<br>      category = optional(string, null)<br>      enabled  = optional(bool, null)<br>      retention_policy = optional(object({<br>        enabled = optional(bool, null)<br>        days    = optional(number, null)<br>      }), null)<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | (Optional) Specifies the encryption configuration for the resource. | <pre>object({<br>    enabled            = optional(bool, null)<br>    key_vault_key_id   = string<br>    identity_client_id = string<br>  })</pre> | `null` | no |
| <a name="input_export_policy_enabled"></a> [export\_policy\_enabled](#input\_export\_policy\_enabled) | (Optional) Boolean value that indicates whether export policy is enabled. Defaults to true. In order to set it to false, make sure the public\_network\_access\_enabled is also set to false. | `bool` | `true` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | (Optional) Specifies the georeplication configuration for the resource. | <pre>list(object({<br>    location                  = string<br>    regional_endpoint_enabled = optional(bool, null)<br>    zone_redundancy_enabled   = optional(bool, null)<br>    tags                      = optional(map(string), {})<br>  }))</pre> | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) Specifies the identity configuration for the resource. | <pre>object({<br>    type         = string<br>    name         = string<br>    identity_ids = optional(list(string), [])<br>    tags = optional(map(string), null)<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_network_rule_bypass_option"></a> [network\_rule\_bypass\_option](#input\_network\_rule\_bypass\_option) | (Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices. | `string` | `null` | no |
| <a name="input_network_rule_sets"></a> [network\_rule\_sets](#input\_network\_rule\_sets) | (Optional) Specifies the network rule set configuration for the resource. | <pre>list(object({<br>    default_action = optional(string, "Allow")<br>    ip_rules = optional(list(object({<br>      action   = string<br>      ip_range = string<br>    })), [])<br>    virtual_networks = optional(list(object({<br>      action    = string<br>      subnet_id = string<br>    })), [])<br>  }))</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether public network access is allowed for the container registry. Defaults to true. | `bool` | `true` | no |
| <a name="input_quarantine_policy_enabled"></a> [quarantine\_policy\_enabled](#input\_quarantine\_policy\_enabled) | (Optional) Boolean value that indicates whether quarantine policy is enabled. | `bool` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | (Optional) Specifies the retention policy configuration for the resource. | <pre>object({<br>    days    = optional(number, 7)<br>    enabled = optional(bool, null)<br>  })</pre> | `null` | no |
| <a name="input_trust_policy"></a> [trust\_policy](#input\_trust\_policy) | (Optional) Specifies the trust policy configuration for the resource. | <pre>object({<br>    enabled = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | (Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | The admin password of the Container Registry. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The admin username of the Container Registry. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Container Registry. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | The principal ID of the Container Registry. |
| <a name="output_identity_tenant_id"></a> [identity\_tenant\_id](#output\_identity\_tenant\_id) | The tenant ID of the Container Registry. |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | The login\_server of the Container Registry. |
<!-- END_TF_DOCS -->