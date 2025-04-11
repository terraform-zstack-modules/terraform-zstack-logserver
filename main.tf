locals {
  context = var.context
}


# 使用镜像模块创建镜像
module "log_server_image" {
  source = "git::http://172.20.14.17/jiajian.chi/terraform-zstack-image.git?ref=v1.1.1"


  image_name  = var.image_name
  image_url   = var.image_url
  guest_os_type = "Centos 7"
  platform    = "Linux"
  format      = "qcow2"
  architecture = "x86_64"
  create_image = true
  backup_storage_name = var.backup_storage_name
  expunge      = var.expunge
}

# 使用实例模块创建实例
module "logserver_instance" {
  source = "git::http://172.20.14.17/jiajian.chi/terraform-zstack-instance.git?ref=v1.1.1"
  

  depends_on = [module.log_server_image]

  name          = var.instance_name
  description   = "Created by Terraform devops"
  instance_count = 1
  image_uuid    = module.log_server_image.image_uuid
  l3_network_name = var.l3_network_name
  instance_offering_name = var.instance_offering_name
  never_stop  = var.never_stop
  expunge     = var.expunge
}

# 创建docker-compose文件
resource "local_file" "dockercompose" {
  depends_on = [module.logserver_instance]
  content = templatefile("${path.module}/files/docker-compose.yaml.tpl", {
    host_ip = module.logserver_instance.instance_ips[0]
  })
  filename = "${path.module}/docker-compose.yaml"
}

# 使用terraform_data资源处理远程操作
resource "terraform_data" "remote_exec" {
  # 确保在虚拟机创建完成后执行
  depends_on = [module.logserver_instance]
  
  # SSH连接配置
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_password
    host     = module.logserver_instance.instance_ips[0]
    timeout  = "5m"
  }

  provisioner "file" {
    source      = "${path.module}/docker-compose.yaml"
    destination = "/root/test/docker-compose.yaml"
    on_failure = fail
  }

  provisioner "file" {
    source      = "${path.module}/files/rsyslog.conf"
    destination = "/etc/rsyslog.conf"
    on_failure = fail
  }

  # 远程执行：在虚拟机上执行命令
  provisioner "remote-exec" {
    inline = [
      "bash /root/test/start_services.sh"  # 执行远程脚本
    ]
    on_failure = fail
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl restart rsyslog"
    ]
    on_failure = fail
  }
}

