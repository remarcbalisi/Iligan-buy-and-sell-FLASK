create or replace function newuser(par_email text, par_fname text, par_mname text, par_lname text, par_contact text, par_username text, par_password text) returns text as
  $$
    declare
    loc_response text;
    loc_userid int8;
    begin
      select into loc_userid id from users where username = par_username or email = par_email;
      if loc_userid isnull then
        insert into users (email, fname, mname, lname, contact_no, username, password) values (par_email, par_fname, par_mname, par_lname, par_contact, par_username, par_password);
        loc_response = 'Ok';
      else
        loc_response = 'username/email already exist';
      end if;
      return loc_response;
    end;
  $$
  language 'plpgsql';

create or replace function getuser(in par_email text, out int8, out text, out text, out text, out text, out text, out int) returns setof record as
$$
   select id, email, fname, mname, lname, contact_no, role from users where email = par_email;

$$
 language 'sql';

create or replace function checkauth(par_email text, par_password text) returns text as
$$
  declare
  loc_response text;
  loc_id int8;
  begin
    select into loc_id id from users where email = par_email and password = par_password;
    if loc_id isnull then
      loc_response = 'Invalid email/password';
    else
      loc_response = "Ok";
    end if;
    return loc_response;
  end;
$$
language 'plpgsql';