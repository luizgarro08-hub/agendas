-- =========================================================
-- PulseDesk + Supabase
-- Rode este SQL no SQL Editor do seu projeto Supabase.
-- =========================================================

create extension if not exists pgcrypto;

create table if not exists public.eventos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  date date not null,
  time time not null default '18:00',
  cat text not null default 'Compromisso',
  color text not null default 'blue',
  note text default '',
  created_at timestamptz not null default now()
);

create table if not exists public.transacoes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  description text not null,
  type text not null check (type in ('income','expense')),
  amount numeric(12,2) not null check (amount >= 0),
  date date not null,
  cat text not null default 'Outros',
  created_at timestamptz not null default now()
);

create table if not exists public.tarefas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  date date,
  priority text not null default 'normal' check (priority in ('low','normal','high')),
  note text default '',
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.alarmes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  date date not null,
  time time not null,
  enabled boolean not null default true,
  fired boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.perfis (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text not null default 'Usuário',
  updated_at timestamptz not null default now()
);

alter table public.eventos enable row level security;
alter table public.transacoes enable row level security;
alter table public.tarefas enable row level security;
alter table public.alarmes enable row level security;
alter table public.perfis enable row level security;

-- Remove políticas anteriores para que o script possa ser executado novamente.
drop policy if exists "eventos_select_own" on public.eventos;
drop policy if exists "eventos_insert_own" on public.eventos;
drop policy if exists "eventos_update_own" on public.eventos;
drop policy if exists "eventos_delete_own" on public.eventos;

drop policy if exists "transacoes_select_own" on public.transacoes;
drop policy if exists "transacoes_insert_own" on public.transacoes;
drop policy if exists "transacoes_update_own" on public.transacoes;
drop policy if exists "transacoes_delete_own" on public.transacoes;

drop policy if exists "tarefas_select_own" on public.tarefas;
drop policy if exists "tarefas_insert_own" on public.tarefas;
drop policy if exists "tarefas_update_own" on public.tarefas;
drop policy if exists "tarefas_delete_own" on public.tarefas;

drop policy if exists "alarmes_select_own" on public.alarmes;
drop policy if exists "alarmes_insert_own" on public.alarmes;
drop policy if exists "alarmes_update_own" on public.alarmes;
drop policy if exists "alarmes_delete_own" on public.alarmes;

drop policy if exists "perfis_select_own" on public.perfis;
drop policy if exists "perfis_insert_own" on public.perfis;
drop policy if exists "perfis_update_own" on public.perfis;
drop policy if exists "perfis_delete_own" on public.perfis;

create policy "eventos_select_own" on public.eventos for select to authenticated using ((select auth.uid()) = user_id);
create policy "eventos_insert_own" on public.eventos for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "eventos_update_own" on public.eventos for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "eventos_delete_own" on public.eventos for delete to authenticated using ((select auth.uid()) = user_id);

create policy "transacoes_select_own" on public.transacoes for select to authenticated using ((select auth.uid()) = user_id);
create policy "transacoes_insert_own" on public.transacoes for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "transacoes_update_own" on public.transacoes for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "transacoes_delete_own" on public.transacoes for delete to authenticated using ((select auth.uid()) = user_id);

create policy "tarefas_select_own" on public.tarefas for select to authenticated using ((select auth.uid()) = user_id);
create policy "tarefas_insert_own" on public.tarefas for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "tarefas_update_own" on public.tarefas for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "tarefas_delete_own" on public.tarefas for delete to authenticated using ((select auth.uid()) = user_id);

create policy "alarmes_select_own" on public.alarmes for select to authenticated using ((select auth.uid()) = user_id);
create policy "alarmes_insert_own" on public.alarmes for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "alarmes_update_own" on public.alarmes for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "alarmes_delete_own" on public.alarmes for delete to authenticated using ((select auth.uid()) = user_id);

create policy "perfis_select_own" on public.perfis for select to authenticated using ((select auth.uid()) = user_id);
create policy "perfis_insert_own" on public.perfis for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "perfis_update_own" on public.perfis for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "perfis_delete_own" on public.perfis for delete to authenticated using ((select auth.uid()) = user_id);

create index if not exists eventos_user_date_idx on public.eventos(user_id, date);
create index if not exists transacoes_user_date_idx on public.transacoes(user_id, date);
create index if not exists tarefas_user_date_idx on public.tarefas(user_id, date);
create index if not exists alarmes_user_date_time_idx on public.alarmes(user_id, date, time);

-- Recarrega o cache da API do Supabase.
notify pgrst, 'reload schema';
