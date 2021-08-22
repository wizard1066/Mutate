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
  @State var fadeIn = 0.0
  @State private var offset = CGSize.zero
  @State private var paused = true
  @State private var report:[Int] = [0,0,0,0]
  @State private var bigText = 16
  @State private var bugImage = 16
  
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
            Text(" clear ")
              .font(Fonts.avenirNextCondensedMedium(size: 24))
              .background(Color.white)
              .onTapGesture {
                scene21.clear()
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
                .frame(width: 64, height: 64, alignment: .center)
            }
            .zIndex(1)
            
            
            HStack {
              LeftOfGrid()
                .zIndex(1)
              
              SpriteView(scene: scene2)
                .frame(width: 256, height: 256, alignment: .center)
                .ignoresSafeArea()
                .scaleEffect(zoomFactor)
              
              RightOfGrid(vMap: $vMap)
            }
            
            Button {
              point.cameraLocation.y -= 16
              scene21.doCamera()
            } label: {
              Image(systemName: "arrow.down.square.fill")
                .resizable()
                .opacity(0.9)
                .frame(width: 64, height: 64, alignment: .center)
            }
            .zIndex(1)
            
          } // VStack
          Text("place")
            .font(Fonts.avenirNextCondensedMedium(size: 24))
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
            Text(" exit ")
              .font(Fonts.avenirNextCondensedMedium(size: 24))
              .background(Color.white)
              .onTapGesture {
                choice.send("score")
                common.running = false
                common.touched = false
                common.placer = nil
                canScroll = false
                paused = true
                scene21.clear()
                print("counts ",scene31.alive.count,scene31.dead.count)
              }
          }
          SpriteView(scene: scene3)
            .ignoresSafeArea()
            .scaleEffect(zoomFactor)
            
            .fixedSize(horizontal: false, vertical: false)
          HStack {
            
            Button {
              scene31.clear()
            } label: {
              Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .padding(Edge.Set.trailing, 12)
                .padding(Edge.Set.bottom, 10)
            }
            
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
                Image(systemName: "play")
                  .resizable()
                  .frame(width: 24, height: 24, alignment: .center)
                  .padding(Edge.Set.bottom, 8)
              } else {
                Image(systemName: "pause")
                  .resizable()
                  .frame(width: 24, height: 24, alignment: .center)
                  .padding(Edge.Set.bottom, 8)
              }
              
            }.onReceive(timer) { _ in
              if !paused {
                common.running = true
                print("pass")
              }
            }
          }
          
        }
      case "score":
        VStack(spacing: 4) {
          HStack {
            Text(" Orange Cells ")
              .font(Fonts.avenirNextCondensedMedium(size: 16))
              .foregroundColor(Color.white)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[0])")
              .font(Fonts.avenirNextCondensedMedium(size: 24))
              .foregroundColor(Color.white)
          }
          HStack {
            Text(" BlueCells Cells ")
              .font(Fonts.avenirNextCondensedMedium(size: 16))
              .foregroundColor(Color.white)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[1])")
              .font(Fonts.avenirNextCondensedMedium(size: 24))
              .foregroundColor(Color.white)
          }
          HStack {
            Text(" Green Cells ")
              .font(Fonts.avenirNextCondensedMedium(size: 16))
              .foregroundColor(Color.white)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[2])")
              .font(Fonts.avenirNextCondensedMedium(size: 24))
              .foregroundColor(Color.white)
          }
          HStack {
            Text(" Red Cells ")
              .font(Fonts.avenirNextCondensedMedium(size: 16))
              .foregroundColor(Color.white)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[3])")
              .font(Fonts.avenirNextCondensedMedium(size: 24))
              .foregroundColor(Color.white)
          }
          Image("128x64b")
            .onTapGesture {
              choice.send("title")
            }.onAppear {
              report = scene31.report()
            }.padding(Edge.Set.top, 32)
        }
      default:
        VStack {
          Color.black
            .frame(width: 1, height: 1, alignment: .center)
          Image("128x64")
            .opacity(fadeIn)
            .onAppear {
              withAnimation(.linear(duration: 12)) {
                fadeIn = 0.8
              }
            }
            .padding(Edge.Set.bottom, 0)
          SpriteView(scene: scene)
            .frame(width: 256, height: 320)
            .ignoresSafeArea()
          
          
          
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

struct LeftOfGrid: View {
  let point = Pointy.shared
  let scene21 = GameScene2.shared
  var body: some View {
    VStack {
      Button {
        point.cameraLocation.x -= 16
        scene21.doCamera()
      } label: {
        Image(systemName: "arrow.backward.square.fill")
          .resizable()
          .opacity(0.9)
          .frame(width: 64, height: 64, alignment: .center)
      }
      .zIndex(1)
      Text(" load ")
        .font(Fonts.avenirNextCondensedMedium(size: 24))
        .background(Color.white)
        .onTapGesture {
          scene21.loadVirus()
        }
    }
  }
}

struct RightOfGrid: View {
  @Binding var vMap:[Int64]
  let point = Pointy.shared
  let scene21 = GameScene2.shared
  var body: some View {
    VStack {
      Text(" save ")
        .font(Fonts.avenirNextCondensedMedium(size: 24))
        .background(Color.white)
        .onTapGesture {
          vMap = scene21.saveVirus()
        }
      
      Button {
        point.cameraLocation.x += 16
        scene21.doCamera()
      } label: {
        Image(systemName: "arrow.forward.square.fill")
          .resizable()
          .opacity(0.8)
          .frame(width: 64, height: 64, alignment: .center)
      }
      .zIndex(1)
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
