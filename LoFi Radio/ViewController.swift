//
//  ViewController.swift
//  LoFi Radio
//
//  Created by Matthew Lock on 15/03/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 219.0/255, green: 188.0/255, blue: 131.0/255, alpha: 1.0)
        view.addSubview(header)
        
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
