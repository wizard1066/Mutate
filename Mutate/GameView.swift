//
//  GameView.swift
//  Mutate
//
//  Created by localadmin on 16.08.21.
//

import Foundation
import SpriteKit




class GameScene: SKScene, touched {
  var point = Pointy.shared
  
  func spriteSling(node: TouchableSprite, say: String) {
    switch say {
      case "red":
        print("red")
        point.colour = "red"
      case "blue":
        print("blue")
        point.colour = "blue"
      case "green":
        print("green")
        point.colour = "green"
      case "orange":
        print("orange")
        point.colour = "orange"
      default:
        break
    }
  }
  
  
  static let shared = GameScene()
  var crop:SKCropNode!
  var crop2:SKCropNode!
  
  override func didMove(to view: SKView) {
    // Tells you when the scene is presented by a view
    
    crop = SKCropNode()
    crop.position = CGPoint(x: 128, y: 320)
    crop.maskNode = SKSpriteNode(imageNamed: "128x256")
    
    crop2 = SKCropNode()
    crop2.position = CGPoint(x: 128, y: 128)
    crop2.maskNode = SKSpriteNode(imageNamed: "256x256")
    
    
    
    if let fireParticles = SKEmitterNode(fileNamed: "MyParticle") {
      fireParticles.position = CGPoint(x: 0, y: 0)
      crop.addChild(fireParticles)
    }
    
//    let sp = SKSpriteNode(color: .red, size: CGSize(width: 256, height: 48))
//    sp.position = CGPoint(x: 0, y: 0)
//    crop.addChild(sp)

    let tex = SKTexture(imageNamed: "Texture")
    let sp2 = SKSpriteNode(texture: tex)
    
    sp2.position = CGPoint(x: 0, y: 256)
    

    crop2.addChild(sp2)

    addChild(crop)
    addChild(crop2)
    
//    sp2.run(SKAction.run {
//      SKAction.move(by: CGVector(dx: 0, dy: -256), duration: 12)
////      SKAction.wait(forDuration: 12)
////      SKAction.move(to: CGPoint(x: 0, y: 128), duration: 0)
//    })

    let redPlayer = TouchableSprite(color: UIColor.red, size: CGSize(width: 64, height: 64))
    redPlayer.delegate = self
    redPlayer.colour = "red"
    redPlayer.position = CGPoint(x: 128, y: 256)
    
    let bluePlayer = TouchableSprite(color: UIColor.blue, size: CGSize(width: 64, height: 64))
    bluePlayer.delegate = self
    bluePlayer.colour = "blue"
    bluePlayer.position = CGPoint(x: 128, y: 64)
    
    let greenPlayer = TouchableSprite(color: UIColor.green, size: CGSize(width: 64, height: 64))
    greenPlayer.delegate = self
    greenPlayer.colour = "green"
    greenPlayer.position = CGPoint(x: 128, y: 128)
    
    let orangePlayer = TouchableSprite(color: UIColor.orange, size: CGSize(width: 64, height: 64))
    orangePlayer.delegate = self
    orangePlayer.colour = "orange"
    orangePlayer.position = CGPoint(x: 128, y: 192)
    
    
    
    let ma = SKAction.move(by: CGVector(dx: 0, dy: -512), duration: 10)
    let ra = SKAction.move(to: CGPoint(x: 0, y: 256), duration: 0)
    let ca = SKAction.run { [self] in
      crop2.removeFromParent()
      addChild(redPlayer)
      addChild(bluePlayer)
      addChild(greenPlayer)
      addChild(orangePlayer)
    }
    let se = SKAction.sequence([ma,ra,ca])
    sp2.run(se)
    
  }
}

protocol touched: NSObjectProtocol {
  func spriteSling(node: TouchableSprite, say: String)
}

class TouchableSprite: SKSpriteNode {
  weak var delegate: touched!
  var colour: String!
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
    self.isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:)has not been implemented")
  }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
      delegate.spriteSling(node: self, say: colour)
    }
    
    
}
