//
//  MessagesTableViewCell.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 05.06.2021.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    @IBOutlet private var userImageView: UIImageView?
    @IBOutlet private var userNameLabel: UILabel?
    @IBOutlet private var messageLabel: UILabel?
    @IBOutlet private var dateTimeLabel: UILabel?

    static let cellReuseIdentifier: String = "MessagesTableViewCell"
}
