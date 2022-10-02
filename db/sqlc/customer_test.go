package db

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"brightdigigold.com/payment/utils"
	"github.com/stretchr/testify/require"
	_ "github.com/stretchr/testify/require"
)

func createNewCustomer(t *testing.T) Customer {
	arg := CreateCustomerParams{
		CustomerID:    utils.RandomCustomerID(),
		BankName:      sql.NullString{String: "Axis Bank", Valid: true},
		AccountNumber: sql.NullString{String: utils.RandomCustomerID(), Valid: true},
		Ifsc:          sql.NullString{String: "UTIB0000654", Valid: true},
		Active:        sql.NullBool{Bool: true, Valid: true},
		CreatedAt:     sql.NullTime{Time: time.Now(), Valid: true},
	}
	customer, err := testQueries.CreateCustomer(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, customer)
	require.Equal(t, arg.CustomerID, customer.CustomerID)
	return customer
}

func TestCreateCustomer(t *testing.T) {
	createNewCustomer(t)
}

func TestGetCustomer(t *testing.T) {
	customer1 := createNewCustomer(t)
	account2, err := testQueries.GetCustomer(context.Background(), customer1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, account2)
	require.Equal(t, customer1.CustomerID, account2.CustomerID)
}

func TestUpdateCustomer(t *testing.T) {
	customer1 := createNewCustomer(t)
	arg := UpdateCustomerParams{
		ID:            customer1.ID,
		Ifsc:          sql.NullString{String: "KKBK0099132", Valid: true},
		BankName:      sql.NullString{String: "Axis Bank", Valid: true},
		AccountNumber: sql.NullString{String: utils.RandomCustomerID(), Valid: true},
		Active:        sql.NullBool{Bool: true, Valid: true},
		CustomerID:    customer1.CustomerID,
	}
	customer2, err := testQueries.UpdateCustomer(context.Background(), arg)
	require.NoError(t, err)
	require.Equal(t, customer1.ID, customer2.ID)
	require.Equal(t, customer2.Ifsc, customer2.Ifsc)
}

func TestDeleteCustomer(t *testing.T) {
	customer1 := createNewCustomer(t)
	err := testQueries.DeleteCustomer(context.Background(), customer1.ID)
	require.NoError(t, err)

	account2, err := testQueries.GetCustomer(context.Background(), customer1.ID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, account2)
}

func TestListCustomer(t *testing.T) {
	for i := 0; i < 10; i++ {
		createNewCustomer(t)
	}
	list, err := testQueries.ListCustomers(context.Background())
	require.NoError(t, err)
	require.NotEmpty(t, list)
}
