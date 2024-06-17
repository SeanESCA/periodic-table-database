#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number = $1")
  else
    QUERY_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol = '$1'")
    if [[ -z $QUERY_RESULT ]]
    then
      QUERY_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name = '$1'")
    fi
  fi

  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database." 
  else
    echo "$QUERY_RESULT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed "s/^ *| *$//g" -r) is $(echo $NAME | sed "s/^ *| *$//g" -r) ($(echo $SYMBOL | sed "s/^ *| *$//g" -r)). It's a $(echo $TYPE | sed "s/^ *| *$//g" -r), with a mass of $(echo $ATOMIC_MASS | sed "s/^ *| *$//g" -r) amu. $(echo $NAME | sed "s/^ *| *$//g" -r) has a melting point of $(echo $MELTING_POINT | sed "s/^ *| *$//g" -r) celsius and a boiling point of $(echo $BOILING_POINT | sed "s/^ *| *$//g" -r) celsius."
    done
  fi
fi
