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
        choice.send("design")
      case "blue":
        print("blue")
        point.colour = "blue"
        choice.send("design")
      case "green":
        print("green")
        point.colour = "green"
        choice.send("design")
      case "orange":
        print("orange")
        point.colour = "orange"
        choice.send("design")
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

    let sp2 = SKNode()
    
    sp2.position = CGPoint(x: 0, y: 256)
    

    addChild(sp2)

    addChild(crop)
    addChild(crop2)
    
    let newImage = changeColor(inputImage2D: UIImage(named: "covid21")!, newColor: CIColor.red).imageByMakingWhiteBackgroundTransparent
    let tex2 = SKTexture(image: newImage()!)
    let redPlayer = TouchableSprite(texture: tex2)
    redPlayer.delegate = self
    redPlayer.colour = "red"
    redPlayer.position = CGPoint(x: 60, y: 256)
    redPlayer.alpha = 0
    redPlayer.zPosition = 1
    
    let newImage2 = changeColor(inputImage2D: UIImage(named: "covid21")!, newColor: CIColor.blue).imageByMakingWhiteBackgroundTransparent
    let tex3 = SKTexture(image: newImage2()!)
    let bluePlayer = TouchableSprite(texture: tex3, size: CGSize(width: 64, height: 64))
    bluePlayer.delegate = self
    bluePlayer.colour = "blue"
    bluePlayer.position = CGPoint(x: 96, y: 224)
    bluePlayer.alpha = 0
    bluePlayer.zPosition = 1
    
    let newImage3 = changeColor(inputImage2D: UIImage(named: "covid21")!, newColor: CIColor.green).imageByMakingWhiteBackgroundTransparent
    let tex4 = SKTexture(image: newImage3()!)
    let greenPlayer = TouchableSprite(texture: tex4, size: CGSize(width: 64, height: 64))
    greenPlayer.delegate = self
    greenPlayer.colour = "green"
    greenPlayer.position = CGPoint(x: 96+64, y: 224)
    greenPlayer.alpha = 0
    greenPlayer.zPosition = 1
    
    let newImage4 = changeColor(inputImage2D: UIImage(named: "covid21")!, newColor: CIColor.yellow).imageByMakingWhiteBackgroundTransparent
    let tex5 = SKTexture(image: newImage4()!)
    let orangePlayer = TouchableSprite(texture: tex5, size: CGSize(width: 64, height: 64))
    orangePlayer.delegate = self
    orangePlayer.colour = "orange"
    orangePlayer.position = CGPoint(x: 64+128, y: 256)
    orangePlayer.alpha = 0
    orangePlayer.zPosition = 1
    
     if let fireParticles2 = SKEmitterNode(fileNamed: "MyParticle") {
      fireParticles2.position = CGPoint(x: 0, y: 0)
      crop2.addChild(fireParticles2)
      
    let ma = SKAction.move(by: CGVector(dx: 0, dy: 64), duration: 4)
//    let ra = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0)
    let na = SKAction.move(by: CGVector(dx: 0, dy: -256), duration: 4)
    let fi = SKAction.fadeAlpha(to: 0.7, duration: 2)
    let co = SKAction.run {
        redPlayer.run(fi)
        bluePlayer.run(fi)
        greenPlayer.run(fi)
        orangePlayer.run(fi)
    }
    let ca = SKAction.run { [self] in
      crop2.removeFromParent()
      addChild(redPlayer)
      addChild(bluePlayer)
      addChild(greenPlayer)
      addChild(orangePlayer)
    }
      let se = SKAction.sequence([ma,na,ca,co])
    
      fireParticles2.run(se)
    }
    
    
    
    
  }
}

func changeColor(inputImage2D:UIImage, newColor: CIColor)-> UIImage {
  let context = CIContext(options: nil)
  let ciimage = CIImage(cgImage: inputImage2D.cgImage!)
  let CIwhite = CIColor(cgColor: UIColor.white.cgColor)
  let filter = CIFilter(name: "CISpotColor", parameters: ["inputImage":ciimage,"inputCenterColor1":CIwhite,"inputReplacementColor1":newColor])
  let outImage = context.createCGImage((filter?.outputImage!)!, from: CGRect(x: 0, y: 0, width: inputImage2D.size.width, height: inputImage2D.size.height))
  return UIImage(cgImage: outImage!)
}

extension UIImage {
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {

        let image = UIImage(data: self.jpegData(compressionQuality: 1.0)!)!
        let rawImageRef: CGImage = image.cgImage!

        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { (context) in
          context.cgContext.translateBy(x: 0.0, y: image.size.height)
          context.cgContext.scaleBy(x: 1.0, y: -1.0)
          context.cgContext.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
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

func returnButton(colour: UIColor) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 64, height: 64))
    return renderer.image { (context) in
      context.cgContext.setStrokeColor(colour.cgColor)
      context.cgContext.setFillColor(colour.cgColor)
      context.cgContext.draw((UIImage(named: "virus1")?.cgImage)!, in: CGRect(x: 0, y: 0, width: 64, height: 64))
      context.cgContext.addArc(center: CGPoint(x: 32, y: 32), radius: 16, startAngle: 0, endAngle: 360, clockwise: false)
      context.cgContext.strokePath()
      context.cgContext.fillPath()
    }
  }
