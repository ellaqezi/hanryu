// Clear data
MATCH (n)
DETACH DELETE n;

LOAD CSV WITH HEADERS FROM 'file:///Ranks.csv' AS row
MERGE (Actor:Actor {Actor: row.Name})
  ON CREATE SET Actor += {rating:toInteger(row.Rating), score:toFloat(row.Score)};

LOAD CSV WITH HEADERS FROM 'file:///Titles.csv' AS row
MERGE (Title:Title {Title: row.Title})
  ON CREATE SET Title += {Type: row.Type, status: coalesce(row.Status, 'Not Started'),
                          rating: toFloat(coalesce(row.Rating, 0)), score: toFloat(coalesce(row.Score, 0))};

LOAD CSV WITH HEADERS FROM 'file:///Cast.csv' AS row
UNWIND split(row.Role, ' / ') AS name
MERGE (Role:Role {Role:  name,
                  Title: row.Title})
  ON CREATE SET Role += {loves: split(row.LoveInterest, ' / '), actors: [row.Actor]}
  ON MATCH SET Role += {loves: Role.loves + split(row.LoveInterest, ' / '), actors: Role.actors + row.Actor}
MERGE (Actor:Actor {Actor: row.Actor})
  ON CREATE SET Actor += {roles: [name], titles: [row.Title]}
  ON MATCH SET Actor += {roles: Actor.roles + name, titles: Actor.titles + row.Title}
WITH Role, Actor, row
MATCH (Title:Title {Title: row.Title})
// Create relationships between Actors, Roles and Titles
MERGE (Actor)-[:AS]->(Role)
MERGE (Role)-[:IN]->(Title);

LOAD CSV WITH HEADERS FROM 'file:///Cast.csv' AS row
UNWIND split(row.Role, ' / ') AS name
MATCH (Role:Role {Role:  name
,                 Title: row.Title
})
UNWIND split(row.LoveInterest, ' / ') AS interest
MATCH (love:Role {Role:  interest
,                 Title: row.Title
})
MATCH (Title:Title {Title: row.Title})
// Create relationships between Roles
MERGE (love)-[:IN]-(Title)
MERGE (Role)-[:LOVES]->(love);

// Display
MATCH p = ()-[]-()-[]-()
RETURN p
  LIMIT 750