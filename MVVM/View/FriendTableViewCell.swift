//
//  FriendTableViewCell.swift
//  MVVM
//
//  Created by Amir on 3/5/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    
    var viewModel: FriendCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        labelFullName?.text = viewModel?.fullName
        labelPhoneNumber?.text = viewModel?.phonenumberText
    }
    
}
