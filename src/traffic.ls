# ===== TOP-LEVEL GAME STATE =====
game =
  state: \menu  # menu, ingame, gameover
  score: 0
  goals-completed: 0
  timer: 0  # Global timer for animations

# ===== IN-GAME STATE =====
ingame =
  state: \select-goal  # select-goal, playing, goal-complete, penalty-select

  # Turn economy
  turns: 0
  turn-breakdown: {base: 0, bonuses: 0, penalties: 0}

  # Goals
  current-goal: null
  goal-options: []
  completed-goals: []
  broken-goals: []  # Goals that are no longer connected
  selected-goal: 0

  # Penalties
  active-penalties: []  # Each has {penalty, goal} - track which goal caused it
  penalty-options: []
  selected-penalty: 0

  # Deck & hand
  deck: []
  hand: []
  hand-rotations: []  # Track rotation for each card in hand
  discard: []
  selected-card: null
  selected-rotation: 0  # 0, 1, 2, 3 for 0°, 90°, 180°, 270°

  # Mouse drag state
  drag:
    active: false
    card-idx: null
    card-type: null
    rotation: 0
    start-x: 0
    start-y: 0

  # Previous mouse state (for debouncing)
  prev-mouse:
    left: false
    right: false
    btn-a: false  # A button for rotation

  # Grid (8x8) - each cell can be {type, rotation} or a bonus tile
  grid: []

  # Bonus tiles
  bonuses: []  # {x, y, type, active}

# Global previous mouse state (for debouncing across game states)
prev-mouse-state =
  left: false
  right: false

# ===== GRID CONSTANTS =====
GRID_SIZE = 8
TILE_SIZE = 12
GRID_X = (240 - GRID_SIZE * TILE_SIZE) / 2  # Center horizontally
GRID_Y = 8  # Top of screen with small margin

# ===== PENALTY TYPES =====
PENALTY_TYPES = [
  {id: \small-hand, name: "Small Hand", desc: "Draw only 4 cards"}
  {id: \no-straights, name: "No Straights", desc: "Can't place straights"}
  {id: \no-turns, name: "No Turns", desc: "Can't place turn cards"}
  {id: \no-junctions, name: "No Junctions", desc: "Can't place junctions"}
  {id: \expensive, name: "Expensive", desc: "+1 turn cost"}
  {id: \no-replace, name: "No Replace", desc: "Can't replace tiles"}
  {id: \slow-draw, name: "Slow Draw", desc: "Draw 3 cards/turn"}
  {id: \discard-3, name: "Discard 3", desc: "Lose 3 random cards"}
  {id: \time-drain, name: "Time Drain", desc: "-1 turn each cycle"}
  {id: \locked-rotation, name: "Locked", desc: "Can't rotate cards"}
]

# ===== BONUS TYPES =====
BONUS_TYPES = [
  {id: \turn-1, name: "+1 Turn", rarity: \common, color: 10}
  {id: \turn-2, name: "+2 Turns", rarity: \uncommon, color: 10}
  {id: \turn-3, name: "+3 Turns", rarity: \rare, color: 9}
  {id: \draw-1, name: "Draw +1", rarity: \common, color: 12}
  {id: \draw-2, name: "Draw +2", rarity: \uncommon, color: 12}
  {id: \premium-card, name: "Premium Card", rarity: \rare, color: 14}
  {id: \wild-card, name: "Wild Card", rarity: \rare, color: 15}
]

# ===== GRID HELPERS =====
screen-to-grid = (sx, sy) ->
  gx = Math.floor (sx - GRID_X) / TILE_SIZE
  gy = Math.floor (sy - GRID_Y) / TILE_SIZE
  if gx >= 0 and gx < GRID_SIZE and gy >= 0 and gy < GRID_SIZE
    {x: gx, y: gy, idx: gy * GRID_SIZE + gx}
  else
    null

grid-to-screen = (gx, gy) ->
  x: GRID_X + gx * TILE_SIZE
  y: GRID_Y + gy * TILE_SIZE

get-cell = (gx, gy) ->
  ingame.grid[gy * GRID_SIZE + gx]

set-cell = (gx, gy, card-type, rotation = 0) ->
  ingame.grid[gy * GRID_SIZE + gx] = {type: card-type, rotation}

is-cell-empty = (gx, gy) ->
  not get-cell gx, gy

# ===== PATHFINDING =====
get-connections = (card-type, rotation = 0) ->
  # Get base connections and rotate them
  connections = CARD_TYPES[card-type]
  if not connections then return null
  rotate-connections connections, rotation

check-connection = (from-x, from-y, to-x, to-y) ->
  # Check if two adjacent cells can connect
  from-cell = get-cell from-x, from-y
  to-cell = get-cell to-x, to-y

  if not from-cell or not to-cell
    return false

  from-conn = get-connections from-cell.type, from-cell.rotation
  to-conn = get-connections to-cell.type, to-cell.rotation

  if not from-conn or not to-conn
    return false

  # Determine direction from -> to
  dx = to-x - from-x
  dy = to-y - from-y

  # Check if connections match
  result = false
  if dx == 1  # Moving East
    result = from-conn.e and to-conn.w
  else if dx == -1  # Moving West
    result = from-conn.w and to-conn.e
  else if dy == 1  # Moving South
    result = from-conn.s and to-conn.n
  else if dy == -1  # Moving North
    result = from-conn.n and to-conn.s

  result

