terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.39.0"
    }
  }

  backend "s3" {
    encrypt        = true
    bucket         = "tantlinger-tf-state"
    dynamodb_table = "tantlinger-tf-state-lock-table"
    region         = "eu-west-1"
    key            = "tantlinger-cluster/terraform.state"
  }
}
