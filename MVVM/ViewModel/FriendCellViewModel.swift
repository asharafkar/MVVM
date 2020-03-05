//
//  FriendCellViewModel.swift
//  MVVM
//
//  Created by Amir on 3/4/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

protocol FriendCellViewModel {
    var friendItem: Friend {get}
    var fullName: String {get}
    var phonenumberText: String {get}
}

extension Friend: FriendCellViewModel{
    
    var friendItem: Friend {
        return self
    }
    
    var fullName: String {
        return  "\(firstname) \(lastname)"
    }
    
    var phonenumberText: String {
        return phonenumber
    }
}
