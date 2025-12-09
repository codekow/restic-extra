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
