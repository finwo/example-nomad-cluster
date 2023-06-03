datacenter = "eu-north1-a"
data_dir   = "/opt/nomad"
bind_addr  = "0.0.0.0"

consul {
  address             = "192.168.240.250:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}
