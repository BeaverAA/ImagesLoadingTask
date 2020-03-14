//
//  ImageStorage.swift
//  Quest
//
//  Created by Anton Bobr on 3/11/20.
//  Copyright © 2020 anton bobr. All rights reserved.
//

import UIKit

class ImageStorage {

    private let queue = DispatchQueue(label: "com.bobr.quest.image_storage")
    private var images = [URL : UIImage]()

    static let shared = ImageStorage()

    private init() {}

    func saveImage(for url: URL, image: UIImage) {
        queue.sync {
            images[url] = image
        }
    }

    func image(for url: URL) -> UIImage? {
        var result: UIImage?
        queue.sync {
            result = images[url]
        }
        return result
    }

}
