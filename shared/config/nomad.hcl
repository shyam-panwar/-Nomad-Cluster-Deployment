data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

# Enable the server
server {
  enabled  = true
  # bootstrap_expect = SERVER_COUNT
  bootstrap_expect = 1
}

consul {
  address = "127.0.0.1:8500"
  token = "CONSUL_TOKEN"
}

acl {
  enabled = true
  token_ttl = "30m"
  token_max_ttl = "30m"
  default_policy = "deny"
  enable_token_persistence = true
}

vault {
  enabled          = false
  address          = "http://active.vault.service.consul:8200"
  task_token_ttl   = "1h"
  create_from_role = "nomad-cluster"
  token            = ""
}

ui {
  enabled = true
  http = "127.0.0.1:4646"
}
