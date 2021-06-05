//
//  MessageDataStructures.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 05.06.2021.
//

import Foundation

struct UserData: Decodable {
    let nickname: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
            case nickname
            case avatarUrl = "avatar_url"
        }
}

struct Message: Decodable {
    let text: String
    let receivingDate: Date
    
    enum CodingKeys: String, CodingKey {
            case text
            case receivingDate = "receiving_date"
        }
}

struct MessageData: Decodable {
    let user: UserData
    let message: Message
}
