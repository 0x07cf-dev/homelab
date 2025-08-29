#!/bin/bash
# Helper script that encrypts or decrypts all found secrets.
# Looks for vault.yml files under *_vars directories.
set -euo pipefail
shopt -s globstar nullglob

function print_usage() {
    echo ""
    echo "Usage: $0 [encrypt|decrypt]"
    echo ""
    echo "Exactly one argument is required:"
    echo " - encrypt    Encrypts all secret files"
    echo " - decrypt    Decrypts all secret files"
    exit 1
}

if [[ $# -eq 0 ]]; then
    echo "ERROR: mode not specified."
    print_usage
fi

files=(
    ./**/*_vars/**/vault.yml
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
    echo "ERROR: invalid argument: ${1}"
    print_usage
fi
