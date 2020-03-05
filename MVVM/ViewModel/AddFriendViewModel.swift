//
//  AddFriendViewModel.swift
//  MVVM
//
//  Created by Amir on 3/4/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

protocol FriendViewModel {
    var title: String {get}
    var firstname: String? {get set}
    var lastname: String? {get set}
    var phonenumber: String? {get set}
    var showLoadingHud: Bindable<Bool> {get}
    
    var updateSubmitButtonState: ((Bool) -> ())? {get set}
    var navigateBack: (() -> ())? {set get}
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)? {get set}
    
    func submitFriend()
}

final class AddFriendViewModel: FriendViewModel{
    
    var title: String{
        return "Add Friend"
    }
    
    var firstname: String?{
        didSet{
            validateInput()
        }
    }
    
    var lastname: String?{
        didSet{
            validateInput()
        }
    }
    
    var phonenumber: String?{
        didSet{
            validateInput()
        }
    }
    
    var updateSubmitButtonState: ((Bool) -> ())?
    var navigateBack: (() -> ())?
    var onShowError: ((SingleButtonAlert) -> Void)?
    
    let showLoadingHud: Bindable<Bool> = Bindable(false)
    
    private let appServerClient: AppServerClient
    
    private var validateInputData: Bool = false{
        didSet{
            if oldValue != validateInputData{
                updateSubmitButtonState?(validateInputData)
            }
        }
    }
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func submitFriend() {
        guard let firstname = firstname, let lastname = lastname, let phonenumber = phonenumber else {
            return
        }
        
        updateSubmitButtonState?(false)
        showLoadingHud.value = true
        
        appServerClient.postFriend(firstname: firstname, lastname: lastname, phonenumber: phonenumber){[weak self] result in
            self?.showLoadingHud.value = false
            self?.updateSubmitButtonState?(true)
            
            switch result{
            case .success:
                self?.navigateBack?()
            case .failure(let error):
                let okAlert = SingleButtonAlert(title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.", message:  "Could not add \(firstname) \(lastname).", action: AlertAction(buttonTitle: "OK", handler: {print("OK pressed")}))
                self?.onShowError?(okAlert)
            }
        }
    }
    
    func validateInput(){
        let validData = [firstname, lastname, phonenumber].filter{
            ($0?.count ?? 0) < 1
        }
        validateInputData = (validData.count == 0) ? true : false
    }
}

fileprivate extension AppServerClient.PostFriendFailureReason{
    func getErrorMessage() -> String?{
        switch self{
        case .unAuthorized:
             return "Please login to add friends friends."
        case .notFound:
             return "Failed to add friend. Please try again."
        }
    }
}
