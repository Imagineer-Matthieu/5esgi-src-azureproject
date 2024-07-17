# Fournisseur Azure
provider "azurerm" {
  features {}
}

# Ressource groupe
resource "azurerm_resource_group" "rg" {
  name     = "rg-hello-world"
  location = "West Europe"
}

# Réseau Virtuel
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-hello-world"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Sous-réseau
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-hello-world"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Groupe de sécurité réseau (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-hello-world"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-FTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "21"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Association du NSG avec le sous-réseau
resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Azure Service Plan (remplace azurerm_app_service_plan)
resource "azurerm_service_plan" "asp" {
  name                = "asp-hello-world"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Azure Linux Web App
resource "azurerm_linux_web_app" "app" {
  name                = "app-hello-world"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  site_config {
    ftps_state = "AllAllowed"
  }
}

# Sortie URL de l'application
output "web_app_url" {
  value = "https://${azurerm_linux_web_app.app.default_hostname}"
}
