# overshare-docker
Few Commands for getting start -
```
docker compose -p ci -f compose.yaml -f compose-ci.yaml --profile test up --exit-code-from integration_tests --build && echo "tests: success" || echo "tests: failure"
```

```
docker compose -f compose.yaml -f compose-dev.yaml up -d
docker compose logs web_app --follow
```

```
docker compose -p ci logs
docker compose logs  --since 10m
```
