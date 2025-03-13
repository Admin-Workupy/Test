#! /bin/sh

main() {
  SCRIPT_PATH="$(set_script_path)"
  ROOT_PATH="$(dirname "$SCRIPT_PATH")"

  git_submodule_update

  cp_envs

  build_images

  echompose

  fixes

  printf \
    'Verifique os arquivos na pasta %s/env e o arquivo %s/compose.yaml para configurar as variáveis de ambiente!' \
    "$ROOT_PATH" "$ROOT_PATH"
}

git_submodule_update() {
  git -C "$ROOT_PATH" submodule update --init --recursive --remote

  clear
}

cp_envs() {
  for base_service in mysql nginx; do
    cp "$ROOT_PATH/env/.env.$base_service.example" "$ROOT_PATH/env/.env.$base_service"
  done

  for module in backend frontend; do
    cp "$ROOT_PATH/modules/$module/.env.example" "$ROOT_PATH/env/.env.$module"
  done
}

build_images() {
  for base_service in node mysql nginx; do
    docker compose -f "$ROOT_PATH/docker/compose.yaml" build $base_service

    clear
  done

  for module in backend frontend; do
    docker compose -f "$ROOT_PATH/modules/$module/compose.yaml" build $module

    clear
  done
}

echompose() {
  {
    echo 'name: 'workupy-test''
    echo 'services:'
    echo '  ingress:'
    echo '    extends:'
    echo '      service: nginx'
    echo '      file: ./docker/compose.yaml'
    echo '    depends_on:'
    echo '      - backend'
    echo '      - frontend'
    echo '    networks:'
    echo '      - workupy-test-net'
    echo '    ports:'
    echo '      - 8080:8080'
    echo '  database:'
    echo '    extends:'
    echo '      service: mysql'
    echo '      file: ./docker/compose.yaml'
    echo '    networks:'
    echo '      - workupy-test-net'
    echo '  backend:'
    echo '    extends:'
    echo '      service: backend'
    echo '      file: ./modules/backend/compose.yaml'
    echo '    depends_on:'
    echo '      - database'
    echo '    env_file:'
    echo '      - ./env/.env.backend'
    echo '    networks:'
    echo '      - workupy-test-net'
    echo '    volumes:'
    echo '      - ./modules/backend/src:/home/workupy/src:rw'
    echo '  frontend:'
    echo '    extends:'
    echo '      service: frontend'
    echo '      file: ./modules/frontend/compose.yaml'
    echo '    depends_on:'
    echo '      - backend'
    echo '    env_file:'
    echo '      - ./env/.env.frontend'
    echo '    networks:'
    echo '      - workupy-test-net'
    echo '    volumes:'
    echo '      - ./modules/frontend/src:/home/workupy/src:rw'
    echo 'networks:'
    echo '  workupy-test-net:'
    echo '    name: 'workupy-test-net''
  } > "$ROOT_PATH/compose.yaml"  
}

fixes() {
  sh "$SCRIPT_PATH/db-fix.sh" && \
  sh "$SCRIPT_PATH/dns-fix.sh" && \
  sh "$SCRIPT_PATH/port-fix.sh"

  clear
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
