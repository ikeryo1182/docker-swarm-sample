  
  ### Goのイメージを作成
  ```
  $ docker image build -t example/echo:lastet .
  ```

  ### registry, manager, worker x3 の起動
  ```
  $  docker-compose up -d
  $  docker container ls
  ```

  ### swarm の導入
  ```
  $  docker container exec -it manager docker swarm init
  $  docker container exec -it worker03 docker swarm join --token xxxxxxxxxxxxxxxxxxxxxxxxxxxxx manager:2377
  $  docker container exec -it manager docker node ls
  ```

  ### registryにimageのpush
  ```
  $  docker image tag example/echo:latest localhost:5000/example/echo:latest
  $  docker image push localhost:5000/example/echo:latest
  ```

  ### dindでimageをpullして起動できるかの確認
  ```
  $  docker container exec -it worker01 docker image pull registry:5000/example/echo:latest
  $  docker container exec -it manager docker service create --replicas 1 --publish 8000:8000 --name echo registry:5000/example/echo:latest
  $  docker container exec -it manager docker service ps echo | grep Running
  ```

  ### networkの作成
  ```
  $  docker container exec -it manager docker network create --driver=overlay --attachable ch03
  ```

  ### stackの作成
  ```
  $  docker container exec -it manager docker stack deploy -c /stack/ch03-webapi.yml echo
  $  docker container exec -it manager docker stack services echo
  $  docker container exec -it manager docker stack ps echo | grep Running
  ```

  ### visualizerの起動 
  ```
  $  docker container exec -it manager docker stack deploy -c /stack/visualizer.yml visualizer
  ```
  http://localhost:9000

  ### haproxy(ロードバランサ)を起動
  ```
  $  docker container exec -it manager docker stack deploy -c /stack/ch03-webapi.yml echo
  $  docker container exec -it manager docker stack deploy -c /stack/ch03-ingress.yml ingress
  ```