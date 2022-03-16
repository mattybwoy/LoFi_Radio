//
//  ViewController.swift
//  LoFi Radio
//
//  Created by Matthew Lock on 15/03/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerItem: AVPlayerItem!
    private var playerLooper: AVPlayerLooper!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        view.addSubview(header)
        setupVideoPlayer()
        
    }
    
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
        view.layer.insertSublayer(playerLayer, at: 1)
        player.play()
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
    
    

}
