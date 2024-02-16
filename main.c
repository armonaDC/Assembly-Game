#include <stdio.h>
#include <stdlib.h>

const int rows = 19;
const int columns = 29;

enum enemyType {BASIC = 0};

void PrintGamePlay(char array[rows][columns]);
void InitializeGame(char array[rows][columns], int posX, int posY);
void MovePlayer(char game[rows][columns], char moveDir, int *playerPosX, int *playerPosY);
void SpawnEnemy(char game[rows][columns], int playerPosX, int playerPosY, int enemySpawnPos[2], int enemyType);
void Enemy(char game[rows][columns], int playerPosX, int playerPosY, int enemyPosX, int enemyPosY, int enemyType);

int main(void) {
  char game[rows][columns];
  int enemySpawnPos[2]; //index 0 will have enemy X position and index 1 will have enemy Y position
  int playing = 1; //1 means game is ongoing, 0 means game is over
  int playerPosX = rows / 2 + 1; //starting player x position
  int playerPosY = columns / 2 + 1; //starting player y position
  char moveDir; //movement direction
  unsigned long loopCounter = 0;

  InitializeGame(game, playerPosX, playerPosY);

  while(playing == 1){
    system("clear");
    PrintGamePlay(game);
    
    scanf(" %c", &moveDir);
    MovePlayer(game, moveDir, &playerPosX, &playerPosY);

    if(loopCounter > 5){
      SpawnEnemy(game, playerPosX, playerPosY, enemySpawnPos, BASIC); //only needs to spawn one enemy, spawns multiple
    }

    loopCounter++;
  }
  
  return 0;
}

void PrintGamePlay(char array[rows][columns]){
  int i;
  int j;

  for (i = 0; i<rows; i++){
    
    for(j = 0; j<columns; j++){
      printf("%c", array[i][j]);
    }
    
    printf("\n");
    
  }  
}

void InitializeGame(char array[rows][columns], int posX, int posY){
  int i;
  int j;

  for (i = 0; i<rows; i++){
    for(j = 0; j<columns; j++){
      array[i][j] = '.';
    }
  }

  array[posX][posY] = 't';
}

void MovePlayer(char game[rows][columns], char moveDir, int *playerPosX, int *playerPosY){
  //FIXME: ADD BOUNDARIES FOR PLAYER MOVEMENT

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

void SpawnEnemy(char game[rows][columns], int playerPosX, int playerPosY, int enemySpawnPos[2], int enemyType){
  //type has not been implemented yet

  if (enemyType == BASIC){
    if (playerPosX - 7 < 0){
      enemySpawnPos[0] = playerPosX + 7;
    }
    else{
      enemySpawnPos[0] = playerPosX - 7;
    }

    if(playerPosY - 12 < 0){
      enemySpawnPos[1] = playerPosY + 12;
    }
    else{
      enemySpawnPos[1] = playerPosY - 12;
    }
  }

  game[enemySpawnPos[0]][enemySpawnPos[1]] = 'e';
}

void Enemy(char game[rows][columns], int playerPosX, int playerPosY, int enemyPosX, int enemyPosY, int enemyType){
  /*int i;
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
  }*/

}