//
//  GameScene.swift
//  FireworksNight
//
//  Created by Juan Francisco Dorado Torres on 29/09/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

  // MARK: - Properties

  var gameTimer: Timer? // this will call `launchFireWorks()` each 6 seconds
  var fireworks = [SKNode]() // fireworks container, a node with other nodes, it will avoid accidental taps triggered by tapping on the fuse of a firework.

  // this next 3 properties are used to define where we launch fireworks from.
  let leftEdge = -22
  let bottomEdge = -22
  let rightEdge = 1024 + 22

  // the score will track the player's score
  var score = 0 {
    didSet {
      // your code here
    }
  }

  // MARK: - Scene lifecycle

  override func didMove(to view: SKView) {
    // add the background
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace // ignores alphas
    background.zPosition = -1
    addChild(background)

    // call the method launchFireworks() each 6 seconds
    gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
  }

  // MARK: - Touches events

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    checkTouches(touches)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    checkTouches(touches)
  }

  // MARK: - Update event

  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)

    // reversed to let it count... 4, 3, 2, 1... in the other way... if we delete for example in 1, 2, 3, 4... the number 3... number 4 moves down and there is a new number 3 that we are going to ignore.
    for (index, firework) in fireworks.enumerated().reversed() {
      if firework.position.y > 900 {
        // this uses a position high above so that rockets can explode off screen
        fireworks.remove(at: index)
        firework.removeFromParent()
      }
    }
  }

  // MARK: - Methods

  @objc func launchFireworks() {
    let movementAmount: CGFloat = 1800

    switch Int.random(in: 0...3) {
    case 0:
      // fire five, straight up
      createFirework(xMovement: 0, x: 512, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
    case 1:
      // fire five, in a fan
      createFirework(xMovement: 0, x: 512, y: bottomEdge)
      createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
      createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
      createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
      createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
    case 2:
      // fire five, from the left to the right
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
    case 3:
      // fire five, from the right to the left
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
    default:
      break
    }
  }

  /// Create a firework with a given speed and position
  /// - Parameter xMovement: The speed your firework is going to move
  /// - Parameter x: Your position in x
  /// - Parameter y: Your position in y
  func createFirework(xMovement: CGFloat, x: Int, y: Int) {
    let node = SKNode() // create the node that will work as your container
    node.position = CGPoint(x: x, y: y) // place it at the position that was specified

    let firework = SKSpriteNode(imageNamed: "rocket") // create the rocket sprite node
    firework.colorBlendFactor = 1 // adjust this property to let us color our node '1' (use the new color exclusively)
    firework.name = "firework" // name our node to easy identify
    node.addChild(firework) // add the firework to our container

    // give the firework sprite node one of three random colors
    switch Int.random(in: 0...2) {
    case 0:
      firework.color = .magenta // magenta instead of blue because it isn't particularly visible on a starry sky background picture
    case 1:
      firework.color = .green
    case 2:
      firework.color = .red
    default:
      break
    }

    // create the UIBezierPath  to represent the movement of the firework
    let path = UIBezierPath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: xMovement, y: 1000))

    // tell the container node to follow that path, turning itself as needed
    let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
    node.run(move)

    // create particles behind the rocket to make it look like the fireworks are lit
    if let emitter = SKEmitterNode(fileNamed: "fuse") {
      emitter.position = CGPoint(x: 0, y: -22)
      node.addChild(emitter)
    }

    // add the firework to our fireworks array and also to the scene
    fireworks.append(node)
    addChild(node)
  }

  func checkTouches(_ touches: Set<UITouch>) {
    // get the point of first touch in a set of touches
    guard let touch = touches.first else {
      return
    }

    // get the location of the touch
    let location = touch.location(in: self)
    // get all the touched nodes on that location
    let nodesAtPoint = nodes(at: location)

    // iterate through each nodes and try to cast it on any SKSpriteNode
    for case let node as SKSpriteNode in nodesAtPoint {
      // look for our 'firework' nodes
      guard node.name == "firework" else {
        continue
      }

      // iterate through each node
      for parent in fireworks {
        // get the children of our container and cast it as skspritenode
        guard let firework = parent.children.first as? SKSpriteNode else {
          continue
        }

        // check if it was selected and the current firework selected is of different color
        if firework.name == "selected" && firework.color != node.color {
          // return to the original name
          firework.name = "firework"
          // return to the original|old color
          firework.colorBlendFactor = 1
        }
      }

      // change the name to selected
      node.name = "selected"
      // and return the color to pure white
      node.colorBlendFactor = 0
    }
  }
}
