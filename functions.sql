
-- function aba_isinpoland(geometry)

create or replace function aba_isinpoland(geometry) returns boolean
    cost 500
    language plpgsql
as
$$
DECLARE inp alias for $1;
Declare	poland geometry;
BEGIN
select ST_SimplifyPreserveTopology(way,1) from view_admin where name = 'Polska' and admin_level = '2' into poland;
if not found then raise exception 'Brak granicy Polski';
end if;

BEGIN
         IF ST_Contains(poland,inp) or ST_Crosses(poland,inp) then
             return true;
         else
             return false;
         end if;
EXCEPTION WHEN OTHERS THEN
     RETURN null;
END;
END;
$$;

alter function aba_isinpoland(geometry) owner to osm;


-- function rep_addr_nostreet()

create or replace function rep_addr_nostreet()
    returns TABLE(osm_user text, osm_changeset text, osm_id bigint, lat double precision, lon double precision)
    language sql
as
$$
select tags -> 'osm_user' as user, tags -> 'osm_changeset' as changeset, osm_id, ST_Y(ST_Transform(way,4326)) as lat, ST_X(ST_Transform(way,4326)) as lon
   from planet_osm_point po
   where po."addr:housenumber" is not null
   and (po.tags->'osm_timestamp')::timestamp at time zone '0:00' between (date_trunc('hour',current_timestamp) - interval '24 hour')::timestamp and current_timestamp::timestamp
   and po."addr:street" is null
   and po."addr:place" is null
   and aba_isinpoland(po.way) = true
   and not (po.tags -> 'osm_user' in ('maraf24','Janusz Stasiak'))
   union
   select tags -> 'osm_user' as user, tags -> 'osm_changeset' as changeset, osm_id, ST_Y(ST_Transform(ST_Centroid(way),4326)) as lat, ST_X(ST_Transform(ST_Centroid(way),4326)) as lon
   from planet_osm_polygon po
   where po."addr:housenumber" is not null
   and (po.tags->'osm_timestamp')::timestamp at time zone '0:00' between (date_trunc('hour',current_timestamp) - interval '24 hour')::timestamp and current_timestamp::timestamp
   and po."addr:street" is null
   and po."addr:place" is null
   and aba_isinpoland(po.way) = true
   and not (po.tags -> 'osm_user' in ('maraf24','Janusz Stasiak','pancernik'));
$$;

alter function rep_addr_nostreet() owner to osm;


-- function rep_addr_street_n_place()

create or replace function rep_addr_street_n_place()
    returns TABLE(osm_user text, osm_changeset text, osm_id bigint, lat double precision, lon double precision)
    language sql
as
$$
select tags -> 'osm_user' as user, tags -> 'osm_changeset' as changeset, osm_id, ST_Y(ST_Transform(way,4326)) as lat, ST_X(ST_Transform(way,4326)) as lon
   from planet_osm_point po
   where po."addr:housenumber" is not null
   and (po.tags->'osm_timestamp')::timestamp at time zone '0:00' between (date_trunc('hour',current_timestamp) - interval '24 hour')::timestamp and current_timestamp::timestamp
   and po."addr:street" is not null
   and po."addr:place" is not null
   and aba_isinpoland(po.way) = true
   and not (po.tags -> 'osm_user' in ('maraf24','Janusz Stasiak'))
   union
   select tags -> 'osm_user' as user, tags -> 'osm_changeset' as changeset, osm_id, ST_Y(ST_Transform(ST_Centroid(way),4326)) as lat, ST_X(ST_Transform(ST_Centroid(way),4326)) as lon
   from planet_osm_polygon po
   where po."addr:housenumber" is not null
   and (po.tags->'osm_timestamp')::timestamp at time zone '0:00' between (date_trunc('hour',current_timestamp) - interval '24 hour')::timestamp and current_timestamp::timestamp
   and po."addr:street" is not null
   and po."addr:place" is not null
   and aba_isinpoland(po.way) = true
   and not (po.tags -> 'osm_user' in ('maraf24','Janusz Stasiak','pancernik'));
$$;

alter function rep_addr_street_n_place() owner to osm;

