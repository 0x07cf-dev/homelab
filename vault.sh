#!/bin/bash
# Helper script that encrypts or decrypts all found ansible-vault secrets.

function show_usage() {
    echo ""
    echo "Usage: $0 [encrypt|decrypt]"
    echo "Exactly one argument is required:"
    echo " - encrypt    Encrypts all secret files"
    echo " - decrypt    Decrypts all secret files"
    exit 1
}

if [[ $# -eq 0 ]]; then
    echo "ERROR: mode not specified."
    show_usage
fi

files=(
    "./group_vars/all/vault.yml"
    "./group_vars/cloud/vault.yml"
)

if [[ $1 == "encrypt" ]]; then
    if ansible-vault encrypt "${files[@]}"; then
        for file in "${files[@]}"; do
            echo "$file"
        done
    fi

elif [[ $1 == "decrypt" ]]; then
    if ansible-vault decrypt "${files[@]}"; then
        for file in "${files[@]}"; do
            echo "$file"
        done
    fi
else
    echo "ERROR: Invalid argument: ${1}"
    show_usage
fi
