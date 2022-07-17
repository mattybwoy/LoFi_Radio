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
import Solar
import CoreLocation

class ViewController: UIViewController, YTPlayerViewDelegate {
    
    private var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerItem: AVPlayerItem!
    private var playerLooper: AVPlayerLooper!
    
    var playerView: YTPlayerView!
    var isPlaying: Bool = false
    var path: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        view.addSubview(header)
        view.addSubview(mode)
        view.addSubview(aboutButton)
        view.addSubview(volumeSlider)
        view.addSubview(playButton)
        findOutSunriseSunset()
        playerView = YTPlayerView()
        playerView.delegate = self
        playerView.load(withVideoId: "jfKfPfyJRdk")
        view.addSubview(playerView)
    }
    
    let aboutButton: UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        button.center = CGPoint(x: 70, y: 70)
        button.titleLabel!.font = UIFont(name: "Chrome Syrup", size: 25)
        button.setTitle("About", for: .normal)
        button.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0).cgColor
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        button.addTarget(self, action: #selector(showAboutScreen), for: .touchUpInside)
        return button
    }()
    
    @objc func showAboutScreen() {
            let vc = AboutViewController()
            if let sheet = vc.presentationController as? UISheetPresentationController {
                sheet.preferredCornerRadius = 25
                sheet.detents = [.medium()]
            }
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
    
    let mode: UISwitch = {
        var toggle = UISwitch(frame: CGRect(x: 330, y: 55, width: 100, height: 100))
        toggle.isAccessibilityElement = false
        toggle.addTarget(self, action: #selector(switchMode), for: .valueChanged)
        toggle.setOn(true, animated: false)
        toggle.onTintColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        toggle.tintColor = UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0)
        toggle.thumbTintColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0)
        toggle.subviews[0].subviews[0].backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        return toggle
    }()
    
    @objc func switchMode(_ sender: UISwitch!) {
        if (sender.isOn == true) {
            view.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
            header.textColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0)
            aboutButton.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
            aboutButton.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
            aboutButton.layer.borderColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0).cgColor
            playerLayer.borderColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0).cgColor
            playButton.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
            playButton.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
            volumeSlider.tintColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        } else {
            view.backgroundColor = UIColor(red: 30/255, green: 26/255, blue: 23/255, alpha: 1)
            header.textColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
            aboutButton.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
            aboutButton.setTitleColor(UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1), for: .normal)
            aboutButton.layer.borderColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0).cgColor
            playerLayer.borderColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0).cgColor
            playButton.setTitleColor(UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1), for: .normal)
            playButton.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
            volumeSlider.tintColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        }
    }
    
    func findOutSunriseSunset() {
        let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: 51.528308, longitude: -0.1340267))
        guard let solar = solar else {
            return
        }
        let sunrise = (Calendar.current.component(.hour, from: solar.sunrise!))
        let sunset = (Calendar.current.component(.hour, from: solar.sunset!))
        setTime(sunriseHour: sunrise, sunsetHour: sunset)
    }
    
    func setTime(sunriseHour: Int, sunsetHour: Int) {
        let today = Date()
        let currentHour = (Calendar.current.component(.hour, from: today))
        path = currentHour > sunriseHour && currentHour < sunsetHour ? Bundle.main.path(forResource: "LofiGirlDay", ofType: "mp4") : Bundle.main.path(forResource: "LofiGirlNight", ofType: "mp4")
        setupVideoPlayer(time: path)
    }
    
    func setupVideoPlayer(time: String?) {
        let pathURL = URL(fileURLWithPath: time!)
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
    
    let playButton : UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        button.center = CGPoint(x: 210, y: 670)
        button.titleLabel?.center = CGPoint(x: 0, y: 0)
        button.titleLabel!.font = UIFont(name: "Chrome Syrup", size: 40)
        button.setTitleColor(UIColor(red: 219/255, green: 188/255, blue: 131/255, alpha: 1.0), for: .normal)
        button.layer.borderWidth = 2
        button.contentVerticalAlignment = .fill
        button.layer.borderColor = UIColor(red: 5.0/255, green: 93.0/255, blue: 76/255, alpha: 1).cgColor
        button.setTitle("Play", for: .normal)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = button.frame.size.width / 2
        button.backgroundColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        button.addTarget(self, action: #selector(playPause), for: .touchUpInside)
        return button
    }()
    
    @objc func playPause() {
        if isPlaying == false {
            playerView.playVideo()
            playButton.layer.borderColor = UIColor(red: 202/255, green: 49/255, blue: 39/255, alpha: 1).cgColor
            playButton.setTitle("Pause", for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.playerLayer.frame = CGRect(x: 50, y: 250, width: 320, height: 320)
            }
            isPlaying = true
        } else {
            playerView.pauseVideo()
            playButton.layer.borderColor = UIColor(red: 5.0/255, green: 93.0/255, blue: 76/255, alpha: 1).cgColor
            playButton.setTitle("Play", for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.playerLayer.frame = CGRect(x: 60, y: 260, width: 300, height: 300)
            }
            isPlaying = false
        }
        player.play()
        player.isMuted = true
    }
    
    let volumeSlider: UISlider = {
        var slider = UISlider(frame: CGRect(x: 0, y: 0, width: 360, height: 20))
        slider.center = (CGPoint(x: 210, y: 800))
        slider.value = 0.5
        slider.tintColor = UIColor(red: 75.0/255, green: 35/255, blue: 27.0/255, alpha: 1)
        slider.thumbTintColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
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
