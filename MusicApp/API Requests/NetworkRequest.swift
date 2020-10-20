
import Foundation
import Alamofire

class NetworkRequest {
    
    static func executeRequest(searchText: String,onCompletion: @escaping (AllData) -> ()){
        
        let headers: HTTPHeaders =
            [
                "x-rapidapi-host": "deezerdevs-deezer.p.rapidapi.com",
                "x-rapidapi-key": "bffd7e7b7cmshe7060b24d80d5f9p1e931ajsn7fb8704664bc"
            ]
        let url = "https://rapidapi.p.rapidapi.com/search?q=\(searchText)"
        let request = AF.request(url, method: .get, headers: headers)
        request.responseDecodable(of: AllData.self) { (response) in
            guard let allSongs = response.value else { return }
            onCompletion(allSongs)
        }
    }
}
