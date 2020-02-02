//
//  ImageLoader.swift
//  Quest
//
//  Created by Anton Bobr on 1/28/20.
//  Copyright © 2020 anton bobr. All rights reserved.
//

import UIKit

class ImageLoader {

    let imagesCount : Int
    let imageLoadingQueue : DispatchQueue
    let semaphore : DispatchSemaphore

    var currentCountImagesLoaded = 0
    var images : [UIImage?]
    var isImageLoading : [Bool]

    init(imagesCount : Int, threadPool : Int) {
        self.imagesCount = imagesCount
        semaphore = DispatchSemaphore(value: threadPool)
        images = [UIImage?](repeating: nil, count: imagesCount)
        isImageLoading = [Bool](repeating: false, count: imagesCount)
        imageLoadingQueue = DispatchQueue(label: "com.bobr.quest.image_loading")
    }

    func loadImage(with url : URL, for cell : ImageCollectionViewCell, at indexPath : IndexPath, callback : @escaping (_ images : [UIImage?]) -> Void) {

        imageLoadingQueue.sync {
            guard currentCountImagesLoaded != imagesCount else {
                cell.image.image = images[indexPath.row]
                return
            }

            guard isImageLoading[indexPath.row] == false else { return }

            isImageLoading[indexPath.row] = true

            let session = URLSession(configuration: .default)
            let sessionTask = session.dataTask(with: url){ [weak self] (data, response, error) in
                guard let data = data else { return }

                self?.images[indexPath.row] = UIImage(data: data)
                self?.semaphore.signal()
                self?.imageLoadingQueue.sync {
                    self?.currentCountImagesLoaded += 1
                    if (self?.currentCountImagesLoaded == self?.imagesCount) {
                        guard let images = self?.images else { return }
                        callback(images)
                    }
                }
            }

            DispatchQueue.global().async { [weak self] in
                self?.semaphore.wait()
                sessionTask.resume()
            }
        }

    }

}