find-path = (start-x, start-y, end-x, end-y) ->
  # BFS pathfinding
  if not get-cell(start-x, start-y) or not get-cell(end-x, end-y)
    return false

  visited = {}
  queue = [{x: start-x, y: start-y}]
  visited["#{start-x},#{start-y}"] = true

  while queue.length > 0
    current = queue.shift!

    # Found the end
    if current.x == end-x and current.y == end-y
      return true

    # Check all 4 directions
    neighbors = [
      {x: current.x + 1, y: current.y}  # East
      {x: current.x - 1, y: current.y}  # West
      {x: current.x, y: current.y + 1}  # South
      {x: current.x, y: current.y - 1}  # North
    ]

    for neighbor in neighbors
      key = "#{neighbor.x},#{neighbor.y}"
      if neighbor.x >= 0 and neighbor.x < GRID_SIZE and neighbor.y >= 0 and neighbor.y < GRID_SIZE
        if not visited[key] and check-connection current.x, current.y, neighbor.x, neighbor.y
          visited[key] = true
          queue.push neighbor

  false

# ===== GOAL SYSTEM =====
create-goal = (start-x, start-y, end-x, end-y, base-turns, rewards, difficulty) ->
  {
    start: {x: start-x, y: start-y}
    end: {x: end-x, y: end-y}
    base-turns: base-turns
    rewards: rewards or []
    difficulty: difficulty or \medium
    difficulty-score: 0
    complete: false
  }

get-network-positions = ->
  positions = []
  for i from 0 to GRID_SIZE * GRID_SIZE - 1
    gx = i % GRID_SIZE
    gy = Math.floor i / GRID_SIZE
    if get-cell gx, gy
      positions.push {x: gx, y: gy}
  positions

get-empty-positions = ->
  positions = []
  for i from 0 to GRID_SIZE * GRID_SIZE - 1
    gx = i % GRID_SIZE
    gy = Math.floor i / GRID_SIZE
    if not get-cell gx, gy
      positions.push {x: gx, y: gy}
  positions

get-network-exits = ->
  exits = []
  for i from 0 to GRID_SIZE * GRID_SIZE - 1
    gx = i % GRID_SIZE
    gy = Math.floor i / GRID_SIZE
    if get-cell gx, gy
      has-empty-neighbor = false
      neighbors = [
        {x: gx + 1, y: gy}
        {x: gx - 1, y: gy}
        {x: gx, y: gy + 1}
        {x: gx, y: gy - 1}
      ]
      for n in neighbors
        if n.x >= 0 and n.x < GRID_SIZE and n.y >= 0 and n.y < GRID_SIZE
          if not get-cell n.x, n.y
            has-empty-neighbor = true
            break
      if has-empty-neighbor
        exits.push {x: gx, y: gy}
  exits

distance-to-exits = (x, y, exits) ->
  if exits.length == 0 then return 0
  min-dist = 999
  for pos in exits
    dist = Math.abs(x - pos.x) + Math.abs(y - pos.y)
    min-dist = Math.min min-dist, dist
  min-dist

calculate-difficulty-score = (goal, exits) ->
  goal-distance = Math.abs(goal.end.x - goal.start.x) + Math.abs(goal.end.y - goal.start.y)
  score = goal-distance * 5

  if exits.length > 0
    start-dist = distance-to-exits goal.start.x, goal.start.y, exits
    end-dist = distance-to-exits goal.end.x, goal.end.y, exits
    score += (start-dist + end-dist) * 3

  Math.min 100, Math.max 0, Math.floor score

generate-goal-with-difficulty = (difficulty) ->
  # TODO: Bug - sometimes goals are generated with start/end on occupied cells
  # This happens even though we filter to empty-positions only. Unclear why.

  empty-positions = get-empty-positions!

  if empty-positions.length < 2
    return null

  exits = get-network-exits!
  max-attempts = 100

  for attempt from 0 to max-attempts - 1
    start-pos = empty-positions[Math.floor Math.random! * empty-positions.length]
    end-pos = empty-positions[Math.floor Math.random! * empty-positions.length]

    if start-pos.x == end-pos.x and start-pos.y == end-pos.y
      continue

    start-occupied = get-cell start-pos.x, start-pos.y
    end-occupied = get-cell end-pos.x, end-pos.y

    if start-occupied or end-occupied
      continue

    goal-distance = Math.abs(end-pos.x - start-pos.x) + Math.abs(end-pos.y - start-pos.y)

    if exits.length == 0
      if difficulty == \easy and goal-distance >= 2 then valid = true
      else if difficulty == \medium and goal-distance >= 4 then valid = true
      else if difficulty == \hard and goal-distance >= 6 then valid = true
      else valid = false
    else
      start-dist = distance-to-exits start-pos.x, start-pos.y, exits
      end-dist = distance-to-exits end-pos.x, end-pos.y, exits
      total-dist = start-dist + end-dist

      if difficulty == \easy
        valid = goal-distance >= 2 and start-dist <= 2 and end-dist <= 2
      else if difficulty == \medium
        valid = goal-distance >= 3 and total-dist >= 2 and total-dist <= 6
      else if difficulty == \hard
        valid = goal-distance >= 4 and total-dist >= 5
      else
        valid = false

    if valid
      base-turns = Math.floor(goal-distance * 1.5) + 3
      if difficulty == \easy then base-turns = Math.floor base-turns * 1.1
      if difficulty == \hard then base-turns = Math.floor base-turns * 1.3

      num-rewards = Math.floor(goal-distance / 2) + 2
      if difficulty == \hard then num-rewards += 1

      rewards = []
      for i from 0 to num-rewards - 1
        r = Math.random!
        if r < 0.5 then rewards.push \straight
        else if r < 0.7 then rewards.push \left-turn
        else if r < 0.85 then rewards.push \right-turn
        else if r < 0.95 then rewards.push \t-junction
        else rewards.push \crossroads

      goal = create-goal start-pos.x, start-pos.y, end-pos.x, end-pos.y, base-turns, rewards, difficulty
      goal.difficulty-score = calculate-difficulty-score goal, exits
      return goal

  null

