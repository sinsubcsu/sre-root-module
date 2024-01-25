module "azure_virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.1.3"

  for_each = local.azure_virtual_network

  # Enforcing value.
  enable_telemetry = true
  vnet_location    = "southeastasia"

  # Coming from variables
  resource_group_name           = each.value.resource_group_name
  vnet_name                     = each.value.vnet_name
  virtual_network_address_space = each.value.virtual_network_address_space

  subnets = each.value.subnets

}

# Can be handled also by tflint
module "validation_azure_virtual_network" {
  source = "../../azure/validation_azure_virtual_network"

  for_each = var.azure_virtual_network

  resource_group_name           = azurerm_resource_group.this[each.value.resource_group_name].name
  vnet_name                     = each.value.vnet_name
  virtual_network_address_space = each.value.virtual_network_address_space
  subnets                       = each.value.subnets
}

locals {
  azure_virtual_network = module.validation_azure_virtual_network

}



variable "azure_virtual_network" {
  type = map(object({
    resource_group_name           = string
    vnet_name                     = string
    virtual_network_address_space = list(string)
    subnets = map(object(
      {
        address_prefixes = list(string) # (Required) The address prefixes to use for the subnet.
        nat_gateway = optional(object({
          id = string # (Required) The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.
        }))
        network_security_group = optional(object({
          id = string # (Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.
        }))
        private_endpoint_network_policies_enabled     = optional(bool, true) # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
        private_link_service_network_policies_enabled = optional(bool, true) # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
        route_table = optional(object({
          id = string # (Required) The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created.
        }))
        service_endpoints           = optional(set(string)) # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.
        service_endpoint_policy_ids = optional(set(string)) # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
        delegations = optional(list(
          object(
            {
              name = string # (Required) A name for this delegation.
              service_delegation = object({
                name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.
                actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
              })
            }
          )
        ))
      }
    ))
  }))
  default     = {}
  description = "description"

  validation {
    condition     = length(keys(var.azure_virtual_network)) > 1 ? false : true
    error_message = "You cannot deploy more than 1 vnet"
  }
}
