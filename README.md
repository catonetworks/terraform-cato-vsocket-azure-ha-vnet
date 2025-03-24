# CATO VSOCKET Azure HA VNET Terraform module

Terraform module which creates a VNET in Azure, required subnets, network interfaces, security groups, route tables, an Azure Socket HA Site in the Cato Management Application (CMA), and deploys a primary and secondary virtual socket VM instance in Azure and configures them as HA.

List of resources:
- azurerm_availability_set (availability-set)
- azurerm_managed_disk (vSocket_disk_primary)
- azurerm_managed_disk (vSocket_disk_secondary)
- azurerm_network_interface (lan-nic-primary)
- azurerm_network_interface (lan-nic-secondary)
- azurerm_network_interface (mgmt-nic-primary)
- azurerm_network_interface (mgmt-nic-secondary)
- azurerm_network_interface (wan-nic-primary)
- azurerm_network_interface (wan-nic-secondary)
- azurerm_network_security_group (lan-sg)
- azurerm_network_security_group (mgmt-sg)
- azurerm_network_security_group (wan-sg)
- azurerm_public_ip (mgmt-public-ip-primary)
- azurerm_public_ip (mgmt-public-ip-secondary)
- azurerm_public_ip (wan-public-ip-primary)
- azurerm_public_ip (wan-public-ip-secondary)
- azurerm_resource_group (azure-rg)
- azurerm_role_assignment (lan-subnet-role)
- azurerm_role_assignment (primary_nic_ha_role)
- azurerm_role_assignment (secondary_nic_ha_role)
- azurerm_route_table (private-rt)
- azurerm_route_table (public-rt)
- azurerm_route (lan-route)
- azurerm_route (public-rt)
- azurerm_route (route-internet)
- azurerm_subnet_network_security_group_association (lan-association)
- azurerm_subnet_network_security_group_association (mgmt-association)
- azurerm_subnet_network_security_group_association (wan-association)
- azurerm_subnet_route_table_association (rt-table-association-lan)
- azurerm_subnet_route_table_association (rt-table-association-mgmt)
- azurerm_subnet_route_table_association (rt-table-association-wan)
- azurerm_subnet (subnet-lan)
- azurerm_subnet (subnet-mgmt)
- azurerm_subnet (subnet-wan)
- azurerm_user_assigned_identity (CatoHaIdentity)
- azurerm_virtual_machine_extension (vsocket-custom-script-primary)
- azurerm_virtual_machine_extension (vsocket-custom-script-secondary)
- azurerm_virtual_machine (vsocket_primary)
- azurerm_virtual_machine (vsocket_secondary)
- azurerm_virtual_network_dns_servers (dns_servers)
- azurerm_virtual_network (vnet)
- cato_socket_site (azure-site)
- null_resource (configure_secondary_azure_vsocket)
- null_resource (run_command_ha_primary)
- null_resource (run_command_ha_secondary)


## Usage

```hcl
module "vsocket-azure-ha-vnet" {
  source                  = "catonetworks/vsocket-azure-ha-vnet/cato"
  token                   = "xxxxxxx"
  account_id              = "xxxxxxx"
  azure_subscription_id   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"
  location                = "East US"
  vnet_prefix             = "10.3.0.0/16"
  subnet_range_mgmt       = "10.3.1.0/24"
  subnet_range_wan        = "10.3.2.0/24"
  subnet_range_lan        = "10.3.3.0/24"
  lan_ip_primary          = "10.3.3.4"
  lan_ip_secondary        = "10.3.3.5"
  floating_ip             = "10.3.3.6"
  site_name               = "Your-Cato-site-name-here"
  site_description        = "Your Cato site desc here"
  site_location           = {
    city         = "San Diego"
    country_code = "US"
    state_code   = "US-CA" ## Optional - for countries with states
    timezone     = "America/Los_Angeles"
  }
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-azure-ha-vnet/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-azure-ha-vnet/tree/master/LICENSE) for full details.

