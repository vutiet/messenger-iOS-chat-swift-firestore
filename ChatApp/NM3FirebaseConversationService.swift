//
//  NM3FirebaseConversationService.swift
//  ChatApp
//
//  Created by Vu Tiet on 10/04/2019.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MessageKit


class NM3FirebaseConversationService: NSObject {

    private static let db = Firestore.firestore()
    private static var reference: CollectionReference?
    private static let storage = Storage.storage().reference()
    
    static func fetchConversations(userId: String, completion: @escaping (_ threads: [ATChatMessage]) -> ()) {
        db.collection("channels").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firebase returned an error while getting chat documents: \(err)")
            } else {
                if querySnapshot?.documents == nil{
                    print("no channels or threads found for this user's organization\n. No worries a brand new one will automatically be created when you first attempt to send a message")
                }else {
                    // Uncomment to see all documents in this user's org
                    // Usually a bad thing though, only use to debug and do not release
                    
                    var results = [ATChatMessage]()
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if document.documentID.contains(userId) {
                            let sender = ATCUser(uid: "guid-1234-5678-9012", username: "dan", firstName: "Dan", lastName: "Burkhardt", avatarURL: "https://cdn0.iconfinder.com/data/icons/avatar-2/500/man-2-512.png", email: "test@gigabitelabs.com", isOnline: false)
                            let recipient = ATCUser(uid: "guid-4321-8765-2109", username: "simulator", firstName: "iPhone", lastName: "Simulator", avatarURL: "https://cdn-images-1.medium.com/max/1000/1*QUmlH0_tRyjlbxVkSKtk3A.png", email: "testcristina@gmail.com", isOnline: true)
                            let thread = ATChatMessage(messageId: document.documentID, messageKind: MessageKind.text("TestThread: \(results.count)"), createdAt: Date().yesterday, atcSender: sender, recipient: recipient, seenByRecipient: false)
                            results.append(thread)
                        }
                    }
                    completion(results)
                }
            }
        }
    }
    
}
