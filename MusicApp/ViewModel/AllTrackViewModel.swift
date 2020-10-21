

import Foundation
import UIKit
import AVFoundation

class AllTracksViewModel {
    var allTracks = [Track]()
    var player: AVPlayer?
    let searchController = UISearchController(searchResultsController: nil)

    func getAllTracks(searchText: String, onCompletion: @escaping ()->()) {
        NetworkRequest.executeRequest(searchText: searchText) { allData in
            self.allTracks = allData.data
            onCompletion()
        }
    }
    
    func setupSearchController(vc: UIViewController) {
        searchController.searchResultsUpdater = vc as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.textColor = .white
        vc.navigationItem.searchController = searchController
        vc.definesPresentationContext = true
    }

    func secondsToTotalDurationTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainedSeconds = seconds % 60
        let timer = String(minutes) + ":" + String(remainedSeconds)
        return timer
    }
    
    func setupPlayer(withIndex index: Int) {
        let path = allTracks[index].preview
        let url = URL(string: path ?? "")
        let playerItem  = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
    }
}
