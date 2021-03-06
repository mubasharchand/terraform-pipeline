# variable "resource_group_name" {
#   type        = string
#   description = "RG name in Azure"
# }

# variable "location" {
#   type        = string
#   description = "RG location in Azure"
# }

# variable "storage_account_name" {
#   type        = string
#   description = "Storage Account name in Azure"
# }

# variable "storage_container_name" {
#   type        = string
#   description = "Storage Container name in Azure"
# }


variable "name" {
  description = "Name of storage account, if it contains illegal characters (,-_ etc) those will be truncated."
  default = "sleepst123"
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
  default = "sleeprg"
}

variable "location" {
  description = "Azure location where resources should be deployed."
  default = "eastus"
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "ZRS"
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool."
  default     = "Hot"
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2."
  default     = "TLS1_2"
}

variable "soft_delete_retention" {
  description = "Number of retention days for soft delete. If set to null it will disable soft delete all together."
  type        = number
  default     = 31
}

variable "cors_rule" {
  description = "CORS rules for storage account."
  type = list(object({
    allowed_origins    = list(string)
    allowed_methods    = list(string)
    allowed_headers    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules restricting access to the storage account."
  type = object({
    ip_rules   = list(string)
    subnet_ids = list(string)
    bypass     = list(string)
  })
  default = null
}

variable "containers" {
  description = "List of containers to create and their access levels."
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}



variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "lifecycles" {
  description = "List of lifecycle delete"
  type = list(object({
    prefix_match      = set(string)
    delete_after_days = number
  }))
  default = []
}

variable "storage_container_name" {
  type        = string
  default = "sleepnumber"
  description = "Storage Container name in Azure"
}