generate-goal-options = ->
  options = []
  for difficulty in [\easy, \medium, \hard]
    goal = generate-goal-with-difficulty difficulty
    if goal
      options.push goal
    else
      empty-positions = get-empty-positions!
      if empty-positions.length >= 2
        pos1 = empty-positions[0]
        pos2 = empty-positions[empty-positions.length - 1]
        goal = create-goal pos1.x, pos1.y, pos2.x, pos2.y, 15, [\straight, \straight], difficulty
        goal.difficulty-score = 0
        options.push goal
      else
        goal = create-goal 0, 0, 1, 1, 15, [\straight], difficulty
        goal.difficulty-score = 0
        options.push goal
  options

validate-goal = (goal) ->
  find-path goal.start.x, goal.start.y, goal.end.x, goal.end.y

validate-all-goals = ->
  for goal in ingame.completed-goals
    if not validate-goal goal
      return false
  true

check-broken-goals = ->
  # Returns list of goals that are no longer connected
  broken = []
  for goal in ingame.completed-goals
    if not validate-goal goal
      # Check if it's not already in broken list
      already-broken = false
      for b in ingame.broken-goals
        if b.start.x == goal.start.x and b.start.y == goal.start.y and b.end.x == goal.end.x and b.end.y == goal.end.y
          already-broken = true
          break
      if not already-broken
        broken.push goal
  broken

update-broken-goals = ->
  # Check all completed goals and update broken list
  ingame.broken-goals = []
  for goal in ingame.completed-goals
    if not validate-goal goal
      ingame.broken-goals.push goal

# ===== PENALTY SYSTEM =====
generate-penalty-options = ->
  # Generate 2 random penalty options
  options = []
  available = PENALTY_TYPES.slice!
  shuffle-array available
  options.push available[0]
  options.push available[1]
  options

has-penalty = (penalty-id) ->
  for p in ingame.active-penalties
    if p.penalty.id == penalty-id
      return true
  false

apply-penalty = (penalty, broken-goal) ->
  # Apply immediate effects
  if penalty.id == \discard-3
    for i from 0 to 2
      if ingame.deck.length > 0
        idx = Math.floor Math.random! * ingame.deck.length
        ingame.deck.splice idx, 1

  # Add to active penalties (unless it's immediate-only)
  # Track which goal caused this penalty
  if penalty.id != \discard-3
    ingame.active-penalties.push {penalty: penalty, goal: broken-goal}

remove-penalty-for-goal = (goal) ->
  # Remove penalty associated with this specific goal
  for p, i in ingame.active-penalties
    if p.goal.start.x == goal.start.x and p.goal.start.y == goal.start.y and
       p.goal.end.x == goal.end.x and p.goal.end.y == goal.end.y
      ingame.active-penalties.splice i, 1
      return

# ===== BONUS SYSTEM =====
get-bonus-by-rarity = (rarity) ->
  options = [b for b in BONUS_TYPES when b.rarity == rarity]
  if options.length > 0
    options[Math.floor Math.random! * options.length]
  else
    BONUS_TYPES[0]

spawn-bonuses = (count) ->
  empty-positions = get-empty-positions!
  spawned = 0

  for i from 0 to count - 1
    if empty-positions.length == 0
      break

    # Random rarity: 60% common, 30% uncommon, 10% rare
    r = Math.random!
    rarity = if r < 0.6 then \common else if r < 0.9 then \uncommon else \rare

    bonus-type = get-bonus-by-rarity rarity
    pos-idx = Math.floor Math.random! * empty-positions.length
    pos = empty-positions[pos-idx]

    # Make sure this position isn't a goal marker
    is-goal = false
    if ingame.current-goal
      if (pos.x == ingame.current-goal.start.x and pos.y == ingame.current-goal.start.y) or
         (pos.x == ingame.current-goal.end.x and pos.y == ingame.current-goal.end.y)
        is-goal = true

    if not is-goal
      ingame.bonuses.push {x: pos.x, y: pos.y, type: bonus-type, active: true}
      empty-positions.splice pos-idx, 1
      spawned += 1

get-bonus-at = (x, y) ->
  for bonus in ingame.bonuses when bonus.active
    if bonus.x == x and bonus.y == y
      return bonus
  null

activate-bonus = (bonus) ->
  bonus.active = false

  # Apply bonus effect
  switch bonus.type.id
  | \turn-1 => ingame.turns += 1; ingame.turn-breakdown.bonuses += 1
  | \turn-2 => ingame.turns += 2; ingame.turn-breakdown.bonuses += 2
  | \turn-3 => ingame.turns += 3; ingame.turn-breakdown.bonuses += 3
  | \draw-1 =>
    card = draw-from-deck!
    if card then ingame.hand.push card
  | \draw-2 =>
    for i from 0 to 1
      card = draw-from-deck!
      if card then ingame.hand.push card
  | \premium-card =>
    r = Math.random!
    if r < 0.5 then ingame.deck.push \t-junction
    else ingame.deck.push \crossroads
    shuffle-array ingame.deck
  | \wild-card =>
    # TODO: Implement wild card mechanic
    ingame.deck.push \crossroads

# ===== DECK MANAGEMENT =====
shuffle-array = (array) ->
  # Fisher-Yates shuffle
  for i from array.length - 1 to 1 by -1
    j = Math.floor Math.random! * (i + 1)
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
  array

