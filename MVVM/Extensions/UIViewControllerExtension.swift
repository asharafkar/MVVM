//
//  UIViewControllerExtension.swift
//  MVVM
//
//  Created by Amir on 3/4/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

import UIKit

protocol SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert)
}

extension SingleButtonDialogPresenter where Self: UIViewController{
    func presentSingleButtonDialog(alert: SingleButtonAlert){
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle, style: .default, handler: {_ in alert.action.handler?()}))
        self.present(alertController, animated: true, completion: nil)
    }
}
