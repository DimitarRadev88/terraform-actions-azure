terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "3d77f1dd-d051-49aa-8606-3f3d77cda1e6"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_service_plan" "sp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }

    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.mssql-server.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.mssql-database.name};User ID=${azurerm_mssql_server.mssql-server.administrator_login};Password=${azurerm_mssql_server.mssql-server.administrator_login_password};Trusted_Connection=False;MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "repo" {
  app_id                 = azurerm_linux_web_app.app.id
  repo_url               = var.repo_URL
  branch                 = "master"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "mssql-server" {
  name                         = var.sql_server_name
  version                      = "12.0"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "mssql-database" {
  name         = var.sql_database_name
  server_id    = azurerm_mssql_server.mssql-server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "BasePrice"
  sku_name     = "Basic"
}

resource "azurerm_mssql_firewall_rule" "server_rule" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.mssql-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}




