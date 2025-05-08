#!/bin/bash

# Check if vault name is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <vault-name>"
    exit 1
fi

VAULT_NAME=$1

# Check if user is logged in to Azure
if ! az account show &> /dev/null; then
    echo "Error: Not logged in to Azure. Please run 'az login' first"
    exit 1
fi

echo "Fetching secrets from vault: $VAULT_NAME..."
echo "----------------------------------------"

# Get list of all secret names
SECRET_NAMES=$(az keyvault secret list --vault-name "$VAULT_NAME" --query "[].name" -o tsv)

if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch secrets list. Please check vault name and permissions."
    exit 1
fi

# Check if any secrets exist
if [ -z "$SECRET_NAMES" ]; then
    echo "No secrets found in the vault."
    exit 0
fi

# Iterate through each secret and get its value
while IFS= read -r secret_name; do
    echo "Secret: $secret_name"
    echo "Value: $(az keyvault secret show --vault-name "$VAULT_NAME" --name "$secret_name" --query "value" -o tsv)"
    echo "----------------------------------------"
done <<< "$SECRET_NAMES"