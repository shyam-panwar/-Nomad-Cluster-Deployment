 #!/bin/bash

NOMAD_USER_TOKEN_FILENAME="nomad.token"
LB_ADDRESS=$(terraform output -raw lb_address_consul_nomad)
CONSUL_BOOTSTRAP_TOKEN=$(terraform output -raw consul_bootstrap_token_secret)

# Get nomad user token from consul kv
NOMAD_TOKEN=$(curl -s --header "Authorization: Bearer ${CONSUL_BOOTSTRAP_TOKEN}" "${LB_ADDRESS}:8500/v1/kv/nomad_user_token?raw")

# Save token to file if file doesn't already exist
if [ ! -f $NOMAD_USER_TOKEN_FILENAME ]; then
    echo $NOMAD_TOKEN > $NOMAD_USER_TOKEN_FILENAME

    # Check length of token to see if retrieval worked before deleting from KV
    if [ ${#NOMAD_TOKEN} -eq 36 ]; then
        # Delete nomad user token from consul kv
        DELETE_TOKEN=$(curl -s -X DELETE --header "Authorization: Bearer ${CONSUL_BOOTSTRAP_TOKEN}" "${LB_ADDRESS}:8500/v1/kv/nomad_user_token")

        echo -e "\nThe Nomad user token has been saved locally to $NOMAD_USER_TOKEN_FILENAME and deleted from the Consul KV store."

        echo -e "\nSet the following environment variables to access your Nomad cluster with the user token created during setup:\n\nexport NOMAD_ADDR=\$(terraform output -raw lb_address_consul_nomad):4646\nexport NOMAD_TOKEN=\$(cat $NOMAD_USER_TOKEN_FILENAME)\n"

        echo -e "\nThe Nomad UI can be accessed at ${LB_ADDRESS}:4646/ui\nwith the bootstrap token: $(cat $NOMAD_USER_TOKEN_FILENAME)"
        
    else
        echo -e "\nSomething went wrong when retrieving the token from the Consul KV store.\nCheck the nomad.token file or wait a bit and then try running the script again.\n\nNOT deleting token from KV."
    fi
    
else 
    echo -e "\n***\nThe $NOMAD_USER_TOKEN_FILENAME file already exists - not overwriting. If this is a new run, delete it first.\n***"
fi

echo -e "\nPost-setup script complete."
# End of script


# -----------------------------
# Secure Nomad UI with NGINX + Basic Auth
# -----------------------------

echo -e "\nSetting up NGINX reverse proxy with Basic Auth for Nomad UI...\n"

# Install nginx and htpasswd tool
sudo apt-get update -y && sudo apt-get install -y nginx apache2-utils

# Create Basic Auth credentials (user: admin / password: StrongPass123)
if [ ! -f /etc/nginx/.htpasswd ]; then
    sudo htpasswd -bc /etc/nginx/.htpasswd admin StrongPass123
    echo "Basic Auth user 'admin' created with password 'StrongPass123'"
else
    echo "Basic Auth credentials already exist, skipping..."
fi

# Configure NGINX reverse proxy
sudo tee /etc/nginx/sites-available/nomad.conf > /dev/null <<EOL
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:4646;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        auth_basic "Restricted Nomad UI";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL

# Enable config and restart nginx
sudo ln -sf /etc/nginx/sites-available/nomad.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

echo -e "\n✅ Nomad UI is now protected:\n"
echo "👉 Access via: http://$LB_ADDRESS/"
echo "👉 Login with Basic Auth: admin / StrongPass123"
echo "👉 Then use your Nomad ACL Token from nomad.token"