init-deck = ->
  # Create starting deck - use rotation instead of separate card types
  deck = []
  # Straights (use rotation for horizontal)
  for i from 0 to 9
    deck.push \straight
  # Turn cards (left and right are different, but can rotate)
  for i from 0 to 4
    deck.push \left-turn
    deck.push \right-turn
  # T-junctions (use rotation for all 4 orientations)
  for i from 0 to 2
    deck.push \t-junction
  # Crossroads (symmetric, rare)
  deck.push \crossroads

  shuffle-array deck

draw-from-deck = ->
  # Reshuffle discard if deck is empty
  if ingame.deck.length == 0 and ingame.discard.length > 0
    ingame.deck = shuffle-array ingame.discard
    ingame.discard = []

  if ingame.deck.length > 0
    ingame.deck.pop!
  else
    null

fill-hand = (max-size = 5) ->
  while ingame.hand.length < max-size
    card = draw-from-deck!
    if card
      ingame.hand.push card
      ingame.hand-rotations.push 0  # New cards start at 0° rotation
    else
      break

# ===== INITIALIZATION =====
init-grid = ->
  ingame.grid = [null for i from 0 to GRID_SIZE * GRID_SIZE - 1]

init-game = ->
  init-grid!
  ingame.state = \select-goal
  ingame.turns = 0
  ingame.turn-breakdown = {base: 0, bonuses: 0, penalties: 0}
  ingame.completed-goals = []
  ingame.broken-goals = []
  ingame.current-goal = null
  ingame.active-penalties = []
  ingame.bonuses = []

  # Initialize deck
  ingame.deck = init-deck!
  ingame.hand = []
  ingame.hand-rotations = []
  ingame.discard = []
  ingame.selected-card = null
  ingame.selected-rotation = 0

  # Generate goal options
  ingame.goal-options = generate-goal-options!
  ingame.selected-goal = 0

  game.state = \ingame

# ===== UPDATE FUNCTIONS =====
update-menu = ->
  [mx, my, left-click] = mouse!

  # Button bounds (centered "Start" button)
  btn-x = 70
  btn-y = 80
  btn-w = 100
  btn-h = 20

  # Check if mouse is over button and clicked (debounced)
  if left-click and not prev-mouse-state.left and mx >= btn-x and mx < btn-x + btn-w and my >= btn-y and my < btn-y + btn-h
    init-game!

  # Also allow keyboard
  if btnp 4  # Z button
    init-game!

  # Update previous state
  prev-mouse-state.left = left-click

update-ingame = ->
  switch ingame.state
  | \select-goal => update-goal-selection!
  | \playing => update-playing!
  | \goal-complete => update-goal-complete!
  | \penalty-select => update-penalty-select!

update-goal-selection = ->
  [mx, my, left-click] = mouse!

  # Check for mouse hover and click on goal boxes
  for option, i in ingame.goal-options
    x = 10 + i * 75
    y = 30
    w = 70
    h = 60

    # Update selection on hover
    if mx >= x and mx < x + w and my >= y and my < y + h
      ingame.selected-goal = i

      # Click to confirm (debounced)
      if left-click and not prev-mouse-state.left
        selected = ingame.goal-options[ingame.selected-goal]

        # Add reward cards to deck
        for card in selected.rewards
          ingame.deck.push card
        shuffle-array ingame.deck

        # Set current goal and turns
        ingame.current-goal = selected
        ingame.turns = selected.base-turns
        ingame.turn-breakdown.base = selected.base-turns
        ingame.turn-breakdown.bonuses = 0
        ingame.turn-breakdown.penalties = 0

        # Spawn bonuses (2-4 based on difficulty)
        bonus-count = 2
        if selected.difficulty == \medium then bonus-count = 3
        if selected.difficulty == \hard then bonus-count = 4
        spawn-bonuses bonus-count

        # Fill hand and start playing
        fill-hand 5
        ingame.state = \playing
        prev-mouse-state.left = left-click
        return

  # Arrow keys or number keys to select
  if keyp 60  # Left arrow
    ingame.selected-goal = Math.max 0, ingame.selected-goal - 1
  if keyp 61  # Right arrow
    ingame.selected-goal = Math.min 2, ingame.selected-goal + 1

  # Number keys 1-3
  if keyp 28 then ingame.selected-goal = 0  # 1
  if keyp 29 then ingame.selected-goal = 1  # 2
  if keyp 30 then ingame.selected-goal = 2  # 3

  # Confirm selection (Z or Enter)
  if btnp 4 or keyp 50  # Z button or Enter
    selected = ingame.goal-options[ingame.selected-goal]

    # Add reward cards to deck
    for card in selected.rewards
      ingame.deck.push card
    shuffle-array ingame.deck

    # Set current goal and turns
    ingame.current-goal = selected
    ingame.turns = selected.base-turns
    ingame.turn-breakdown.base = selected.base-turns
    ingame.turn-breakdown.bonuses = 0
    ingame.turn-breakdown.penalties = 0

    # Spawn bonuses (2-4 based on difficulty)
    bonus-count = 2
    if selected.difficulty == \medium then bonus-count = 3
    if selected.difficulty == \hard then bonus-count = 4
    spawn-bonuses bonus-count

    # Fill hand and start playing
    fill-hand 5
    ingame.state = \playing

  # Update previous state
  prev-mouse-state.left = left-click

