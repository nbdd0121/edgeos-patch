[private]
default:
    just --list

gen_patch:
    diff -u a b > patch.diff || true

# Fetch files
fetch:
    mkdir -p fetched
    scp -O $TARGET:/opt/vyatta/\{sbin/vpn-config.pl,sbin/vyatta-vti-config.pl,share/perl5/Vyatta/VPN/vtiIntf.pm,share/vyatta-cfg/templates/interfaces/vti/node.tag/address/node.def,sbin/vyatta-interfaces.pl\} fetched

# Patch fetched files
patch: gen_patch
    rm -rf patched
    cp -r fetched patched
    cat patch.diff | (cd patched; patch -p1)

# Override with patched files
override:
    #!/usr/bin/env bash
    echo Uploading
    scp -r patched $TARGET:/tmp/patched
    echo Overriding
    ssh -tt $TARGET <<EOF
    sudo bash
    mv /tmp/patched/vpn-config.pl /opt/vyatta/sbin
    mv /tmp/patched/vyatta-vti-config.pl /opt/vyatta/sbin/
    mv /tmp/patched/vtiIntf.pm /opt/vyatta/share/perl5/Vyatta/VPN/
    mv /tmp/patched/node.def /opt/vyatta/share/vyatta-cfg/templates/interfaces/vti/node.tag/address/
    mv /tmp/patched/vyatta-interfaces.pl /opt/vyatta/sbin/
    rm -rf /tmp/patched
    exit
    exit
    EOF
    echo Completed

