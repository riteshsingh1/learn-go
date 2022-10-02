-- name: GetCustomer :one
SELECT * FROM customer
WHERE id = $1 LIMIT 1;

-- name: ListCustomers :many
SELECT * FROM customer
ORDER BY name;

-- name: CreateCustomer :one
INSERT INTO customer (
  customer_id, created_at, bank_name, ifsc, account_number, active
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: DeleteCustomer :exec
DELETE FROM customer
WHERE id = $1;


-- name: UpdateCustomer :one
UPDATE customer
set customer_id = $2,
bank_name = $3,
ifsc = $4,
account_number = $5,
active = $6
WHERE id = $1
RETURNING *;