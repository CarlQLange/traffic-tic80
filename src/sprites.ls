# ===== SPRITE DEFINITIONS =====
# All visual sprites as pixel arrays (0 = transparent, 1-15 = palette colors)

# Bonus icon sprites (6x6 or smaller, centered)
BONUS_SPRITES =
  # Clock icon for turn bonuses (5x5)
  "clock": [
    [0 0 0 0 0 0]
    [0 0 15 15 0 0]
    [0 15 0 15 0 0]
    [0 15 15 15 0 0]
    [0 0 15 15 0 0]
    [0 0 0 0 0 0]
  ]

  # Card stack for draw bonuses (6x6)
  "cards": [
    [0 0 0 0 0 0]
    [0 15 15 15 0 0]
    [0 15 0 15 15 15]
    [0 15 0 15 0 15]
    [0 15 15 15 0 15]
    [0 0 0 15 15 15]
  ]

  # Star/X for premium card (5x5)
  "star": [
    [0 0 0 0 0 0]
    [0 15 0 0 15 0]
    [0 0 15 15 0 0]
    [0 0 15 15 0 0]
    [0 15 0 0 15 0]
    [0 0 0 0 0 0]
  ]

  # Question mark for wild card (5x6)
  "question": [
    [0 0 15 15 0 0]
    [0 15 0 0 15 0]
    [0 0 0 0 15 0]
    [0 0 0 15 0 0]
    [0 0 0 0 0 0]
    [0 0 0 15 0 0]
  ]

# Goal marker sprites (variable size, drawn in corners)
GOAL_SPRITES =
  # Simple dot marker (used with white border and colored background)
  "dot": [
    [15 15 15]
    [15 15 15]
    [15 15 15]
  ]

# Road tile sprites (12x12)
ROAD_SPRITES =
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

# ===== SPRITE UTILITY FUNCTIONS =====

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

# ===== RENDERING FUNCTIONS =====

# Draw a sprite from a pixel grid
draw-sprite = (grid, x, y, size, rotation = 0) ->
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

# Draw a road tile
draw-road-tile = (tile-type, x, y, size = 12, rotation = 0) ->
  grid = ROAD_SPRITES[tile-type]
  draw-sprite grid, x, y, size, rotation

# Draw bonus icon on a tile (centered at cx, cy)
draw-bonus-icon = (bonus-type-id, cx, cy) ->
  sprite-name = null

  switch bonus-type-id
  | \turn-1, \turn-2, \turn-3 => sprite-name = "clock"
  | \draw-1, \draw-2 => sprite-name = "cards"
  | \premium-card => sprite-name = "star"
  | \wild-card => sprite-name = "question"

  if sprite-name
    grid = BONUS_SPRITES[sprite-name]
    if grid
      # Center the sprite at cx, cy
      sprite-size = grid.length
      x = cx - sprite-size / 2
      y = cy - sprite-size / 2
      draw-sprite grid, x, y, sprite-size, 0

# Draw a goal marker as circles (centered on tile center, pulsing outward)
draw-goal-marker = (x, y, marker-radius, dot-radius, offset-x, offset-y, is-start, marker-color, marker-bg) ->
  border-color = 15  # White border for maximum contrast

  # Position at tile center and pulse outward symmetrically
  tile-center-x = Math.floor(x + 6)  # TILE_SIZE / 2 = 12 / 2 = 6
  tile-center-y = Math.floor(y + 6)

  # Draw as circles centered at tile center
  # White border (outer circle)
  circ tile-center-x, tile-center-y, marker-radius + 1, border-color
  # Background circle
  circ tile-center-x, tile-center-y, marker-radius, marker-bg
  # Bright dot (centered circle)
  circ tile-center-x, tile-center-y, dot-radius, marker-color
