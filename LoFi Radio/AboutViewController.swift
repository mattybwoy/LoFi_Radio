//
//  AboutViewController.swift
//  LoFi Radio
//
//  Created by Matthew Lock on 17/03/2022.
//

import UIKit

class AboutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(header)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView?.frame = self.view.bounds
        self.blurEffectView?.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurEffectView, at: 0)
        UIView.animate(withDuration: 0.8) {
            self.view.alpha = 1
        }
    }
    
    let header: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.center = CGPoint(x: 210, y: 65)
        label.textAlignment = .center
        label.font = UIFont(name: "Chrome Syrup", size: 50)
        label.textColor = UIColor(red: 25.0/255, green: 85.0/255, blue: 80.0/255, alpha: 1.0)
        label.text = "About"
        return label
    }()


}
