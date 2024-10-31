#!/bin/bash

# Connect to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0  # Exit with a success status
fi

# Check if the argument is a number (atomic number)
if [[ $1 =~ ^[0-9]+$ ]]; then
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                   FROM elements 
                   JOIN properties USING(atomic_number) 
                   JOIN types USING(type_id) 
                   WHERE atomic_number = $1")
else
  # Argument is a string (symbol or name)
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                   FROM elements 
                   JOIN properties USING(atomic_number) 
                   JOIN types USING(type_id) 
                   WHERE symbol = '$1' OR name = '$1'")
fi

# Check if the element was found in the database
if [[ -z $element ]]; then
  echo "I could not find that element in the database."
else
  # Parse the element data
  IFS="|" read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$element"
  
  # Output the formatted information
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi
