import strutils

type GameBoard = array[3, array[3, char]]

# Create a gameboard that is initialized with whitespace during compile time
var gameboard: GameBoard = static:
  var gameboard: array[3,array[3, char]]
  for x in 0..<3:
    for y in 0..<3:
      gameboard[x][y] = ' '
  gameboard

proc promptInput(prompt: string): string =
  stdout.write prompt
  stdout.flushFile
  result = stdin.readLine

proc displayBoard(gameboard: GameBoard) =
  echo ' ', gameboard[0][0], " │ ", gameboard[1][0], " │ ", gameboard[2][0]
  echo "───┼───┼───"
  echo ' ', gameboard[0][1], " │ ", gameboard[1][1], " │ ", gameboard[2][1]
  echo "───┼───┼───"
  echo ' ', gameboard[0][2], " │ ", gameboard[1][2], " │ ", gameboard[2][2]

proc boardFilled(gameboard: GameBoard): bool =
  for x in 0..<3:
    for y in 0..<3:
      if gameboard[x][y] == ' ':
        return false
  return true

proc checkWin(gameboard: GameBoard, forp: char): bool =
  for x in 0..<3:
    if gameboard[0][x] == forp and gameboard[1][x]  == forp and gameboard[2][x] == forp:
      return true
  for y in 0..<3:
    if gameboard[y][0] == forp and gameboard[y][1] == forp and gameboard[y][2] == forp:
      return true
  if gameboard[0][0] == forp and gameboard[1][1] == forp and gameboard[2][2] == forp:
    return true
  if gameboard[0][2] == forp and gameboard[1][1] == forp and gameboard[2][0] == forp:
    return true
  return false

proc clearScreen() =
  stdout.write "\x1b[H\x1b[2J"
  stdout.flushFile()

proc playGame(gameboard: var GameBoard) =
  stdout.write "\x1b[?47h"
  stdout.flushFile()
  clearScreen()
  var
    position, x, y: int
    winner: char = ' '

  while true:
    displayBoard gameboard
    while true:
      position = promptInput("Turn for X: ").parseInt - 1
      x = position mod 3
      y = position div 3
      if gameboard[x][y] == ' ':
        gameboard[x][y] = 'X'
        break
      else:
        clearScreen()
        displayBoard gameboard
        echo "Invalid Location, already occupied"
    if gameboard.checkWin 'X':
      winner = 'X'
      break

    if boardFilled gameboard:
      break

    clearScreen()
    displayBoard gameboard
    while true:
      position = promptInput("Turn for O: ").parseInt - 1
      x = position mod 3
      y = position div 3
      if gameboard[x][y] == ' ':
        gameboard[x][y] = 'O'
        break
      else:
        clearScreen()
        displayBoard gameboard
        echo "Invalid Location, already occupied"
    if gameboard.checkWin 'O':
      winner = 'O'
      break

    if boardFilled gameboard:
      break

    clearScreen()

  clearScreen()
  displayBoard gameboard
  if winner == ' ':
    echo "Its a Draw"
  elif winner == 'X':
    echo "X won the game"
  else:
    echo "O won the game"
  discard promptInput("Press Enter to continue... ")
  stdout.write "\x1b[?47l"
  stdout.flushFile()

when isMainModule:
  playGame(gameboard)