//
//  ViewController.swift
//  LoFi Radio
//
//  Created by Matthew Lock on 15/03/2022.
//

import UIKit
import AVFoundation
import youtube_ios_player_helper
import MediaPlayer

class ViewController: UIViewController, YTPlayerViewDelegate {
    
    private var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerItem: AVPlayerItem!
    private var playerLooper: AVPlayerLooper!

    var playerView: YTPlayerView!
    var isPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        view.addSubview(header)
        
        setupVideoPlayer()
        setUpPlayButton()
        setupVolumeSlider()
        setUpAboutButton()
        playerView = YTPlayerView()
        playerView.delegate = self
        playerView.load(withVideoId: "5qap5aO4i9A")
        view.addSubview(playerView)
    }
    
    func setUpAboutButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        button.center = CGPoint(x: 70, y: 70)
        button.titleLabel!.font = UIFont(name: "Chrome Syrup", size: 25)
        button.setTitle("About", for: .normal)
        button.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0).cgColor
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showAboutScreen))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        button.addGestureRecognizer(gesture)
        self.view.addSubview(button)
    }
    
    @objc func showAboutScreen() {
        let vc = AboutViewController()
        let presentationVC = vc.presentationController as? UISheetPresentationController
        presentationVC!.detents = [.medium()]
        self.present(vc, animated: true)
    }
    
    let header: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center = CGPoint(x: 210, y: 160)
        label.textAlignment = .center
        label.font = UIFont(name: "Chrome Syrup", size: 80)
        label.textColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0)
        label.text = "Lofi Radio"
        return label
    }()
    
    func setupVideoPlayer() {
        let path = Bundle.main.path(forResource: "LofiGirlDay", ofType: "mp4")
        let pathURL = URL(fileURLWithPath: path!)
        let duration = Int64( ( (Float64(CMTimeGetSeconds(AVAsset(url: pathURL).duration)) *  10.0) - 1) / 10.0 )

        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerItem = AVPlayerItem(url: pathURL)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem,
                                      timeRange: CMTimeRange(start: CMTime.zero, end: CMTimeMake(value: duration, timescale: 1)) )
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = CGRect(x: 60, y: 260, width: 300, height: 300)
        playerLayer.masksToBounds = true
        playerLayer.cornerRadius = 10
        view.layer.insertSublayer(playerLayer, at: 1)
        playerLayer.borderWidth = 3
        playerLayer.borderColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0).cgColor
        player.play()
        player.isMuted = true
    }
    
    func setUpPlayButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        button.center = CGPoint(x: 210, y: 670)
        button.titleLabel?.center = CGPoint(x: 0, y: 0)
        button.titleLabel!.font = UIFont(name: "Chrome Syrup", size: 40)
        isPlaying ? button.setTitle("Pause", for: .normal) : button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
        button.layer.borderWidth = 2
        isPlaying ? (button.layer.borderColor = UIColor(red: 202/255, green: 49/255, blue: 39/255, alpha: 1).cgColor) : (button.layer.borderColor = UIColor(red: 5.0/255, green: 93.0/255, blue: 76/255, alpha: 1).cgColor)
        button.contentVerticalAlignment = .fill
        //button.contentHorizontalAlignment = .fill
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = button.frame.size.width / 2
        button.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(playPause))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        button.addGestureRecognizer(gesture)
        self.view.addSubview(button)
    }
    
    @objc func playPause() {
        if isPlaying == false {
            playerView.playVideo()
            isPlaying = true
            setUpPlayButton()
        } else {
            playerView.pauseVideo()
            isPlaying = false
            setUpPlayButton()
        }
    }
    
    func setupVolumeSlider() {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 360, height: 20))
        slider.center = (CGPoint(x: 210, y: 800))
        slider.value = 0.5
        slider.tintColor = .brown
        slider.thumbTintColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0)
        slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider!) {
        MPVolumeView.setVolume(sender.value)
    }
    
        
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
