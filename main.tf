
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${var.resource_group_name_prefix}-aks-mvp-15-01"
}

resource "azurerm_container_registry" "acr" {
  name                = "osAksAcr1501"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "myAKSCluster"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "cluster"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

   network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }

}

resource "azurerm_role_assignment" "policy" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}