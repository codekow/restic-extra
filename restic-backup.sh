#!/bin/sh

restic_backup(){
  BACKUP_DIR=${1:-/}
  TAG=${2:-manual}

  RESTIC_REPOSITORY=$(pwd)
  RESTIC_PASSWORD="ishouldworryaboutsecurity"
  export RESTIC_REPOSITORY RESTIC_PASSWORD

  [ -e restic.exclude ] || touch restic.exclude

  # shellcheck source=/dev/null
  [ -e restic.env ] && . ./restic.env

  restic backup \
    --tag "${TAG}" \
    --exclude-file restic.exclude \
    --exclude-if-present .nobackup \
    "${BACKUP_DIR}"
}

restic_snapshots(){
  restic snapshots
}

restic_find_nobackup(){
  find / -type f -name .nobackup
}

restic_backup "${1}"
