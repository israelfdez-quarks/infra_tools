#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <vault-name>"
    exit 1
fi

VAULT_NAME=$1
OUTPUT_FILE="app_secrets/$VAULT_NAME"

mkdir -p app_secrets

# Check if user is logged in to Azure
if ! az account show &> /dev/null; then
    echo "Error: Not logged in to Azure. Please run 'az login' first"
    exit 1
fi

echo "Fetching secrets from vault: $VAULT_NAME..."

SECRET_NAMES=$(az keyvault secret list --vault-name "$VAULT_NAME" --query "[].name" -o tsv)

if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch secrets list. Please check vault name and permissions."
    exit 1
fi

if [ -z "$SECRET_NAMES" ]; then
    echo "No secrets found in the vault."
    exit 0
fi

echo "# Auto-generated from $VAULT_NAME on $(date)" > "$OUTPUT_FILE"
echo "declare -A secrets" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "secrets=(" >> "$OUTPUT_FILE"

has_secrets=false

while IFS= read -r secret_name; do
    secret_value=$(az keyvault secret show --vault-name "$VAULT_NAME" --name "$secret_name" --query "value" -o tsv)
    echo "  [\"$secret_name\"]=\"$secret_value\"" >> "$OUTPUT_FILE"
    has_secrets=true
    echo "Exported secret: $secret_name"
done <<< "$SECRET_NAMES"

echo ")" >> "$OUTPUT_FILE"

if [ "$has_secrets" = true ]; then
    echo "Successfully exported secrets to $OUTPUT_FILE"
    echo "Note: This file is listed in .gitignore to prevent accidentally committing secrets"
else
    echo "No secrets were exported"
fi