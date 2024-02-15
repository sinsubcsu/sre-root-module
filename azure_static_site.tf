module "azure_static_site" {
  source  = "Azure/avm-res-web-staticsite/azurerm"
  version = "~> 0.1.0"

  for_each = var.azure_static_site

  # Enforcing value.
  enable_telemetry = true
  location         = "southeastasia"

  # Coming from variables
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  sku_size            = each.value.sku_size
  sku_tier            = each.value.sku_tier
  tags                = each.value.tags

}

variable "azure_static_site" {
  type = map(object({
    location            = string
    name                = string
    resource_group_name = string
    
    app_settings = optional(map(string))
    enable_telemetry    = optional(bool)
    sku_size            = optional(string)
    sku_tier            = optional(string)
    tags                = optional(map(string))
  }))
  default = {}
}