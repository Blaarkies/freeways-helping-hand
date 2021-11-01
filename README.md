# Freeways-helping-hand

### Autohotkey script that draws Bezier Curves (quad/cubic)

Checkout [Freeways](https://captaingames.itch.io/freeways), a game where you build roads, interchanges, and freeways by drawing on screen.

This tool helps to draw smooth curves or very straight lines.

###### 4 Checkpoints can draw complex curves
![A relay network](./storage/4-checkpoints.jpg?raw=true "A Cubic Bezier Curve")

## Steps to install
1. Download the `.ahk` files from the repo
2. Download and install [AutoHotkey](https://www.autohotkey.com/)
3. Double-click / run `freeways-helping-hand.ahk`

## How to use
### Draw a straight line
1. Move the mouse cursor to the left of the screen
2. Then press `e`, to add a checkpoint
3. Move the mouse to the right of the screen
4. Then press `e`, to add another checkpoint
   1. An overlay will appear on screen, showing the intended drawing path 
5. Now press `f` to draw
   1. The mouse cursor will move by itself along a straight line between those 2 checkpoints

###### 2 Checkpoints draw a straight line
![A relay network](./storage/2-checkpoints.jpg?raw=true "A line")

### Draw a curve
Follow the same steps as drawing a line, but keep adding more checkpoints

###### 3 Checkpoints draw a curve
![A relay network](./storage/3-checkpoints.jpg?raw=true "A Quadratic Bezier Curve")

### Draw a better curve
The Cubic Bezier Curve provides more control over the start and end sections. This allows you to draw S-curves.

### More control

| Key | Result |
| --- | ----------- |
| `ctrl+Q` | Quit the hotkey app. This will stop keys being "stuck" |
| `W` | Draw while pressed. Press and hold `W`, then release to stop drawing. A short single press of `W` will continue the drawing by 1 step. Continue tapping `W` to slowly draw. |
| `F` | Draw until completion |
| `E` | Add a checkpoint at mouse cursor location |
| `R` | Reset list of checkpoints. Use this if you did not complete the previous drawing |
| `S` | Set bridge-level adjustment. When using bridges in Freeways, the game will force a short section of road forwards (beyond where the script has drawn thus far). *Compensate for that difference with this hotkey everytime you click on the bridge up/down button.* |
| `1 - 4` | Reposition specific checkpoint. |

