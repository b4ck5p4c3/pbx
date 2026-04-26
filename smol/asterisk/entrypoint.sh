#!/bin/sh
set -e

VARS='${SMOL_CID}:${SMOL_PBX_USERNAME}:${SMOL_PBX_PASSWORD}:${SMOL_LOCAL_USERNAME}:${SMOL_LOCAL_PASSWORD}'

for f in /etc/asterisk/*.conf; do
    envsubst "$VARS" < "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done

exec asterisk -f
