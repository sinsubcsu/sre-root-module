resource "azurerm_resource_group" "this" {
  for_each = var.azurerm_resource_group

  name     = each.value.name
  location = each.value.location

}

variable "azurerm_resource_group" {
  type = map(object({
    name     = string
    location = string
  }))
}

