#################################################################
# CONTAINER REGISTRY
#################################################################
output "id" {
  value       = azurerm_container_registry.this.id
  description = "The ID of the Container Registry."
}

output "login_server" {
  value       = azurerm_container_registry.this.login_server
  description = "The login_server of the Container Registry."
}

output "admin_username" {
  value       = azurerm_container_registry.this.admin_username
  description = "The admin username of the Container Registry."
}

output "admin_password" {
  value       = azurerm_container_registry.this.admin_password
  description = "The admin password of the Container Registry."
}

output "identity_principal_id" {
  value       = try(azurerm_container_registry.this.identity[0].principal_id, "")
  description = "The principal ID of the Container Registry."
}

output "identity_tenant_id" {
  value       = try(azurerm_container_registry.this.identity[0].tenant_id, "")
  description = "The tenant ID of the Container Registry."
}
