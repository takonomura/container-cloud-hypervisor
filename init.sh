#!/bin/sh
set -eu

i=0
for dev in ${REDIRECT_DEV=}; do
  tap="tap$i"
  ip tuntap add dev "$tap" mode tap

  tc qdisc  add dev "$dev" ingress
  tc filter add dev "$dev" parent ffff: protocol all u32 match u8 0 0 action mirred egress redirect dev "$tap"
  tc qdisc  add dev "$tap" ingress
  tc filter add dev "$tap" parent ffff: protocol all u32 match u8 0 0 action mirred egress redirect dev "$dev"

  ip link set dev "$tap" up

  i=$((i + 1))
done

exec "$@"
