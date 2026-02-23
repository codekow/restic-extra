# Restic Repo Info

Insert useful repo information here.

## Usage

Create new local `restic` repo and then add parity using the following:

```sh
cp restic.env.example restic.env

# modify the env with your password or AWS vars
. restic.env
```

```sh
restic init -r .
```

Add scripts to existing restic repo

```sh
git init
git remote add origin https://github.com/codekow/restic-extra.git
git fetch
git checkout main
```

```sh
VERIFY=true ./restic-parity.sh

du -sh data par2
```

Clean

```sh
git clean -dxf
```

## Install Restic Server

```sh
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

```sh
STORAGE_PATH=/storage/restic
getent group backup || groupadd -g 34 backup
id backup || useradd -u 34 -g 34 backup

[ -d "${STORAGE_PATH}" ] || mkdir -p "${STORAGE_PATH}"
chown backup:backup "${STORAGE_PATH}"
chmod 770 "${STORAGE_PATH}"

cp files/etc/systemd/system/rest-server.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now rest-server
systemctl status rest-server

firewall-cmd --add-port 8000/tcp --permanent
firewall-cmd --reload
```

```sh
touch ./htpasswd
htpasswd -C10 -B ./htpasswd cfi-main.restic
```

## Links

- [Restic Windows Backup](https://github.com/kmwoley/restic-windows-backup)
