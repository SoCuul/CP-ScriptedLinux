# Many ideas taken (stolen) from: https://gist.github.com/bobpaw/a0b6828a5cfa31cfe9007b711a36082f

read -p "Press enter to begin securing the system..."
echo ""

# Install updates
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# Configure ufw (firewall)
apt-get install ufw && ufw allow ssh && ufw --force enable

# Configure ssh server
if grep -qF 'PermitRootLogin' /etc/ssh/sshd_config;
    then sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config;
else echo 'PermitRootLogin no' >> /etc/ssh/sshd_config;
fi

# Lock root user
passwd -l root

# Change login requirements (i hope to god this works)
sed -i 's/PASS_MAX_DAYS.*$/PASS_MAX_DAYS 90/;s/PASS_MIN_DAYS.*$/PASS_MIN_DAYS 10/;s/PASS_WARN_AGE.*$/PASS_WARN_AGE 7/' /etc/login.defs

# Disable avahi
systemctl disable avahi-daemon

# Disable guest account
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf

# Check for non-root UID 0 users
echo ""
echo "Checking for non-root UID 0 users..."
mawk -F: '$3 == 0 && $1 != "root"' /etc/passwd