CREATE TYPE "transaction_type" AS ENUM (
  'CREDIT',
  'DEBIT'
);

CREATE TYPE "status_val" AS ENUM (
  'REQUEST_SUBMITTED',
  'PAYMENT_TRANSFERRED',
  'PAYMENT_FAILED',
  'PAYMENT_SETTELED'
);

CREATE TYPE "mode_val" AS ENUM (
  'IMPS',
  'NEFT'
);

CREATE TABLE "customer" (
  "id" bigserial PRIMARY KEY,
  "customer_id" varchar UNIQUE NOT NULL,
  "created_at" timestamp,
  "bank_name" varchar,
  "ifsc" varchar,
  "account_number" varchar,
  "active" boolean DEFAULT false
);

CREATE TABLE "wallet" (
  "id" bigserial PRIMARY KEY,
  "customer_id" varchar,
  "amount" float8,
  "created_at" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "wallet_transactions" (
  "id" bigserial,
  "customer_id" varchar,
  "amount" float8,
  "transaction_type" transaction_type,
  "created_at" timestamp
);

CREATE TABLE "vault" (
  "id" bigserial,
  "customer_id" varchar,
  "gold" float8,
  "silver" float8,
  "created_at" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "vault_transactions" (
  "id" bigserial,
  "customer_id" varchar,
  "amount" float8,
  "transaction_type" transaction_type,
  "created_at" timestamp
);

CREATE TABLE "payout_orders" (
  "id" bigserial PRIMARY KEY,
  "customer_id" varchar NOT NULL,
  "amount" float8,
  "bank_name" varchar,
  "account_number" varchar,
  "ifsc" varchar,
  "created_at" timestamp,
  "status" status_val,
  "bank_transaction_number" varchar,
  "transaction_number" varchar,
  "mode" mode_val,
  "utr_number" varchar,
  "reason" varchar
);

CREATE TABLE "payout_order_details" (
  "id" bigserial PRIMARY KEY,
  "transaction_number" varchar,
  "payoutOrderId" bigserial,
  "responsecode" varchar NOT NULL,
  "utr_number" varchar,
  "bank_transaction_number" varchar,
  "status" status_val,
  "unique_id" varchar
);

CREATE INDEX ON "customer" ("customer_id");

CREATE INDEX ON "wallet" ("customer_id");

CREATE INDEX ON "wallet_transactions" ("customer_id");

CREATE INDEX ON "vault" ("customer_id");

CREATE INDEX ON "vault_transactions" ("customer_id");

CREATE INDEX ON "payout_orders" ("customer_id");

CREATE INDEX ON "payout_orders" ("id");

CREATE INDEX ON "payout_order_details" ("transaction_number");

ALTER TABLE "payout_order_details" ADD FOREIGN KEY ("payoutOrderId") REFERENCES "payout_orders" ("id");

ALTER TABLE "wallet" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "vault" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "vault_transactions" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "payout_orders" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "wallet_transactions" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");
