#🎈 Ping Pong Game (x86 Assembly – DOSBox / NASM)

## Overview
This project is a two-player Ping Pong game developed in 16-bit x86 Assembly language using NASM and executed in DOSBox. The game uses BIOS interrupts and video memory (0xB800) to render graphics directly on the screen. It includes paddle control, ball physics, collision detection, scoring system, and game restart/exit functionality.

## Features

### 1. Screen Rendering
- Direct video memory manipulation (text mode 80x25).
- Custom screen clearing and coloring routines.
- Wall rendering at top and bottom of the screen using character-based graphics.
- Real-time drawing of paddles and ball.

### 2. Player Controls
- **Player 1 (Right Paddle):**
  - Move Up: 'W'
  - Move Down: 'S'
- **Player 2 (Left Paddle):**
  - Move Up: Up Arrow Key
  - Move Down: Down Arrow Key
- Input handled using BIOS keyboard interrupt (INT 16h).

### 3. Paddle System
- Each paddle is 3 characters tall (| representation).
- Paddle movement is restricted within screen boundaries (25-row limit).
- Smooth vertical movement with real-time updates.

### 4. Ball Movement & Physics
- Ball starts near the center of the screen.
- Moves in straight and diagonal directions.
- Direction changes based on collision with:
  - Top/bottom walls
  - Left/right paddles
- Movement is updated using position arithmetic on video memory.

### 5. Collision Detection
- Detects collision with paddles (Player 1 and Player 2).
- Detects boundary crossing for game over condition.
- Adjusts ball direction after each valid hit.

### 6. Scoring System
- Each player earns a point when the opponent misses the ball.
- Score is displayed on the screen.
- Scores are updated dynamically during gameplay.

### 7. Win Condition
- First player to reach **5 points** wins the game.
- Displays:
  - Player 1 Wins / Player 2 Wins / Tie message
- Game ends when win condition is met.

### 8. Game Over & Restart System
- After game ends, user is prompted to:
  - Press **R** to restart the game
  - Press **Q** to quit
- Restart resets all game variables and restarts execution.

### 9. Game Flow
- Welcome screen with instructions.
- Wait for Enter key to start.
- Main gameplay loop handles:
  - Paddle movement
  - Ball movement
  - Collision detection
  - Score updates
- End screen displays result and restart/exit options.

## Technical Details
- Language: x86 Assembly (NASM syntax)
- Platform: DOSBox (16-bit real mode)
- Graphics: Text mode video memory (0xB800)
- Input: BIOS Interrupt 16h
- Output: BIOS Interrupt 10h + direct memory writes

## Controls Summary
- W / S → Move Player 1 paddle
- ↑ / ↓ → Move Player 2 paddle
- R → Restart game
- Q → Quit game

## Conclusion
This project demonstrates low-level system programming concepts including memory-mapped I/O, interrupt handling, real-time input processing, and basic game physics in assembly language.
