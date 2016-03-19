create table tasks (
   id int8 primary key,
   title text,
   description text,
   done boolean
);

create or replace function newtask(par_id int8, par_title  text, par_description text, par_done boolean) returns text as
$$
  declare
    loc_id text;
    loc_res text;
  begin
     select into loc_id id from tasks where id = par_id;
     if loc_id isnull then

       insert into tasks (id, title, description, done) values (par_id, par_title, par_description, par_done);
       loc_res = 'OK';

     else
       loc_res = 'ID EXISTED';  
     end if;
     return loc_res;
  end;
$$
 language 'plpgsql';

create or replace function deletetask(par_id int8) returns text as
$$
  declare
    loc_id text;
    loc_res text;
  begin
     select into loc_id id from tasks where id = par_id;
     if loc_id isnull then

       loc_res = 'ERROR! NO DATA FOUND!';

     else
       loc_res = 'ID EXISTED';  
     end if;
     return loc_res;
  end;
$$
 language 'plpgsql';

--select newtask(1, 'Buy Groceries','Milk, Cheese, Pizza, Fruit, Tylenol', false); 
--select newtask(2, 'Learn Python','Need to find a good Python tutorial on the web', false); 

create or replace function gettasks(out int8, out text, out text, out boolean) returns setof record as
$$
   select id, title, description, done from tasks;

$$
 language 'sql';
 
--select * from gettasks();

create or replace function gettaskid(in par_id int8, out text, out text, out boolean) returns setof record as
$$
   select title, description, done from tasks where id = par_id;

$$
 language 'sql';
 
--select * from gettaskid(2);

create table userpass (
    username text primary key,
    password text
);


insert into userpass (username, password) values ('ako', 'akolagini');

create or replace function getpassword(par_username text) returns text as
$$
  declare
    loc_password text;
  begin
     select into loc_password password from userpass where username = par_username;
     if loc_password isnull then
       loc_password = 'null';
     end if;
     return loc_password;
 end;
$$
 language 'plpgsql';

select getpassword('ako');
