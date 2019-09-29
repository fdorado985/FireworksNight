# Fireworks Night
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![IDE: Xcode](https://img.shields.io/badge/IDE-Xcode%2011-blue.svg)](https://developer.apple.com/xcode/)
[![Language: Swift](https://img.shields.io/badge/Language-Swift-red.svg)](https://swift.org/blog/)
[![Game Technology: SpriteKit](https://img.shields.io/badge/Game%20Technology-SpriteKit-purple)](https://developer.apple.com/spritekit/)

## Description
Create fireworks displays using your fingers, touch the fireworks of the same color, shake the device and see them explode.

## Demo
### feature/setting-up
* Add the `Content` folder with the resources that we are going to use
* Clean the project.
  * On `GameScene.sks`
    * Delete the **Hello World `Node`**
    * On `attributes inspector` from `GameScene.sks`:
      * Change the `anchor point` for **`X`:0 `Y`:0**.
      * Change the size for **W:1024** **H:768** to match iPad `landscape` size.
          > Although there are iPads much bigger, `SpriteKit` takes care of it, so don't worry about this size.
  * Delete `Actions.sks`, move it to trash.