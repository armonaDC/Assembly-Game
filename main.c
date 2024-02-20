#include <stdio.h>
#include <stdlib.h>

const int rows = 19;
const int columns = 29;
const int MAX_ENEMIES = 100; //number of enemies over the course of the entire game

enum enemyType {BASIC = 0};

void PrintGamePlay(char array[rows][columns]);
void InitializeGame(char array[rows][columns], int posX, int posY);
void MovePlayer(char game[rows][columns], char moveDir, int *playerPosX, int *playerPosY);
void SpawnEnemy(char game[rows][columns], int playerPosX, int playerPosY, int enemyPosX[MAX_ENEMIES], int enemyPosY[MAX_ENEMIES], int enemyIndex[MAX_ENEMIES], int enemyType);
void Enemy(char game[rows][columns], int playerPosX, int playerPosY, int enemyPosX[MAX_ENEMIES], int enemyPosY[MAX_ENEMIES], int enemyIndex[MAX_ENEMIES]);

int main(void) {
  char game[rows][columns];
  int enemyPosX[MAX_ENEMIES]; //each enemy will have its own index in both enemyPos arrays
  int enemyPosY[MAX_ENEMIES];
  int enemyIndex[MAX_ENEMIES]; //this array will store every enemy's index
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
      SpawnEnemy(game, playerPosX, playerPosY, enemyPosX, enemyPosY, enemyIndex, BASIC); //used for testing spawn logic
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

void SpawnEnemy(char game[rows][columns], int playerPosX, int playerPosY, int enemyPosX[MAX_ENEMIES], int enemyPosY[MAX_ENEMIES], int enemyIndex[MAX_ENEMIES], int enemyType){
  int i = 0;
  int index;

  while(i < MAX_ENEMIES){ //search for first available index in enemyIndex that is 0, then break
    if(enemyIndex[i] == 0){
      index = i;
      break;
    }

    i++;
  }

  //enemyIndex[index] = index; //FIXME: this line introduces a bug when enemies are spawned at the same spot an existing enemy is

  if (enemyType == BASIC){
    if (playerPosX - 7 < 0){
      enemyPosX[index] = playerPosX + 7;
    }
    else{
      enemyPosX[index] = playerPosX - 7;
    }

    if(playerPosY - 12 < 0){
      enemyPosY[index] = playerPosY + 12;
    }
    else{
      enemyPosY[index] = playerPosY - 12;
    }
  }

  game[enemyPosX[index]][enemyPosY[index]] = 'e'; //BASIC enemies will be represented using the char 'e'
}

void Enemy(char game[rows][columns], int playerPosX, int playerPosY, int enemyPosX[MAX_ENEMIES], int enemyPosY[MAX_ENEMIES], int enemyIndex[MAX_ENEMIES]){
  //GOAL: find how many enemies are on the screen, then calculate behavior for each enemy on the next frame
  //each enemy type are unique chars so no need to pass this in


}