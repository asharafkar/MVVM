//
//  Result.swift
//  MVVM
//
//  Created by Amir on 3/3/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

enum Result<T, U: Error>{
    
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U: Error>{
    case success
    case failure(U?)
}
