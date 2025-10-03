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
