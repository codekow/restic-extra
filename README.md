# Restic Repo Info

Insert useful repo information here.

## Usage

Create new local `restic` repo and then add parity using the following:

```sh
cp .env-example .env

# modify the env with your password or AWS vars
. .env
```

```sh
restic init
```

```sh
git init
git remote add origin https://github.com/codekow/restic-extra.git
git fetch
git checkout main
```

```sh
./create-parity.sh

du -hs data par2
```
