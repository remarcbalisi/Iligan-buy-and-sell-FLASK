------------------------------------------------------------------------------------------------------------------------------------------
-- EXAMPLE ONLY!!!

-- TRIGGER (notification) - if new assessment is created, automatically create new notification
create or replace function default_itemname() RETURNS trigger AS '

  BEGIN

    IF tg_op = ''INSERT'' THEN
      INSERT INTO Notification (assessment_id, doctor_id)
          VALUES (new.id, new.attendingphysician);
    RETURN new;
    END IF;

  END
  ' LANGUAGE plpgsql;

create TRIGGER notify_trigger AFTER INSERT ON Assessment FOR each ROW
EXECUTE PROCEDURE notify();