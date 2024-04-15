---Geometry – Creating Point
BEGIN TRAN
CREATE TABLE tblGeom
(GXY geometry,
Description varchar(30),
IDtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(1,1))
INSERT INTO tblGeom
VALUES (geometry::STGeomFromText('POINT (3 4)', 0),'First point'),
       (geometry::STGeomFromText('POINT (3 5)', 0),'Second point'),
	   (geometry::Point(4, 6, 0),'Third Point'),
	   (geometry::STGeomFromText('MULTIPOINT ((1 2), (2 3), (3 4))', 0), 'Three Points')

Select * from tblGeom

ROLLBACK TRAN

---Queries Points
begin tran
create table tblGeom
(GXY geometry,
Description varchar(20),
IDtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(1,1))
insert into tblGeom
VALUES (geometry::STGeomFromText('POINT (3 4)', 0),'First point'),
       (geometry::STGeomFromText('POINT (3 5)', 0),'Second point'),
	   (geometry::Point(4, 6, 0),'Third Point'),
	   (geometry::STGeomFromText('MULTIPOINT ((1 2), (2 3), (3 4))', 0),'Three Points')

SELECT * from tblGeom

select IDtblGeom, GXY.STGeometryType() as MyType
, GXY.STStartPoint().ToString() as StartingPoint
, GXY.STEndPoint().ToString() as EndingPoint
, GXY.STPointN(1).ToString() as FirstPoint
, GXY.STPointN(2).ToString() as SecondPoint
, GXY.STPointN(1).STX as FirstPointX
, GXY.STPointN(1).STY as FirstPointY
, GXY.STNumPoints() as NumberPoints
from tblGeom

DECLARE @g as geometry
DECLARE @h as geometry

select @g = GXY from tblGeom where IDtblGeom = 1
select @h = GXY from tblGeom where IDtblGeom = 3
select @g.STDistance(@h) as MyDistance

ROLLBACK TRAN

---Defining LINESTRINGs,  POLYGONs and CIRCULARSTRINGs
begin tran
create table tblGeom
(GXY geometry,
Description varchar(20),
IDtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(5,1))
insert into tblGeom
VALUES (geometry::STGeomFromText('LINESTRING (1 1, 5 5)', 0),'First line'),
       (geometry::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0),'Second line'),
	   (geometry::STGeomFromText('MULTILINESTRING ((1 5, 2 6), (1 4, 2 5))', 0),'Third line'),
	   (geometry::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (geometry::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Circle')
SELECT * FROM tblGeom
rollback tran



---Querying LINESTRINGs,  POLYGONs and CIRCULARSTRINGs
begin tran
create table tblGeom
(GXY geometry,
Description varchar(20),
IDtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(5,1))
insert into tblGeom
VALUES (geometry::STGeomFromText('LINESTRING (1 1, 5 5)', 0),'First line'),
       (geometry::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0),'Second line'),
	   (geometry::STGeomFromText('MULTILINESTRING ((1 5, 2 6), (1 4, 2 5))', 0),'Third line'),
	   (geometry::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (geometry::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Circle')
SELECT * FROM tblGeom



select IDtblGeom, GXY.STGeometryType() as MyType
, GXY.STStartPoint().ToString() as StartingPoint
, GXY.STEndPoint().ToString() as EndingPoint
, GXY.STPointN(1).ToString() as FirstPoint
, GXY.STPointN(2).ToString() as SecondPoint
, GXY.STPointN(1).STX as FirstPointX
, GXY.STPointN(1).STY as FirstPointY
, GXY.STBoundary().ToString() as Boundary
, GXY.STLength() as MyLength
, GXY.STNumPoints() as NumberPoints
from tblGeom

DECLARE @g as geometry
select @g = GXY from tblGeom where IDtblGeom = 5

select IDtblGeom, GXY.STIntersection(@g).ToString() as Intersection
, GXY.STDistance(@g) as DistanceFromFirstLine
from tblGeom

select GXY.STUnion(@g), Description
from tblGeom
where IDtblGeom = 8 

rollback tran


---Geography
begin tran
create table tblGeog
(GXY geography,
Description varchar(30),
IDtblGeog int CONSTRAINT PK_tblGeog PRIMARY KEY IDENTITY(1,1))
insert into tblGeog
VALUES (geography::STGeomFromText('POINT (-73.993492 40.750525)', 4326),'Madison Square Gardens, NY'),
       (geography::STGeomFromText('POINT (-0.177452 51.500905)', 4326),'Royal Albert Hall, London'),
	   (geography::STGeomFromText('LINESTRING (-73.993492 40.750525, -0.177452 51.500905)', 4326),'Connection')

select * from tblGeog

DECLARE @g as geography
select @g = GXY from tblGeog where IDtblGeog = 1

select IDtblGeog, GXY.STGeometryType() as MyType
, GXY.STStartPoint().ToString() as StartingPoint
, GXY.STEndPoint().ToString() as EndingPoint
, GXY.STPointN(1).ToString() as FirstPoint
, GXY.STPointN(2).ToString() as SecondPoint
, GXY.STLength() as MyLength
, GXY.STIntersection(@g).ToString() as Intersection
, GXY.STNumPoints() as NumberPoints
, GXY.STDistance(@g) as DistanceFromFirstLine
from tblGeog

DECLARE @h as geography

select @g = GXY from tblGeog where IDtblGeog = 1
select @h = GXY from tblGeog where IDtblGeog = 2
select @g.STDistance(@h) as MyDistance

select GXY.STUnion(@g)
from tblGeog
where IDtblGeog = 2 

ROLLBACK TRAN

select * from sys.spatial_reference_systems




---Spatial aggregates
begin tran
create table tblGeom
(GXY geometry,
Description varchar(20),
IDtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(5,1))
insert into tblGeom
VALUES (geometry::STGeomFromText('LINESTRING (1 1, 5 5)', 0),'First line'),
	   (geometry::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0),'Second line'),
	   (geometry::STGeomFromText('MULTILINESTRING ((1 5, 2 6), (1 4, 2 5))', 0),'Third line'),
	   (geometry::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (geometry::STGeomFromText('POLYGON ((5 2, 7 2, 7 4, 5 4, 5 2))', 0), 'Second Polygon'),
	   (geometry::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Circle')
select * from tblGeom

SELECT *  FROM tblGeom
where GXY.Filter(geometry::Parse('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))')) = 1
UNION ALL
SELECT geometry::STGeomFromText('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))', 0), 'Filter', 0

declare @i as geometry
select @i = geometry::UnionAggregate(GXY) 
from tblGeom

Select @i as CombinedShapes

declare @j as geometry
select @j = geometry::CollectionAggregate(GXY) 
from tblGeom

select @j

Select @i as CombinedShapes
--union all
select geometry::EnvelopeAggregate(GXY) as Envelope from tblGeom
--union all
select geometry::ConvexHullAggregate(GXY) as Envelope from tblGeom

ROLLBACK TRAN
