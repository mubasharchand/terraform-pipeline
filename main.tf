terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "sleepstg2321"
    container_name       = "terraformdemo"
    key                  = "dev.terraformdemo.tfstate"
  }
}

resource "azurerm_resource_group" "storage" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                      = format("%s%ssa", lower(replace(var.name, "/[[:^alnum:]]/", "")), random_string.unique.result)
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_kind              = "StorageV2"
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention
    }

    dynamic "cors_rule" {
      for_each = var.cors_rule
      content {
        allowed_origins    = cors_rule.value.allowed_origins
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_headers    = cors_rule.value.allowed_headers
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
      bypass                     = var.network_rules.bypass
    }
  }

  tags = var.tags
}
resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private" 
  
}
resource "azurerm_storage_blob" "blob" {
  name                   = "veduio.mp4"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "1. Kubernetes Intro.mp4"
}

data "azurerm_storage_account_blob_container_sas" "example" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  container_name    = azurerm_storage_container.container.name
  https_only        = true

  # ip_address = "168.1.5.65"

  start  = "2021-10-26"
  expiry = "2021-11-26"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"
}

resource "azurerm_advanced_threat_protection" "threat_protection" {
  count              = var.enable_advanced_threat_protection ? 1 : 0
  target_resource_id = azurerm_storage_account.storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_management_policy" "storage" {
  count = length(var.lifecycles) == 0 ? 0 : 1

  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          delete_after_days_since_modification_greater_than = rule.value.delete_after_days
        }
      }
    }
  }
}
