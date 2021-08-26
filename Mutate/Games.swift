//
//  Games.swift
//  Mutate
//
//  Created by localadmin on 24.08.21.
//

import Foundation
import GameKit
import UIKit
import SwiftUI

var vc:GKMatchmakerViewController!

class SimpleViewController: UIViewController, GKLocalPlayerListener {

  let minPlayers = 2
  let maxPlayers = 4
  
  
  
  @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    // do nothing
    print("gc finished")
    self.dismiss(animated: true) {
      // ciao babe
    }
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      GKLocalPlayer.local.authenticateHandler = { [self] gcAuthVC, error in
      if GKLocalPlayer.local.isAuthenticated {
        GKLocalPlayer.local.register(self)
        print("Authenticated to Game Center!")

//        GKMatchmaker.shared().cancel()
        
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = "Mutant Anyone?"
        request.defaultNumberOfPlayers = 2
        request.recipientResponseHandler = { player, response in
          print("accepted")
        }
        
        vc = GKMatchmakerViewController(matchRequest: request)
        vc.matchmakerDelegate = self
//        vc!.delegate = self
        present(vc, animated: true)
          
//        GameCenter is Apple's social gaming network!
//          game discoverability, players profiles

          


//          Friends API iOS 14 Add friends button on screen [use SF symbols]
//          Fast Start iOS 14
//          competition or connection

//


//        Support several types of multiplayer games
//          realtime, turnbased and server hosted
//            mutlple ways to find other players, auto-match, friends, contacts, recently played, nearby, game players groups, message groups
//              works cross platform mac & iphone & ipad & appleTV
          
//          let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
//          vc.delegate = self

//          let vc = GKGameCenterViewController()
//          vc.delegate = self
//          present(vc, animated: true)
//
//          GKLeaderboard.submitScore(0, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["topPlayers"]) { error in
//            //submitted score
//          }
//          let vc2 = GKGameCenterViewController(state: .leaderboards)
//          vc2.gameCenterDelegate = self
//          present(vc2, animated: true) {
//            // presenting leaderboard
//          }
//        or
//          let vc3 = GKGameCenterViewController(leaderboardID: "topPlayers", playerScope: .global, timeScope: .allTime)
//          vc3.gameCenterDelegate = self
//          present(vc3, animated: true) {
//            // presenting custom leaderboard
//          }

//        An achivement is a collectable item, indicating the player has successfully reached a particular goal in your game
//          4 states locked, in progress, complete & [hidden for surprise players]
//          maximum 100 achivements each can award 100 more points, up to 1000 bonus points can be achived
//          range skills + dedication to mind, don't use all at once!
          
//            let percentComplete = 50.0
//            let achievement = GKAchievement(identifier: "blah")
//            achievement.percentComplete = percentComplete
//            GKAchievement.report([achievement]) { error in
//              if let error = error {
//                  print("error ",error)
//                }
//            }
            
//            // show achivements page
//            let vc4 = GKGameCenterViewController(state: .achievements)
//            vc4.gameCenterDelegate = self
//            present(vc4, animated: true) {
//              // say something
//            }

//            Custom achivements shown, will be localised
//              var identifier: String { get set }
//              var title: String { get set }
//              var unachievedDescription: String { get set }
//              var achievedDescription: String { get set }
//            + APIs for images achived + failed
        
      } else if let vc = gcAuthVC {
        self.present(vc, animated: true)
      }
      else {
        print("Error authentication to GameCenter: " +
          "\(error?.localizedDescription ?? "none")")
      }
    }
    
    
      
  }
  
  
  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 128, height: 64))
//    label.text = "Hello World"
//    label.textColor = .white
//    self.view.addSubview(label)
//  }
}


extension SimpleViewController: GKMatchmakerViewControllerDelegate, GKMatchDelegate, UINavigationControllerDelegate, GKGameCenterControllerDelegate, GKInviteEventListener, GKTurnBasedEventListener {
    
  func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
    print("------------------")
  }
    
    func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
      print("++++++++++++++++++++")
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
//      GKMatchmaker.shared().findPlayers(forHostedRequest: <#T##GKMatchRequest#>) { [], error in
//        <#code#>
//      }
//      GKMatchmaker.shared().addPlayers(to: <#T##GKMatch#>, matchRequest: <#T##GKMatchRequest#>) { error in
//        <#code#>
//      }
      
        self.dismiss(animated: true, completion: {
            print("foobar", player,invite)
//            GKLocalPlayer.local.register(self)
//
//
//            let vc = GKMatchmakerViewController(invite: invite)
//            vc?.delegate = self
//            self.present(vc!, animated: true)
        })
    }
    
   func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        self.dismiss(animated: true)
        match.delegate = self
        
        print("matchmakerViewController ")

    }
  
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, hostedPlayerDidAccept player: GKPlayer) {
      print("matchmakerViewController")
      self.dismiss(animated: true, completion: {
            print("player ",player)
        })
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFindHostedPlayers players: [GKPlayer]) {
      print("matchmakerViewController")
      self.dismiss(animated: true, completion: {
            print("player ",players)
        })
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        self.dismiss(animated: true)
        print("matchmakerViewControllerWasCancelled")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
    
  func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
    print("match")
  }
  
  func match(_ match: GKMatch, didFailWithError error: Error?) {
    print("didFailWithError")
  }
  
  func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
    print("shouldReinviteDisconnectedPlayer")
    return true
  }
  
  func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
    print("didReceive")
  }
  
  func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
    print("didReceive")
  }
    
}

struct GameView: UIViewControllerRepresentable {
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    // later
  }
  
  func makeUIViewController(context: Context) -> UIViewController {
    let gameOn = SimpleViewController()
    return gameOn
  }
  
  typealias UIViewControllerType = UIViewController
}
