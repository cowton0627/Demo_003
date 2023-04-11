//
//  WelcomeViewController.swift
//  Demo_003
//
//  Created by 鄭淳澧 on 2021/8/30.
//

import UIKit

/// 歡迎頁面 VC
class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.backgroundColor = .systemOrange
//        logoutBtn.tintColor = .orange
    }
    

}
