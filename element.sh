PSQL="psql --username=freecodecamp --dbname=periodic_table -t -q --no-align -c"
ARG1=$1

MAIN() {

  if [[ "$ARG1" =~ ^[0-9]+$ ]]
  then
    MAKE_CHECK=$($PSQL "select atomic_number, symbol, name from elements where atomic_number=$ARG1")
  else
    MAKE_CHECK=$($PSQL "select atomic_number, symbol, name from elements where symbol='$ARG1' or name='$ARG1'") 
  fi

  if [[ ! -z $MAKE_CHECK ]]
  then
    IFS="|" read ATOMIC_NUM SYMBOL NAME <<< "$MAKE_CHECK"
    
    PROPS=$($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUM")
    IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$PROPS"
    echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
}

if [[ -z $ARG1 ]]
then
  echo "Please provide an element as an argument."
else
  MAIN
fi
