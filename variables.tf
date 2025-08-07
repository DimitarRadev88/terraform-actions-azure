variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "Resource group location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "Application service plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "Appication service name in Azure"
}

variable "sql_server_name" {
  type        = string
  description = "Server name in Azure"
}

variable "sql_database_name" {
  type        = string
  description = "Database name in Azure"
}

variable "sql_admin_login" {
  type        = string
  description = "Database login username in Azure"
}

variable "sql_admin_password" {
  type        = string
  description = "Database login password in Azure"
}

variable "firewall_rule_name" {
  type        = string
  description = "Database firewall rule name in Azure"
}

variable "repo_URL" {
  type        = string
  description = "Source control URL"
}




