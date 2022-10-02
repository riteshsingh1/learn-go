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
  "customerId" varchar UNIQUE PRIMARY KEY NOT NULL,
  "createdAt" timestamp,
  "bankName" varchar,
  "ifsc" varchar,
  "accountNumber" varchar,
  "active" boolean DEFAULT false
);

CREATE TABLE "wallet" (
  "id" bigserial PRIMARY KEY,
  "customerId" varchar,
  "amount" float8,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "walletTransactions" (
  "id" bigserial,
  "customerId" varchar,
  "amount" float8,
  "transactionType" transaction_type,
  "createdAt" timestamp
);

CREATE TABLE "vault" (
  "id" bigserial,
  "customerId" varchar,
  "gold" float8,
  "silver" float8,
  "createdAt" timestamp,
  "updatedAt" timestamp
);

CREATE TABLE "vaultTransactions" (
  "id" bigserial,
  "customerId" varchar,
  "amount" float8,
  "transactionType" transaction_type,
  "createdAt" timestamp
);

CREATE TABLE "payoutOrders" (
  "id" bigserial PRIMARY KEY,
  "customerId" varchar NOT NULL,
  "amount" float8,
  "bankName" varchar,
  "accountNumber" varchar,
  "ifsc" varchar,
  "createdAt" timestamp,
  "status" status_val,
  "bankTransactionNumber" varchar,
  "transactionNumber" varchar,
  "mode" mode_val,
  "utrNumber" varchar,
  "reason" varchar
);

CREATE TABLE "PayoutOrderDetails" (
  "id" bigserial PRIMARY KEY,
  "transactionNumber" varchar,
  "payoutOrderId" bigserial,
  "responsecode" varchar NOT NULL,
  "utrNumber" varchar,
  "bankTransactionNumber" varchar,
  "status" status_val,
  "uniqueId" varchar
);

CREATE INDEX ON "customer" ("customerId");

CREATE INDEX ON "wallet" ("customerId");

CREATE INDEX ON "walletTransactions" ("customerId");

CREATE INDEX ON "vault" ("customerId");

CREATE INDEX ON "vaultTransactions" ("customerId");

CREATE INDEX ON "payoutOrders" ("customerId");

CREATE INDEX ON "payoutOrders" ("id");

CREATE INDEX ON "PayoutOrderDetails" ("transactionNumber");

ALTER TABLE "PayoutOrderDetails" ADD FOREIGN KEY ("payoutOrderId") REFERENCES "payoutOrders" ("id");

ALTER TABLE "wallet" ADD FOREIGN KEY ("customerId") REFERENCES "customer" ("customerId");

ALTER TABLE "vault" ADD FOREIGN KEY ("customerId") REFERENCES "customer" ("customerId");

ALTER TABLE "vaultTransactions" ADD FOREIGN KEY ("customerId") REFERENCES "customer" ("customerId");

ALTER TABLE "payoutOrders" ADD FOREIGN KEY ("customerId") REFERENCES "customer" ("customerId");

ALTER TABLE "walletTransactions" ADD FOREIGN KEY ("customerId") REFERENCES "customer" ("customerId");
