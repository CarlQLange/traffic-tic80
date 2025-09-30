# Game state
game =
  state: \menu
  time: 0

# Menu state
menu-tick = ->
  cls 0
  print "TRAFFIC", 90, 60, 15, false, 2
  print "Press Z to start", 70, 80, 12

  if btnp 4  # Z button
    game.state = \play
    init-game!

# Initialize gameplay
init-game = ->
  game.time = 0

# Game state
play-tick = ->
  cls 5
  print "Game running...", 10, 10, 15
  print "Time: #{game.time}", 10, 20, 15

  game.time++

  if btnp 4  # Z button
    game.state = \menu

# Main game loop
export TIC = ->
  if game.state == \menu
    menu-tick!
  else if game.state == \play
    play-tick!
