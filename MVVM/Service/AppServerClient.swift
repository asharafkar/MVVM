//
//  AppServerClient.swift
//  MVVM
//
//  Created by Amir on 3/3/20.
//  Copyright © 2020 Amir Sharafkar. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - AppServerClient
class AppServerClient{
    
    // MARK: - GetFriends
    enum GetFriendsFailureReason: Int, Error{
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias GetFriendsResult = Result<[Friend], GetFriendsFailureReason>
    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void
    
    func getFriends(completion: @escaping GetFriendsCompletion){
        AF.request("http://friendservice.herokuapp.com/listFriends").validate().responseJSON{response in
            
            switch response.result{
            case .success:
                do{
                    guard let data = response.data else {
                        completion(.failure(nil))
                        return
                    }
                    let friends = try JSONDecoder().decode([Friend].self, from: data)
                    completion(.success(payload: friends))
                }catch{
                    completion(.failure(nil))
                }
            case .failure(_):
                if let statusCode = response.response?.statusCode,
                    let reason = GetFriendsFailureReason(rawValue: statusCode){
                    completion(.failure(reason))
                }
                completion(.failure(nil))
            }
        }
    }
    
    //MARK: - PostFriend
    enum PostFriendFailureReason: Int, Error{
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias PostFriendResult = EmptyResult<PostFriendFailureReason>
    typealias PostFriendCompletion = (_ result: PostFriendResult) -> Void
    
    func postFriend(firstname: String, lastname: String, phonenumber: String, completion: @escaping PostFriendCompletion){
        let param = ["firstname": firstname,
                     "lastname": lastname,
                     "phonenumber": phonenumber]
        
        AF.request("https://friendservice.herokuapp.com/addFriend", method: .post, parameters: param, encoding: JSONEncoding.default)
            .validate().responseJSON{ response in
                switch response.result{
                case .success:
                    completion(.success)
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reasson = PostFriendFailureReason(rawValue: statusCode){
                        completion(.failure(reasson))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    // MARK: - PatchFriend
    enum PatchFriendFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias PatchFriendResult = Result<Friend, PatchFriendFailureReason>
    typealias PatchFriendCompletion = (_ result: PatchFriendResult) -> Void
    
    func patchFriend(firstname: String, lastname: String, phonenumber: String, id: Int, completion: @escaping PatchFriendCompletion){
        let param = ["firstname": firstname,
                     "lastname": lastname,
                     "phonenumber": phonenumber]
        AF.request("https://friendservice.herokuapp.com/editFriend/\(id)", method: .patch, parameters: param, encoding: JSONEncoding.default)
            .validate().responseJSON{response in
                switch response.result{
                case .success:
                    do{
                        guard let data = response.data else {
                            completion(.failure(nil))
                            return
                        }
                        let friend = try JSONDecoder().decode(Friend.self, from: data)
                        completion(.success(payload: friend))
                    }catch{
                        completion(.failure(nil))
                    }
                case .failure(_):
                    if let statusCode = response.response?.statusCode, let reason = PatchFriendFailureReason(rawValue: statusCode){
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
        
    }
    
    // MARK: - DeleteFriend
    enum DeleteFriendFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias DeleteFriendResult = EmptyResult<DeleteFriendFailureReason>
    typealias DeleteFriendCompletion = (_ result: DeleteFriendResult) -> Void
    
    func deleteFriend(id: Int, completion: @escaping DeleteFriendCompletion){
        
        AF.request("https://friendservice.herokuapp.com/editFriend/\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default)
            .validate().responseJSON{ response in
                switch response.result{
                case .success:
                    completion(.success)
                case .failure(_):
                    if let statusCode = response.response?.statusCode, let reason = DeleteFriendFailureReason(rawValue: statusCode){
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
}