update-playing = ->
  [mx, my, left-click, mid-click, right-click] = mouse!
  btn-a = btn 4  # A button

  # Auto-fill hand (respect penalties)
  max-hand-size = 5
  if has-penalty \small-hand then max-hand-size = 4
  fill-hand max-hand-size

  # Apply time drain penalty
  if has-penalty \time-drain
    ingame.turns -= 1
    ingame.turn-breakdown.penalties -= 1

  # Mouse drag & drop system
  if not ingame.drag.active
    # Check for rotation in hand (right-click OR A button)
    rotate-pressed = (right-click and not ingame.prev-mouse.right) or (btn-a and not ingame.prev-mouse.btn-a)

    if rotate-pressed
      if not has-penalty \locked-rotation
        hand-y = 110
        card-spacing = 24
        hand-start-x = (240 - ingame.hand.length * card-spacing) / 2

        for card, i in ingame.hand
          card-x = hand-start-x + i * card-spacing
          if mx >= card-x and mx < card-x + 20 and my >= hand-y and my < hand-y + 20
            # Rotate this card in hand
            ingame.hand-rotations[i] = (ingame.hand-rotations[i] + 1) % 4
            break

    # Try to start drag from hand
    if left-click
      hand-y = 110
      card-spacing = 24
      hand-start-x = (240 - ingame.hand.length * card-spacing) / 2

      for card, i in ingame.hand
        card-x = hand-start-x + i * card-spacing
        if mx >= card-x and mx < card-x + 20 and my >= hand-y and my < hand-y + 20
          # Check if this card is blocked by penalties
          can-place = true
          if has-penalty \no-straights and card == \straight then can-place = false
          if has-penalty(\no-turns) and (card == \left-turn or card == \right-turn) then can-place = false
          if has-penalty(\no-junctions) and (card == \t-junction or card == \crossroads) then can-place = false

          if can-place
            # Start drag with current rotation from hand
            ingame.drag.active = true
            ingame.drag.card-idx = i
            ingame.drag.card-type = card
            ingame.drag.rotation = ingame.hand-rotations[i]
            ingame.drag.start-x = mx
            ingame.drag.start-y = my
          break
  else
    # Currently dragging
    # Rotate while dragging (right-click OR A button, debounced)
    rotate-pressed = (right-click and not ingame.prev-mouse.right) or (btn-a and not ingame.prev-mouse.btn-a)

    if rotate-pressed
      if not has-penalty \locked-rotation
        ingame.drag.rotation = (ingame.drag.rotation + 1) % 4

    # Release to place
    if not left-click
      cell = screen-to-grid mx, my
      if cell
        is-replacement = not is-cell-empty cell.x, cell.y

        # Check no-replace penalty
        if is-replacement and has-penalty \no-replace
          # Can't place, end drag
          ingame.drag.active = false
          ingame.drag.card-idx = null
          ingame.drag.card-type = null
        else
          turn-cost = if is-replacement then 2 else 1
          if has-penalty \expensive then turn-cost += 1

          # Check if we have enough turns
          if ingame.turns >= turn-cost
            set-cell cell.x, cell.y, ingame.drag.card-type, ingame.drag.rotation
            # Remove card and its rotation from hand
            ingame.hand.splice ingame.drag.card-idx, 1
            ingame.hand-rotations.splice ingame.drag.card-idx, 1
            ingame.turns -= turn-cost

            # Check for bonus at this position
            bonus = get-bonus-at cell.x, cell.y
            if bonus
              activate-bonus bonus

            # Check if current goal is complete
            if ingame.current-goal and validate-goal ingame.current-goal
              ingame.current-goal.complete = true
              ingame.state = \goal-complete
            else
              # Check if any previously broken goals are now fixed
              for broken-goal in ingame.broken-goals.slice!  # Use slice to avoid mutation issues
                if validate-goal broken-goal
                  # Goal is now fixed! Remove its penalty
                  remove-penalty-for-goal broken-goal
                  # Remove from broken list
                  for g, idx in ingame.broken-goals
                    if g.start.x == broken-goal.start.x and g.start.y == broken-goal.start.y and
                       g.end.x == broken-goal.end.x and g.end.y == broken-goal.end.y
                      ingame.broken-goals.splice idx, 1
                      break

              # Check if any previous goals broke
              newly-broken = check-broken-goals!
              if newly-broken.length > 0
                # Generate penalty options for the FIRST newly broken goal
                # (if multiple break at once, only penalize for the first one)
                ingame.penalty-options = generate-penalty-options!
                ingame.selected-penalty = 0
                ingame.state = \penalty-select

      # End drag (whether placed or not)
      if ingame.state == \playing  # Only clear if we haven't transitioned states
        ingame.drag.active = false
        ingame.drag.card-idx = null
        ingame.drag.card-type = null

  # Update previous mouse state
  ingame.prev-mouse.left = left-click
  ingame.prev-mouse.right = right-click
  ingame.prev-mouse.btn-a = btn-a

  # Temp: press X to add turns
  if keyp 51  # X key
    ingame.turns += 5

  # Check for game over (but only if goal isn't complete)
  if ingame.turns <= 0
    # Give one last check - did they complete the goal on the final turn?
    if not (ingame.current-goal and validate-goal ingame.current-goal)
      game.state = \gameover

update-goal-complete = ->
  [mx, my, left-click] = mouse!

  # Click anywhere or press button to continue (debounced)
  if (left-click and not prev-mouse-state.left) or btnp 4
    # Mark goal as completed and add to history
    game.goals-completed += 1
    ingame.completed-goals.push ingame.current-goal

    # Generate new goal options
    ingame.goal-options = generate-goal-options!
    ingame.selected-goal = 0
    ingame.current-goal = null

    # Go to goal selection
    ingame.state = \select-goal

  # Update previous state
  prev-mouse-state.left = left-click

