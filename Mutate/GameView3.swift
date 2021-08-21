//
//  GameView3.swift
//  Mutate
//
//  Created by localadmin on 17.08.21.
//

import Foundation
import SpriteKit

class CommonVariables: ObservableObject {
  static var shared = CommonVariables()
  @Published var running = false
  @Published var touched = false
  @Published var gridDrawn = false
  @Published var placer:SKSpriteNode? = nil
}

class GameScene3: SKScene {
  
  struct Cords {
    var c:Int!
    var r:Int!
  }
  var cordValue:Cords!
  
  static let shared = GameScene3()
  let scene2 = GameScene2.shared
  var point = Pointy.shared
  var common = CommonVariables.shared
  var cent:SKSpriteNode!
  
  
  var tileMap:SKTileMapNode!
//  var spriteMap:[[SKSpriteNode?]] = Array(repeating: Array(repeating: nil, count: 16), count: 16)
  var redGroup:SKTileGroup!
  var blueGroup: SKTileGroup!
  var greenGroup: SKTileGroup!
  var orangeGroup: SKTileGroup!
  var blackGroup:SKTileGroup!
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let column = tileMap.tileColumnIndex(fromPosition: location)
    let row = tileMap.tileRowIndex(fromPosition: location)
    common.placer?.position = tileMap.centerOfTile(atColumn: column, row: row)
    cordValue = Cords(c: column - 8, r: row - 8)
//    point.mark = false
//    cameraNode.position = location
//    camera = cameraNode
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let column = tileMap.tileColumnIndex(fromPosition: location)
    let row = tileMap.tileRowIndex(fromPosition: location)
    common.placer?.position = tileMap.centerOfTile(atColumn: column, row: row)
    cordValue = Cords(c: column - 8, r: row - 8)
    
  }
  
  override func update(_ currentTime: TimeInterval) {
    if common.running {
      self.doRules()
      common.running = false
      if common.placer != nil {
        common.placer?.removeFromParent()
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      cent.removeFromParent()
        if !common.touched {
        for c in 0..<mapSize {
          for r in 0..<mapSize {
            let nC = cordValue.c + c
            let nR = cordValue.r + r
            if scene2.tileMap.tileGroup(atColumn: c, row: r)?.name == point.colour {
              switch point.colour {
                case "blue":
                  tileMap.setTileGroup(blueGroup, forColumn: nC, row: nR)
                case "orange":
                  tileMap.setTileGroup(orangeGroup, forColumn: nC, row: nR)
                case "green":
                  tileMap.setTileGroup(greenGroup, forColumn: nC, row: nR)
                default:
                  tileMap.setTileGroup(redGroup, forColumn: nC, row: nR)
              }
              
            }
          }
        }
        common.touched = true
      }
      
  }
  
  
  override func didMove(to view: SKView) {
    
    if common.placer == nil {
      print("didMove")
      if !common.gridDrawn {
        doGrid()
        common.gridDrawn = true
      }
      let tex = SKTexture(image: returnMark())
      common.placer = SKSpriteNode(texture: tex)
      common.placer?.position = tileMap.centerOfTile(atColumn: mapSize, row: mapSize)
      common.placer?.name = "mark"
      addChild(common.placer!)
      
      let corner = SKSpriteNode(color: UIColor.red, size: CGSize(width: 4, height: 4))
      corner.position = tileMap.centerOfTile(atColumn: 0, row: 0)
      addChild(corner)
      let corner2 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 4, height: 4))
      corner2.position = tileMap.centerOfTile(atColumn: 0, row: 63)
      addChild(corner2)
      let corner3 = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 4, height: 4))
      corner3.position = tileMap.centerOfTile(atColumn: 63, row: 0)
      addChild(corner3)
      let corner4 = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 4, height: 4))
      corner4.position = tileMap.centerOfTile(atColumn: 63, row: 63)
      addChild(corner4)
      cent = SKSpriteNode(color: UIColor.white, size: CGSize(width: 4, height: 4))
      cent.position = tileMap.centerOfTile(atColumn: 32, row: 32)
      addChild(cent)
    }
  }
  
  func doGrid() {
    let box = returnBox()
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
    let tileSet = SKTileSet(tileGroups: [blackGroup, redGroup, blueGroup, orangeGroup, greenGroup], tileSetType: .grid)
    
    let tileSize = tileSet.defaultTileSize // from image size
    tileMap = SKTileMapNode(tileSet: tileSet, columns: 64, rows: 64, tileSize: tileSize)
    tileMap.fill(with: blackGroup) // fill or set by column/row
    tileMap.anchorPoint = .zero
    
    self.addChild(tileMap)
  }
  
  func clear() {
    tileMap.fill(with: blackGroup)
  }
  
  func report() -> Int {
    var count = 0
    for c in 0..<tileMap.numberOfColumns {
      for r in 0..<tileMap.numberOfRows {
        if tileMap.tileGroup(atColumn: c, row: r)?.name == "red" {
          count += 1
        }
      }
    }
    return count
  }
  
  func returnBox() -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
    return renderer.image { (context) in
      context.cgContext.setStrokeColor(UIColor.gray.cgColor)
      context.cgContext.addArc(center: CGPoint(x: 4, y: 4), radius: 2.0, startAngle: 0, endAngle: 360, clockwise: false)
      context.cgContext.strokePath()
    }
  }
  
  func returnColour(mapSize: Int, colour:UIColor) -> UIImage {
    let tileSize = 256 / mapSize
    print("ts ",tileSize)
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
    return renderer.image { (context) in
      context.cgContext.setStrokeColor(UIColor.white.cgColor)
      context.cgContext.setFillColor(colour.cgColor)
      context.fill(CGRect(x: 0, y: 0, width: 8, height: 8))
      context.stroke(CGRect(x: 0, y: 0, width: 8, height: 8))

    }
  }
  
