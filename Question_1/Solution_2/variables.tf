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

####                                           ####
#     Container Management Platform variables     #
####                                           ####

variable "container_plat_name" {
  description = "Name for your implementation of the container management platform."
  default = "az-kube"
}

variable "master_node_count" {
  description = "Number of master nodes for your container management platform. Can be 1,3 or 5."
  default = "1"
}

variable "master_dns" {
  description = "Prefix for the master nodes FQDN. Must be unique in the region."
  default = "kube-master-xpto"
}

variable "key_root_folder" {
  description = "Root folder where the keys are located (leave trailling slash). Can be a relative path to the root of the project."
  default = "keys/"
}

variable "master_ssh_user" {
  description = "Name of the ssh user, to access the Container Management masters."
  default = "kube_master"
}

variable "master_ssh_key" {
  description = "Name of the public key (*.pub) for the ssh user, to access the Container Management masters."
  default = "container_key.pub"
}

variable "worker_pool_name" {
  description = "Name for the worker pool. Can only have 12 alfanumeric chars."
  default = "k8sagpool"
}


variable "worker_node_count" {
  description = "Number of worker nodes for your container management platform. Has to be at least > 0."
  default = "2"
}

variable "worker_dns_prefix" {
  description = "Prefix for the worker nodes FQDN."
  default = "kube-agent"
}

variable "worker_vm_type" {
  description = "Type of VM for the worker nodes. See Azure type names for more info."
  default = "Standard_A2"
}

variable "worker_os" {
  description = "OS for the worker nodes."
  default = "Linux"
}

variable "worker_disk_size" {
  description = "Size, in GB, for the worker node disks. Min 30GB"
  default = 30
}


####                                         ####
#     Container Registry Platform variables     #
####                                         ####

variable "acr_dns_prefix" {
  description = "Name and DNS prefix for the Container Registry. Must be unique in the region."
  default = "azcontregxpto"
}

variable "acr_sku" {
  description = "SKU for ACR."
  default = "Basic"
}

variable "acr_admin_enabled" {
  default = true
}