update-penalty-select = ->
  [mx, my, left-click] = mouse!

  # Update broken goals list
  update-broken-goals!

  # Check for mouse click on penalty options
  for option, i in ingame.penalty-options
    x = 40 + i * 80
    y = 50
    w = 70
    h = 70

    # Update selection on hover
    if mx >= x and mx < x + w and my >= y and my < y + h
      ingame.selected-penalty = i

      # Click to confirm (debounced)
      if left-click and not prev-mouse-state.left
        selected = ingame.penalty-options[ingame.selected-penalty]
        # Apply penalty to the first broken goal
        broken-goal = ingame.broken-goals[0]
        apply-penalty selected, broken-goal
        ingame.state = \playing
        prev-mouse-state.left = left-click
        return

  # Keyboard selection (1-2)
  if keyp 28 then ingame.selected-penalty = 0  # 1
  if keyp 29 then ingame.selected-penalty = 1  # 2

  # Confirm with Z or Enter
  if btnp 4 or keyp 50
    selected = ingame.penalty-options[ingame.selected-penalty]
    # Apply penalty to the first broken goal
    broken-goal = ingame.broken-goals[0]
    apply-penalty selected, broken-goal
    ingame.state = \playing

  # Update previous state
  prev-mouse-state.left = left-click

update-gameover = ->
  [mx, my, left-click] = mouse!

  if (left-click and not prev-mouse-state.left) or btnp 4
    game.state = \menu

  # Update previous state
  prev-mouse-state.left = left-click

# ===== DRAW FUNCTIONS =====
draw-menu = ->
  [mx, my] = mouse!
  cls 0

  print "TRAFFIC", 90, 60, 15, false, 2

  # Draw clickable start button
  btn-x = 70
  btn-y = 80
  btn-w = 100
  btn-h = 20

  # Check if mouse is hovering
  is-hover = mx >= btn-x and mx < btn-x + btn-w and my >= btn-y and my < btn-y + btn-h

  # Button background
  if is-hover
    rect btn-x, btn-y, btn-w, btn-h, 12  # Blue highlight
  else
    rect btn-x, btn-y, btn-w, btn-h, 1

  rectb btn-x, btn-y, btn-w, btn-h, if is-hover then 11 else 15

  # Button text (centered)
  print "START", btn-x + 30, btn-y + 6, if is-hover then 0 else 15

draw-ingame = ->
  cls 0

  draw-grid!
  draw-turn-panel!
  draw-deck-info!

  switch ingame.state
  | \select-goal => draw-goal-options!
  | \playing => draw-hand!; draw-active-penalties!
  | \goal-complete => draw-completion-overlay!
  | \penalty-select => draw-penalty-options!

draw-grid = ->
  [mx, my] = mouse!
  hover-cell = screen-to-grid mx, my

  # Draw grid background and cards
  for i from 0 to GRID_SIZE * GRID_SIZE - 1
    gx = i % GRID_SIZE
    gy = Math.floor i / GRID_SIZE
    x = GRID_X + gx * TILE_SIZE
    y = GRID_Y + gy * TILE_SIZE

    # Grid cell border (highlight hovered cell when dragging)
    is-hovered = hover-cell and hover-cell.x == gx and hover-cell.y == gy
    border-color = if is-hovered and ingame.drag.active then 12 else 13
    rectb x, y, TILE_SIZE, TILE_SIZE, border-color

    # Draw bonuses (under cards) - static, no pulse
    bonus = get-bonus-at gx, gy
    if bonus
      bonus-color = bonus.type.color
      # Static square, centered on tile (slightly larger)
      bonus-size = 9
      tile-center-x = x + 6  # TILE_SIZE / 2 = 12 / 2 = 6
      tile-center-y = y + 6
      bonus-x = Math.floor(tile-center-x - bonus-size / 2)
      bonus-y = Math.floor(tile-center-y - bonus-size / 2)
      rect bonus-x, bonus-y, bonus-size, bonus-size, bonus-color

      # Draw icon in center
      draw-bonus-icon bonus.type.id, tile-center-x, tile-center-y

    # Draw card if present (skip if dragging over this cell)
    should-draw = true
    if ingame.drag.active and hover-cell and gx == hover-cell.x and gy == hover-cell.y
      should-draw = false

    if should-draw
      cell = get-cell gx, gy
      if cell
        # Check if this tile is on a goal position
        is-on-goal = false
        goal-tint = 1  # Default dark background

        # Check current goal
        if ingame.current-goal
          if (gx == ingame.current-goal.start.x and gy == ingame.current-goal.start.y) or
             (gx == ingame.current-goal.end.x and gy == ingame.current-goal.end.y)
            is-on-goal = true
            goal-tint = 3  # Dark green tint for current goal

        # Check completed goals
        if not is-on-goal
          for goal in ingame.completed-goals
            if (gx == goal.start.x and gy == goal.start.y) or
               (gx == goal.end.x and gy == goal.end.y)
              is-on-goal = true
              # Check if broken
              is-broken = false
              for broken in ingame.broken-goals
                if broken.start.x == goal.start.x and broken.start.y == goal.start.y and
                   broken.end.x == goal.end.x and broken.end.y == goal.end.y
                  is-broken = true
                  break
              goal-tint = if is-broken then 2 else 3  # Dark red if broken, dark green if ok
              break

        rect x + 1, y + 1, TILE_SIZE - 2, TILE_SIZE - 2, goal-tint
        draw-road-tile cell.type, x, y, TILE_SIZE, cell.rotation

  # Show drag preview on hovered cell
  if hover-cell and ingame.drag.active
    is-replacement = not is-cell-empty hover-cell.x, hover-cell.y
    turn-cost = if is-replacement then 2 else 1
    can-afford = ingame.turns >= turn-cost

    x = GRID_X + hover-cell.x * TILE_SIZE
    y = GRID_Y + hover-cell.y * TILE_SIZE

    # Preview card with transparency (use bright color to indicate preview)
    preview-color = if can-afford then 12 else 8  # Blue or red
    rect x + 1, y + 1, TILE_SIZE - 2, TILE_SIZE - 2, preview-color
    draw-road-tile ingame.drag.card-type, x, y, TILE_SIZE, ingame.drag.rotation

    # Show cost
    cost-color = if can-afford then 10 else 8  # Yellow or red
    print "#{turn-cost}", x + 4, y + 4, cost-color

  # Draw ALL goal markers ON TOP of everything with pulse animation
  # Pulse effect for animation (slower than bonuses)
  pulse = Math.sin(game.timer * 0.05) * 0.5 + 0.5  # 0 to 1, much slower pulse
  base-marker-radius = 3  # Base radius for circles
  pulse-amount = Math.floor(pulse * 2) - 1  # Oscillate between -1 and +1 pixels
  marker-radius = base-marker-radius + pulse-amount
  dot-radius = 1 + Math.floor(pulse * 1)  # Dot also pulses slightly
  offset-x = 2
  offset-y = 2

  # Helper wrapper to draw a corner marker at grid coordinates (only if no tile present)
  draw-marker-at = (gx, gy, is-start, marker-color, marker-bg) ->
    # Only draw marker if there's no tile on this position
    if not get-cell gx, gy
      x = GRID_X + gx * TILE_SIZE
      y = GRID_Y + gy * TILE_SIZE
      draw-goal-marker x, y, marker-radius, dot-radius, offset-x, offset-y, is-start, marker-color, marker-bg

  # Draw current goal markers (bright colors for active goal)
  if ingame.current-goal
    draw-marker-at ingame.current-goal.start.x, ingame.current-goal.start.y, true, 11, 3  # Bright green
    draw-marker-at ingame.current-goal.end.x, ingame.current-goal.end.y, false, 8, 2  # Bright red

  # Draw completed goal markers
  for goal in ingame.completed-goals
    # Check if this goal is broken
    is-broken = false
    for broken in ingame.broken-goals
      if broken.start.x == goal.start.x and broken.start.y == goal.start.y and
         broken.end.x == goal.end.x and broken.end.y == goal.end.y
        is-broken = true
        break

    marker-color = if is-broken then 8 else 11  # Red if broken, bright green if connected
    marker-bg = if is-broken then 2 else 3  # Dark red or dark green background

    draw-marker-at goal.start.x, goal.start.y, true, marker-color, marker-bg
    draw-marker-at goal.end.x, goal.end.y, false, marker-color, marker-bg

