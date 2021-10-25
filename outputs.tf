output "id" {
  description = "Id of the storage account created."
  value       = azurerm_storage_account.storage.id
}

output "name" {
  description = "Name of the storage account created."
  value       = azurerm_storage_account.storage.name
}
output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "blob_url" {
  value = azurerm_storage_blob.blob.url
}



