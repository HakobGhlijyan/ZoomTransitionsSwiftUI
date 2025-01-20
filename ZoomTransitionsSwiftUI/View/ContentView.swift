//
//  ContentView.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var sharedModel = SharedModel()
    @Namespace private var animation
    
    var body: some View {
        @Bindable var bindings = sharedModel
        
        GeometryReader {
            let screenSize: CGSize = $0.size
            
            NavigationStack {
                VStack(spacing: 0.0) {
                    HeaderView()
                    
                    ScrollView(.vertical) {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(spacing: 10), count: 2),
                            spacing: 10) {
                                ForEach($bindings.video) { $video in
                                    NavigationLink(value: video) {
                                        CardView(video: $video, screenSize: screenSize)
                                            .environment(sharedModel)
                                            .frame(height: screenSize.height * 0.4)
                                            //Creating a Zoom transition is very simple. First, we need to create a namespace and then use it in the new matchedTransitionSource
                                            .matchedTransitionSource(id: video.id, in: animation) {
                                                $0
                                                    .background(.clear)
                                                    .clipShape(.rect(cornerRadius: 15))
                                            }
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                }
                            }
                            .padding(15)
                    }
                }
                .navigationDestination(for: Video.self) { video in
                    DetailView(video: video, animation: animation)
                        .environment(sharedModel)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
            }
        }
        .overlay {
            Text("Stories")
                .font(.title3.bold())
        }
        .foregroundStyle(.primary)
        .padding(15)
        .background(.ultraThinMaterial)
    }
}

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
                         /*
                          If we utilise the card view size, the thumbnail max resolution will be the same as the card size, but this image will be used for zoom transitions in the detail view. Thus, if we utilise these sizes, the image will be pixelated in the detail view, and because the detail view will extend to its full screen size, creating thumbnails for the screen size will be appropriate.
                          
                          Если мы используем размер изображения на карточке, максимальное разрешение миниатюр будет таким же, как и на карточке, но это изображение будет использоваться для изменения масштаба при детальном просмотре. Таким образом, если мы используем эти размеры, изображение будет пикселизированным при детальном просмотре, а поскольку детальный просмотр расширится до полного размера экрана, будет уместно создать миниатюры для соответствующего размера экрана.
                          */
                         await sharedModel.generateThumbnail($video, size: screenSize)
                     }
             }
         }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
    }
}

#Preview {
    ContentView()
}
