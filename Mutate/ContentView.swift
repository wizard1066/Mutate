//
//  ContentView.swift
//  Mutate
//
//  Created by localadmin on 16.08.21.
//

import SwiftUI
import SpriteKit
import Combine

var choose:AnyCancellable!
var choice = PassthroughSubject<String,Never>()
var turnOnScrolling = PassthroughSubject<Void,Never>()
var resetScrollView = PassthroughSubject<Void,Never>()

var scene: SKScene {
  let scene = GameScene.shared
  scene.size = CGSize(width: 256, height: 384)
  scene.scaleMode = .aspectFill
  scene.backgroundColor = .black
  scene.name = "mutate"
  return scene
}

var scene2: SKScene {
  let scene2 = GameScene2.shared
  scene2.size = CGSize(width: 256, height: 256)
  scene2.scaleMode = .fill
  scene2.backgroundColor = .black
  scene2.name = "design"
  return scene2
}

var scene3: SKScene {
  let scene3 = GameScene3.shared
  scene3.size = CGSize(width: 512, height: 512)
  scene3.scaleMode = .fill
  scene3.backgroundColor = .black
  scene3.name = "simulate"
  return scene3
}

struct ContentView: View {
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    @State var vMap:[Int64] = []
    @State var menu:String!
    @State var ready = 0.0
    @State var canScroll = false
    @State var zoomFactor:CGFloat = 1
//    @State var zoomMargin:CGFloat = 0.5
//    @State var xOffset:CGFloat = 0
//    @State var yOffset:CGFloat = 0
//    @State var showGame = false
    @State private var offset = CGSize.zero
//    @State private var doDrag = false
    @State private var paused = true
    
    
    @ObservedObject var point = Pointy.shared
    @ObservedObject var common = CommonVariables.shared
    let scene31 = GameScene3.shared
    let scene21 = GameScene2.shared
    var body: some View {
      ZStack {
      Color.black
      switch menu {
        case "design":
          VStack {
            HStack {
            Text("clear")
              .font(Fonts.futuraCondensedMedium(size: 48))
              .background(Color.white)
              .onTapGesture {
                scene21.clear()
              }
            Text("save")
              .font(Fonts.futuraCondensedMedium(size: 48))
              .background(Color.white)
              .onTapGesture {
                vMap = scene21.saveVirus()
                print("Virus ",vMap,vMap.count)
              }
            Text("load")
              .font(Fonts.futuraCondensedMedium(size: 48))
              .background(Color.white)
              .onTapGesture {
                scene21.loadVirus(map: vMap)
              }
            }
            VStack {
            
              Button {
                  point.cameraLocation.y += 16
                  scene21.doCamera()
              } label: {
                Image(systemName: "arrow.up.square.fill")
                  .resizable()
                  .opacity(0.9)
                  .frame(width: 64, height: 32, alignment: .center)
                }
                .zIndex(1)
               
              HStack {
                Button {
                  point.cameraLocation.x -= 16
                  scene21.doCamera()
              } label: {
                Image(systemName: "arrow.backward.square.fill")
                .resizable()
                .opacity(0.9)
                  .frame(width: 32, height: 64, alignment: .center)
                }
                .zIndex(1)
              
             
                SpriteView(scene: scene2)
                  .frame(width: 256, height: 256, alignment: .center)
                  .ignoresSafeArea()
                  .scaleEffect(zoomFactor)

                  
                
                Button {
                point.cameraLocation.x += 16
                scene21.doCamera()
              } label: {
                Image(systemName: "arrow.forward.square.fill")
                .resizable()
                .opacity(0.8)
                  .frame(width: 32, height: 64, alignment: .center)
                }
                .zIndex(1)
              }
              Button {
                point.cameraLocation.y -= 16
                scene21.doCamera()
              } label: {
                Image(systemName: "arrow.down.square.fill")
                .resizable()
                .opacity(0.9)
                  .frame(width: 64, height: 32, alignment: .center)
                }
                .zIndex(1)
                
            } // VStack
            Text("place")
              .font(Fonts.futuraCondensedMedium(size: 48))
              .background(Color.white)
              .onTapGesture {
                choice.send("run")
            }
            VStack {

              VStack {
              HStack {
                Button {
                  zoomFactor += 0.5
                 
                } label: {
                  Image(systemName: "plus.magnifyingglass")
                  .resizable()
                    .frame(width: 64, height: 64, alignment: .center)
                }
                

                Button {
                  zoomFactor -= 0.5
                  
                } label: {
                  Image(systemName: "minus.magnifyingglass")
                  .resizable()
                    .frame(width: 64, height: 64, alignment: .center)
                }
              }
              

             
              }
            }
          }
        case "run":
          
          VStack(spacing: 10) {
            HStack {
            Text("score")
            .font(Fonts.futuraCondensedMedium(size: 48))
            .background(Color.white)
            .onTapGesture {
              choice.send("score")
              common.running = false
              common.touched = false
              common.placer = nil
              canScroll = false
//              scene21.clear()
              print("counts ",scene31.alive.count,scene31.dead.count)
            }
             Text("clear")
              .font(Fonts.futuraCondensedMedium(size: 48))
              .background(Color.white)
              .onTapGesture {
                scene31.clear()
              }
            }
            PreventableScrollView(canScroll: $canScroll) {
              SpriteView(scene: scene3)
//                    .frame(width: 512, height: 512)
                    .ignoresSafeArea()
                    .scaleEffect(zoomFactor)
            }.onReceive(turnOnScrolling) { _ in
              canScroll = true
            }
            .fixedSize(horizontal: false, vertical: false)
             HStack {
                Button {
                  zoomFactor += 0.5
                } label: {
                  Image(systemName: "plus.magnifyingglass")
                  .resizable()
                    .frame(width: 64, height: 64, alignment: .center)
                }
                Button {
                  zoomFactor -= 0.5
                } label: {
                  Image(systemName: "minus.magnifyingglass")
                  .resizable()
                    .frame(width: 64, height: 64, alignment: .center)
                }
                Button {
                  paused.toggle()
                } label: {
                  if paused {
                    Image(systemName: "playpause")
                    .resizable()
                    .frame(width: 64, height: 64, alignment: .center)
                  } else {
                    Image(systemName: "playpause.fill")
                    .resizable()
                    .frame(width: 64, height: 64, alignment: .center)
                  }
                  
                }.onReceive(timer) { _ in
                  if !paused {
                    common.running = true
                  }
                }
              }
         
            }
        case "score":
          VStack {
          Text("cycles \(scene31.passes)")
            .font(Fonts.futuraCondensedMedium(size: 32))
            .background(Color.white)
            .padding(Edge.Set.bottom, 4)
          Text("cells \(scene31.report())")
            .font(Fonts.futuraCondensedMedium(size: 32))
            .background(Color.white)
            .padding()
          Text("re-run")
            .font(Fonts.futuraCondensedMedium(size: 48))
            .background(Color.white)
            .onTapGesture {
              choice.send("title")
            }
          }
        default:
          ZStack {
            Color.black
            SpriteView(scene: scene)
                .frame(width: 256, height: 320)
                .ignoresSafeArea()
            Button {
              choice.send("design")
            } label: {
              Image("64x64")
            }.offset(CGSize(width: 0, height: -180))
            .opacity(ready)
            .onAppear {
              Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    ready += 0.05
                  }
            }
                
            
          }.onAppear {
            choose = choice
              .sink { value in
              menu = value
            }
          }
        }
      }
    }
}

struct PreventableScrollView<Content>: View where Content: View {
    @Binding var canScroll: Bool
    var content: () -> Content
    
    var body: some View {
        if canScroll {
          ScrollViewReader { scrollView in
            ScrollView([.vertical, .horizontal], showsIndicators: false, content: content)
              .onReceive(resetScrollView) { _ in
                scrollView.scrollTo(99, anchor: .center)
              }
          }
        } else {
            content()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
