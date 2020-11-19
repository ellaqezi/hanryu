// Clear data
MATCH (n)
DETACH DELETE n;

LOAD CSV WITH HEADERS FROM 'file:///Ranks.csv' AS row
MERGE (a:Actor {actor: row.Name, rating: toInteger(row.Rating), score: toFloat(row.Score)})
  ON CREATE SET a.Actor = row.Actor;

LOAD CSV WITH HEADERS FROM 'file:///Titles.csv' AS row
WITH row
  WHERE row.Rating IS NOT NULL AND row.Score IS NOT NULL
MERGE (title:Title {title: row.Title, type: row.Type, rating: toFloat(row.Rating), score: toFloat(row.Score)})
  ON CREATE SET title.Title = row.Title;

LOAD CSV WITH HEADERS FROM 'file:///Cast.csv' AS row
UNWIND split(row.Role, ' / ') AS name
MERGE (role:Role {role:  name
,                 title: row.Title
,                 actor: row.Actor
})
WITH role, row
MATCH (title:Title {title: row.Title})
MATCH (actor:Actor {actor: row.Actor})
// Create relationships between actors, roles and titles
MERGE (actor)-[:AS]->(role)
MERGE (role)-[:IN]->(title)
  ON CREATE SET role.Role = row.Role;

LOAD CSV WITH HEADERS FROM 'file:///Cast.csv' AS row
UNWIND split(row.Role, ' / ') AS name
MATCH (role:Role {role:  name
,                 title: row.Title
,                 actor: row.Actor
})
UNWIND split(row.LoveInterest, ' / ') AS interest
MERGE (love:Role {role:  interest
,                 title: row.Title
})
// Create relationships between roles
MERGE (role)-[:LOVES]->(love);


// Display
MATCH p = ()-[]-()-[]-()
RETURN p
  LIMIT 750

/*LOAD CSV WITH HEADERS FROM 'file:///Cast.csv' AS row
UNWIND split(row.LoveInterest, ' / ') AS interest
MATCH (love:Role {title: row.Title
,                 role:  interest
})
WITH love
MATCH (actor)-[:AS]->(love)
RETURN DISTINCT love.role, love.title, actor.actor*/