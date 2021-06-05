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

    private var dataTask: URLSessionDataTask?

    static let cellReuseIdentifier: String = "MessagesTableViewCell"

    func setup(withUserName userName: String, userAvatarURL avatarURL: String, messageText: String, receivingDate: Date) {
        dataTask?.cancel()
        dataTask = ImageDownloader.sharedInstance.getTask(forURL: avatarURL) { [weak self] image in
            self?.userImageView?.image = image
        }
        dataTask?.resume()
        userNameLabel?.text = userName
        messageLabel?.text = messageText

        let calendar = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .weekday, .hour, .minute, .second], from: receivingDate, to: Date())
        switch calendar {
        case let x where x.year ?? .zero > 1:
            dateTimeLabel?.text = "\(x.year ?? .zero) years"
        case let x where x.year ?? .zero == 1:
            dateTimeLabel?.text = "one year"
        case let x where x.month ?? .zero > .zero:
            dateTimeLabel?.text = "\(x.month ?? .zero) months"
        case let x where x.weekOfYear ?? .zero > 0:
            dateTimeLabel?.text = "\(x.weekOfYear ?? .zero) weeks"
        case let x where x.day ?? .zero > 2:
            switch x.weekday {
            case 1:
                dateTimeLabel?.text = "Monday"
            case 2:
                dateTimeLabel?.text = "Tuesday"
            case 3:
                dateTimeLabel?.text = "Wednesday"
            case 4:
                dateTimeLabel?.text = "Thursday"
            case 5:
                dateTimeLabel?.text = "Friday"
            case 6:
                dateTimeLabel?.text = "Saturday"
            case 7:
                dateTimeLabel?.text = "Sunday"
            default:
                dateTimeLabel?.text = ""
            }
        case let x where x.day ?? .zero > 1:
            dateTimeLabel?.text = "Yesterday"
        case let x where x.hour ?? .zero > .zero:
            dateTimeLabel?.text = "\(x.hour ?? .zero) hours"
        case let x where x.minute ?? .zero > .zero:
            dateTimeLabel?.text = "\(x.minute ?? .zero) minutes"
        case let x where x.second ?? .zero > .zero:
            dateTimeLabel?.text = "\(x.second ?? .zero) seconds"
        default:
            dateTimeLabel?.text = "Now"
        }
    }
}
