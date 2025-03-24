
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
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
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


variable "vnet_prefix" {
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
