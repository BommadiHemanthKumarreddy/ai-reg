-- Run once in Supabase: SQL Editor > New query > paste > Run
create table if not exists registrations(
  phone text primary key, name text not null, college text not null,
  branch text, ref text, created_at timestamptz default now());
create table if not exists codes(code text primary key, name text, college text);

-- Lock tables: browsers can NOT read phone numbers directly
alter table registrations enable row level security;
alter table codes enable row level security;

create or replace function register(p_phone text,p_name text,p_college text,p_branch text,p_ref text)
returns text language plpgsql security definer set search_path=public as $$
begin
  insert into registrations(phone,name,college,branch,ref) values(p_phone,p_name,p_college,p_branch,nullif(p_ref,''));
  return 'ok';
exception when unique_violation then return 'duplicate';
end $$;

create or replace function create_code(p_code text,p_name text,p_college text)
returns void language sql security definer set search_path=public as $$
  insert into codes(code,name,college) values(p_code,p_name,p_college) on conflict do nothing;
$$;

create or replace function stats() returns json language sql security definer set search_path=public as $$
  select json_build_object(
    'total',(select count(*) from registrations),
    'refs',(select coalesce(json_agg(x),'[]'::json) from (select ref as code,count(*) as n from registrations where ref is not null group by ref order by n desc limit 10) x),
    'colleges',(select coalesce(json_agg(y),'[]'::json) from (select coalesce(c.college,'Unknown') as college,count(*) as n from registrations r left join codes c on c.code=r.ref where r.ref is not null group by 1 order by n desc limit 5) y));
$$;

grant execute on function register(text,text,text,text,text), create_code(text,text,text), stats() to anon;
