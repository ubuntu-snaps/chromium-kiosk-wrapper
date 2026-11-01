#!/bin/bash -eu
# Download Chrome extensions by ID at build time

set -e

EXTENSIONS_DIR="$1"
EXTENSION_IDS="$2"

if [ -z "$EXTENSIONS_DIR" ] || [ -z "$EXTENSION_IDS" ]; then
    echo "Usage: $0 <extensions-dir> <comma-separated-extension-ids>"
    exit 1
fi

mkdir -p "$EXTENSIONS_DIR"

IFS=',' read -ra IDS <<< "$EXTENSION_IDS"
for EXT_ID in "${IDS[@]}"; do
    EXT_ID=$(echo "$EXT_ID" | xargs)  # trim whitespace
    if [ -z "$EXT_ID" ]; then
        continue
    fi

    echo "Downloading extension: $EXT_ID"

    # Chrome Web Store CRX download URL
    # Using the update API which returns a redirect to the CRX file
    CRX_URL="https://clients2.google.com/service/update2/crx?response=redirect&prodversion=120&acceptformat=crx2,crx3&x=id%3D${EXT_ID}%26uc"

    OUTPUT_FILE="${EXTENSIONS_DIR}/${EXT_ID}.crx"

    # Download with curl, following redirects
    if curl -fL -o "$OUTPUT_FILE" "$CRX_URL" 2>/dev/null; then
        # Verify it's a valid CRX file (starts with "Cr24" magic bytes)
        if head -c 4 "$OUTPUT_FILE" | grep -q "Cr24"; then
            echo "  ✓ Downloaded: $EXT_ID"
        else
            echo "  ✗ Invalid CRX file for: $EXT_ID"
            rm -f "$OUTPUT_FILE"
        fi
    else
        echo "  ✗ Failed to download: $EXT_ID"
        rm -f "$OUTPUT_FILE"
    fi
done

echo "Extension download complete. Files in $EXTENSIONS_DIR:"
ls -la "$EXTENSIONS_DIR"