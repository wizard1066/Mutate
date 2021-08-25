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

class SimpleViewController: UIViewController, UINavigationControllerDelegate, GKGameCenterControllerDelegate, GKLocalPlayerListener {

  let minPlayers = 1
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

          let request = GKMatchRequest()
          request.minPlayers = minPlayers
          request.maxPlayers = maxPlayers
          request.inviteMessage = "Mutant Anyone?"
          
          let vc = GKMatchmakerViewController(matchRequest: createRequest())
          vc!.delegate = self
          present(vc!, animated: true)
          
          
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


extension SimpleViewController: GKMatchmakerViewControllerDelegate {

  

  private func createMatchmaker(withInvite invite: GKInvite? = nil) -> GKMatchmakerViewController? {
        
        //If there is an invite, create the matchmaker vc with it
        if let invite = invite {
            return GKMatchmakerViewController(invite: invite)
        }
        
        return GKMatchmakerViewController(matchRequest: createRequest())
    }
    
    private func createRequest() -> GKMatchRequest {
        print("new request")
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = "Mutant Anyone?"
        return request
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        print("matchmakerViewController")
//        delegate?.presentGame(match: match)
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        self.dismiss(animated: true, completion: {
            print("player ",invite)
//            self.presentMatchmaker(withInvite: invite)
        })
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
        print("matchmakerViewControllerWasCancelled")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
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
