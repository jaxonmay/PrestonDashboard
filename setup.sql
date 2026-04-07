-- Run this in Supabase SQL Editor (Database → SQL Editor → New query)

-- Stores the latest parsed data for each report type per store
create table if not exists reports (
  id uuid default gen_random_uuid() primary key,
  store text not null,        -- 'ford', 'cdjr', 'body'
  report_type text not null,  -- 'writer', 'tech', 'wip'
  data jsonb not null,
  uploaded_at timestamptz default now(),
  unique(store, report_type)
);

-- Stores tech name mappings (initials -> full name)
create table if not exists tech_names (
  id uuid default gen_random_uuid() primary key,
  initial text not null unique,
  full_name text not null,
  updated_at timestamptz default now()
);

-- Allow public read access (dashboard reads data)
alter table reports enable row level security;
alter table tech_names enable row level security;

create policy "public can read reports" on reports for select using (true);
create policy "public can read tech_names" on tech_names for select using (true);
create policy "public can upsert reports" on reports for insert with check (true);
create policy "public can update reports" on reports for update using (true);
create policy "public can upsert tech_names" on tech_names for insert with check (true);
create policy "public can update tech_names" on tech_names for update using (true);
