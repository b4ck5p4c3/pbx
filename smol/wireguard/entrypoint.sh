#!/bin/sh
set -e

: "${WG_PRIVATE_KEY:?WG_PRIVATE_KEY is required}"
: "${WG_LOCAL_IP:?WG_LOCAL_IP is required}"
: "${WG_PSK:?WG_PSK is required}"

IFACE=bksp-siprnet
CONF=/etc/wireguard/${IFACE}.conf

mkdir -p /etc/wireguard
chmod 700 /etc/wireguard

# Write config with permissions restricted before populating secrets
install -m 600 /dev/null "$CONF"

cat > "$CONF" << EOF
[Interface]
PrivateKey = ${WG_PRIVATE_KEY}
Address = ${WG_LOCAL_IP}

[Peer]
PublicKey = h4CWg3xFvpNv8+rOMSQtrYpkzPYEkbi+Yae3/wjskmQ=
PresharedKey = ${WG_PSK}
Endpoint = sip.bksp.in:37201
AllowedIPs = fd91:652e:271a:e164:100c::1/128
PersistentKeepalive = 30
EOF

cleanup() {
    echo "Bringing down ${IFACE}..."
    wg-quick down "$IFACE" 2>/dev/null || true
    exit 0
}
trap cleanup INT TERM

echo "Bringing up ${IFACE}..."
wg-quick up "$IFACE"

echo "WireGuard interface ${IFACE} is up."
wg show "$IFACE"

# Wait indefinitely, waking on signal
while true; do
    sleep 30 &
    wait $!
done
