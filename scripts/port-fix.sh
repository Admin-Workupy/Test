#! /bin/sh

main() {
  SCRIPT_PATH="$(set_script_path)"
  ROOT_PATH="$(dirname "$SCRIPT_PATH")"

  for container in mysql backend frontend nginx; do
    docker compose -f "$ROOT_PATH/compose.yaml" stop $container && \
      echo y | docker compose -f "$ROOT_PATH/compose.yaml" rm $container

    case $container in
      mysql)
        sed -i 's/^DB_PORT=.*/DB_PORT=3306/' "$ROOT_PATH/env/.env.backend"
      ;;

      backend)
        sed -i 's/^HTTP_PORT=.*/HTTP_PORT=8000/' "$ROOT_PATH/env/.env.backend"

        sed -i 's/^HTTP_PORT_BACKEND=.*/HTTP_PORT_BACKEND=8000/' "$ROOT_PATH/env/.env.nginx"
      ;;

      frontend)
        sed -i 's/^HTTP_PORT=.*/HTTP_PORT=3000/' "$ROOT_PATH/env/.env.frontend"
        sed -i 's/^VITE_HTTP_PORT=.*/VITE_HTTP_PORT=3000/' "$ROOT_PATH/env/.env.frontend"

        sed -i 's/^HTTP_PORT_BACKEND=.*/HTTP_PORT_BACKEND=3000/' "$ROOT_PATH/env/.env.nginx"
      ;;

      nginx)
        sed -i 's/^HTTP_PORT=.*/HTTP_PORT=4444/' "$ROOT_PATH/env/.env.nginx"

        sed 's/^\(\s*- \)8080:8080/\14444:4444/' "$ROOT_PATH/compose.yaml"
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

main "$@"
