-- Execute este arquivo no SQL Editor do projeto Supabase (o mesmo do Personal Finance).
-- Cria uma tabela só da Trilha de Carreira: um estado JSON por pessoa autenticada.
-- Não mexe na tabela finance_states do Personal Finance.
create table if not exists public.career_states (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{"registros": [], "goals": []}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.career_states enable row level security;

drop policy if exists "Usuário lê apenas sua trilha" on public.career_states;
create policy "Usuário lê apenas sua trilha"
on public.career_states for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Usuário cria apenas sua trilha" on public.career_states;
create policy "Usuário cria apenas sua trilha"
on public.career_states for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Usuário altera apenas sua trilha" on public.career_states;
create policy "Usuário altera apenas sua trilha"
on public.career_states for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Usuário exclui apenas sua trilha" on public.career_states;
create policy "Usuário exclui apenas sua trilha"
on public.career_states for delete
to authenticated
using ((select auth.uid()) = user_id);
