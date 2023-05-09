
#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams,games" )"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOAL OPP_GOAL
do 
echo $YEAR $ROUND $WINNER $OPPONENT $WIN_GOAL $OPP_GOAL
if [[ $YEAR != 'year' ]]
then
  #Get Winner Team ID 
  WINNER_TEAM_ID=$($PSQL "SELECT TEAM_ID FROM TEAMS WHERE NAME='$WINNER' ")
  #If not found 
  if [[ -z $WINNER_TEAM_ID ]]
  then 
    #Insert Winner Team 
    INSERT_WINNER=$($PSQL "INSERT INTO TEAMS(NAME) VALUES('$WINNER')")
    echo $INSERT_WINNER
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then 
      echo "Inserted Team , $WINNER"
    fi  
    #Get new Winner Team ID .
    WINNER_TEAM_ID=$($PSQL "SELECT TEAM_ID FROM TEAMS WHERE NAME='$WINNER' ")
  fi
  
  #Get Opponent Team ID 
  OPP_TEAM_ID=$($PSQL "SELECT TEAM_ID FROM TEAMS WHERE NAME='$OPPONENT'")
 #If Opponent Team ID not found 
  if [[ -z $OPP_TEAM_ID ]]
  then 
    #Insert Opponent Team 
    INSERT_OPPO=$($PSQL "INSERT INTO TEAMS(NAME) VALUES('$OPPONENT')")  
    echo $INSERT_OPPO
    if [[ $INSERT_OPPO == "INSERT 0 1" ]]
    then 
      echo "Inserted Team , $OPPONENT"
    fi  
    #Get new Opponent Team ID
    OPP_TEAM_ID=$($PSQL "SELECT TEAM_ID FROM TEAMS WHERE NAME='$OPPONENT'")
  fi
  #Insert Game details 
  INSERT_GAME=$($PSQL "INSERT INTO GAMES(YEAR,ROUND,WINNER_ID,OPPONENT_ID,WINNER_GOALS,OPPONENT_GOALS) values($YEAR,'$ROUND',$WINNER_TEAM_ID,$OPP_TEAM_ID,$WIN_GOAL,$OPP_GOAL)" )
  
  echo $INSERT_GAME
  if [[ $INSERT_GAME == "INSERT 0 1" ]]
  then 
    echo "Game Inserted"
  fi  
  
 fi
done
