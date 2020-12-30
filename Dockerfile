FROM neo4j:4.2.0
ENV NEO4J_AUTH=
COPY wrapper.sh wrapper.sh
COPY cypher/* ./
ENTRYPOINT ["./wrapper.sh"]