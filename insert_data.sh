#! /bin/bash

if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "truncate table games, teams;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  if [[ $WINNER != 'winner' ]]; then
    WINNER_IS_EXISTING=$($PSQL "select name from teams where name = '$WINNER'")
    if [[ -z $WINNER_IS_EXISTING ]]; then
      echo "$($PSQL "insert into teams values(default, '$WINNER');")"
    fi
  fi

  if [[ $OPPONENT != 'opponent' ]]; then
    OPPONENT_IS_EXISTING=$($PSQL "select name from teams where name = '$OPPONENT'")
    if [[ -z $OPPONENT_IS_EXISTING ]]; then
      echo "$($PSQL "insert into teams values(default, '$OPPONENT');")"
    fi
  fi

  if [[ $YEAR != 'year' ]]; then
    echo $WINNER, $OPPONENT
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER';")
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT';")
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done

