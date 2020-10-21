
import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var textView: UIView!
    
    func setupCell(track: Track) {
        layer.cornerRadius = 12
        cellImage.sd_setImage(with: URL(string: track.album.coverXl!)!)
        artistNameLabel.text = track.artist.name
        songNameLabel.text = track.title
    }
}
