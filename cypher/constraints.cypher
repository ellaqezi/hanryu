CREATE CONSTRAINT title IF NOT exists ON (t:Title) ASSERT t.Title IS UNIQUE;
CREATE CONSTRAINT actor IF NOT exists ON (a:Actor) ASSERT a.Actor IS UNIQUE;
CREATE INDEX role IF NOT exists FOR (r:Role) ON (r.Role);
