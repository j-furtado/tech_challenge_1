output "kube_admin_user" {
  value = "${var.master_ssh_user}"
}

output "usage" {
  value = "ssh -i <private_key> ${var.master_ssh_user}@${azurerm_kubernetes_cluster.kubernetes.fqdn}"
}

output "kube_host" {
  value = "${azurerm_kubernetes_cluster.kubernetes.kube_config.0.host}"
}

output "kube_username" {
  value = "${azurerm_kubernetes_cluster.kubernetes.kube_config.0.username}"
}

output "kube_password" {
  value = "${azurerm_kubernetes_cluster.kubernetes.kube_config.0.password}"
}

output "kube_cluster" {
  value = "${azurerm_kubernetes_cluster.kubernetes.kube_config_raw}"
}

output "app_dns" {
  value = "${azurerm_kubernetes_cluster.kubernetes.addon_profile.0.http_application_routing.0.http_application_routing_zone_name}"
}

output "container_registry_login_server" {
  value = "${azurerm_container_registry.container_registry.login_server}"
}

output "container_registry_admin_username" {
  value = "${azurerm_container_registry.container_registry.admin_username}"
}

output "container_registry_admin_password" {
  value = "${azurerm_container_registry.container_registry.admin_password}"
}
