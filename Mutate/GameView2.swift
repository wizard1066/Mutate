//
//  GameView2.swift
//  Mutate
//
//  Created by localadmin on 16.08.21.
//

import Foundation
import SpriteKit

let mapSize = 16

class Pointy: ObservableObject {
  static var shared = Pointy()
  @Published var column = 0
  @Published var row = 0
  @Published var cameraLocation = CGPoint(x: 128, y: 128)
  @Published var colour: String!
}

class GameScene2: SKScene {

  var bar:SKSpriteNode!
  var point = Pointy.shared
  static let shared = GameScene2()
  
  var cameraNode = SKCameraNode()
  
  
  var tileMap:SKTileMapNode!
  var redGroup:SKTileGroup!
  var blueGroup: SKTileGroup!
  var greenGroup: SKTileGroup!
  var orangeGroup: SKTileGroup!
  
  var blackGroup:SKTileGroup!
  var freeze:Bool = false
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let column = tileMap.tileColumnIndex(fromPosition: location)
    let row = tileMap.tileRowIndex(fromPosition: location)

    let foo = tileMap.tileGroup(atColumn: column, row: row)
    if foo == blackGroup {
      print("pc ",point.colour)
      switch point.colour {
        case "blue":
          tileMap.setTileGroup(blueGroup, forColumn: column, row: row)
        case "green":
          tileMap.setTileGroup(greenGroup, forColumn: column, row: row)
        case "orange":
          tileMap.setTileGroup(orangeGroup, forColumn: column, row: row)
        default:
          tileMap.setTileGroup(redGroup, forColumn: column, row: row)
      }
    
    
      
    } else {
      tileMap.setTileGroup(blackGroup, forColumn: column, row: row)
      freeze = true
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let column = tileMap.tileColumnIndex(fromPosition: location)
    let row = tileMap.tileRowIndex(fromPosition: location)

    let foo = tileMap.tileGroup(atColumn: column, row: row)
    
    if foo == blackGroup && !freeze {
      switch point.colour {
        case "blue":
          tileMap.setTileGroup(blueGroup, forColumn: column, row: row)
        case "green":
          tileMap.setTileGroup(greenGroup, forColumn: column, row: row)
        case "orange":
          tileMap.setTileGroup(orangeGroup, forColumn: column, row: row)
        default:
          tileMap.setTileGroup(redGroup, forColumn: column, row: row)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    freeze = false
  }
  
  override func update(_ currentTime: TimeInterval) {
//    cameraNode.position = point.cameraLocation
//    camera = cameraNode
  }
  
  
  override func didMove(to view: SKView) {

    if bar == nil {
      doGrid()
      bar = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 12, height: 12))
    }
  }
  
  func doCamera() {
    cameraNode.position = point.cameraLocation
    camera = cameraNode
  }
  
  func clear() {
    tileMap.fill(with: blackGroup)
  }
  
  func doGrid() {
    
    let box = returnBox(mapSize: mapSize)
    let boxTexture = SKTexture(image: box)
    let boxTile = SKTileDefinition(texture: boxTexture)
    
    let blue = returnColour(mapSize: mapSize, colour: UIColor.blue)
    let blueTexture = SKTexture(image: blue)
    let blueTile = SKTileDefinition(texture: blueTexture)
    
    let green = returnColour(mapSize: mapSize, colour: UIColor.green)
    let greenTexture = SKTexture(image: green)
    let greenTile = SKTileDefinition(texture: greenTexture)
    
    let orange = returnColour(mapSize: mapSize, colour: UIColor.orange)
    let orangeTexture = SKTexture(image: orange)
    let orangeTile = SKTileDefinition(texture: orangeTexture)
    
    let red = returnColour(mapSize: mapSize, colour: UIColor.red)
    let redTexture = SKTexture(image: red)
    let redTile = SKTileDefinition(texture: redTexture)
    
    blackGroup = SKTileGroup(tileDefinition: boxTile)
    blackGroup.name = "black"
    redGroup = SKTileGroup(tileDefinition: redTile)
    redGroup.name = "red"
    blueGroup = SKTileGroup(tileDefinition: blueTile)
    blueGroup.name = "blue"
    greenGroup = SKTileGroup(tileDefinition: greenTile)
    greenGroup.name = "green"
    orangeGroup = SKTileGroup(tileDefinition: orangeTile)
    orangeGroup.name = "orange"
    
    let tileSet = SKTileSet(tileGroups: [blackGroup, redGroup, blueGroup, greenGroup, orangeGroup], tileSetType: .grid)
    
    let tileSize = tileSet.defaultTileSize
    tileMap = SKTileMapNode(tileSet: tileSet, columns: mapSize, rows: mapSize, tileSize: tileSize)
    tileMap.fill(with: blackGroup)
    tileMap.anchorPoint = .zero
    
    
    self.addChild(tileMap)
  }
  
  func saveVirus() -> [Int64]{
    var vMap:[Int64] = []
    for r in 0..<tileMap.numberOfRows {
      var basic:Int64 = 0
      var bitMask:Int64 = 1
      for c in 0..<tileMap.numberOfColumns {
        if tileMap.tileGroup(atColumn: c, row: r)?.name != "black" {
          basic = basic | bitMask
        }
        bitMask = bitMask << 1
        print("bitMask ",bitMask,basic)
      }
      vMap.append(basic)
    }
    let defaults = UserDefaults.standard
    defaults.set(vMap, forKey:"virus")
    return vMap
  }
  
  func loadVirus() {
    // assuming rows = columns
    let defaults = UserDefaults.standard
    let map = defaults.object(forKey: "virus") as! Array<Int64>
    for r in 0..<tileMap.numberOfRows {
      var bitMask:Int64 = 1
      let basic:Int64 = map[r]
      for c in 0..<tileMap.numberOfColumns {
        if basic & bitMask != 0 {
          switch point.colour {
            case "blue":
              tileMap.setTileGroup(blueGroup, forColumn: c, row: r)
            case "green":
              tileMap.setTileGroup(greenGroup, forColumn: c, row: r)
            case "orange":
              tileMap.setTileGroup(orangeGroup, forColumn: c, row: r)
            default:
              tileMap.setTileGroup(redGroup, forColumn: c, row: r)
          }
        }
        bitMask = bitMask << 1
      }
    }
  }
  
  
  
  func returnBox(mapSize: Int) -> UIImage {
    let tileSize = 256 / mapSize
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: tileSize, height: tileSize))
    return renderer.image { (context) in
      context.cgContext.setStrokeColor(UIColor.gray.cgColor)
      context.cgContext.addArc(center: CGPoint(x: tileSize/2, y: tileSize/2), radius: CGFloat(tileSize/4), startAngle: 0, endAngle: 360, clockwise: false)
      context.cgContext.strokePath()
    }
  }
  

  
  func returnColour(mapSize: Int, colour:UIColor) -> UIImage {
    let tileSize = 256 / mapSize
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: tileSize, height: tileSize))
    return renderer.image { (context) in
      context.cgContext.setStrokeColor(UIColor.white.cgColor)
      context.cgContext.setFillColor(colour.cgColor)
      context.fill(CGRect(x: 0, y: 0, width: tileSize, height: tileSize))
      context.stroke(CGRect(x: 0, y: 0, width: tileSize, height: tileSize))

    }
  }
}



