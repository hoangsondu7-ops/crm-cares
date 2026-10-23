CREATE TABLE IF NOT EXISTS customers (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  company VARCHAR(180),
  email VARCHAR(254),
  phone VARCHAR(40),
  avatar_data_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('lead', 'active', 'inactive')),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS contacts (
  id BIGSERIAL PRIMARY KEY,
  customer_id BIGINT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  name VARCHAR(160) NOT NULL,
  role VARCHAR(120),
  email VARCHAR(254),
  phone VARCHAR(40),
  avatar_data_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS interactions (
  id BIGSERIAL PRIMARY KEY,
  customer_id BIGINT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  contact_id BIGINT REFERENCES contacts(id) ON DELETE SET NULL,
  type VARCHAR(20) NOT NULL DEFAULT 'note' CHECK (type IN ('call', 'email', 'meeting', 'note')),
  summary VARCHAR(500) NOT NULL,
  details TEXT,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_customers_name ON customers (LOWER(name));
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers (LOWER(email));
CREATE INDEX IF NOT EXISTS idx_contacts_customer ON contacts (customer_id);
CREATE INDEX IF NOT EXISTS idx_interactions_customer_date ON interactions (customer_id, occurred_at DESC);

INSERT INTO customers (name, company, email, phone, status, notes)
SELECT 'Nguyễn Minh Anh', 'Công ty Sao Việt', 'minhanh@example.com', '0901234567', 'active', 'Khách hàng mẫu để kiểm tra hệ thống.'
WHERE NOT EXISTS (SELECT 1 FROM customers);

INSERT INTO contacts (customer_id, name, role, email, phone)
SELECT c.id, 'Trần Quốc Bảo', 'Quản lý mua hàng', 'bao@example.com', '0912345678'
FROM customers c
WHERE c.email = 'minhanh@example.com'
  AND NOT EXISTS (SELECT 1 FROM contacts x WHERE x.customer_id = c.id);

INSERT INTO interactions (customer_id, type, summary, details, occurred_at)
SELECT c.id, 'call', 'Gọi điện giới thiệu dịch vụ', 'Khách hàng quan tâm gói dịch vụ CRM, hẹn liên hệ lại.', NOW() - INTERVAL '1 day'
FROM customers c
WHERE c.email = 'minhanh@example.com'
  AND NOT EXISTS (SELECT 1 FROM interactions i WHERE i.customer_id = c.id);
