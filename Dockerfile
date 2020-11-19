FROM neo4j:4.1.4
ENV NEO4J_AUTH=

COPY wrapper.sh wrapper.sh
COPY cypher/* .
ENTRYPOINT ["./wrapper.sh"]