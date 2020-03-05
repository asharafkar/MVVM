//
//  FriendsTableViewViewModel.swift
//  MVVM
//
//  Created by Amir on 3/4/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

class FriendsTableViewViewModel {
    
    enum FriendTableViewCellType{
        case normal(cellViewModel: FriendCellViewModel)
        case error(message: String)
        case empty
    }
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    
    let friendCells = Bindable([FriendTableViewCellType]())
    let appServerClient: AppServerClient
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func getFriends(){
        showLoadingHud.value = true
        appServerClient.getFriends(completion: {[weak self] result in
            self?.showLoadingHud.value = false
            switch result{
            case .success(let friends):
                guard friends.count > 0 else {
                    self?.friendCells.value = [.empty]
                    return
                }
                self?.friendCells.value = friends.compactMap { .normal(cellViewModel: $0 as FriendCellViewModel) }
                
            case .failure(let error):
                self?.friendCells.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        })
    }
    
    func deleteFriend(at index: Int){
        switch friendCells.value[index]{
        case .normal(let vm):
            appServerClient.deleteFriend(id: vm.friendItem.id){ [weak self] result in
                switch result{
                case .success:
                    self?.getFriends()
                case .failure(let error):
                    let okAlert = SingleButtonAlert(title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.", message: "Could not remove \(vm.fullName).", action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                    )
                    self?.onShowError?(okAlert)
                }
            }
        default:
            break
        }
    }
}

fileprivate extension AppServerClient.GetFriendsFailureReason{
    func getErrorMessage() -> String{
        switch self{
        case .unAuthorized:
            return "Please login to remove friends."
        case .notFound:
             return "Could not complete request, please try again."
        }
    }
}

fileprivate extension AppServerClient.DeleteFriendFailureReason{
    func getErrorMessage() -> String{
        switch self{
        case .unAuthorized:
            return "Please login to remove friends."
        case .notFound:
            return "Friend not found."
        }
    }
}
