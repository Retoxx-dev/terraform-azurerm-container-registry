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