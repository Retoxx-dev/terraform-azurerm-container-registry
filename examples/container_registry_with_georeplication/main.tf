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

  name                          = "<container-registry-name>"
  sku                           = "Basic"
  admin_enabled                 = false
  public_network_access_enabled = false

  georeplications = [
    {
      location                  = "westeurope"
      regional_endpoint_enabled = true
      zone_redundancy_enabled   = true
    }
  ]
}