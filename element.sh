#!/bin/bash

# Include the -X flag to prevent user configurations from interfering with output formatting
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Determine condition based on argument type
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="elements.atomic_number = $1"
else
  CONDITION="elements.symbol = '$1' OR elements.name = '$1'"
fi

# Fetch element records
DATA=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $CONDITION")

if [[ -z $DATA ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$DATA"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi