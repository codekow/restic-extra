#!/bin/bash
# set -x
# DEBUG=true

which par2 || exit 1

# path to par2
PAR2_DIR=${PAR2_DIR:-par2}

# percentage redundancy desired
PERCENT=5

# oldest file for which to create parchive files (-3 = 3 days before present)
# FIND_OPTS="-mtime -1"

create_par2(){
  FILE="${1}"
  DIR=$(dirname "${FILE}")
  FILENAME=$(basename "${FILE}")

  PARITY_DIR="${PAR2_DIR}/${DIR}"
  PARITY_FILENAME="${PARITY_DIR}/${FILENAME}"

  # create directory if it doesn't exist
  if [[ ! -d "${PARITY_DIR}" ]]; then
    echo making directory "${PARITY_DIR}"
    mkdir -p "${PARITY_DIR}"
  fi

  # create par file if it doesn't exist
  if [ ! -f "${PARITY_FILENAME}-${PERCENT}.par2" ]; then
    [ -n "${DEBUG}" ] && echo "run: par2 create -q -B ./ -n1 -r${PERCENT} ${PARITY_FILENAME} ..."
    [ -n "${DEBUG}" ] && echo "in $(pwd)"
    par2 create -q -B ./ -n1 -r${PERCENT} "${PARITY_FILENAME}" "${FILE}"

    # remove index; rename main file
    rm "${PARITY_FILENAME}".par2
    mv "${PARITY_FILENAME}".vol*par2 "${PARITY_FILENAME}-${PERCENT}".par2
  else
    [ -n "${VERIFY}" ] || return
    par2 verify -qq -B ./ "${PARITY_FILENAME}-${PERCENT}".par2 || \
      { echo "${FILE} needs REPAIR" && \
      par2 repair -B ./ "${PARITY_FILENAME}-${PERCENT}".par2
      }
  fi
}

repo_scan(){

  create_par2 ./config
  # find any files changed within $mtime days and pipe them into the do loop
  # shellcheck disable=SC2086
  find . ${FIND_OPTS} \
    -type f \
    -not -name "*.sh" \
    \( -path "./data/*" -o \
    -path "./index/*" -o \
    -path "./keys/*" -o \
    -path "./snapshots/*" \) \
    -print0 | while IFS= read -r -d '' FIND_FILE
  do
    [ -n "${DEBUG}" ] && echo "${FIND_FILE}"
    create_par2 "${FIND_FILE}"
  done

  # du -hs "${PAR2_DIR}"
}

verify_file(){
  VERIFY=true
  repo_scan
}

delete_parity(){
  rm -rf "${PAR2_DIR}"
}

repo_scan
