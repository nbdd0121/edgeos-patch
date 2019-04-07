edgeos-patch
============

This tiny project patches EdgeOS/VyOS to support:
* Use any/default as local-address for ipsec vpn even if vti is used.
* Negotiate ::/0 in addition to 0.0.0.0/0 when vti is used.
* Allow IPv6 addresses to be used on vti interfaces.
* Allow vti to be used along with dhcp-interface
* Allow duplicate assignment of /32 (v4) and /128 (v6) addresses

Usage is simple: cd to the project directory, and do
```
TARGET=<your EdgeRouter ip> ./patch.sh
```
Be careful if any patch failed, which may indicate that the EdgeOS firmware is updated so that this simple patch is no longer usable.

