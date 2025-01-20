//
//  CustomVideoPlayerView.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewControllerRepresentable {
    // player kotoromu budet privyazka
    @Binding var player: AVPlayer?
    
    //ETI 2 func obyazatelni dlya otobrojeniya UIKIT elenemta AVKit
    
    // ui sozdayom
    // sozdayom avplayer
    // naznchaem nash player , tot kotoriy budet upravlyat
    // knopki upravleniya otkluchaem
    // i delaem video chtom polnostyu fill ves ekram
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    // obnovlnenie player
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
