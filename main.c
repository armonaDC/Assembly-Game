#include <stdio.h>
#include <stdlib.h>

const int rows = 19;
const int columns = 29;

void printGamePlay(char array[rows][columns]);
void initializeGame(char array[rows][columns], int posX, int posY);
void movePlayer(char game[rows][columns], char moveDir, int *playerPosX, int *playerPosY);
void Enemy(char game[rows][columns], int playerPosX, int playerPosY);

int main(void) {
  char game[rows][columns];
  int playing = 1; //1 means game is ongoing, 0 means game is over
  int playerPosX = rows / 2 + 1; //starting player x position
  int playerPosY = columns / 2 + 1; //starting player y position
  char moveDir; //movement direction
  unsigned long loopCounter = 0;

  initializeGame(game, playerPosX, playerPosY);

  while(playing == 1){
    system("clear");
    printGamePlay(game);
    
    scanf(" %c", &moveDir);
    movePlayer(game, moveDir, &playerPosX, &playerPosY);

    if(loopCounter > 5){
      Enemy(game, playerPosX, playerPosY);
    }

    loopCounter++;
  }
  
  return 0;
}

void printGamePlay(char array[rows][columns]){
  int i;
  int j;

  for (i = 0; i<rows; i++){
    
    for(j = 0; j<columns; j++){
      printf("%c", array[i][j]);
    }
    
    printf("\n");
    
  }  
}

void initializeGame(char array[rows][columns], int posX, int posY){
  int i;
  int j;

  for (i = 0; i<rows; i++){
    for(j = 0; j<columns; j++){
      array[i][j] = '.';
    }
  }

  array[posX][posY] = 't';
}

void movePlayer(char game[rows][columns], char moveDir, int *playerPosX, int *playerPosY){
  if (moveDir == 'w'){
    game[*playerPosX][*playerPosY] = '.';
    (*playerPosX)--; //moving up is decreasing by one row
    game[*playerPosX][*playerPosY] = 't';
  }
  if (moveDir == 'a'){
    game[*playerPosX][*playerPosY] = '.';
    (*playerPosY)--; //moving left is decreasing by one column
    game[*playerPosX][*playerPosY] = 't';
  }
  if (moveDir == 's'){
    game[*playerPosX][*playerPosY] = '.';
    (*playerPosX)++; //moving down is increasing by one row
    game[*playerPosX][*playerPosY] = 't';
  }
  if (moveDir == 'd'){
    game[*playerPosX][*playerPosY] = '.';
    (*playerPosY)++; //moving right is increasing by one column
    game[*playerPosX][*playerPosY] = 't';
  }
}

void Enemy(char game[rows][columns], int playerPosX, int playerPosY){
  int i;
  int j;
  int enemyExists = 0;
  int enemySpawnX;
  int enemySpawnY;

  //check if enemy exists, if not, spawn one
  for (i = 0; i<rows; i++){
    for(j = 0; j<columns; j++){
      if (game[i][j] == 'e'){
        enemyExists = 1;
      }
    }
  }

  if (enemyExists == 0){
    if (playerPosX - 7 < 0){
        enemySpawnX = playerPosX + 7;
    }
    else{
        enemySpawnX = playerPosX - 7;
    }

    if(playerPosY - 12 < 0){
      enemySpawnY = playerPosY + 12;
    }
    else{
      enemySpawnY = playerPosY - 12;
    }

    game[enemySpawnX][enemySpawnY] = 'e';
  }



}