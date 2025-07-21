data "azurerm_virtual_network" "custom-vnet" {
  count               = var.vnet_name == null ? 0 : 1
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

## VNET Module Resources
resource "azurerm_resource_group" "azure-rg" {
  count    = var.resource_group_name == null ? 1 : 0
  location = var.location
  name     = replace(replace("${var.site_name}-RG", "-", ""), " ", "_")
  tags     = var.tags
}

resource "azurerm_availability_set" "availability-set" {
  location                     = var.location
  name                         = replace(replace("${var.site_name}-availabilitySet", "-", "_"), " ", "_")
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  resource_group_name          = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  tags                         = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

## Create Network and Subnets
resource "azurerm_virtual_network" "vnet" {
  count               = var.vnet_name == null ? 1 : 0
  address_space       = [var.vnet_network_range]
  location            = var.location
  name                = replace(replace("${var.site_name}-vsNet", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

resource "azurerm_virtual_network_dns_servers" "dns_servers" {
  virtual_network_id = var.vnet_name == null ? azurerm_virtual_network.vnet[0].id : data.azurerm_virtual_network.custom-vnet[0].id
  dns_servers        = var.dns_servers
}

resource "azurerm_subnet" "subnet-mgmt" {
  address_prefixes     = [var.subnet_range_mgmt]
  name                 = replace(replace("${var.site_name}-subnetMGMT", "-", "_"), " ", "_")
  resource_group_name  = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  virtual_network_name = replace(replace("${var.site_name}-vsNet", "-", "_"), " ", "_")
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "subnet-wan" {
  address_prefixes     = [var.subnet_range_wan]
  name                 = replace(replace("${var.site_name}-subnetWAN", "-", "_"), " ", "_")
  resource_group_name  = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  virtual_network_name = replace(replace("${var.site_name}-vsNet", "-", "_"), " ", "_")
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "subnet-lan" {
  address_prefixes     = [var.subnet_range_lan]
  name                 = replace(replace("${var.site_name}-subnetLAN", "-", "_"), " ", "_")
  resource_group_name  = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  virtual_network_name = replace(replace("${var.site_name}-vsNet", "-", "_"), " ", "_")
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Allocate Public IPs
resource "azurerm_public_ip" "mgmt-public-ip-primary" {
  allocation_method   = "Static"
  location            = var.location
  name                = replace(replace("${var.site_name}-mngPublicIPPrimary", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.azure-rg,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_public_ip" "wan-public-ip-primary" {
  allocation_method   = "Static"
  location            = var.location
  name                = replace(replace("${var.site_name}-wanPublicIPPrimary", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_public_ip" "mgmt-public-ip-secondary" {
  allocation_method   = "Static"
  location            = var.location
  name                = replace(replace("${var.site_name}-mngPublicIPSecondary", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_public_ip" "wan-public-ip-secondary" {
  allocation_method   = "Static"
  location            = var.location
  name                = replace(replace("${var.site_name}-wanPublicIPSecondary", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg,
    azurerm_virtual_network.vnet
  ]
}

# Create Network Interfaces
resource "azurerm_network_interface" "mgmt-nic-primary" {
  location            = var.location
  name                = "${var.site_name}-mngPrimary"
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  ip_configuration {
    name                          = replace(replace("${var.site_name}-mgmtIPPrimary", "-", "_"), " ", "_")
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt-public-ip-primary.id
    subnet_id                     = azurerm_subnet.subnet-mgmt.id
  }
  tags = var.tags
  depends_on = [
    azurerm_public_ip.mgmt-public-ip-primary,
    azurerm_subnet.subnet-mgmt
  ]
}

resource "azurerm_network_interface" "wan-nic-primary" {
  ip_forwarding_enabled = true
  location              = var.location
  name                  = "${var.site_name}-wanPrimary"
  resource_group_name   = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  ip_configuration {
    name                          = replace(replace("${var.site_name}-wanIPPrimary", "-", "_"), " ", "_")
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.wan-public-ip-primary.id
    subnet_id                     = azurerm_subnet.subnet-wan.id
  }
  tags = var.tags
  depends_on = [
    azurerm_public_ip.wan-public-ip-primary,
    azurerm_subnet.subnet-wan
  ]
}

resource "azurerm_network_interface" "lan-nic-primary" {
  ip_forwarding_enabled = true
  location              = var.location
  name                  = "${var.site_name}-lanPrimary"
  resource_group_name   = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  ip_configuration {
    name                          = replace(replace("${var.site_name}-lanIPConfigPrimary", "-", "_"), " ", "_")
    private_ip_address_allocation = "Static"
    private_ip_address            = var.lan_ip_primary
    subnet_id                     = azurerm_subnet.subnet-lan.id
  }
  tags = var.tags
  depends_on = [
    azurerm_subnet.subnet-lan
  ]
  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_network_interface" "mgmt-nic-secondary" {
  location            = var.location
  name                = "${var.site_name}-mngSecondary"
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  ip_configuration {
    name                          = replace(replace("${var.site_name}-mgmtIPSecondary", "-", "_"), " ", "_")
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt-public-ip-secondary.id
    subnet_id                     = azurerm_subnet.subnet-mgmt.id
  }
  tags = var.tags
  depends_on = [
    azurerm_public_ip.mgmt-public-ip-secondary,
    azurerm_subnet.subnet-mgmt
  ]
}

resource "azurerm_network_interface" "wan-nic-secondary" {
  ip_forwarding_enabled = true
  location              = var.location
  name                  = "${var.site_name}-wanSecondary"
  resource_group_name   = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  ip_configuration {
    name                          = replace(replace("${var.site_name}-wanIPSecondary", "-", "_"), " ", "_")
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.wan-public-ip-secondary.id
    subnet_id                     = azurerm_subnet.subnet-wan.id
  }
  tags = var.tags
  depends_on = [
    azurerm_public_ip.wan-public-ip-secondary,
    azurerm_subnet.subnet-wan
  ]
}

resource "azurerm_network_interface" "lan-nic-secondary" {
  ip_forwarding_enabled = true
  location              = var.location
  name                  = "${var.site_name}-lanSecondary"
  resource_group_name   = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  ip_configuration {
    name                          = replace(replace("${var.site_name}-lanIPConfigSecondary", "-", "_"), " ", "_")
    private_ip_address_allocation = "Static"
    private_ip_address            = var.lan_ip_secondary
    subnet_id                     = azurerm_subnet.subnet-lan.id
  }
  tags = var.tags
  depends_on = [
    azurerm_subnet.subnet-lan
  ]
}

resource "azurerm_subnet_network_security_group_association" "mgmt-association" {
  subnet_id                 = azurerm_subnet.subnet-mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt-sg.id
}

resource "azurerm_subnet_network_security_group_association" "wan-association" {
  subnet_id                 = azurerm_subnet.subnet-wan.id
  network_security_group_id = azurerm_network_security_group.wan-sg.id
}

resource "azurerm_subnet_network_security_group_association" "lan-association" {
  subnet_id                 = azurerm_subnet.subnet-lan.id
  network_security_group_id = azurerm_network_security_group.lan-sg.id
}

# Create Security Groups
resource "azurerm_network_security_group" "mgmt-sg" {
  location            = var.location
  name                = replace(replace("${var.site_name}-MGMTSecurityGroup", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name

  security_rule {
    name                       = "Allow-DNS-TCP"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-DNS-UDP"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-HTTPS-TCP"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-HTTPS-UDP"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Deny-All-Outbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

resource "azurerm_network_security_group" "wan-sg" {
  location            = var.location
  name                = replace(replace("${var.site_name}-WANSecurityGroup", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name

  security_rule {
    name                       = "Allow-DNS-TCP"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-DNS-UDP"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-HTTPS-TCP"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Allow-HTTPS-UDP"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Deny-All-Outbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

resource "azurerm_network_security_group" "lan-sg" {
  location            = var.location
  name                = replace(replace("${var.site_name}-LANSecurityGroup", "-", "_"), " ", "_")
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name

  security_rule {
    name                       = "Allow-All-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

## Create Route Tables, Routes and Associations 
resource "azurerm_route_table" "private-rt" {
  bgp_route_propagation_enabled = false
  location                      = var.location
  name                          = replace(replace("${var.site_name}-viaCato", "-", "_"), " ", "_")
  resource_group_name           = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  tags                          = var.tags
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

resource "azurerm_route" "public-route-kms" {
  address_prefix      = "23.102.135.246/32" #
  name                = "Microsoft-KMS"
  next_hop_type       = "Internet"
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  route_table_name    = replace(replace("${var.site_name}-viaCato", "-", "_"), " ", "_")
  depends_on = [
    azurerm_route_table.private-rt
  ]
}

resource "azurerm_route" "lan-route" {
  address_prefix         = "0.0.0.0/0"
  name                   = "default-cato"
  next_hop_in_ip_address = var.floating_ip
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  route_table_name       = replace(replace("${var.site_name}-viaCato", "-", "_"), " ", "_")
  depends_on = [
    azurerm_route_table.private-rt
  ]
}

resource "azurerm_route_table" "public-rt" {
  bgp_route_propagation_enabled = false
  location                      = var.location
  name                          = replace(replace("${var.site_name}-viaInternet", "-", "_"), " ", "_")
  resource_group_name           = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  depends_on = [
    azurerm_resource_group.azure-rg
  ]
}

resource "azurerm_route" "internet-route" {
  address_prefix      = "0.0.0.0/0"
  name                = "default-internet"
  next_hop_type       = "Internet"
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  route_table_name    = replace(replace("${var.site_name}-viaInternet", "-", "_"), " ", "_")
  depends_on = [
    azurerm_route_table.public-rt
  ]
}

resource "azurerm_subnet_route_table_association" "rt-table-association-mgmt" {
  route_table_id = azurerm_route_table.public-rt.id
  subnet_id      = azurerm_subnet.subnet-mgmt.id
  depends_on = [
    azurerm_route_table.public-rt,
    azurerm_subnet.subnet-mgmt
  ]
}

resource "azurerm_subnet_route_table_association" "rt-table-association-wan" {
  route_table_id = azurerm_route_table.public-rt.id
  subnet_id      = azurerm_subnet.subnet-wan.id
  depends_on = [
    azurerm_route_table.public-rt,
    azurerm_subnet.subnet-wan,
  ]
}

resource "azurerm_subnet_route_table_association" "rt-table-association-lan" {
  route_table_id = azurerm_route_table.private-rt.id
  subnet_id      = azurerm_subnet.subnet-lan.id
  depends_on = [
    azurerm_route_table.private-rt,
    azurerm_subnet.subnet-lan
  ]
}

module "cato_socket_site" {
  source                          = "catonetworks/vsocket-azure-ha/cato"
  token                           = var.token
  account_id                      = var.account_id
  location                        = var.location
  azure_subscription_id           = var.azure_subscription_id
  resource_group_name             = var.resource_group_name == null ? azurerm_resource_group.azure-rg[0].name : var.resource_group_name
  lan_subnet_name                 = azurerm_subnet.subnet-lan.name
  mgmt_nic_name_primary           = azurerm_network_interface.mgmt-nic-primary.name
  wan_nic_name_primary            = azurerm_network_interface.wan-nic-primary.name
  lan_nic_name_primary            = azurerm_network_interface.lan-nic-primary.name
  mgmt_nic_name_secondary         = azurerm_network_interface.mgmt-nic-secondary.name
  wan_nic_name_secondary          = azurerm_network_interface.wan-nic-secondary.name
  lan_nic_name_secondary          = azurerm_network_interface.lan-nic-secondary.name
  native_network_range            = var.native_network_range
  floating_ip                     = var.floating_ip
  subnet_range_lan                = var.subnet_range_lan
  vnet_name                       = var.vnet_name == null ? azurerm_virtual_network.vnet[0].name : var.vnet_name
  site_name                       = var.site_name
  site_description                = var.site_description
  site_type                       = var.site_type
  site_location                   = local.cur_site_location
  tags                            = var.tags
  routed_networks                 = var.routed_networks
  routed_ranges_gateway           = var.routed_ranges_gateway
  enable_static_range_translation = var.enable_static_range_translation

  depends_on = [
    azurerm_network_interface.lan-nic-primary,
    azurerm_network_interface.lan-nic-secondary,
    azurerm_network_interface.mgmt-nic-primary,
    azurerm_network_interface.mgmt-nic-secondary,
    azurerm_network_interface.wan-nic-primary,
    azurerm_network_interface.wan-nic-secondary
  ]
}
