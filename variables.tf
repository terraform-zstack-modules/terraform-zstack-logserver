#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

# variables.tf

# Provider 变量
variable "host" {
  description = "ZStack API host"
  type        = string
}

variable "account_name" {
  description = "ZStack account name"
  type        = string
}

variable "account_password" {
  description = "ZStack account password"
  type        = string
  sensitive   = true
}

# 应用配置变量
variable "image_name" {
  description = "Name for the log server image"
  type        = string
  default     = "logserver-by-terraform"
}

variable "image_url" {
  description = "URL to download the image from"
  type        = string
  default     = "http://minio.zstack.io:9001/packer/logserver-by-packer-image-compressed.qcow2"
}

variable "backup_storage_name" {
  description = "Name of the backup storage to use"
  type        = string
  default     = "bs"
}

variable "instance_name" {
  description = "Name for the log server instance"
  type        = string
  default     = "logserver_instance"
}

variable "l3_network_name" {
  description = "Name of the L3 network to use"
  type        = string
  default     = "test"
}

variable "instance_offering_name" {
  description = "Name of the instance offering to use"
  type        = string
  default     = "min"
}

variable "ssh_user" {
  description = "SSH username for remote access"
  type        = string
  default     = "root"
}

variable "ssh_password" {
  description = "SSH password for remote access"
  type        = string
  default     = "password"
  sensitive   = true
}

