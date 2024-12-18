#!/bin/bash

 Display the services offered
echo "~~~~~ MY SALON ~~~~~"
echo "Welcome to My Salon, how can I help you?"
echo "1) cut"
echo "2) color"
echo "3) perm"
echo "4) style"
echo "5) trim"

# Read the selected service
read SERVICE_ID_SELECTED

# Function to handle invalid service input
while ! [[ "$SERVICE_ID_SELECTED" =~ ^[1-5]$ ]]; do
    echo "I could not find that service. What would you like today?"
    echo "1) cut"
    echo "2) color"
    echo "3) perm"
    echo "4) style"
    echo "5) trim"
    read SERVICE_ID_SELECTED
done

# Get the phone number
echo "What's your phone number?"
read CUSTOMER_PHONE

# Check if the customer exists
CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

if [ -z "$CUSTOMER_ID" ]; then
    # If no customer exists, ask for their name
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    
    # Insert the customer into the customers table
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');"
    
    # Get the customer ID
    CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
fi

# Get the appointment time
SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

# Insert the appointment into the appointments table
psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

# Display the confirmation message
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."