# LÖVE Platformer Game

A 2D platformer game built with LÖVE (Love2D), featuring multiple levels, animated characters, enemies, and a persistent game state system.

![LÖVE Platformer Game](sprites/background.png)

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [How to Play](#how-to-play)
- [Controls](#controls)
- [Dependencies](#dependencies)
- [Development](#development)

## Features

- Smooth character movement and animations
- Multiple levels with checkpoint system
- Enemies with patrolling behavior
- Physics-based interactions
- Persistent game data saving
- Beautiful background and sprite artwork
- Custom sound effects and background music

## Prerequisites

- [LÖVE](https://love2d.org/) (version 11.3 or newer recommended)

## Installation

1. Clone this repository or download it as a ZIP file:

```bash
git clone https://github.com/yourusername/love-platformer.git
```

2. Navigate to the project directory:

```bash
cd love-platformer
```

3. Run the game using LÖVE:

```bash
love .
```

Alternatively, you can drag the project folder onto the LÖVE application icon.

## How to Play

Navigate through the platformer levels, avoid enemies, and reach the flag to progress to the next level. If you touch an enemy or fall into a danger zone, you'll respawn at the starting point of the current level.

## Controls

- **Left Arrow**: Move character left
- **Right Arrow**: Move character right
- **Up Arrow**: Jump

## Dependencies

This game uses several excellent libraries:

- [STI (Simple Tiled Implementation)](https://github.com/karai17/Simple-Tiled-Implementation) - For loading and rendering Tiled maps
- [anim8](https://github.com/kikito/anim8) - For sprite animations
- [Windfield](https://github.com/adnzzzzZ/windfield) - For physics and collision detection
- [HUMP](https://github.com/vrld/hump) - For camera functionality

All dependencies are included in the repository under the `libraries/` directory.

## Development

The game was developed using the LÖVE framework, which is a 2D game development framework for Lua. The level design was done using the [Tiled Map Editor](https://www.mapeditor.org/).
