//
//  ImageLoader.swift
//  Quest
//
//  Created by Anton Bobr on 1/28/20.
//  Copyright © 2020 anton bobr. All rights reserved.
//

import UIKit

class ImageLoader {

    private let imageLoadingQueue : DispatchQueue
    private let semaphore : DispatchSemaphore

    static let shared = ImageLoader()

    private init() {
        semaphore = DispatchSemaphore(value: 2)
        imageLoadingQueue = DispatchQueue(label: "com.bobr.quest.image_loading", qos: .userInitiated, attributes: .concurrent)
    }

    func loadImage(with url : URL, complte : @escaping (_ image : UIImage?) -> Void) {
        weak var weakSelf = self
        imageLoadingQueue.async {
            weakSelf?.semaphore.wait()
            let session = URLSession(configuration: .default)
            let sessionTask = session.dataTask(with: url){ (data, response, error) in
                var image: UIImage? = nil

                if let error = error {
                    NSLog(error.localizedDescription)
                }
                if let data = data {
                    image = UIImage(data: data)
                }
                complte(image)

                weakSelf?.semaphore.signal()
            }
            sessionTask.resume()
        }
    }

}
