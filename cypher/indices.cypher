CREATE INDEX title IF NOT exists FOR (t:Title) ON (t.Title);
CREATE INDEX role IF NOT exists FOR (r:Role) ON (r.Role);
CREATE CONSTRAINT actor IF NOT exists ON (a:Actor) ASSERT a.Actor IS UNIQUE;