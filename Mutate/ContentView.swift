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
var pausePlay = PassthroughSubject<Void,Never>()

let ButtonSize:CGFloat = 48
let textSize:CGFloat = 13

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
  let ButtonSize:CGFloat = 32
  
  var body: some View {
    
    ZStack {
      Color.black
      switch menu {
      case "design":
        VStack {
          TopOfGrid().zIndex(1)
            HStack {
              LeftOfGrid().zIndex(1)
              ZStack {
              SpriteView(scene: scene2)
                .frame(width: 256, height: 256, alignment: .center)
                .ignoresSafeArea()
                .scaleEffect(zoomFactor)
                MagnifyGrid(zoomFactor: $zoomFactor).zIndex(1)
                  .offset(x: 0, y: 256)
              }
              RightOfGrid(vMap: $vMap).zIndex(1)
            }
          BottomOfGrid().zIndex(1)
        }
      case "run":
        VStack(spacing: 24) {
          HighGrid(paused: $paused)
            .zIndex(1)
            .offset(x: 0, y: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
          SpriteView(scene: scene3)
            .ignoresSafeArea()
            .scaleEffect(zoomFactor)
          LowGrid(zoomFactor: $zoomFactor, paused: $paused).zIndex(1)
        }
      case "score":
        VStack(spacing: 4) {
          HStack {
            Text(" yellow cells ")
              .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.yellow)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[0])")
             .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
          }
          HStack {
            Text(" blueCells cells ")
              .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.blue)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[1])")
              .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
          }
          HStack {
            Text(" green cells ")
             .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.green)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[2])")
              .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
          }
          HStack {
            Text(" red cells ")
             .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.red)
            Image("covid21")
              .resizable()
              .frame(width: 64, height: 64, alignment: .center)
            Text("\(report[3])")
             .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
          }
          HStack {
            Text("generations")
            .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
            Text(String(scene31.passes))
           .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
            }
            .padding(Edge.Set.top, 24)
          Text(" re-run ")
             .font(Fonts.touchOfNature(size: textSize))
              .foregroundColor(Color.white)
            .onTapGesture {
              scene31.passes = 0
              choice.send("title")
            }.onAppear {
              report = scene31.report()
            }.padding(Edge.Set.top, 32)
        }
      default:
        VStack {
          Color.black
            .frame(width: 1, height: 1, alignment: .center)
          Text(" select player ")
            .font(Fonts.touchOfNature(size: textSize))
            .foregroundColor(Color.white)
            .opacity(fadeIn)
            .onAppear {
              withAnimation(.linear(duration: 12)) {
                fadeIn = 0.9
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

struct LowGrid: View {
  let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
  
  @Binding var zoomFactor: CGFloat
  @Binding var paused: Bool
  let point = Pointy.shared
  let scene31 = GameScene3.shared
  @ObservedObject var common = CommonVariables.shared
  
  var body: some View {
    HStack(alignment: .center, spacing: 24) {
      Button {
        point.cameraLocation.y -= 16
        scene31.doCamera()
      } label: {
        Text("down")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 64, height: 32, alignment: .center))
      }
      
      
      HStack(spacing: 0) {
        Button {
          withAnimation(.linear(duration: 2)) {
            zoomFactor += 0.5
          }
        } label: {
          Image(systemName: "plus.magnifyingglass")
            .resizable()
            .frame(width: ButtonSize, height: ButtonSize, alignment: .center)
        }
        
        Button {
          withAnimation(.linear(duration: 1)) {
            zoomFactor -= 0.5
          }
        } label: {
          Image(systemName: "minus.magnifyingglass")
            .resizable()
            .frame(width: ButtonSize, height: ButtonSize, alignment: .center)
        }
      }
      Button {
        paused.toggle()
      } label: {
        if paused {
          Text("play")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 64, height: 32, alignment: .center))
        } else {
          Text("pause")
            .font(Fonts.touchOfNature(size: textSize))
            .foregroundColor(Color.white)
            .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 64, height: 32, alignment: .center))
        }
        
      }.onReceive(timer) { _ in
        if !paused {
          common.running = true
        }
      }.onReceive(pausePlay) { _ in
        paused.toggle()
        withAnimation(.linear(duration: 1)) {
          zoomFactor = 1.0
        }
      }
      
      Button {
        point.cameraLocation.x -= 16
        scene31.doCamera()
      } label: {
      Text("right")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 64, height: 32, alignment: .center))
      }
    }
  }
}

