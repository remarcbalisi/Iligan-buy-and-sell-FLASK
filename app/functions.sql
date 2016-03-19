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