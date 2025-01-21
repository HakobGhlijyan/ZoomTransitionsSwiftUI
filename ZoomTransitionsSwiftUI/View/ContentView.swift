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

#Preview {
    ContentView()
}
