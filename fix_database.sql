-- PulseDesk: compatibilidade com tabelas antigas em português.
-- Execute no SQL Editor do Supabase uma vez.

-- EVENTOS
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS title text;
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS date date;
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS time time;
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS cat text DEFAULT 'Compromisso';
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS color text DEFAULT 'blue';
ALTER TABLE public.eventos ADD COLUMN IF NOT EXISTS note text DEFAULT '';

UPDATE public.eventos SET title = COALESCE(title, titulo) WHERE title IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='eventos' AND column_name='titulo');
UPDATE public.eventos SET date = COALESCE(date, data) WHERE date IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='eventos' AND column_name='data');
UPDATE public.eventos SET time = COALESCE(time, horario) WHERE time IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='eventos' AND column_name='horario');
UPDATE public.eventos SET cat = COALESCE(cat, categoria, 'Compromisso') WHERE cat IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='eventos' AND column_name='categoria');
UPDATE public.eventos SET color = COALESCE(color, cor, 'blue') WHERE color IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='eventos' AND column_name='cor');
UPDATE public.eventos SET note = COALESCE(note, observacao, '') WHERE note IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='eventos' AND column_name='observacao');

-- TRANSAÇÕES
ALTER TABLE public.transacoes ADD COLUMN IF NOT EXISTS description text;
ALTER TABLE public.transacoes ADD COLUMN IF NOT EXISTS type text;
ALTER TABLE public.transacoes ADD COLUMN IF NOT EXISTS amount numeric(12,2);
ALTER TABLE public.transacoes ADD COLUMN IF NOT EXISTS date date;
ALTER TABLE public.transacoes ADD COLUMN IF NOT EXISTS cat text DEFAULT 'Outros';

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='transacoes' AND column_name='descricao') THEN
    EXECUTE 'UPDATE public.transacoes SET description = COALESCE(description, descricao) WHERE description IS NULL';
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='transacoes' AND column_name='data') THEN
    EXECUTE 'UPDATE public.transacoes SET date = COALESCE(date, data) WHERE date IS NULL';
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='transacoes' AND column_name='valor') THEN
    EXECUTE 'UPDATE public.transacoes SET amount = COALESCE(amount, valor) WHERE amount IS NULL';
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='transacoes' AND column_name='categoria') THEN
    EXECUTE 'UPDATE public.transacoes SET cat = COALESCE(cat, categoria, ''Outros'') WHERE cat IS NULL';
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='transacoes' AND column_name='tipo') THEN
    EXECUTE $$UPDATE public.transacoes SET type = COALESCE(type, CASE WHEN lower(tipo::text) IN ('entrada','income','receita','credito','crédito') THEN 'income' WHEN lower(tipo::text) IN ('saida','saída','expense','gasto','despesa','debito','débito') THEN 'expense' ELSE tipo::text END) WHERE type IS NULL$$;
  END IF;
END $$;

-- TAREFAS
ALTER TABLE public.tarefas ADD COLUMN IF NOT EXISTS title text;
ALTER TABLE public.tarefas ADD COLUMN IF NOT EXISTS date date;
ALTER TABLE public.tarefas ADD COLUMN IF NOT EXISTS priority text DEFAULT 'normal';
ALTER TABLE public.tarefas ADD COLUMN IF NOT EXISTS note text DEFAULT '';
ALTER TABLE public.tarefas ADD COLUMN IF NOT EXISTS done boolean DEFAULT false;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='tarefas' AND column_name='titulo') THEN EXECUTE 'UPDATE public.tarefas SET title = COALESCE(title, titulo) WHERE title IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='tarefas' AND column_name='data') THEN EXECUTE 'UPDATE public.tarefas SET date = COALESCE(date, data) WHERE date IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='tarefas' AND column_name='prioridade') THEN EXECUTE 'UPDATE public.tarefas SET priority = COALESCE(priority, prioridade, ''normal'') WHERE priority IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='tarefas' AND column_name='observacao') THEN EXECUTE 'UPDATE public.tarefas SET note = COALESCE(note, observacao, '''') WHERE note IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='tarefas' AND column_name='concluida') THEN EXECUTE 'UPDATE public.tarefas SET done = COALESCE(done, concluida, false) WHERE done IS NULL'; END IF;
END $$;

-- ALARMES
ALTER TABLE public.alarmes ADD COLUMN IF NOT EXISTS name text;
ALTER TABLE public.alarmes ADD COLUMN IF NOT EXISTS date date;
ALTER TABLE public.alarmes ADD COLUMN IF NOT EXISTS time time;
ALTER TABLE public.alarmes ADD COLUMN IF NOT EXISTS enabled boolean DEFAULT true;
ALTER TABLE public.alarmes ADD COLUMN IF NOT EXISTS fired boolean DEFAULT false;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='alarmes' AND column_name='nome') THEN EXECUTE 'UPDATE public.alarmes SET name = COALESCE(name, nome) WHERE name IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='alarmes' AND column_name='data') THEN EXECUTE 'UPDATE public.alarmes SET date = COALESCE(date, data) WHERE date IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='alarmes' AND column_name='horario') THEN EXECUTE 'UPDATE public.alarmes SET time = COALESCE(time, horario) WHERE time IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='alarmes' AND column_name='ativo') THEN EXECUTE 'UPDATE public.alarmes SET enabled = COALESCE(enabled, ativo, true) WHERE enabled IS NULL'; END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='alarmes' AND column_name='disparado') THEN EXECUTE 'UPDATE public.alarmes SET fired = COALESCE(fired, disparado, false) WHERE fired IS NULL'; END IF;
END $$;

NOTIFY pgrst, 'reload schema';
