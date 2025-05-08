#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: Vault name must be provided as a command line argument"
    echo "Usage: $0 <vault-name>"
    exit 1
fi

VAULT_NAME="$1"

SECRETS_FILE="app_secrets/$VAULT_NAME"

if [ ! -f "$SECRETS_FILE" ]; then
    echo "Error: Secrets file not found at $SECRETS_FILE"
    exit 1
fi

source "$SECRETS_FILE"

if [ ${#secrets[@]} -eq 0 ]; then
    echo "Warning: No secrets found in $SECRETS_FILE"
    exit 0
fi

for key in "${!secrets[@]}"; do
    az keyvault secret set --vault-name "$VAULT_NAME" --name "$key" --value "${secrets[$key]}"
    # echo "Adding ${secrets[$key]} to key $key to vault $VAULT_NAME"
done

echo "Completed adding ${#secrets[@]} secrets to $VAULT_NAME"