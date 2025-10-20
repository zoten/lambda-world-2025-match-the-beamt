# NTP sync

For simplicity we'll sync against Google's NTP

## Linux

### chrony

``` bash
# sudo apt-get install chrony ofc
# Edit /etc/chrony/chrony.conf
sudo bash -c 'cat > /etc/chrony/chrony.conf << EOF
server time.google.com iburst
server time.cloudflare.com iburst
makestep 1.0 3
EOF'

sudo systemctl restart chronyd
sudo chronyc makestep  # Force immediate sync
```

### systemd-timesyncd

``` bash
# Edit /etc/systemd/timesyncd.conf
sudo bash -c 'cat > /etc/systemd/timesyncd.conf << EOF
[Time]
NTP=time.google.com time.cloudflare.com
FallbackNTP=time.apple.com
EOF'

sudo systemctl restart systemd-timesyncd
sudo timedatectl set-ntp true  # Ensure NTP is enabled
```

## MacOS

``` bash
sudo systemsetup -setnetworktimeserver time.google.com
sudo systemsetup -setusingnetworktime on
```
