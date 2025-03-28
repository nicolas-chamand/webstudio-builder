#!/bin/bash

# Define static values
APP_PORT=8080
DB_NAME="webstudio"
DB_USER="webstudio_user"

# Generate random secrets
DB_PASSWORD=$(openssl rand -hex 32)
AUTH_SECRET=$(openssl rand -hex 32)
JWT_SECRET=$(openssl rand -hex 32)

# Function to perform Base64 URL encoding
base64url_encode() {
    echo -n "$1" | openssl base64 -A | tr '+/' '-_' | tr -d '='
}

# JWT Header
HEADER='{"alg":"HS256","typ":"JWT"}'
HEADER_BASE64=$(base64url_encode "$HEADER")

# JWT Payload
PAYLOAD=$(jq -c --null-input --arg role "$DB_USER" '{
    iss: "supabase",
    ref: "kmdpixzoqiirbmpdippy",
    role: $role,
    iat: 1666336428,
    exp: 1981912428
}')
PAYLOAD_BASE64=$(base64url_encode "$PAYLOAD")

# Create Signature (ensure raw binary output before Base64 URL encoding)
SIGNATURE_RAW=$(echo -n "$HEADER_BASE64.$PAYLOAD_BASE64" | openssl dgst -sha256 -mac HMAC -macopt key:"$JWT_SECRET" -binary)
SIGNATURE=$(base64url_encode "$SIGNATURE_RAW")

# Full JWT Token
POSTGREST_API_KEY="$HEADER_BASE64.$PAYLOAD_BASE64.$SIGNATURE"

# Create .env file
cat > .env <<EOL
APP_PORT=$APP_PORT

DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
AUTH_SECRET=$AUTH_SECRET

JWT_SECRET=$JWT_SECRET

POSTGREST_API_KEY=$POSTGREST_API_KEY
EOL

echo ".env file has been created successfully."
