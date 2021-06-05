//
//  UserInfo.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 05.06.2021.
//

import Foundation

struct UserData {
    let nickname: String
    let avatarUrl: String
}

struct MessageData {
    let text: String
    let receivingDate: Date
}

struct Message {
    let user: UserData
    let data: MessageData
}
