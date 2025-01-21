//
//  VideoPlayerView.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let video: Video
    @State private var player: AVPlayer?
    
    var body: some View {
        CustomVideoPlayerView(player: $player)
            .onAppear(perform: {
                guard player == nil else { return }
                player = AVPlayer(url: video.fileUrl)
            })
            .onDisappear(perform: {
                player?.pause()
            })
            .onScrollVisibilityChange { isVisible in
                if isVisible {
                    player?.play()
                } else {
                    player?.pause()
                }
            }
            .onGeometryChange(for: Bool.self) { proxy in
                let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                let height = proxy.size.height * 0.97
                
                return -minY > height || minY > height
            } action: { newValue in
                if newValue {
                    player?.pause()
                    player?.seek(to: .zero)
                }
            }
    }
}