draw-turn-panel = ->
  # Right side with large turn display (with 4px margin from grid)
  x = 168 + 4  # Add 4px margin from grid edge
  y = 8

  # Label (small)
  print "TURNS", x, y, 13
  y += 8

  # Turns number (REALLY BIG - scale 3)
  turn-color = 12  # Blue
  if ingame.turns <= 3
    turn-color = 8  # Red warning
  else if ingame.turns <= 6
    turn-color = 9  # Orange warning

  print "#{ingame.turns}", x, y, turn-color, false, 3
  y += 24  # Space for the big number

  # Breakdown (smaller, if not first goal)
  if ingame.completed-goals.length > 0 or ingame.current-goal
    print "Base: #{ingame.turn-breakdown.base}", x, y, 13
    y += 6
    if ingame.turn-breakdown.bonuses > 0
      print "Bonus: +#{ingame.turn-breakdown.bonuses}", x, y, 10
      y += 6
    if ingame.turn-breakdown.penalties < 0
      print "Penalty: #{ingame.turn-breakdown.penalties}", x, y, 8
      y += 6

draw-deck-info = ->
  # Count cards by type in deck
  counts = {}
  for card in ingame.deck
    counts[card] = (counts[card] or 0) + 1

  # Display at top-left
  y = 8
  print "DECK:", 8, y, 13
  y += 8

  # Show each card type with icon
  card-size = 12
  x-icon = 8
  x-count = x-icon + card-size + 4

  if counts[\straight]
    rectb x-icon, y, card-size, card-size, 13
    draw-road-tile \straight, x-icon, y, card-size, 0
    print "x#{counts[\straight]}", x-count, y + 3, 15
    y += card-size + 2

  if counts[\left-turn]
    rectb x-icon, y, card-size, card-size, 13
    draw-road-tile \left-turn, x-icon, y, card-size, 0
    print "x#{counts[\left-turn]}", x-count, y + 3, 15
    y += card-size + 2

  if counts[\right-turn]
    rectb x-icon, y, card-size, card-size, 13
    draw-road-tile \right-turn, x-icon, y, card-size, 0
    print "x#{counts[\right-turn]}", x-count, y + 3, 15
    y += card-size + 2

  if counts[\t-junction]
    rectb x-icon, y, card-size, card-size, 13
    draw-road-tile \t-junction, x-icon, y, card-size, 0
    print "x#{counts[\t-junction]}", x-count, y + 3, 15
    y += card-size + 2

  if counts[\crossroads]
    rectb x-icon, y, card-size, card-size, 13
    draw-road-tile \crossroads, x-icon, y, card-size, 0
    print "x#{counts[\crossroads]}", x-count, y + 3, 15
    y += card-size + 2

  # Show total
  y += 2
  print "Total: #{ingame.deck.length}", 8, y, 12

