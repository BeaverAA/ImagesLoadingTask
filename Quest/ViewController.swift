
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let imageLoader = ImageLoader(imagesCount: 10, threadPool: 2)

    var urls = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loadImages(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        urls.append("https://static.21vek.by/img/galleries/556/535/preview_b/80369_dekart_5abf64e590dc4.jpeg")
        urls.append("https://bipbap.ru/wp-content/uploads/2017/05/VOLKI-krasivye-i-ochen-umnye-zhivotnye.jpg")
        urls.append("https://www.wallpaperflare.com/static/965/448/45/moai-easter-island-statues-easter-wallpaper.jpg")
        urls.append("https://s00.yaplakal.com/pics/pics_original/5/7/8/13224875.jpg")
        urls.append("https://www.prikol.ru/wp-content/uploads/2017/10/kartinki-04102017-001.jpg")
        urls.append("https://kartinki.detki.today/wp-content/uploads/2017/08/solnishko-1150x657.jpg")
        urls.append("https://s1.1zoom.ru/big3/593/Cats_Eyes_Glance_Snout_502444.jpg")
        urls.append("https://s1.1zoom.me/big3/717/406233-svetik.jpg")
        urls.append("https://avatars.mds.yandex.net/get-pdb/2296887/9d7b093a-b5ef-4b80-ba6b-669937d4834a/s1200")
        urls.append("https://look.com.ua/pic/201511/1024x600/look.com.ua-138164.jpg")

        collectionView.reloadData()
    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell

        imageLoader.loadImage(with: URL(string: urls[indexPath.row])!, for: cell, at: indexPath) { (images) in
            DispatchQueue.main.async {
                for cell in collectionView.visibleCells {
                    guard let cell = cell as? ImageCollectionViewCell, let indexPath = collectionView.indexPath(for: cell) else { return }
                    cell.image.image = images[indexPath.row]
                }
            }
        }

        return cell
    }

}