struct HighGrid: View {
  @Binding var paused: Bool
  @ObservedObject var common = CommonVariables.shared
  let scene31 = GameScene3.shared
  let scene21 = GameScene2.shared
  let point = Pointy.shared
  
  var body: some View {
    HStack(spacing: 42) {
      Button {
        point.cameraLocation.y += 16
        scene31.doCamera()
      } label: {
        Text("up")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
      }
      
      Button {
        scene31.clear()
      } label: {
        Text("clear")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 64, height: 32, alignment: .center))
      }.padding(Edge.Set.trailing, 10)
      
      Text("exit")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
        .onTapGesture {
          choice.send("score")
          common.running = false
          common.touched = false
          common.placer = nil
          paused = true
          scene21.clear()
          scene31.common.placer?.removeFromParent()
        }
      
      Button {
        point.cameraLocation.x += 16
        scene31.doCamera()
      } label: {
        Text("left")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
      }
    }
  }
}

struct MagnifyGrid: View {
  @Binding var zoomFactor: CGFloat
  var body: some View {
    HStack {
      Button {
        withAnimation(.linear(duration: 1)) {
          zoomFactor += 0.5
        }
      } label: {
        Image(systemName: "plus.magnifyingglass")
          .resizable()
          .frame(width: ButtonSize, height: ButtonSize, alignment: .center)
      }
      Button {
        withAnimation(.linear(duration: 1)) {
          zoomFactor -= 0.5
        }
      } label: {
        Image(systemName: "minus.magnifyingglass")
          .resizable()
          .frame(width: ButtonSize, height: ButtonSize, alignment: .center)
      }
    }
  }
}

struct BottomOfGrid: View {
  let point = Pointy.shared
  let scene21 = GameScene2.shared
  var body: some View {
    HStack(spacing: 24) {
    Button {
        point.cameraLocation.y -= 16
        scene21.doCamera()
      } label: {
        Text(" up ")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
      }
        
      Text("place")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
        .onTapGesture {
          choice.send("run")
          point.cameraLocation = CGPoint(x: 256, y: 240)
        }
        .padding()
      }
  }
}

struct TopOfGrid: View {
  let point = Pointy.shared
  let scene21 = GameScene2.shared
  var body: some View {
    HStack(spacing: 10) {
      Text("clear")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
      .onTapGesture {
        scene21.clear()
      }
      .padding()
       Button {
          point.cameraLocation.y += 16
          scene21.doCamera()
        } label: {
        Text(" down ")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
        }
    }
  }
}

struct LeftOfGrid: View {
  let point = Pointy.shared
  let scene21 = GameScene2.shared
  var body: some View {
    VStack(spacing: 64) {
      Button {
        point.cameraLocation.x -= 16
        scene21.doCamera()
      } label: {
        Text("left")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
      }
      .rotationEffect(.degrees(90))
      
      Text("load")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedbottom")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
        .onTapGesture {
          scene21.loadVirus()
        }
        .rotationEffect(.degrees(90))
    }
  }
}

struct RightOfGrid: View {
  @Binding var vMap:[Int64]
  let point = Pointy.shared
  let scene21 = GameScene2.shared
  var body: some View {
    VStack(spacing: 64) {
      Text("save")
        .font(Fonts.touchOfNature(size: textSize))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
        .onTapGesture {
          vMap = scene21.saveVirus()
        }
        .rotationEffect(.degrees(90))
      Button {
        point.cameraLocation.x += 16
        scene21.doCamera()
      } label: {
        Text("right")
        .font(Fonts.touchOfNature(size: textSize - 1))
        .foregroundColor(Color.white)
        .overlay(Image(systemName: "rectangle.roundedtop")
          .resizable()
          .foregroundColor(Color.white)
          .opacity(0.9)
          .frame(width: 72, height: 32, alignment: .center))
          .rotationEffect(.degrees(90))

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
