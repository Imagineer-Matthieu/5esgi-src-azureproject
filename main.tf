# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Public IP
resource "azurerm_public_ip" "lb_pip" {
  name                = "lbPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "my_lb" {
  name                = "myLoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.my_lb.id
  name            = "BackendPool"
}

resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id     = azurerm_lb.my_lb.id
  name                = "http_probe"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.my_lb.id
  name                           = "http_rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Web App 1
resource "azurerm_linux_web_app" "web_app_1" {
  name                = var.web_app_1_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    default_documents = ["palopasalto.html"]
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "PalopasaltoBlobUrl"       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.static_files.name}/palopasalto.html"
  }
}

# Web App 2
resource "azurerm_linux_web_app" "web_app_2" {
  name                = var.web_app_2_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    default_documents = ["palopasalto.html"]
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "PalopasaltoBlobUrl"       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.static_files.name}/palopasalto.html"
  }
}

# Blob Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob Container
resource "azurerm_storage_container" "static_files" {
  name                  = "staticfiles"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "blob"  # Permet l'accès direct aux blobs pour le contenu public

  depends_on = [azurerm_storage_account.storage_account]
}

# Blob File for palopasalto
resource "azurerm_storage_blob" "palopasalto_html" {
  name                   = "palopasalto.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.static_files.name
  type                   = "Block"
  source                 = "./palopasalto.html" # Chemin relatif mis à jour
}