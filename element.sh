#!/bin/bash

# Connect to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 1
fi

# Query the database for element information
if [[ $1 =~ ^[0-9]+$ ]]; then
  # If input is a number, search by atomic_number
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$1"
else
  # If input is a string, search by symbol or name
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types ON properties.type_id=types.type_id WHERE symbol='$1' OR name='$1'"
fi

RESULT=$($PSQL "$QUERY")

# Check if the element exists
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Parse and display element information
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
