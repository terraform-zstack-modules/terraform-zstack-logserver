<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_zstack"></a> [zstack](#requirement\_zstack) | 1.0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_log_server_image"></a> [log\_server\_image](#module\_log\_server\_image) | git::http://172.20.14.17/jiajian.chi/terraform-zstack-image.git | v1.1.1 |
| <a name="module_logserver_instance"></a> [logserver\_instance](#module\_logserver\_instance) | git::http://172.20.14.17/jiajian.chi/terraform-zstack-instance.git | v1.1.1 |

## Resources

| Name | Type |
|------|------|
| [local_file.dockercompose](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [terraform_data.remote_exec](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_storage_name"></a> [backup\_storage\_name](#input\_backup\_storage\_name) | Name of the backup storage to use | `string` | `"bs"` | no |
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br/><br/>Examples:<pre>context:<br/>  project:<br/>    name: string<br/>    id: string<br/>  environment:<br/>    name: string<br/>    id: string<br/>  resource:<br/>    name: string<br/>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_expunge"></a> [expunge](#input\_expunge) | n/a | `bool` | `true` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name for the log server image | `string` | `"logserver-by-terraform"` | no |
| <a name="input_image_url"></a> [image\_url](#input\_image\_url) | URL to download the image from | `string` | `"http://minio.zstack.io:9001/packer/logserver-by-packer-image-compressed.qcow2"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name for the log server instance | `string` | `"logserver_instance"` | no |
| <a name="input_instance_offering_name"></a> [instance\_offering\_name](#input\_instance\_offering\_name) | Name of the instance offering to use | `string` | `"min"` | no |
| <a name="input_l3_network_name"></a> [l3\_network\_name](#input\_l3\_network\_name) | Name of the L3 network to use | `string` | `"test"` | no |
| <a name="input_never_stop"></a> [never\_stop](#input\_never\_stop) | VM HA | `bool` | `true` | no |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | SSH password for remote access | `string` | `"password"` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH username for remote access | `string` | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | n/a |
| <a name="output_es"></a> [es](#output\_es) | elastic search endpoint |
| <a name="output_instance_info"></a> [instance\_info](#output\_instance\_info) | n/a |
| <a name="output_kafka_ui"></a> [kafka\_ui](#output\_kafka\_ui) | kafka ui |
| <a name="output_loki"></a> [loki](#output\_loki) | loki endpoint |
| <a name="output_service_ip"></a> [service\_ip](#output\_service\_ip) | Service IP |
| <a name="output_walrus_environment_id"></a> [walrus\_environment\_id](#output\_walrus\_environment\_id) | The id of environment where deployed in Walrus. |
| <a name="output_walrus_environment_name"></a> [walrus\_environment\_name](#output\_walrus\_environment\_name) | The name of environment where deployed in Walrus. |
| <a name="output_walrus_project_id"></a> [walrus\_project\_id](#output\_walrus\_project\_id) | The id of project where deployed in Walrus. |
| <a name="output_walrus_project_name"></a> [walrus\_project\_name](#output\_walrus\_project\_name) | The name of project where deployed in Walrus. |
| <a name="output_walrus_resource_id"></a> [walrus\_resource\_id](#output\_walrus\_resource\_id) | The id of resource where deployed in Walrus. |
| <a name="output_walrus_resource_name"></a> [walrus\_resource\_name](#output\_walrus\_resource\_name) | The name of resource where deployed in Walrus. |
<!-- END_TF_DOCS -->

## 服务与端口

本日志服务器提供以下核心服务：

1. **Rsyslog 服务**
   - **端口**: 514 (UDP/TCP)
   - **功能**: 接收远程系统日志消息
   - **配置文件**: `/etc/rsyslog.conf`

2. **Elasticsearch**
   - **端口**: 9200
   - **功能**: 日志存储和搜索引擎
   - **验证方式**: `curl http://<服务器IP>:9200/_cluster/health`

3. **Loki**
   - **端口**: 3100
   - **功能**: 日志聚合系统
   - **验证方式**: `curl http://<服务器IP>:3100/ready`

4. **Fluent Bit**
   - **端口**: 24224
   - **功能**: 日志收集和处理
   - **验证方式**: `curl http://<服务器IP>:24224/api/v1/metrics`

5. **Kafka (Web 界面)**
   - **端口**: 9092, 9093
   - **功能**: kafka ui
   - **访问方式**: `http://<服务器IP>:7777`

## 服务验证

### Elasticsearch 验证
```bash
# 检查集群健康状态
curl http://<服务器IP>:9200/_cluster/health

# 查看索引列表
curl http://<服务器IP>:9200/_cat/indices
```

### Loki 验证
```bash
# 检查 Loki 服务是否就绪
curl http://<服务器IP>:3100/ready

# 检查 Loki 服务状态
curl http://<服务器IP>:3100/metrics
```

### Fluent Bit 验证
```bash
# 检查 Fluent Bit 指标
curl http://<服务器IP>:24224/api/v1/metrics

# 发送测试日志
echo '{"log": "测试日志消息"}' | nc <服务器IP> 24224
```

### Rsyslog 验证
```bash
# 发送测试日志
logger -n <服务器IP> -P 514 "测试系统日志消息"
```

## 配置变量说明

### ZStack 连接配置
- **host**: ZStack API 服务器地址
- **account_name**: ZStack 账户名
- **account_password**: ZStack 账户密码

### 镜像配置
- **image_name**: 日志服务器镜像名称
- **image_url**: 镜像下载地址
- **backup_storage_name**: 备份存储名称

### 实例配置
- **instance_name**: 虚拟机实例名称
- **l3_network_name**: 网络名称，用于网络连接
- **instance_offering_name**: 实例规格，决定资源分配

### SSH 配置
- **ssh_user**: SSH 连接用户名
- **ssh_password**: SSH 连接密码

