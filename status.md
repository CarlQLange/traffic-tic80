# Traffic - Development Status

## Implemented Features ✓

### Core Systems
- **Three-level state machine**: Menu → In-game (goal selection, playing, goal complete, penalty select) → Game over
- **Card system**: 5 base card types (straight, left-turn, right-turn, t-junction, crossroads) with full rotation support (0°/90°/180°/270°)
- **Grid system**: 8x8 grid with 12x12px tiles, centered display
- **Custom pixel art**: All cards have 12x12 visual representations that scale to different sizes
- **Drag & drop**: Mouse-based card placement with right-click rotation

### Pathfinding & Goals
- **BFS pathfinding**: Validates road connections with proper N/E/S/W connection matching
- **Goal generation**: Random start/end positions with difficulty-based distance requirements
- **Goal selection**: Choose 1 of 3 random goals with displayed info (difficulty score, distance, turns, rewards)
- **Goal rewards**: 2-5 cards based on difficulty, added to deck on selection
- **Dynamic difficulty**: Base turns calculated from distance (~1.5 turns per tile + buffer)
- **Multi-goal constraint**: ALL previous goals must remain connected after each placement
- **Broken goal detection**: Detects when old goals break and triggers penalty selection
- **Visual validation**: Goal markers tinted green (connected) or red (broken)

### Turn Economy
- **Placement cost**: 1 turn for empty tiles, 2 for replacements
- **Penalty modifiers**: +1 turn cost penalty, no-replace penalty
- **Visual feedback**: Hover highlights with turn cost (respects penalties)
- **Turn breakdown panel**: Shows Base + Bonuses + Penalties = Total
- **Bonus turn tracking**: Accumulated from bonus tiles

### Penalty System ✓
- **10 penalty types**: Small hand, no straights, no turns, no junctions, expensive, no replace, slow draw, discard 3, time drain, locked rotation
- **Penalty selection**: Choose 1 of 2 random penalties when goals break
- **Active penalties display**: Red banner at bottom showing active penalties
- **Penalty mechanics**: Fully integrated into gameplay (card blocking, turn costs, hand size, etc.)
- **Visual feedback**: Blocked cards grayed out in hand

### Bonus Tiles ✓
- **7 bonus types**: +1/+2/+3 turns, draw +1/+2, premium card, wild card
- **Rarity system**: Common (60%), uncommon (30%), rare (10%)
- **Spawn system**: 2-4 bonuses per goal based on difficulty
- **Activation**: Trigger when road placed on bonus tile
- **Visual indication**: Colored squares on grid (yellow for turns, blue for cards, etc.)

### Deck & Hand Management
- **Starting deck**: 10 straights, 10 turns, 3 t-junctions, 1 crossroads
- **Shuffle system**: Fisher-Yates shuffle with automatic reshuffle when deck empty
- **Hand display**: 5 cards (or 4 with small-hand penalty) with visual previews
- **Penalty-aware drawing**: Respects small-hand and slow-draw penalties
- **Deck visualization**: Top-left panel shows card type counts with icons

### UI/UX
- **Drag & drop**: Pick card from hand, drag to grid, right-click to rotate
- **Grid hover highlighting**: Blue border when dragging
- **Goal markers**: Green (current start), red (current end), dark green/red (completed goals by status)
- **Deck composition display**: Visual card icons with counts
- **Penalty UI**: Selection screen + active penalty banner
- **Turn breakdown**: Clear display of turn sources

## TODO - Priority 2 (Strategic Depth) ✓

### Enhancements
- [x] Remove penalties when broken goals are re-established
- [x] Better bonus visual effects (pulse animation)
- [x] Bonus tile icons/symbols (clock for turns, cards for draw, star for premium, ? for wild)

## TODO - Priority 3 (Polish)

### Polish & Flow
- [ ] Better goal completion screen (show rewards earned)
- [ ] Proper game over screen (remove score, show goals completed)
- [ ] Retry flow from game over (reset properly)
- [ ] Fix goal generation bug (sometimes places on occupied cells)
- [ ] Better goal markers (less intrusive, maybe icons)
- [ ] Card tooltips/descriptions
- [ ] Difficulty labels on goal selection (Easy/Medium/Hard instead of score)

## TODO - Priority 4 (Juice 🧃)

### Visual Effects
- [ ] Little cars driving on completed roads
- [ ] Screen shake on card placement
- [ ] Particles when goals complete
- [ ] Particles when bonuses activate
- [ ] Squash/stretch animation on card drop
- [ ] Trail effect for moving cars
- [ ] Sound effects (placement, rotation, completion, bonus, penalty)

## Architecture Notes

### File Structure
```
src/
├── cards.ls          # Card definitions, pixel art, rotation logic
└── traffic.ls        # Main game logic, state machines, rendering
```

### Key Design Decisions
- **Rotation instead of variants**: Use single base cards + rotation rather than separate card types for each orientation
- **Icon-based UI**: Due to 240x136 resolution constraint, minimize text and use visual card representations
- **Separable systems**: Modular update/draw functions for easy feature iteration
- **Feature flags ready**: Easy to toggle systems on/off for testing

## Current Game Flow

1. **Menu** → Press Z to start
2. **Goal Selection** → Choose 1 of 3 goals (1-3 or arrows + Z)
3. **Playing**:
   - Select card (1-5)
   - Rotate if needed (R)
   - Click grid to place (1 or 2 turns)
   - Goal complete → Next goal selection
   - Turns reach 0 → Game over
4. **Game Over** → Press Z to return to menu

## Known Issues

None currently - all core features working as expected.

## Next Steps

Recommended implementation order:
1. **Multi-goal constraint** - This is the core challenge mechanic
2. **Penalty system** - Follows naturally from multi-goal
3. **Turn breakdown panel** - QoL for understanding turn economy
4. **Bonus tiles** - Adds strategic depth
5. **Polish pass** - Better screens, score, retry flow