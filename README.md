# Workupy - Test

Seja bem-vindo(a)!

**Para inicializar, você pode executar diretamente o script `init.sh` ou seguir**
**os passos abaixo manualmente.**

O desafio para cada teste você encontra dentro dos respectivos módulos. Mais dicas
podem ser vistas [aqui](./docs/README.md).

<details>

  <summary>
    Ver instruções manuais...
  </summary>

  Para você instanciar o seu teste, primeiro você precisa realizar o download dos
  submódulos deste repositório.

  Para isso, execute os seguintes comando na pasta raiz:

  ```sh
  # Primeiramente altere as URLs para as suas
  git submodule set-url modules/backend https://github.com/$SEU_USUARIO/$NOME_DO_REPO
  git submodule set-url modules/frontend https://github.com/$SEU_USUARIO/$NOME_DO_REPO

  # Faça o download dos repositórios
  git submodule update --init --remote

  # Atualize eles para a branch main
  git submodule foreach git checkout main
  ```

  Após isso, copie os arquivos de ambiente necessários:

  ```sh
  cp env/.env.nginx.example env/.env.nginx
  cp env/.env.mysql.example env/.env.mysql

  # Se preferir, você pode deixar a cópia do arquivo na pasta do submódulo
  cp modules/backend/.env.example env/.env.backend
  cp modules/frontend/.env.example env/.env.frontend
  ```

  Com isso feito, defina os valores das suas variáveis de ambiente e comece a montar
  as Imagens Docker.

  A mais importante é a imagem base do Node.js, que pode ser compilada com:

  ```sh
  docker compose -f docker/compose.yaml build node
  ```

  A partir daqui, use os arquivos `docker/compose.yaml`, `modules/backend/compose.yaml`
  e `modules/frontend/compose.yaml` para manipular os containers, ou também se
  pode criar um arquivo `compose.yaml` diretamente na raiz do projeto.

  Este é um exemplo:

  ```yaml
  name: 'workupy-test'
  services:
    ingress:
      extends:
        service: nginx
        file: ./docker/compose.yaml
      depends_on:
        - backend
        - frontend
      networks:
        - workupy-test-net
      ports:
        - 8080:8080
    database:
      extends:
        service: mysql
        file: ./docker/compose.yaml
      networks:
        - workupy-test-net
    backend:
      extends:
        service: backend
        file: ./modules/backend/compose.yaml
      depends_on:
        - database
      env_file:
        - ./env/.env.backend
      networks:
        - workupy-test-net
      volumes:
        - ./modules/backend/src:/home/workupy/src:rw
    frontend:
      extends:
        service: frontend
        file: ./modules/frontend/compose.yaml
      depends_on:
        - backend
      env_file:
        - ./env/.env.frontend
      networks:
        - workupy-test-net
      volumes:
        - ./modules/frontend/src:/home/workupy/src:rw
  networks:
    workupy-test-net:
      name: 'workupy-test-net'
  ```

</details>
