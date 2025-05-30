#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
tail -n +2 games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# Above line skips the first line with the names of columns and sets separator as "," then stores values as variables
do
  $PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT DO NOTHING;" 
# On conflict that is when there are duplicates, do nothing
  $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT DO NOTHING;"

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
  VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
done