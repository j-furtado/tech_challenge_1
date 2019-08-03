####                        ####
#     Credential variables     #
####                        ####

variable "subscription_id" {
  description = "Should be on the credentials file if not you must generate it."
}

variable "client_id" {
  description = "Should be on the credentials file if not you must generate it."
}

variable "client_secret" {
  description = "Should be on the credentials file if not you must generate it."
}

variable "tenant_id" {
  description = "Should be on the credentials file if not you must generate it."
}

####                         ####
#     Global Azure Settings     #
####                         ####
variable "infra_loc" {
  description = "Sets the location for your Azure resources. Check the Azure locations for more info."
  default = "westeurope"
}

####                         ####
#     Data Bricks Settings      #
####                         ####
variable "db_workspace_name" {
  description = "Sets the name of the DataBricks workspace."
  default = "challenge-dbricks"
}
