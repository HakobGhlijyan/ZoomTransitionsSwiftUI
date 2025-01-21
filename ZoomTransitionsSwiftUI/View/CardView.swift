//
//  CardView.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI

struct CardView: View {
    @Environment(SharedModel.self) private var sharedModel
    @Binding var video: Video
    let screenSize: CGSize

     var body: some View {
         GeometryReader {
             let size = $0.size
             
             if let thumbnail = video.thumbnail {
                 Image(uiImage: thumbnail)
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: size.width, height: size.height)
                     .clipShape(.rect(cornerRadius: 15))
             } else {
                 RoundedRectangle(cornerRadius: 15, style: .continuous)
                     .fill(.fill)
                     .task(priority: .high) {
                         await sharedModel.generateThumbnail($video, size: screenSize)
                     }
             }
         }
    }
}
