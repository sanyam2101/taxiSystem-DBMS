
CREATE TABLE client (
  c_id         NUMBER PRIMARY KEY,
  regno        VARCHAR(20),
  cname        VARCHAR(20),
  premium_pass VARCHAR(5),
  gender       CHAR,
  email        VARCHAR(30)
);

CREATE TABLE cards (
  c_id NUMBER
    REFERENCES client ( c_id ),
  card VARCHAR(20)
);

CREATE TABLE driver (
  d_id       NUMBER PRIMARY KEY,
  d_name     VARCHAR(20),
  phone      VARCHAR(10),
  vac_status VARCHAR(20),
  address    VARCHAR(30)
);

CREATE TABLE vehicle (
  d_id      NUMBER PRIMARY KEY
    REFERENCES driver ( d_id ),
  vno       VARCHAR(25) UNIQUE,
  model     VARCHAR(20),
  category  VARCHAR(20),
  fuel_type VARCHAR(10),
  color     VARCHAR(20)
);

CREATE TABLE pass (
  c_id     NUMBER
    REFERENCES client ( c_id ),
  pass_id  VARCHAR(10) PRIMARY KEY,
  plan     VARCHAR(10),
  validity DATE
);

CREATE TABLE rating (
  c_id     NUMBER
    REFERENCES client ( c_id ),
  d_id     NUMBER
    REFERENCES driver ( d_id ),
  type     CHAR,
  dor      DATE,
  rating   INT,
  comments VARCHAR(50)
);



--Display Any table
SELECT *
FROM client order by c_id;

SELECT *
FROM vehicle;

SELECT *
FROM driver;

SELECT *
FROM cards
ORDER BY c_id;

SELECT *
FROM rating;

SELECT *
FROM pass;


--Display  Drivers with their  avg ratings
SELECT a.d_id                  "Driver ID",
       a.d_name                "Driver Name",
       round(AVG(b.rating), 2) AS "AVG Rating"
FROM driver a,
     rating b
WHERE a.d_id = b.d_id
      AND b.type = 'D'
GROUP BY a.d_id,
         a.d_name
ORDER BY a.d_id;


--Display All Drivers With Vehicle Details
SELECT a.*,
       b.*
FROM driver  a,
     vehicle b
WHERE a.d_id = b.d_id;



-- ******  Exception Handling *********
--Rate a Driver Program
DECLARE
  rating_mt5 EXCEPTION;
  rat  NUMBER;
  did  NUMBER(2);
  driv driver.d_name%TYPE;
BEGIN
  did := &driver_id_of_driver;
  --SELECT d_name INTO driv FROM driver;
  SELECT d_name
  INTO driv
  FROM driver
  WHERE d_id = did;

  rat := &rating;
  IF rat > 5 OR rat < 1 THEN
    RAISE rating_mt5;
  END IF;
  dbms_output.put_line('You have Rated '
                       || driv
                       || ' with '
                       || rat
                       || ' stars');

EXCEPTION
  WHEN too_many_rows THEN
    dbms_output.put_line('TOO MANY ROWS');
  WHEN no_data_found THEN
    dbms_output.put_line('NO DATA FOUND');
  WHEN rating_mt5 THEN
    dbms_output.put_line('Rating can only be between 1 and 5');
  WHEN OTHERS THEN
    dbms_output.put_line('other errors');
END;


-- *******Cursor Handling *****
DECLARE
  CURSOR c1 IS
  SELECT *
  FROM cards
  WHERE c_id = 318;

BEGIN
  FOR rec IN c1 LOOP
    dbms_output.put_line('CID '
                         || rec.c_id
                         || ' card '
                         || rec.card);
  END LOOP;
END;

--******Trigger******
CREATE OR REPLACE TRIGGER cl_upper BEFORE
  INSERT OR UPDATE OF cname ON client
  FOR EACH ROW
BEGIN
  :new.cname := upper(:new.cname);
END;
/
update client set cname='akshit';
select* from client;
rollback;


--***Procedure ***
create or replace procedure end_prem(cid number) as
begin
delete from pass where c_id = cid;
end;
/
declare
d number;
begin
d:=478;
end_prem(d);
end;
/
select* from pass;
rollback;



