//
//  FriendViewController.swift
//  MVVM
//
//  Created by Amir on 3/5/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

import UIKit
import PKHUD

class FriendViewController: UIViewController {

    @IBOutlet weak var textFieldFirstname: UITextField!{
        didSet{
            textFieldFirstname.delegate = self
            textFieldFirstname.addTarget(self, action:  #selector(firstnameTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var textFieldLastname: UITextField!{
        didSet{
            textFieldLastname.delegate = self
            textFieldLastname.addTarget(self, action: #selector(lastnameTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var textFieldPhonenumber: UITextField!{
        didSet{
            textFieldPhonenumber.delegate = self
            textFieldPhonenumber.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var updateFriends: (() -> Void)?
    var viewModel: FriendViewModel?
    
    fileprivate var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    @objc
    func firstnameTextFieldDidChange(textField: UITextField){
        viewModel?.firstname = textField.text ?? ""
    }

    @objc
    func lastnameTextFieldDidChange(textField: UITextField){
        viewModel?.lastname = textField.text ?? ""
    }
    
    @objc
    func phoneNumberTextFieldDidChange(textFiled: UITextField){
        viewModel?.phonenumber = textFiled.text ?? ""
    }
    
    func bindViewModel(){
        title = viewModel?.title
        textFieldFirstname?.text = viewModel?.firstname ?? ""
        textFieldLastname?.text = viewModel?.lastname ?? ""
        textFieldPhonenumber?.text = viewModel?.phonenumber ?? ""
        
        viewModel?.showLoadingHud.bind{[weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
        
        viewModel?.updateSubmitButtonState = {[weak self] state in
            self?.buttonSubmit.isEnabled = state
        }
        
        viewModel?.navigateBack = { [weak self] in
            self?.updateFriends?()
            let _ = self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel?.onShowError = {[weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
    }
}

extension FriendViewController {
    @IBAction func rootViewTapped(_ sender: Any) {
        activeTextField?.resignFirstResponder()
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        viewModel?.submitFriend()
    }
}

extension FriendViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

extension FriendViewController: SingleButtonDialogPresenter {}
