//
//  ViewController.swift
//  MVVM
//
//  Created by Amir on 2/14/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appService = AppServerClient()
        appService.getFriends(completion: { [weak self] result in
            switch result{
            case .success(let friends):
                print(friends)
            case .failure(let error):
                print(error)
            }
        })
    }
}
