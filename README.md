# CATO VSOCKET Azure HA VNET Terraform module

Terraform module which creates a VNET in Azure, required subnets, network interfaces, security groups, route tables, an Azure Socket HA Site in the Cato Management Application (CMA), and deploys a primary and secondary virtual socket VM instance in Azure and configures them as HA.

## NOTE
- This module will look up the Cato Site Location information based on the Location of Azure specified.  If you would like to override this behavior, please leverage the below for help finding the correct values.
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).
- For Translated Ranges, "Enable Static Range Translation" must be enabled for more information please refer to [Configuring System Settings for the Account](https://support.catonetworks.com/hc/en-us/articles/4413280536849-Configuring-System-Settings-for-the-Account)



## Usage

```hcl

variable azure_subscription_id {
  default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable cato_token {}
variable baseurl {}
variable account_id {}


provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.cato_token
  account_id = var.account_id
}

module "vsocket-azure-ha-vnet" {
  source                  = "catonetworks/vsocket-azure-ha-vnet/cato"
  token                   = var.cato_token
  account_id              = var.account_id
  azure_subscription_id   = var.azure_subscription_id
  location                = "East US"
  native_network_range    = "10.3.0.0/22"
  vnet_network_range      = "10.3.0.0/22" 
  subnet_range_mgmt       = "10.3.1.0/24"
  subnet_range_wan        = "10.3.2.0/24"
  subnet_range_lan        = "10.3.3.0/24"
  lan_ip_primary          = "10.3.3.4"
  lan_ip_secondary        = "10.3.3.5"
  floating_ip             = "10.3.3.6"  
  site_name               = "Your-Cato-site-name-here"
  site_description        = "Your Cato site desc here"
  # Site Location is Derived from Cloud Region / Location
  enable_static_range_translation = false #set to true if the Account settings has been updated.
  routed_networks         = { 
    "Peered-VNET-1" = {
      subnet = "10.100.1.0/24"
    }
    "On-Prem-Network-With-NAT" = {
      subnet            = "192.168.51.0/24"
      translated_subnet = "10.250.1.0/24" # Example translated range, SRT Required, set enable_static_range_translation = true
    }
  }
  tags = {
    built_with = "terraform"
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

## Example Diagram 
<details><summary> Example Diagram </summary>
<img src=./images/terraform-cato-vsocket-azure-vnet-ha.png></img>
</details>


## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-azure-ha-vnet/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-azure-ha-vnet/tree/master/LICENSE) for full details.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.33.0 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | >= 0.0.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.33.0 |
| <a name="provider_cato"></a> [cato](#provider\_cato) | >= 0.0.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cato_socket_site"></a> [cato\_socket\_site](#module\_cato\_socket\_site) | catonetworks/vsocket-azure-ha/cato | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.availability-set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_network_interface.lan-nic-primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.lan-nic-secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.mgmt-nic-primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.mgmt-nic-secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.wan-nic-primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.wan-nic-secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.lan-sg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.mgmt-sg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.wan-sg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.mgmt-public-ip-primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.mgmt-public-ip-secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.wan-public-ip-primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.wan-public-ip-secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azure-rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.internet-route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.lan-route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.public-route-kms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.private-rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_route_table.public-rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.subnet-lan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet-mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet-wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.lan-association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.mgmt-association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.wan-association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.rt-table-association-lan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.rt-table-association-mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.rt-table-association-wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_dns_servers.dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_virtual_network.custom-vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [cato_siteLocation.site_location](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Account ID used for the Cato Networks integration. | `number` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The Azure Subscription ID where the resources will be created. Example: 00000000-0000-0000-0000-000000000000 | `string` | n/a | yes |
| <a name="input_baseurl"></a> [baseurl](#input\_baseurl) | Base URL for the Cato Networks API. | `string` | `"https://api.catonetworks.com/api/v1/graphql2"` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Size of the managed disk in GB. | `number` | `8` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | n/a | `list(string)` | <pre>[<br/>  "168.63.129.16",<br/>  "10.254.254.1",<br/>  "1.1.1.1",<br/>  "8.8.8.8"<br/>]</pre> | no |
| <a name="input_enable_static_range_translation"></a> [enable\_static\_range\_translation](#input\_enable\_static\_range\_translation) | Enables the ability to use translated ranges | `string` | `false` | no |
| <a name="input_floating_ip"></a> [floating\_ip](#input\_floating\_ip) | Floating IP Address for the vSocket | `string` | `null` | no |
| <a name="input_image_reference_id"></a> [image\_reference\_id](#input\_image\_reference\_id) | The path to the image used to deploy a specific version of the virtual socket. | `string` | `"/Subscriptions/38b5ec1d-b3b6-4f50-a34e-f04a67121955/Providers/Microsoft.Compute/Locations/eastus/Publishers/catonetworks/ArtifactTypes/VMImage/Offers/cato_socket/Skus/public-cato-socket/Versions/19.0.17805"` | no |
| <a name="input_lan_ip_primary"></a> [lan\_ip\_primary](#input\_lan\_ip\_primary) | Local IP Address of socket LAN interface | `string` | `null` | no |
| <a name="input_lan_ip_secondary"></a> [lan\_ip\_secondary](#input\_lan\_ip\_secondary) | Local IP Address of socket LAN interface | `string` | `null` | no |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `null` | no |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Choose a unique range for your Azure environment that does not conflict with the rest of your Wide Area Network.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) if a custom resource group is passed, we will use the custom resource group.  If it's not, we will build one | `any` | `null` | no |
| <a name="input_routed_networks"></a> [routed\_networks](#input\_routed\_networks) | A map of routed networks to be accessed behind the vSocket site.<br/>  - The key is the logical name for the network.<br/>  - The value is an object containing:<br/>    - "subnet" (string, required): The actual CIDR range of the network.<br/>    - "translated\_subnet" (string, optional): The NATed CIDR range if translation is used.<br/>  Example: <br/>  routed\_networks = {<br/>    "Peered-VNET-1" = {<br/>      subnet = "10.100.1.0/24"<br/>    }<br/>    "On-Prem-Network-NAT" = {<br/>      subnet            = "192.168.51.0/24"<br/>      translated\_subnet = "10.200.1.0/24"<br/>    }<br/>  } | <pre>map(object({<br/>    subnet            = string<br/>    translated_subnet = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_routed_ranges_gateway"></a> [routed\_ranges\_gateway](#input\_routed\_ranges\_gateway) | Routed ranges gateway. If null, the first IP of the LAN subnet will be used. | `string` | `null` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the vsocket site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the Azure region dynamicaly. | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | <pre>{<br/>  "city": null,<br/>  "country_code": null,<br/>  "state_code": null,<br/>  "timezone": null<br/>}</pre> | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the vsocket site | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_subnet_range_lan"></a> [subnet\_range\_lan](#input\_subnet\_range\_lan) | Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /29.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | `null` | no |
| <a name="input_subnet_range_mgmt"></a> [subnet\_range\_mgmt](#input\_subnet\_range\_mgmt) | Choose a range within the VPC to use as the Management subnet. This subnet will be used initially to access the public internet and register your vSocket to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | `null` | no |
| <a name="input_subnet_range_wan"></a> [subnet\_range\_wan](#input\_subnet\_range\_wan) | Choose a range within the VPC to use as the Public/WAN subnet. This subnet will be used to access the public internet and securely tunnel to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A Map of Key = Value to describe infrastructure | `map(any)` | `null` | no |
| <a name="input_token"></a> [token](#input\_token) | API token used to authenticate with the Cato Networks API. | `any` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Required) Specifies the size of the Virtual Machine. See Azure VM Naming Conventions: https://learn.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions | `string` | `"Standard_D8ls_v5"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | (Optional) if a custom VNET ID is passed we will use the custom VNET, otherwise we will build one. | `any` | `null` | no |
| <a name="input_vnet_network_range"></a> [vnet\_network\_range](#input\_vnet\_network\_range) | Choose a unique range for your new VPC that does not conflict with the rest of your Wide Area Network.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_primary_serial"></a> [cato\_primary\_serial](#output\_cato\_primary\_serial) | Primary Cato Socket Serial Number |
| <a name="output_cato_secondary_serial"></a> [cato\_secondary\_serial](#output\_cato\_secondary\_serial) | Secondary Cato Socket Serial Number |
| <a name="output_cato_site_id"></a> [cato\_site\_id](#output\_cato\_site\_id) | ID of the Cato Socket Site |
| <a name="output_cato_site_name"></a> [cato\_site\_name](#output\_cato\_site\_name) | Name of the Cato Site |
| <a name="output_ha_identity_id"></a> [ha\_identity\_id](#output\_ha\_identity\_id) | ID of the User Assigned Identity for HA |
| <a name="output_ha_identity_principal_id"></a> [ha\_identity\_principal\_id](#output\_ha\_identity\_principal\_id) | Principal ID of the HA Identity |
| <a name="output_lan_nic_name_primary"></a> [lan\_nic\_name\_primary](#output\_lan\_nic\_name\_primary) | The name of the primary LAN network interface. |
| <a name="output_lan_nic_name_secondary"></a> [lan\_nic\_name\_secondary](#output\_lan\_nic\_name\_secondary) | The name of the secondary LAN network interface for HA. |
| <a name="output_lan_primary_nic_id"></a> [lan\_primary\_nic\_id](#output\_lan\_primary\_nic\_id) | ID of the LAN Primary Network Interface |
| <a name="output_lan_secondary_mac_address"></a> [lan\_secondary\_mac\_address](#output\_lan\_secondary\_mac\_address) | MAC Address of the Secondary LAN Interface |
| <a name="output_lan_secondary_nic_id"></a> [lan\_secondary\_nic\_id](#output\_lan\_secondary\_nic\_id) | ID of the LAN Secondary Network Interface |
| <a name="output_lan_subnet_id"></a> [lan\_subnet\_id](#output\_lan\_subnet\_id) | The ID of the LAN subnet within the virtual network. |
| <a name="output_lan_subnet_name"></a> [lan\_subnet\_name](#output\_lan\_subnet\_name) | The name of the LAN subnet within the virtual network. |
| <a name="output_lan_subnet_role_assignment_id"></a> [lan\_subnet\_role\_assignment\_id](#output\_lan\_subnet\_role\_assignment\_id) | Role Assignment ID for the LAN Subnet |
| <a name="output_mgmt_nic_name_primary"></a> [mgmt\_nic\_name\_primary](#output\_mgmt\_nic\_name\_primary) | The name of the primary management network interface. |
| <a name="output_mgmt_nic_name_secondary"></a> [mgmt\_nic\_name\_secondary](#output\_mgmt\_nic\_name\_secondary) | The name of the secondary management network interface for HA. |
| <a name="output_mgmt_primary_nic_id"></a> [mgmt\_primary\_nic\_id](#output\_mgmt\_primary\_nic\_id) | ID of the Management Primary Network Interface |
| <a name="output_mgmt_secondary_nic_id"></a> [mgmt\_secondary\_nic\_id](#output\_mgmt\_secondary\_nic\_id) | ID of the Management Secondary Network Interface |
| <a name="output_primary_nic_role_assignment_id"></a> [primary\_nic\_role\_assignment\_id](#output\_primary\_nic\_role\_assignment\_id) | Role Assignment ID for the Primary NIC |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Azure Resource Group used for deployment. |
| <a name="output_secondary_nic_role_assignment_id"></a> [secondary\_nic\_role\_assignment\_id](#output\_secondary\_nic\_role\_assignment\_id) | Role Assignment ID for the Secondary NIC |
| <a name="output_site_location"></a> [site\_location](#output\_site\_location) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the Azure Virtual Network used by the deployment. |
| <a name="output_vsocket_primary_vm_id"></a> [vsocket\_primary\_vm\_id](#output\_vsocket\_primary\_vm\_id) | ID of the Primary vSocket Virtual Machine |
| <a name="output_vsocket_primary_vm_name"></a> [vsocket\_primary\_vm\_name](#output\_vsocket\_primary\_vm\_name) | Name of the Primary vSocket Virtual Machine |
| <a name="output_vsocket_secondary_vm_id"></a> [vsocket\_secondary\_vm\_id](#output\_vsocket\_secondary\_vm\_id) | ID of the Secondary vSocket Virtual Machine |
| <a name="output_vsocket_secondary_vm_name"></a> [vsocket\_secondary\_vm\_name](#output\_vsocket\_secondary\_vm\_name) | Name of the Secondary vSocket Virtual Machine |
| <a name="output_wan_nic_name_primary"></a> [wan\_nic\_name\_primary](#output\_wan\_nic\_name\_primary) | The name of the primary WAN network interface. |
| <a name="output_wan_nic_name_secondary"></a> [wan\_nic\_name\_secondary](#output\_wan\_nic\_name\_secondary) | The name of the secondary WAN network interface for HA. |
| <a name="output_wan_primary_nic_id"></a> [wan\_primary\_nic\_id](#output\_wan\_primary\_nic\_id) | ID of the WAN Primary Network Interface |
| <a name="output_wan_secondary_nic_id"></a> [wan\_secondary\_nic\_id](#output\_wan\_secondary\_nic\_id) | ID of the WAN Secondary Network Interface |
<!-- END_TF_DOCS -->