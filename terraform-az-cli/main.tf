terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Root module should specify the maximum provider version
      # The ~> operator is a convenient shorthand for allowing only patch releases within a specific minor release.
      version = "~> 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  location = "East US"
}

data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "../function-app"
  output_path = "function-app.zip"
}

module "linux_consumption" {
  source = "./modules/fa"
  project = "tf-deploy-func-con"
  location = local.location
  os = "linux"
  hosting_plan = "consumption"
  archive_file = data.archive_file.file_function_app
}

module "linux_premium" {
  source = "./modules/fa"
  project = "tf-deploy-func-pre"
  location = local.location
  os = "linux"
  hosting_plan = "premium"
  archive_file = data.archive_file.file_function_app
}

output "linux_consumption_hostname" {
  value = module.linux_consumption.function_app_default_hostname
}

output "linux_premium_hostname" {
  value = module.linux_premium.function_app_default_hostname
}
