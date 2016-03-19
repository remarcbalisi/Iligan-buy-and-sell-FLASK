create table users(
  id serial8 primary key,
  email text,
  fname text,
  mname text,
  lname text,
  contact_no text,
  is_active boolean default TRUE,
  role int default 2 --1: admin 2: normal  
  username text,
  password text
);

create table Type(
  id serial8 primary key,
  name text
);

create table Category(
  id serial8 primary key,
  name text
);

create table Item(
  id serial8 primary key,
  name text,
  price int,
  description text,
  post_date timestamp default CURRENT_TIMESTAMP,
  type_id int8 references Type(id),
  category_id int8 references Category(id),
  owner int8 references users(id)
);

create table Image(
  id serial8 primary key,
  title text,
  creation_date timestamp default CURRENT_TIMESTAMP,
  stuff_image text,
  item_id int8 references Item(id)
);

create table Ranking(
  id serial8 primary key,
  item_rank timestamp default CURRENT_TIMESTAMP,
  item_id int8 references Item(id)
);

create table Comment(
  id serial8 primary key,
  comment text,
  post_comment_date timestamp default CURRENT_TIMESTAMP,
  commmentator int8 references users(id),
  item_id int8 references Item(id)
);