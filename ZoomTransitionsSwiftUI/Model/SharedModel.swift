//
//  SharedModel.swift
//  ZoomTransitionsSwiftUI
//
//  Created by Hakob Ghlijyan on 1/20/25.
//

import SwiftUI
import Observation
import AVKit

@Observable
class SharedModel {
    var video: [Video] = files
    
    func generateThumbnail(_ video: Binding<Video>, size: CGSize) async {
        //This helper method creates a thumbnail image from the video URL at 0 seconds. If you require a thumbnail at a different time, modify the zero value to another time value.
        //Этот вспомогательный метод создает уменьшенное изображение из URL-адреса видео за 0 секунд. Если вам требуется уменьшенное изображение в другое время, измените нулевое значение на другое значение времени.
        
        do {
            //1 - url File
            let asset = AVURLAsset(url: video.wrappedValue.fileUrl)
            //2 - generator image
            let generator = AVAssetImageGenerator(asset: asset)
            
            //3
            generator.maximumSize = size
            generator.appliesPreferredTrackTransform = true
            /*
             generator.maximumSize
             
             The maximum size of images to generate.
             Discussion
             The default value is zero, which generates images at the asset’s unscaled dimensions.
             Setting a size scales images to fit their defined bounding boxes. You define the aspect ratio of the scaled image by setting a value for the apertureMode property.
             
             Максимальный размер создаваемых изображений.
             Обсуждение
             Значение по умолчанию равно нулю, что позволяет создавать изображения в немасштабированных размерах объекта.
             При установке размера изображения масштабируются так, чтобы они соответствовали определенным ограничивающим рамкам. Вы определяете соотношение сторон масштабируемого изображения, устанавливая значение для свойства apertureMode.
             
             
             generator.appliesPreferredTrackTransform
             
             Discussion
             The default value is false. This class only supports rotation by 90, 180, or 270 degrees.
             The image generator ignores this property if you set a value for the videoComposition property.
             
             Обсуждение
             Значение по умолчанию равно false. Этот класс поддерживает поворот только на 90, 180 или 270 градусов.
             Генератор изображений игнорирует это свойство, если вы задаете значение для свойства videoComposition.
             */
            
            //4 - time for generate
            let cgImage = try await generator.image(at: .zero).image
            /*
             Generates an image for a requested time.
             Parameters
             time
             A time in the asset timeline at which to create an image.
             Return Value
             A tuple that contains the image and the time the asset was created.
             
             Генерирует изображение на заданное время.
             Параметры
             время
             Время создания изображения на временной шкале ресурса.
             Возвращаемое значение
             Кортеж, содержащий изображение и время создания ресурса.
             */
             
            //5 - generate color by image based .. -> deviceColorBasedImage: CGImage
            guard let deviceColorBasedImage = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else { return }
            /*
             Creates a device-dependent RGB color space.
             Return Value
             A device-dependent RGB color space. You are responsible for releasing this object by calling CGColorSpaceRelease. If unsuccessful, returns NULL.
             Discussion
             Colors in a device-dependent color space are not transformed or otherwise modified when displayed on an output device—that is, there is no attempt to maintain the visual appearance of a color. As a consequence, colors in a device color space often appear different when displayed on different output devices. For this reason, device color spaces are not recommended when color preservation is important.
             
             Создает цветовое пространство RGB, зависящее от устройства.
             Возвращает значение
             Цветовое пространство RGB, зависящее от устройства. Вы несете ответственность за освобождение этого объекта, вызвав CGColorSpaceRelease. В случае неудачи возвращает значение NULL.
             Обсуждение
             Цвета в цветовом пространстве, зависящем от устройства, не преобразуются и не модифицируются иным образом при отображении на устройстве вывода, то есть не предпринимается попыток сохранить визуальный вид цвета. Как следствие, цвета в цветовом пространстве устройства часто выглядят по-разному при отображении на разных устройствах вывода. По этой причине не рекомендуется использовать цветовые пространства устройств, когда важно сохранить цвет.
             
             */
            
            //6 - image for generated colors -> return UIImage
            let thumbnail = UIImage(cgImage: deviceColorBasedImage)
            
            //7 - add in
            await MainActor.run {
                video.wrappedValue.thumbnail = thumbnail
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
