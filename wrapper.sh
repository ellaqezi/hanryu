#!/bin/bash
set -m
_term() {
  trap "$@" SIGINT SIGTERM
}
export NEO4J_AUTH=${NEO4J_AUTH:-neo4j/password}
_term 'kill $(jobs -p); wait && exit 0'
# Start the primary process and put it in the background
exec /docker-entrypoint.sh neo4j &
# wait for Neo4j
wget --quiet --tries=10 --waitretry=10 -O /dev/null http://localhost:7474

export NEO4J_USERNAME=${NEO4J_AUTH%%/*}
export NEO4J_PASSWORD=${NEO4J_AUTH##*/}
for f in *.cyp*; do
  echo "running cypher [${f}]"
  until cypher-shell -u "$NEO4J_USERNAME" -p "$NEO4J_PASSWORD" --file "$f" || exit 1; do
    echo "[${f}]"
    sleep 10
  done
done
cypher-shell --format verbose "MATCH (n) RETURN count(n) AS count"

_term -
fg %1