//  func returnRed() -> UIImage {
//    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
//    return renderer.image { (context) in
//      context.cgContext.setStrokeColor(UIColor.red.cgColor)
//      context.cgContext.setFillColor(UIColor.white.cgColor)
//      context.fill(CGRect(x: 0, y: 0, width: 8, height: 8))
//      context.stroke(CGRect(x: 0, y: 0, width: 8, height: 8))
//
//    }
//  }
  
  func returnMark() -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: mapSize, height: mapSize))
    return renderer.image { (context) in
      context.cgContext.setStrokeColor(UIColor.yellow.cgColor)
      context.stroke(CGRect(x: 0, y: 0, width: mapSize, height: mapSize))
    }
  }
  
  struct Matrix {
    var c: Int!
    var r: Int!
    var colour: Int!
  }
  
  var alive:[Matrix] = []
  var dead:[Matrix] = []
  var passes = 0
  
  func doRules() {
    var sortie = false
    var cellColumn = 0
    var cellRow = 0
    
    alive.removeAll()
    dead.removeAll()
    passes = 0
    
    struct Players {
      var index: Int
      var name: String
      var score: Int
    }
    
    var counts:[Players] = [Players(index: 0, name: "orange", score: 0),Players(index: 1, name: "blue", score: 0),Players(index: 2, name: "green",score:0),Players(index: 3, name: "red", score:0)]
    
    repeat {
      passes += 1
 
      
//      for i in 0..<counts.count {
//        counts[i].score = 0
//      }
      
      counts.indices.forEach { counts[$0].score = 0 }
      
      let plusCellColumn = cellColumn + 1
      let minusCellColumn = cellColumn - 1
      let plusRow = cellRow + 1
      let minusRow = cellRow - 1
      
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: minusCellColumn, row: cellRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: minusCellColumn, row: cellRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: minusCellColumn, row: cellRow)?.name)) {
//        counts[dix].score += 1
//      }
      
      
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: plusCellColumn, row: cellRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: plusCellColumn, row: cellRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: plusCellColumn, row: cellRow)?.name)) {
//        counts[dix].score += 1
//      }
      
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: minusCellColumn, row: minusRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: minusCellColumn, row: minusRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: minusCellColumn, row: minusRow)?.name)) {
//        counts[dix].score += 1
//      }

//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: cellColumn, row: minusRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: cellColumn, row: minusRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: cellColumn, row: minusRow)?.name)) {
//        counts[dix].score += 1
//      }
      
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: plusCellColumn, row: minusRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: plusCellColumn, row: minusRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: plusCellColumn, row: minusRow)?.name)) {
//        counts[dix].score += 1
//      }
    
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: minusCellColumn, row: plusRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: minusCellColumn, row: plusRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: minusCellColumn, row: plusRow)?.name)) {
//        counts[dix].score += 1
//      }
      
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: cellColumn, row: plusRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: cellColumn, row: plusRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: cellColumn, row: plusRow)?.name)) {
//        counts[dix].score += 1
//      }
      
//      if let dix = counts.first(where: { $0.name == tileMap.tileGroup(atColumn: plusCellColumn, row: plusRow)?.name }) {
//        counts[dix.index].score += 1
//      }
      if let dix = counts.firstIndex(where: { $0.name == tileMap.tileGroup(atColumn: plusCellColumn, row: plusRow)?.name }) {
        counts[dix].score += 1
      }
//      if let dix = returnCounts(colour: (tileMap.tileGroup(atColumn: plusCellColumn, row: plusRow)?.name)) {
//        counts[dix].score += 1
//      }

//      let sum = counts.lazy.compactMap { $0.score }
//            .reduce(0, +)
            
      let sum = counts[0].score | counts[1].score | counts[2].score | counts[3].score
      
      if sum != 2 {
        if sum < 2 || sum > 3 {
          dead.append(Matrix(c: cellColumn, r: cellRow))
        } else {
          if sum == 3 {
            let indexed = counts.max { $0.score < $1.score }?.index
            print("indexed ",indexed)
              
          
//              var largest = 0
//              var indexed = 0
//              for (index,value) in counts.enumerated() {
//                if value.score > largest {
//                  largest = value.score
//                  indexed = index
//                }
//              }
              alive.append(Matrix(c: cellColumn, r: cellRow, colour: indexed))
          }
        }
      }
      
      if cellColumn > tileMap.numberOfColumns {
        cellRow += 1
        cellColumn = 0
      } else {
        cellColumn += 1
      }
      if cellRow > tileMap.numberOfRows {
        sortie = true
      }
    } while !sortie
    
    for cells in dead {
      tileMap.setTileGroup(blackGroup, forColumn: cells.c, row: cells.r)
    }
    for cells in alive {
      switch cells.colour {
        case 0:
          tileMap.setTileGroup(orangeGroup, forColumn: cells.c, row: cells.r)
        case 1:
          tileMap.setTileGroup(blueGroup, forColumn: cells.c, row: cells.r)
        case 2:
          tileMap.setTileGroup(greenGroup, forColumn: cells.c, row: cells.r)
        default:
          tileMap.setTileGroup(redGroup, forColumn: cells.c, row: cells.r)
      }
      
    }
  }
}



func returnCounts(colour:String?) -> Int? {
  switch colour {
    case "orange":
      return 0
    case "blue":
      return 1
    case "green":
      return 2
    case "red":
      return 3
    default:
      return nil
  }
}



func delay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
