if [ -z "$TARGET" ]
then
    echo "Please set \$TARGET"
    exit
fi

mkdir -p patched
echo Fetching files to patch
scp $TARGET:"/opt/vyatta/sbin/vpn-config.pl /opt/vyatta/sbin/vyatta-vti-config.pl /opt/vyatta/share/perl5/Vyatta/VPN/vtiIntf.pm /opt/vyatta/share/vyatta-cfg/templates/interfaces/vti/node.tag/address/node.def /opt/vyatta/sbin/vyatta-interfaces.pl" patched/
echo Files fetched
diff -u a b | (cd patched; patch -p1)
read -p "Files patched. Do you want to override these files on target? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
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
fi
