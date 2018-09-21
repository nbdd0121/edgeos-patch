if [ -z "$TARGET" ]
then
    echo "Please set \$TARGET"
    exit
fi

echo Uploading
scp -r b $TARGET:/tmp/patched
echo Overriding
ssh -tt $TARGET <<EOF
sudo bash
mv /tmp/patched/vpn-config.pl /opt/vyatta/sbin
mv /tmp/patched/vyatta-vti-config.pl /opt/vyatta/sbin/
mv /tmp/patched/vtiIntf.pm /opt/vyatta/share/perl5/Vyatta/VPN/
mv /tmp/patched/node.def /opt/vyatta/share/vyatta-cfg/templates/interfaces/vti/node.tag/address/
rm -rf /tmp/patched
exit
exit
EOF
echo Completed

