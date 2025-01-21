//
//  Video.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI

struct Video: Identifiable, Hashable {
    var id: UUID = .init()
    var fileUrl: URL
    var thumbnail: UIImage?
}

let files = [
    URL(filePath: Bundle.main.path(forResource: "Video1", ofType: "mp4") ?? ""),
    // Video https://www.pexels.com/video/sunset-over-sea-and-city-11359609/
    URL(filePath: Bundle.main.path(forResource: "Video2", ofType: "mp4") ?? ""),
    // Video https://www.pexels.com/video/a-rocky-river-in-the-forest-5896379/
    URL(filePath: Bundle.main.path(forResource: "Video3", ofType: "mp4") ?? ""),
    // Video https://www.pexels.com/video/sea-foam-coming-to-the-seashore-5085845/
    URL(filePath: Bundle.main.path(forResource: "Video4", ofType: "mp4") ?? ""),
    // Video https://www.pexels.com/video/panning-shot-of-the-sea-at-sunset-6202759/
    URL(filePath: Bundle.main.path(forResource: "Video5", ofType: "mp4") ?? ""),
    // Video https://www.pexels.com/video/slow-motion-footage-of-multnomah-falls-7297870/
    URL(filePath: Bundle.main.path(forResource: "Video6", ofType: "mp4") ?? ""),
    // Video https://www.pexels.com/video/view-from-flying-airplane-at-sunset-9669392/
]
    .compactMap({ Video(fileUrl: $0)})
