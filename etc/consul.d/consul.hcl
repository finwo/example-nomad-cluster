datacenter  = "eu-north1-a"
data_dir    = "/opt/consul"
bind_addr   = "0.0.0.0"
client_addr = "0.0.0.0"
server      = true

ui_config {
  enabled = true
}

bootstrap_expect = 1
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
retry_join = ["192.168.240.250"]
