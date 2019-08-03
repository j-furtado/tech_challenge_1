# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

# Creates the resource group needed for DataBricks
resource "azurerm_resource_group" "databricks_rs_grp" {
  name     = "databricks_rsgrp"
  location = "${var.infra_loc}"
}

resource "azurerm_databricks_workspace" "db_workspace" {
  name                = "${var.db_workspace_name}"
  resource_group_name = "${azurerm_resource_group.databricks_rs_grp.name}"
  location            = "${azurerm_resource_group.databricks_rs_grp.location}"
  sku                 = "standard"
}
