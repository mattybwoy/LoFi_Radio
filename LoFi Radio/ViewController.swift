//
//  ViewController.swift
//  LoFi Radio
//
//  Created by Matthew Lock on 15/03/2022.
//

import UIKit
import AVFoundation
import youtube_ios_player_helper

class ViewController: UIViewController, YTPlayerViewDelegate {
    
    private var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerItem: AVPlayerItem!
    private var playerLooper: AVPlayerLooper!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        view.addSubview(header)
        
        setupVideoPlayer()
        playPause()
        let playerView = YTPlayerView()
        playerView.delegate = self
        playerView.load(withVideoId: "5qap5aO4i9A")
        view.addSubview(playerView)
    }
    
    let header: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center = CGPoint(x: 210, y: 140)
        label.textAlignment = .center
        label.font = UIFont(name: "Chrome Syrup", size: 70)
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
        playerLayer.frame = CGRect(x: 60, y: 220, width: 300, height: 300)
        playerLayer.masksToBounds = true
        playerLayer.cornerRadius = 10
        view.layer.insertSublayer(playerLayer, at: 1)
        
        player.play()
        player.isMuted = true
    }
    
    func playPause() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        button.center = CGPoint(x: 210, y: 630)
        button.titleLabel?.center = CGPoint(x: 0, y: 0)
        button.titleLabel!.font = UIFont(name: "Chrome Syrup", size: 40)
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 5.0/255, green: 93.0/255, blue: 76/255, alpha: 1).cgColor
        button.contentVerticalAlignment = .fill
        //button.contentHorizontalAlignment = .fill
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = button.frame.size.width / 2
        button.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        self.view.addSubview(button)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

}
