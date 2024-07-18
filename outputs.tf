output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "app_service_web_app_1_default_site_hostname" {
  value = azurerm_linux_web_app.web_app_1.default_hostname
}

output "app_service_web_app_2_default_site_hostname" {
  value = azurerm_linux_web_app.web_app_2.default_hostname
}

output "public_ip_address" {
  value = azurerm_public_ip.lb_pip.ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_container_name" {
  value = azurerm_storage_container.static_files.name
}

output "palopasalto_blob_url" {
  value = azurerm_storage_blob.palopasalto_html.url
}
