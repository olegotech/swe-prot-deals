-- Supabase setup for ProtJakt users, preferences, price history
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  updated_at TIMESTAMP WITH TIME ZONE,
  full_name TEXT
);

CREATE TABLE IF NOT EXISTS alerts (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users NOT NULL,
  product_name TEXT NOT NULL,
  threshold_decimal NUMERIC NOT NULL,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Price history for analytics
CREATE TABLE IF NOT EXISTS price_logs (
  id BIGSERIAL PRIMARY KEY,
  product TEXT,
  store TEXT,
  price_sek NUMERIC,
  protein_g INTEGER,
  price_per_g NUMERIC GENERATED ALWAYS AS (price_sek / protein_g) STORED,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE price_logs ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can manage their own alerts" ON alerts 
  FOR ALL USING (auth.uid() = user_id);
