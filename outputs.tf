# ## The following attributes are exported:
output "resource_group_name" {
  description = "The name of the Azure Resource Group used for deployment."
  value       = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
}

output "mgmt_nic_name_primary" {
  description = "The name of the primary management network interface."
  value       = azurerm_network_interface.mgmt-nic-primary.name
}

output "wan_nic_name_primary" {
  description = "The name of the primary WAN network interface."
  value       = azurerm_network_interface.wan-nic-primary.name
}

output "lan_nic_name_primary" {
  description = "The name of the primary LAN network interface."
  value       = azurerm_network_interface.lan-nic-primary.name
}

output "mgmt_nic_name_secondary" {
  description = "The name of the secondary management network interface for HA."
  value       = azurerm_network_interface.mgmt-nic-secondary.name
}

output "wan_nic_name_secondary" {
  description = "The name of the secondary WAN network interface for HA."
  value       = azurerm_network_interface.wan-nic-secondary.name
}

output "lan_nic_name_secondary" {
  description = "The name of the secondary LAN network interface for HA."
  value       = azurerm_network_interface.lan-nic-secondary.name
}

output "lan_subnet_id" {
  description = "The ID of the LAN subnet within the virtual network."
  value       = azurerm_subnet.subnet-lan.id
}

output "vnet_name" {
  description = "The name of the Azure Virtual Network used by the deployment."
  value       = var.vnet_name == null ? azurerm_virtual_network.vnet[0].name : var.vnet_name
}

output "lan_subnet_name" {
  description = "The name of the LAN subnet within the virtual network."
  value       = azurerm_subnet.subnet-lan.name
}

# # Cato Socket Site Outputs
output "cato_site_id" {
  description = "ID of the Cato Socket Site"
  value       = module.cato_socket_site.cato_site_id
}

output "cato_site_name" {
  description = "Name of the Cato Site"
  value       = module.cato_socket_site.cato_site_name
}

output "cato_primary_serial" {
  description = "Primary Cato Socket Serial Number"
  value       = module.cato_socket_site.cato_primary_serial
}

output "cato_secondary_serial" {
  description = "Secondary Cato Socket Serial Number"
  value       = module.cato_socket_site.cato_secondary_serial
}

# # Network Interfaces Outputs
output "mgmt_primary_nic_id" {
  description = "ID of the Management Primary Network Interface"
  value       = azurerm_network_interface.mgmt-nic-primary.id
}

output "wan_primary_nic_id" {
  description = "ID of the WAN Primary Network Interface"
  value       = azurerm_network_interface.wan-nic-primary.id
}

output "lan_primary_nic_id" {
  description = "ID of the LAN Primary Network Interface"
  value       = azurerm_network_interface.lan-nic-primary.id
}

output "mgmt_secondary_nic_id" {
  description = "ID of the Management Secondary Network Interface"
  value       = azurerm_network_interface.mgmt-nic-secondary.id
}

output "wan_secondary_nic_id" {
  description = "ID of the WAN Secondary Network Interface"
  value       = azurerm_network_interface.wan-nic-secondary.id
}

output "lan_secondary_nic_id" {
  description = "ID of the LAN Secondary Network Interface"
  value       = azurerm_network_interface.lan-nic-secondary.id
}

# Virtual Machine Outputs
output "vsocket_primary_vm_id" {
  description = "ID of the Primary vSocket Virtual Machine"
  value       = module.cato_socket_site.vsocket_primary_vm_id
}

output "vsocket_primary_vm_name" {
  description = "Name of the Primary vSocket Virtual Machine"
  value       = module.cato_socket_site.vsocket_primary_vm_name
}

output "vsocket_secondary_vm_id" {
  description = "ID of the Secondary vSocket Virtual Machine"
  value       = module.cato_socket_site.vsocket_secondary_vm_id
}

output "vsocket_secondary_vm_name" {
  description = "Name of the Secondary vSocket Virtual Machine"
  value       = module.cato_socket_site.vsocket_secondary_vm_name
}

# # Managed Disks Outputs
output "primary_disk_id" {
  description = "ID of the Primary vSocket Managed Disk"
  value       = module.cato_socket_site.primary_disk_id
}

output "primary_disk_name" {
  description = "Name of the Primary vSocket Managed Disk"
  value       = module.cato_socket_site.primary_disk_name
}

output "secondary_disk_id" {
  description = "ID of the Secondary vSocket Managed Disk"
  value       = module.cato_socket_site.secondary_disk_id
}

output "secondary_disk_name" {
  description = "Name of the Secondary vSocket Managed Disk"
  value       = module.cato_socket_site.secondary_disk_name
}

# # User Assigned Identity
output "ha_identity_id" {
  description = "ID of the User Assigned Identity for HA"
  value       = module.cato_socket_site.ha_identity_id
}

output "ha_identity_principal_id" {
  description = "Principal ID of the HA Identity"
  value       = module.cato_socket_site.ha_identity_principal_id
}

# # Role Assignments Outputs
output "primary_nic_role_assignment_id" {
  description = "Role Assignment ID for the Primary NIC"
  value       = module.cato_socket_site.primary_nic_role_assignment_id
}

output "secondary_nic_role_assignment_id" {
  description = "Role Assignment ID for the Secondary NIC"
  value       = module.cato_socket_site.secondary_nic_role_assignment_id
}

output "lan_subnet_role_assignment_id" {
  description = "Role Assignment ID for the LAN Subnet"
  value       = module.cato_socket_site.lan_subnet_role_assignment_id
}

# # LAN MAC Address Output
output "lan_secondary_mac_address" {
  description = "MAC Address of the Secondary LAN Interface"
  value       = azurerm_network_interface.lan-nic-secondary.mac_address
}

# output "cato_license_site" {
#   value = var.license_id == null ? null : {
#     id           = cato_license.license[0].id
#     license_id   = cato_license.license[0].license_id
#     license_info = cato_license.license[0].license_info
#     site_id      = cato_license.license[0].site_id
#   }
# }