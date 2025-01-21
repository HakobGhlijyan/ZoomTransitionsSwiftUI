//
//  DetailView.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(SharedModel.self) private var sharedModel
    var video: Video
    var animation: Namespace.ID
    @State private var hidesThumbnail: Bool = false
    @State private var scrollID: UUID?
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Color.black
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(sharedModel.video) { video in
                        VideoPlayerView(video: video)
                            .frame(width: size.width, height: size.height)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollID)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .zIndex(hidesThumbnail ? 1 : 0)
            
            if let thumbnail = video.thumbnail , !hidesThumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
                    .task {
                        scrollID = video.id
                        try? await Task.sleep(for: .seconds(0.15))
                        hidesThumbnail = true
                    }
            }
        }
        .ignoresSafeArea()
        .navigationTransition(.zoom(sourceID: hidesThumbnail ? (scrollID ?? video.id) : video.id, in: animation))
    }
}

#Preview {
    ContentView()
}
