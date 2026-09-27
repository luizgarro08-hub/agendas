# PulseDesk — Agenda & Finanças + Supabase

Sistema pessoal com Dashboard, Agenda, Finanças, Tarefas e Alarmes.

## 1. Banco de dados

No Supabase, abra **SQL Editor**, crie uma query, cole todo o conteúdo de `supabase.sql` e execute.

## 2. Configuração

O arquivo `config.js` já está configurado com a URL e a Publishable Key do projeto informado.

Não coloque uma `service_role` ou `secret key` no frontend.

## 3. Abrir o sistema

Como o projeto usa módulos/CDN e autenticação do Supabase, é recomendado abrir por um servidor local.

No VS Code, você pode usar uma extensão como Live Server ou outro servidor HTTP local.

## 4. Login

No primeiro acesso, use **Criar conta**. Depois confirme o e-mail se o seu projeto Supabase exigir confirmação.

## 5. GitLab

Depois de testar:

```bash
git init
git add .
git commit -m "PulseDesk integrado ao Supabase"
git branch -M main
git remote add origin https://gitlab.com/SEU_USUARIO/PulseDesk.git
git push -u origin main
```
