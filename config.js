// Configuração pública do Supabase.
// A Publishable Key pode ficar no frontend quando o RLS está configurado corretamente.
// NUNCA coloque aqui uma service_role/secret key.
const SUPABASE_URL = "https://yyhwfdlwenhzolvvnojb.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "sb_publishable_SUNcK-nznwGuv91Jx3gLEg_GVDqLqmB";

const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_PUBLISHABLE_KEY
);
