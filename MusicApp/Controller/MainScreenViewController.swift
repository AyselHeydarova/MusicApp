import UIKit
import SDWebImage

class MainScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var allTracksViewModel = AllTracksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allTracksViewModel.getAllTracks(searchText: "popular") {
            self.collectionView.reloadData()
        }
        title = "Discover music"
        allTracksViewModel.setupSearchController(vc: self)
        setupCollectionView()
        design()
        }
    
    func design(){
        navigationController?.navigationBar.standardAppearance.backgroundColor = backgroundColor
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        view.backgroundColor = backgroundColor
        collectionView.backgroundColor = backgroundColor
    }
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTracksViewModel.allTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width / 2) - 30, height: (self.view.frame.width / 2) - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackCollectionViewCell
        cell.cellImage.sd_setImage(with: URL(string: allTracksViewModel.allTracks[indexPath.row].album.coverXl)!)
        cell.artistNameLabel.text = allTracksViewModel.allTracks[indexPath.row].artist.name
        cell.songNameLabel.text = allTracksViewModel.allTracks[indexPath.row].title
        cell.layer.cornerRadius = 30
        cell.textView.backgroundColor = backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let playerScreen = storyboard?.instantiateViewController(identifier: "DetailsViewController") as!
        DetailsViewController
        playerScreen.allTracksViewModel = self.allTracksViewModel
        playerScreen.rowPosition = indexPath.row
        present(playerScreen, animated: true)
    }
}

extension MainScreenViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        allTracksViewModel.getAllTracks(searchText: searchController.searchBar.text!) {
            self.collectionView.reloadData()
        }
    }
}

