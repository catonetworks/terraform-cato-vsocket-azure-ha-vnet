
## Cato Provider Variables
variable "token" {
  description = "API token used to authenticate with the Cato Networks API."
}

variable "account_id" {
  description = "Account ID used for the Cato Networks integration."
  type        = number
  default     = null
}

variable "baseurl" {
  description = "Base URL for the Cato Networks API."
  type        = string
  default     = "https://api.catonetworks.com/api/v1/graphql2"
}

variable "site_name" {
  description = "Name of the vsocket site"
  type        = string
}

variable "site_description" {
  description = "Description of the vsocket site"
  type        = string
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  default     = "CLOUD_DC"
  validation {
    condition     = contains(["DATACENTER", "BRANCH", "CLOUD_DC", "HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
}

variable "site_location" {
  description = "Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the Azure region dynamicaly."
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
  default = {
    city         = null
    country_code = null
    state_code   = null ## Optional - for countries with states
    timezone     = null
  }
}


## VNET Variables
variable "azure_subscription_id" {
  description = "The Azure Subscription ID where the resources will be created. Example: 00000000-0000-0000-0000-000000000000"
  type        = string
}

variable "location" {
  type    = string
  default = null
}

variable "lan_ip_primary" {
  type        = string
  description = "Local IP Address of socket LAN interface"
  default     = null
}

variable "lan_ip_secondary" {
  type        = string
  description = "Local IP Address of socket LAN interface"
  default     = null
}

variable "floating_ip" {
  type        = string
  description = "Floating IP Address for the vSocket"
  default     = null
}

variable "dns_servers" {
  type = list(string)
  default = [
    "168.63.129.16", # Azure DNS
    "10.254.254.1",  # Cato Cloud DNS
    "1.1.1.1",
    "8.8.8.8"
  ]
}

variable "subnet_range_mgmt" {
  type        = string
  description = <<EOT
    Choose a range within the VPC to use as the Management subnet. This subnet will be used initially to access the public internet and register your vSocket to the Cato Cloud.
    The minimum subnet length to support High Availability is /28.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  default     = null
}

variable "subnet_range_wan" {
  type        = string
  description = <<EOT
    Choose a range within the VPC to use as the Public/WAN subnet. This subnet will be used to access the public internet and securely tunnel to the Cato Cloud.
    The minimum subnet length to support High Availability is /28.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  default     = null
}

variable "subnet_range_lan" {
  type        = string
  description = <<EOT
    Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.
    The minimum subnet length to support High Availability is /29.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  default     = null
}

variable "native_network_range" {
  type        = string
  description = <<EOT
  	Choose a unique range for your Azure environment that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
}

variable "vnet_network_range" {
  type        = string
  description = <<EOT
  	Choose a unique range for your new VPC that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
  default     = null
}

variable "vm_size" {
  description = "(Required) Specifies the size of the Virtual Machine. See Azure VM Naming Conventions: https://learn.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions"
  type        = string
  default     = "Standard_D8ls_v5"
}

variable "disk_size_gb" {
  description = "Size of the managed disk in GB."
  type        = number
  default     = 8
  validation {
    condition     = var.disk_size_gb > 0
    error_message = "Disk size must be greater than 0."
  }
}

variable "image_reference_id" {
  description = "The path to the image used to deploy a specific version of the virtual socket."
  type        = string
  default     = "/Subscriptions/38b5ec1d-b3b6-4f50-a34e-f04a67121955/Providers/Microsoft.Compute/Locations/eastus/Publishers/catonetworks/ArtifactTypes/VMImage/Offers/cato_socket/Skus/public-cato-socket/Versions/19.0.17805"
}

variable "license_id" {
  description = "The license ID for the Cato vSocket of license type CATO_SITE, CATO_SSE_SITE, CATO_PB, CATO_PB_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts."
  type        = string
  default     = null
}

variable "license_bw" {
  description = "The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10."
  type        = string
  default     = null
}

variable "tags" {
  description = "A Map of Key = Value to describe infrastructure"
  type        = map(any)
  default     = null
}

variable "resource_group_name" {
  description = <<EOF
  (Optional) if a custom resource group is passed, we will use the custom resource group.  If it's not, we will build one
  EOF
  default     = null
}

variable "vnet_name" {
  description = <<EOF
  (Optional) if a custom VNET ID is passed we will use the custom VNET, otherwise we will build one.
  EOF
  default     = null
}


variable "enable_static_range_translation" {
  description = "Enables the ability to use translated ranges"
  type        = string
  default     = false
}



variable "routed_networks" {
  description = <<EOF
  A map of routed networks to be accessed behind the vSocket site.
  - The key is the logical name for the network.
  - The value is an object containing:
    - "subnet" (string, required): The actual CIDR range of the network.
    - "translated_subnet" (string, optional): The NATed CIDR range if translation is used.
  Example: 
  routed_networks = {
    "Peered-VNET-1" = {
      subnet = "10.100.1.0/24"
    }
    "On-Prem-Network-NAT" = {
      subnet            = "192.168.51.0/24"
      translated_subnet = "10.200.1.0/24"
    }
  }
  EOF
  type = map(object({
    subnet            = string
    translated_subnet = optional(string)
  }))
  default = {}
}


# This variable remains the same as it applies to all networks.
variable "routed_ranges_gateway" {
  description = "Routed ranges gateway. If null, the first IP of the LAN subnet will be used."
  type        = string
  default     = null
}
