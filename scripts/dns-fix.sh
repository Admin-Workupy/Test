#! /bin/sh

main() {
  SCRIPT_PATH="$(set_script_path)"
  ROOT_PATH="$(dirname "$SCRIPT_PATH")"

  dns_host="$(cat -n /etc/hosts | grep '^ *3' | awk '{print $3}')-4444.csb.app"

  for container in ingress frontend; do
    docker compose -f "$ROOT_PATH/compose.yaml" stop $container && \
      echo y | docker compose -f "$ROOT_PATH/compose.yaml" rm $container

    case $container in
      ingress)
        sed -i "s/^DNS_HOST=.*/DNS_HOST=$dns_host/" "$ROOT_PATH/env/.env.nginx"
      ;;

      frontend)
        sed -i "s/^DNS_HOST=.*/DNS_HOST=$dns_host/" "$ROOT_PATH/env/.env.$container"
        sed -i "s/^VITE_DNS_HOST=.*/VITE_DNS_HOST=$dns_host/" "$ROOT_PATH/env/.env.$container"
      ;;
    esac
  done

  docker compose -f "$ROOT_PATH/compose.yaml" up -d
}

set_script_path() (
  target=$0
  name=''
  targetdir=''
  CDPATH=''

  { \unalias command; \unset -f command; } >/dev/null 2>&1

  # shellcheck disable=SC2034
  [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on

  while :
  do
    [ -L "$target" ] || [ -e "$target" ] || return 1

    # shellcheck disable=SC2164
    command cd "$(command dirname -- "$target")"

    name=$(command basename -- "$target")

    [ "$name" = '/' ] && name=''

    if [ -L "$name" ]; then
      target=$(command ls -l "$name")
      target=${target#* -> }

      continue
    fi

    break
  done

  targetdir=$(command pwd -P)

  if  [ "$name" = '..' ]; then
    SCRIPT_PATH=$(command dirname -- "${targetdir}")
  else
    SCRIPT_PATH=${targetdir%/}
  fi

  echo "$SCRIPT_PATH"
)

main
