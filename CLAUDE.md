# Traffic - Road Card Deck-Builder

## Game Concept

A deck-builder game where each "card" is a piece of road (similar to Carcassonne). Players complete increasingly difficult connection goals on a constrained grid, managing turn economy and deck composition.

## Core Loop

1. **Choose a goal** (first turn: pick 1 of 3 options)
2. **Place road cards** from your hand onto the 8x8 grid
3. **Complete the connection** (e.g., "connect house to school")
4. **Receive rewards**: cards added to deck, new bonuses spawn
5. **Choose next goal** - must work around existing roads
6. **Repeat** until you run out of turns

## Grid & Layout

### Game Area (Top Half)
- **8x8 grid** @ **12x12 pixels per tile** = 96x96 game area
- Centered in top portion of screen
- Contains:
  - Goal start/end markers
  - Bonus tiles (sparse, random placement)
  - Placed road cards

### Hand Display (Bottom)
- **5 card slots** displayed as icons (20x24px each)
- Icon-based with description panel (space-constrained UI)
- Click card → click grid to place

### Turn Breakdown (Right Side)
```
TURNS: 12
─────────
Base: 8
Goal bonus: +3
Route bonuses: +4
Penalties: -3
```
Clear breakdown showing why you have X turns available.

## Card Types

Road pieces with different connection patterns:
- **Straight** - Two opposite connections
- **Left Turn** - 90° bend
- **Right Turn** - 90° bend
- **T-Junction** - Three connections
- **Crossroads** - Four connections

Each card can be rotated when placed (implement later).

## Turn Economy

### Turn Costs
- **Place card on empty tile**: 1 turn
- **Replace existing tile**: 2 turns
- **Draw cards**: Free (automatic at start of turn, up to 5)

### Turn Sources
- **Base turns**: Provided by the goal (varies by difficulty)
- **Bonus tiles**: +1-3 turns when routed through
- **Goal completion bonuses**: May award extra turns for next goal

### Game Over
Game ends when **turns reach 0** before completing the current goal.

## Goal System

### Goal Selection
- **First turn**: Choose 1 of 3 randomly generated goals
- **After completion**: Choose 1 of 3 new goals
- Goals typically: "Connect point A to point B"
  - Thematic flavor (house→school, store→park, etc.) for later polish
- Choosing a goal **adds X cards to your deck** (better than starting cards)

### Goal Validation
- Checked via **pathfinding** (BFS) each turn
- Must have continuous road connection from start to end
- All **previous goals must remain solved**

### Breaking Old Goals
If a previous goal connection is broken:
1. Present **2 random penalty options**:
   - "No left turns" (can't place left turn cards)
   - "One less card in hand" (draw only 4 cards)
   - "No replacements" (can't replace existing tiles)
   - "+1 turn cost for placements"
   - Other penalties (pool of ~10 total)
2. Player chooses which penalty to accept
3. Penalty remains **until goal is re-established**
4. Multiple broken goals = multiple active penalties

### Multi-Goal Constraint
This is the **core challenge**: each new goal must be solved while maintaining all previous connections. Late-game boards become increasingly constrained.

## Bonuses

### Bonus Tiles
- Spawn randomly on grid (sparse)
- **Activated** when a road is routed through that tile
- Effects:
  - **Extra turns**: +1 to +3 turns
  - **Card draw**: Draw 1-2 extra cards this turn
  - **Deck upgrade**: Add premium card to deck
  - **Time extension**: +X turns for next goal

### Goal Completion Bonuses
- **Cards added to deck** (goal-specific rewards)
- May include **turn bonuses** for the next goal
- New bonus tiles spawn for subsequent goals

## Deck Building

### Starting Deck
- Mostly basic cards (straights, simple turns)
- ~15-20 cards total

### Deck Improvement
- **Goal selection** adds themed cards to deck
- **Bonus tiles** may add premium cards
- No card removal mechanic (for now)

### Draw Mechanic
- Draw up to **5 cards** at start of each turn (or 4 if penalty active)
- Deck reshuffles when empty
- Discard pile reshuffled into deck

## Win Condition

There is no explicit "win" - the goal is to **survive as many rounds as possible** and achieve the highest score.

### Expected Endgame
- By goal 5-6, the board is heavily constrained
- Replacing tiles becomes common (2 turn cost)
- Multiple bonuses accumulated to extend turns
- **Grid lockout** is the expected failure mode - when it becomes impossible to route new goals given existing constraints

## Technical Notes

### Pathfinding
- Use **BFS** to validate connections
- Check from goal start → goal end
- Roads must form continuous path (tile connections match)

### Road Connection Logic
Each tile has 4 possible connection points (N, E, S, W). A valid path requires:
- Adjacent tiles have matching connections (e.g., tile A's East connects to tile B's West)
- Continuous path from start to end

### Tile Rotation
- Each card type can be placed in 4 rotations (0°, 90°, 180°, 270°)