draw-hand = ->
  # Draw hand at bottom of screen
  hand-y = 110
  card-spacing = 24
  hand-start-x = (240 - ingame.hand.length * card-spacing) / 2

  [mx, my] = mouse!

  for card, i in ingame.hand
    # Skip drawing if this card is being dragged
    if ingame.drag.active and i == ingame.drag.card-idx
      continue

    card-x = hand-start-x + i * card-spacing

    # Check if card is blocked by penalty
    is-blocked = false
    if has-penalty \no-straights and card == \straight then is-blocked = true
    if has-penalty(\no-turns) and (card == \left-turn or card == \right-turn) then is-blocked = true
    if has-penalty(\no-junctions) and (card == \t-junction or card == \crossroads) then is-blocked = true

    # Highlight on hover
    is-hover = mx >= card-x and mx < card-x + 20 and my >= hand-y and my < hand-y + 20

    # Card background
    if is-blocked
      rect card-x, hand-y, 20, 20, 0  # Dark/disabled
    else if is-hover
      rect card-x, hand-y, 20, 20, 13  # Light highlight
    else
      rect card-x, hand-y, 20, 20, 1

    rectb card-x, hand-y, 20, 20, if is-blocked then 8 else if is-hover then 12 else 15

    # Draw card preview with current rotation
    card-rotation = ingame.hand-rotations[i] or 0
    draw-road-tile card, card-x, hand-y, 20, card-rotation

  # Draw dragged card following mouse (13x13 - slightly bigger than tiles)
  if ingame.drag.active
    drag-size = 13
    drag-x = mx - drag-size / 2
    drag-y = my - drag-size / 2

    # Card background (bright to show it's being dragged)
    rect drag-x, drag-y, drag-size, drag-size, 14  # Pink/bright
    rectb drag-x, drag-y, drag-size, drag-size, 15

    # Draw card with current rotation
    draw-road-tile ingame.drag.card-type, drag-x, drag-y, drag-size, ingame.drag.rotation

    # Show placement cost next to cursor (so it's not covered by dragged card)
    hover-cell = screen-to-grid mx, my
    if hover-cell
      is-replacement = not is-cell-empty hover-cell.x, hover-cell.y
      turn-cost = if is-replacement then 2 else 1
      if has-penalty \expensive then turn-cost += 1
      can-afford = ingame.turns >= turn-cost
      cost-color = if can-afford then 10 else 8  # Yellow or red

      # Draw cost to the right of the cursor
      print "#{turn-cost}", mx + 10, my - 4, cost-color

draw-active-penalties = ->
  # Draw penalty banner at bottom (if any active)
  if ingame.active-penalties.length > 0
    # Red banner
    rect 0, 132, 240, 4, 2

    # Show first 3 penalties (should fit)
    x = 2
    for p, i in ingame.active-penalties
      if i >= 3 then break
      print p.penalty.name, x, 133, 8
      x += p.penalty.name.length * 6 + 8

draw-goal-options = ->
  cls 0
  print "SELECT GOAL", 85, 5, 12

  # Draw 3 goal options side by side
  for option, i in ingame.goal-options
    is-selected = i == ingame.selected-goal
    x = 10 + i * 75
    y = 30

    # Box
    color = if is-selected then 11 else 13
    rectb x, y, 70, 60, color
    if is-selected
      rect x + 1, y + 1, 68, 58, 1

    # Difficulty label with color
    diff-label = "Easy"
    diff-color = 11  # Green
    if option.difficulty == \medium
      diff-label = "Medium"
      diff-color = 10  # Yellow
    else if option.difficulty == \hard
      diff-label = "Hard"
      diff-color = 8   # Red

    print diff-label, x + 5, y + 5, diff-color
    print "Turns: #{option.base-turns}", x + 5, y + 15, 10
    print "Rewards:", x + 5, y + 25, 14
    print "+#{option.rewards.length} cards", x + 5, y + 35, 14

  print "Click to select and confirm", 50, 115, 15

draw-completion-overlay = ->
  print "GOAL COMPLETE!", 70, 105, 11
  print "Click to continue", 70, 118, 13

draw-penalty-options = ->
  cls 0
  print "GOAL BROKEN!", 75, 10, 8, false, 1
  print "Choose a penalty:", 65, 22, 13

  # Draw 2 penalty options
  for option, i in ingame.penalty-options
    is-selected = i == ingame.selected-penalty
    x = 40 + i * 80
    y = 50

    # Box
    color = if is-selected then 8 else 13
    rectb x, y, 70, 70, color
    if is-selected
      rect x + 1, y + 1, 68, 68, 1

    # Penalty info
    print option.name, x + 5, y + 10, if is-selected then 8 else 15

    # Description (wrapped)
    desc-words = option.desc.split ' '
    line = ""
    line-y = y + 25
    for word in desc-words
      test = if line then "#{line} #{word}" else word
      if test.length > 10
        print line, x + 5, line-y, 13
        line-y += 8
        line = word
      else
        line = test
    if line
      print line, x + 5, line-y, 13

    # Number indicator
    print "#{i + 1}", x + 5, y + 5, if is-selected then 8 else 13

  print "Click or press 1-2 to select", 40, 125, 15

draw-gameover = ->
  cls 0
  print "GAME OVER", 80, 50, 8
  print "Goals: #{game.goals-completed}", 75, 65, 12
  print "Score: #{game.score}", 75, 75, 12
  print "Click to continue", 70, 90, 13

# ===== MAIN LOOP =====
export TIC = ->
  game.timer += 1

  switch game.state
  | \menu => update-menu!; draw-menu!
  | \ingame => update-ingame!; draw-ingame!
  | \gameover => update-gameover!; draw-gameover!
