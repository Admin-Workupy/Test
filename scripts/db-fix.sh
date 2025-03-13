#! /bin/sh

main() {
  SCRIPT_PATH="$(set_script_path)"
  ROOT_PATH="$(dirname "$SCRIPT_PATH")"

  mysql_root_password="$(gpg --gen-random --armor 1 64 | tr -d "=+/" | cut -c1-25)"

  for container in mysql backend; do
    docker compose -f "$ROOT_PATH/compose.yaml" stop $container && \
      echo y | docker compose -f "$ROOT_PATH/compose.yaml" rm $container

    case $container in
      mysql)
        sed -i "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$mysql_root_password/" "$ROOT_PATH/env/.env.mysql"
      ;;

      backend)
        sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$mysql_root_password/" "$ROOT_PATH/env/.env.backend"
        sed -i 's/^DB_HOST=.*/DB_HOST=database/' "$ROOT_PATH/env/.env.backend"
      ;;
    esac

    docker compose -f "$ROOT_PATH/compose.yaml" up -d $container

    if [ $container = 'mysql' ]; then
      sleep 5
    fi
  done
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

main "$@"
