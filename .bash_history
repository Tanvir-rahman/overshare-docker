docker compose up -d
docker compose exec postgres pg_isready -U web_user -d web_app -h postgres
docker compose exec postgres env
docker compose up -d
docker compose exec postgres env
# Ensure the database accepts connections. 
docker compose exec postgres pg_isready -d web_app -U web_user
echo "status code: $?"
# Ensure the secrets are correctly mounted.
docker compose exec postgres cat /secrets/db_user | grep -iq "$(cat /home/project/secrets/db_user.txt)"
echo "status code: $?"
docker compose exec postgres cat /secrets/db_pass | grep -iq "$(cat /home/project/secrets/db_pass.txt)"
echo "status code: $?"
docker compose exec postgres cat /secrets/db_name | grep -iq "$(cat /home/project/secrets/db_name.txt)"
echo "status code: $?"
touch overshare/web_app/Dockerfile
docker compose up -d
docker compose exec web_app wget -q -O - localhost:9000
docker compose exec web_app wget -q -O - localhost:9000/timeline
docker ps 
docker compose exec web_app python3 /code/app.py
docker compose exec web_app wget -q -O - localhost:9000/timeline
docker compose up -d
# Ensure the web application can connect to an initialized database.
docker compose exec web_app wget -q -O - localhost:9000/timeline > /tmp/timeline.html && grep -q "$(docker compose exec postgres psql -U web_user -d web_app -c 'SELECT content FROM posts LIMIT 1;' -tA)" /tmp/timeline.html
echo "status code: $?"
docker compose up -d
# Ensure an HTTP status of 200 (success) is returned.
docker compose exec proxy curl -L -s --HEAD -o /dev/null -w "%{http_code}" 0.0.0.0/timeline | grep -iq 200
echo "status code: $?"
# Ensure the timeline route is loading the template.
docker compose exec proxy curl -L -s 0.0.0.0/timeline | grep -iq "trending stories"
echo "status code: $?"
# Ensure records are being pulled from the database and rendered in the timeline.
docker compose exec proxy curl -L -s 0.0.0.0/timeline > /tmp/timeline.html && grep -iq "$(docker compose exec postgres psql -U web_user -d web_app -c 'SELECT content FROM posts LIMIT 1;' -tA)" /tmp/timeline.html
echo "status code: $?"
docker compose up -d
docker compose ps -a
touch compose-defaults.yaml
docker compose -f compose.yaml -f compose-defaults.yaml up -d
touch compose-ci.yaml
docker compose -p ci -f compose.yaml -f compose-ci.yaml up -d
docker ps
docker compose ps -a
docker compose -p ci ps -a
docker compose ps -a
docker compose -p ci down
docker compose -p ci -f compose.yaml -f compose-ci.yaml --profile test up --exit-code-from integration_tests --build && echo "tests: success" || echo "tests: failure"
docker compose -p ci -f compose.yaml -f compose-ci.yaml --profile test up --exit-code-from integration_tests --build && echo "tests: success" || echo "tests: failure"
docker compose -p ci logs
docker compose -p ci logs postgres
# Ensure the integration testing is correctly configured.
docker compose -p ci -f compose.yaml -f compose-ci.yaml --profile test up --exit-code-from integration_tests --build &> /dev/null
echo "status code: $?"
