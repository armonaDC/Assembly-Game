#include <stdio.h>
#include <stdlib.h>

const int rows = 19;
const int columns = 29;

void printGamePlay(char array[rows][columns]);
void initializeGame(char array[rows][columns], int posX, int posY);
void movePlayer(char game[rows][columns], char moveDir, int *playerPosX, int *playerPosY);

int main(void) {
  char game[rows][columns];
  int playing = 1; //1 means game is ongoing, 0 means game is over
  int playerPosX = rows / 2 + 1; //starting player x position
  int playerPosY = columns / 2 + 1; //starting player y position
  char moveDir; //movement direction

  initializeGame(game, playerPosX, playerPosY);

  while(playing == 1){
    system("clear");
    printGamePlay(game);
    
    scanf(" %c", &moveDir);
    movePlayer(game, moveDir, &playerPosX, &playerPosY);
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
    (*playerPosX)++; //moving right is increasing by one column
    game[*playerPosX][*playerPosY] = 't';
  }
  if (moveDir == 'd'){
    game[*playerPosX][*playerPosY] = '.';
    (*playerPosY)++; //moving down is increasing by one row
    game[*playerPosX][*playerPosY] = 't';
  }
}