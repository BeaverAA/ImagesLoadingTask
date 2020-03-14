
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            imageView.image = nil
            updateImageView()
        }
    }

    private func updateImageView() {
        if let url = imageURL {
            let image = ImageStorage.shared.image(for: url)
            if image != nil {
                imageView.image = image
            } else {
                spinner.startAnimating()
                weak var weakSelf = self
                ImageLoader.shared.loadImage(with: url) { (image) in
                    if let image = image {
                        ImageStorage.shared.saveImage(for: url, image: image)
                        DispatchQueue.main.async {
                            if (url == weakSelf?.imageURL) {
                                weakSelf?.imageView.image = image
                                weakSelf?.spinner.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
    }

}
