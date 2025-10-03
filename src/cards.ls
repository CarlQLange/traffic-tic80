# ===== CARD DEFINITIONS =====
CARD_TYPES =
  straight: {n: true, e: false, s: true, w: false}  # Vertical line
  "straight-h": {n: false, e: true, s: false, w: true}  # Horizontal line
  "left-turn": {n: true, e: true, s: false, w: false}  # ⌐ shape
  "right-turn": {n: true, e: false, s: false, w: true}  # ⌙ shape
  "left-turn-s": {n: false, e: true, s: true, w: false}  # ⌙ rotated
  "right-turn-s": {n: false, e: false, s: true, w: true}  # ⌐ rotated
  "t-junction": {n: true, e: true, s: true, w: false}  # ⊤ shape
  "t-junction-r": {n: true, e: false, s: true, w: true}  # ⊤ rotated
  "t-junction-b": {n: false, e: true, s: true, w: true}  # ⊥ shape
  "t-junction-l": {n: true, e: true, s: false, w: true}  # ⊤ rotated left
  "crossroads": {n: true, e: true, s: true, w: true}  # + shape

# ===== CUSTOM PIXEL ART OVERRIDES =====
# Override card visuals with custom pixel grids (any size, auto-scales)
# Use palette colors 0-15:
#   0=black 1=dark-blue 2=dark-purple 3=dark-green 4=brown 5=dark-grey
#   6=light-grey 7=white 8=red 9=orange 10=yellow 11=green 12=blue
#   13=indigo 14=pink 15=peach
#
# Example - vertical straight road (12x12 grid):
# CARD_VISUALS =
#   straight: [
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#   ]
#
#   left-turn: [
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 0 0 0 0 0]
#     [0 0 0 0 0 11 11 11 11 11 11 11]
#     [0 0 0 0 0 11 11 11 11 11 11 11]
#     [0 0 0 0 0 0 0 0 0 0 0 0]
#     [0 0 0 0 0 0 0 0 0 0 0 0]
#     [0 0 0 0 0 0 0 0 0 0 0 0]
#     [0 0 0 0 0 0 0 0 0 0 0 0]
#     [0 0 0 0 0 0 0 0 0 0 0 0]
#   ]

CARD_VISUALS =
  # Vertical straight road
  "straight": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

  # Horizontal straight road
  "straight-h": [
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
  ]

  # Left turn: North to East (⌐ shape)
  "left-turn": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 11 11 11 11 11]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
  ]

  # Right turn: North to West (⌙ shape)
  "right-turn": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
  ]

  # Left turn south: South to East
  "left-turn-s": [
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

  # Right turn south: South to West
  "right-turn-s": [
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [11 11 11 11 11 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

  # T-junction: North, East, South (⊤ shape)
  "t-junction": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

  # T-junction right: North, West, South
  "t-junction-r": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

  # T-junction bottom: East, South, West (⊥ shape)
  "t-junction-b": [
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

  # T-junction left: North, East, West
  "t-junction-l": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
  ]

  # Crossroads: All four directions (+ shape)
  "crossroads": [
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [11 11 11 11 11 11 11 11 11 11 11 11]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
    [0 0 0 0 0 11 11 0 0 0 0 0]
  ]

# Rotate a grid 90 degrees clockwise
rotate-grid-cw = (grid) ->
  size = grid.length
  rotated = []
  for i from 0 to size - 1
    row = []
    for j from 0 to size - 1
      row.push grid[size - 1 - j][i]
    rotated.push row
  rotated

# Rotate grid by rotation amount (0-3 = 0/90/180/270 degrees)
rotate-grid = (grid, rotation) ->
  if rotation == 0
    return grid
  else if rotation == 1
    return rotate-grid-cw grid
  else if rotation == 2
    return rotate-grid-cw(rotate-grid-cw grid)
  else if rotation == 3
    return rotate-grid-cw(rotate-grid-cw(rotate-grid-cw grid))
  grid

# Rotate connection pattern
rotate-connections = (connections, rotation) ->
  if rotation == 0
    return connections
  else if rotation == 1  # 90° clockwise
    {n: connections.w, e: connections.n, s: connections.e, w: connections.s}
  else if rotation == 2  # 180°
    {n: connections.s, e: connections.w, s: connections.n, w: connections.e}
  else if rotation == 3  # 270° clockwise
    {n: connections.e, e: connections.s, s: connections.w, w: connections.n}
  else
    connections

# Visual representation function
draw-card-visual = (card-type, x, y, size = 12, rotation = 0) ->
  grid = CARD_VISUALS[card-type]
  if not grid then return

  # Apply rotation
  if rotation > 0
    grid = rotate-grid grid, rotation

  grid-size = grid.length
  # Calculate scale to fit - use actual division, not floor
  scale = size / grid-size

  for row, i in grid
    for color, j in row
      if color > 0  # 0 = transparent/empty
        px = x + j * scale
        py = y + i * scale
        # Draw scaled pixel (may be fractional size, TIC-80 handles this)
        rect px, py, scale, scale, color