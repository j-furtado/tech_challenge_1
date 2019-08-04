# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

#### Creates the resource groups needed for the platform
# Creates the Resource Group for the container platform
resource "azurerm_resource_group" "container_rg" {
  name = "container_mgmt_rsgrp"
  location = "${var.infra_loc}"
}

# Creates the container registry platform
resource "azurerm_container_registry" "container_registry" {
  resource_group_name = "${azurerm_resource_group.container_rg.name}"
  location = "${var.infra_loc}"
  name = "${var.acr_dns_prefix}"
  admin_enabled = "${var.acr_admin_enabled}"
  sku = "${var.acr_sku}"
}

# Variable composition
locals {
  key_path = "${var.key_root_folder}${var.master_ssh_key}"
}

# Creates the container platform
resource "azurerm_kubernetes_cluster" "kubernetes" {
  resource_group_name = "${azurerm_resource_group.container_rg.name}"
  location = "${var.infra_loc}"
  name = "${var.container_plat_name}"
  dns_prefix = "${var.master_dns}"

  agent_pool_profile {
    name = "${var.worker_pool_name}"
    count = "${var.worker_node_count}"
    vm_size = "${var.worker_vm_type}"
    os_type = "${var.worker_os}"
    os_disk_size_gb = "${var.worker_disk_size}"
  }

  addon_profile {
      http_application_routing {
          enabled = true
      }
  }
  
  linux_profile {
    admin_username = "${var.master_ssh_user}"
    ssh_key {
        key_data = "${file(local.key_path)}"
    }
  }

  service_principal {
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}

