//
//  DetailView.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI
import AVKit

struct DetailView: View {
    @Environment(SharedModel.self) private var sharedModel
    var video: Video
    var animation: Namespace.ID
    @State private var hidesThumbnail: Bool = false
    /*
     As you can see, when the detail view content is changed, the transition is settling back to the same source view from which it originated. This can be easily solved by changing the id in the navigationTransition modifier, but in order to do that, we must know which id is currently active. To do that, we can use the scrollPosition Modifier.
     Как вы можете видеть, при изменении содержимого подробного представления переход возвращается к тому же исходному представлению, из которого он был создан. Это можно легко решить, изменив идентификатор в модификаторе navigationTransition, но для этого мы должны знать, какой идентификатор активен в данный момент. Для этого мы можем использовать модификатор scrollPosition.
     */
    @State private var scrollID: UUID?
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            /*
             The second step is to add the navigation Transition modifier to the detail view, and that's all. With these two modifiers, we can create a zoom transition effect.
             Now, let's use the thumbnail image we created earlier on the detail view, which makes the transition look more like a hero effect.
             
             Вторым шагом является добавление модификатора перехода навигации к подробному представлению, и это все. С помощью этих двух модификаторов мы можем создать эффект перехода с масштабированием.
             Теперь давайте воспользуемся уменьшенным изображением, которое мы создали ранее в режиме детализации, чтобы переход больше походил на эффект героя.
             */
            
            Color.black
            
            //VIDEO
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
            
            //PHOTO
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
                /*
                 A 1.5-second delay is used to settle the transition animations, and once the transition is complete, the scrollview moves to the front of the ZStack, making the view scrollable.
                 Для настройки анимации перехода используется задержка в 1,5 секунды, и как только переход завершен, scrollview перемещается в переднюю часть ZStack, делая вид доступным для прокрутки.
                 */
            }
            /*
             As you can see, the transition now looks like a hero transition. Let's create a scrollview so that we can scroll to change the videos once the detail view is opened.
             Как вы можете видеть, переход теперь выглядит как переход героя. Давайте создадим scrollview, чтобы мы могли прокручивать видео, чтобы изменить их, как только откроется подробный просмотр.
             */
        }
        .ignoresSafeArea()
        .navigationTransition(.zoom(sourceID: hidesThumbnail ? (scrollID ?? video.id) : video.id, in: animation))
    }
}

#Preview {
    ContentView()
}

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
            //onGeometryChange
            /*
            Mi v onGeometryChange
            for eto to chto ya xochu pluchit pri izmenenii
            
            izmenyatya budet prozy znacheie
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let height = proxy.size.height * 0.97
            
            vot nache uslovie kotoroe vozrocahet
            return -minY > height || minY > height
            
        tak mi poluchili min y bolche visoti ili naoborot
            
            takoe znachenie
            
            v acrtion
            
            na a=osnove etiz danix mi i budem
            
            esli tak to true sdelat odno pro newvalue
            
            
            .onGeometryChange(for: <#T##Equatable.Type#>, of: <#T##(GeometryProxy) -> Equatable#>, action: <#T##(Equatable) -> Void##(Equatable) -> Void##(_ newValue: Equatable) -> Void#>)
            .onGeometryChange(for: Bool.Type) { <#GeometryProxy#> in
                <#code#>
            } action: { newValue in
                <#code#>
            }
            
            I just want to add one more addition to this view, which is that when the view is completely moved away, I want to reset the video to the beginning so that when it comes back to play, it will start from the beginning and not from anywhere in the middle.
            Я просто хочу добавить еще одно дополнение к этому представлению, которое заключается в том, что когда изображение полностью удаляется, я хочу вернуть видео к началу, чтобы, когда оно снова начнет воспроизводиться, оно начиналось с самого начала, а не с середины.
            
            
            onGeometryChange(for:of:action:)
            Adds an action to be performed when a value, created from a geometry proxy, changes.

            Parameters
            type
            The type of value transformed from a GeometryProxy.
            transform
            A closure that transforms a GeometryProxy to your type.
            action
            A closure to run when the transformed data changes.
            Discussion
            The geometry of a view can change frequently, especially if the view is contained within a ScrollView and that scroll view is scrolling.
            You should avoid updating large parts of your app whenever the scroll geometry changes. To aid in this, you provide two closures to this modifier:
            transform: This converts a value of GeometryProxy to your own data type.
            action: This provides the data type you created in of and is called whenever the data type changes.
            For example, you can use this modifier to know how much of a view is visible on screen. In the following example, the data type you convert to is a Bool and the action is called whenever the Bool changes.
            
            
            onGeometryChange(for:of:action:)
            Добавляет действие, которое должно выполняться при изменении значения, созданного с помощью прокси-сервера geometry.

            Параметры
            тип
            Тип значения, преобразованного из GeometryProxy.
            преобразовать
            Замыкание, которое преобразует GeometryProxy в ваш тип.
            действие
            Замыкание, запускаемое при изменении преобразованных данных.
            Обсуждение
            Геометрия вида может часто меняться, особенно если вид содержится в ScrollView и этот вид прокрутки является прокручиваемым.
            Вам следует избегать обновления больших частей вашего приложения всякий раз, когда изменяется геометрия прокрутки. Чтобы помочь в этом, вы предоставляете два замыкания для этого модификатора:
            transform: Это преобразует значение GeometryProxy в ваш собственный тип данных.
            действие: Этот параметр определяет тип данных, который вы создали в of, и вызывается при каждом изменении типа данных.
            Например, вы можете использовать этот модификатор, чтобы узнать, какая часть представления отображается на экране. В следующем примере преобразуемый тип данных - это Bool, и действие вызывается всякий раз, когда изменяется значение Bool.
            */
    }
}
