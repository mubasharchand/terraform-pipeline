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
# output "sas_url_query_string" {
#   value = data.azurerm_storage_account_blob_container_sas.example.sas
# }


