
import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageForBackground: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    var musicTimer: Int = 0
    
    var allTracksViewModel: AllTracksViewModel?
    var rowPosition: Int?
    var linkForTrack: String?
    var isAudioPaused = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        allTracksViewModel?.player?.pause()
    }
    
    func setupScreen() {
        setupCurrentTrackDetails()
        timerLabel.text = "00:00"
        playPauseButton.isEnabled = true
        playPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        progressBar.progress = 0
        isAudioPaused = true
        addBlurToBackground()
        allTracksViewModel?.setupPlayer(withIndex: rowPosition ?? 0)
    }
    
    func setupCurrentTrackDetails() {
        guard let index = rowPosition else { return }
        mainImage.sd_setImage(with: URL(string: allTracksViewModel?.allTracks[index].album.coverXl ?? "")!)
        imageForBackground.sd_setImage(with: URL(string: allTracksViewModel?.allTracks[index].album.coverXl ?? "g")!)
        songName.text = allTracksViewModel?.allTracks[index].title
        artistName.text = allTracksViewModel?.allTracks[index].artist.name
        let seconds = allTracksViewModel?.allTracks[index].duration
        duration.text = allTracksViewModel?.secondsToTotalDurationTime(seconds: seconds!)
    }
    
    func addBlurToBackground(){
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        blurredView.frame = self.imageForBackground.bounds
        blurredView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageForBackground.addSubview(blurredView)
    }
    
    func runMusicTimer() {
        switch true {
        case musicTimer < 10:
            timerLabel.text = "00:0\(String(musicTimer))"
        case musicTimer == 30:
            playPauseButton.isEnabled = false
            fallthrough
        default:
            timerLabel.text = "00:\(String(musicTimer))"
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            let progressValue = (allTracksViewModel?.player?.currentItem!.currentTime().seconds ?? 0.0) / 30
            progressBar.setProgress(Float(progressValue), animated: true)
            musicTimer = Int((allTracksViewModel?.player?.currentItem!.currentTime().seconds)!)
            runMusicTimer()
            if progressValue >= 1 {
                timer.invalidate()
            }
        }
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        if isAudioPaused {
            allTracksViewModel?.player?.play()
            isAudioPaused = false
            sender.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            startTimer()
        } else {
            allTracksViewModel?.player?.pause()
            isAudioPaused = true
            sender.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    
    @IBAction func playPreviousTrack(_ sender: UIButton) {
        rowPosition = rowPosition! - 1
        if rowPosition == 0 {
         rowPosition = (allTracksViewModel?.allTracks.count)! - 1
        }
        setupScreen()
    }
    
    @IBAction func playNextTrack(_ sender: UIButton) {
        rowPosition = rowPosition! + 1
        if rowPosition == (allTracksViewModel?.allTracks.count)! - 1 {
            rowPosition = 0
        }
        setupScreen()
    }
}
