create schema data authorization nrgs; 
create schema dataviews authorization nrgs; 

/*creating the tract file with tractfk table*/
create table data.tracts_tbl (
     idpk kserial primary key, 
     parcelnum varchar (24), 
     name varchar (36),
     tractinservice date, 
     tractoutservice date
                                  ); 
create table data.tracts_p (
     geom geometry(polygon, 4326),
     idpk serial primary key, 
     tractfk integer references data.tracts_tbl (idpk), 
     ident varchar (12), 
     acres double precision, 
     perimeter double precision, 
     edituser character(24), 
     editdate timestamp  
                                 );
/*create the cruise and seedling survival layer*/
create table data.cruise_x (
     idpk serial primary key, 
     geom geometry(point, 4326), 
     name char(12), 
     tractfk integer references data.tracts_tbl (idpk), 
     spacing_ft numeric(6,2),
     edituser character(24),
     editdate timestamp
                          ); 

create table data.seedling_survival_x (
     idpk serial primary key, 
     geom geometry(point, 4326), 
     name char(12), 
     tractfk integer references data.tracts_tbl (idpk), 
     spacing_ft numeric(6,2),
     edituser character(24),
     editdate timestamp
                          ); 
/*create planting*/ 
create table data.planting_p (
     geom geometry(polygon, 4326),
     idpk serial primary key,
     tractfk integer references data.tracts_tbl (idpk),
     ident varchar (12),
     acres double precision,
     perimeter double precision,
     edituser character(24),
     editdate timestamp
                             ); 
/*Create gates*/ 
create table data.type_tbl (
     idpk serial primary key,
     check_date date
                           ); 

create table data.key_tbl (
     idpk serial primary key,
     keynum char(24) 
                          ); 

create table data.combination_tbl (
     idpk serial primary key,
     combination char(24) 
                                  ); 

create table data.gates_tbl ( 
     idpk serial primary key, 
     typefk integer references data.type_tbl (idpk), 
     combinationfk integer references data.combination_tbl (idpk); 
     keyfk integer references data.key_tbl (idpk), 
     installed date, 
     checkedfk integer references data.gatecheck_tbl (idpk)  
                            ); 
     
create table data.gates_x (
     idpk serial primary key, 
     geom geometry(point, 4326), 
     tractfk integer references data.tracts_tbl (idpk), 
     

/*create a road layer*/ 
create table data.roadtype_tbl ( 
     idpk serial primary key, 
     roadtype varchar(64)
                       ); 

create table data.road_l (
     idpk serial primary key, 
     geom geometry(lines, 4326), 
     roadtypefk integer references data.roadtype_tbl (idpk), 
     width real (3,2) 
     edituser character(24),
     editdate timestamp
                          ); 


                        
     

/*functions*/
/*acres function*/
CREATE OR REPLACE FUNCTION update_acres_func()
        RETURNS TRIGGER AS '
BEGIN
  NEW.acres = st_area(geom)/43560;
  RETURN NEW;
END;
' LANGUAGE 'plpgsql';

/*length function*/ 
CREATE OR REPLACE FUNCTION update_length_func()
        RETURNS TRIGGER AS '
BEGIN
  NEW.length = st_length(NEW.geom);
  RETURN NEW;
END;
' LANGUAGE 'plpgsql';

/*user function*/
CREATE OR REPLACE FUNCTION update_edituser_func()
RETURNS TRIGGER AS ' 
BEGIN
   NEW.edituser = current_user; 
   RETURN NEW;
END;
' language 'plpgsql';

CREATE OR REPLACE FUNCTION update_timestamp_func()
RETURNS TRIGGER AS ' 
BEGIN
   NEW.editdate = current_timestamp; 
   RETURN NEW;
END;
' language 'plpgsql';


/*triggers*/ 
CREATE TRIGGER update_tract_acres BEFORE insert or update
  on inventory.tracts FOR EACH ROW EXECUTE PROCEDURE
  update_acres_func();

CREATE TRIGGER update_stands_acres BEFORE insert or update
  on inventory.stands FOR EACH ROW EXECUTE PROCEDURE
  update_acres_func();

CREATE TRIGGER update_tracts_length BEFORE insert or update
  on inventory.tracts FOR EACH ROW EXECUTE PROCEDURE
  update_length_func();

CREATE TRIGGER update_tract_edituser BEFORE insert or update
    ON inventory.tracts FOR EACH ROW EXECUTE PROCEDURE
    update_edituser_func();

CREATE TRIGGER update_stands_edituser BEFORE insert or update
    ON inventory.stands FOR EACH ROW EXECUTE PROCEDURE
    update_edituser_func();

CREATE TRIGGER update_tract_timestamp BEFORE insert or update
    ON inventory.tracts FOR EACH ROW EXECUTE PROCEDURE
    update_timestamp_func();

CREATE TRIGGER update_tract_timestamp BEFORE insert or update
    ON inventory.stands FOR EACH ROW EXECUTE PROCEDURE
    update_timestamp_func();

