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
        dataTask = nil
        userImageView?.image = UIImage(named: "person_default")
        dataTask = ImageDownloader.sharedInstance.getTask(forURL: avatarURL) { [weak self] image in
            self?.userImageView?.image = image
        }
        dataTask?.resume()
        userNameLabel?.text = userName
        messageLabel?.text = messageText
        let dateComponents = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .weekday, .hour, .minute, .second], from: receivingDate, to: Date())
        switch dateComponents {
        case let x where x.year ?? .zero > .zero:
            let years = x.year ?? .zero
            dateTimeLabel?.text = "\(years) \(years > 1 ? "years" : "year") ago"
        case let x where x.month ?? .zero > .zero:
            let months = x.month ?? .zero
            dateTimeLabel?.text = "\(months) \(months > 1 ? "months" : "month") ago"
        case let x where x.weekOfYear ?? .zero > 0:
            let weeks = x.weekOfYear ?? .zero
            dateTimeLabel?.text = "\(weeks) \(weeks > 1 ? "weeks" : "week") ago"
        case let x where x.day ?? .zero > 2:
            switch x.weekday {
            case 0:
                dateTimeLabel?.text = "Monday"
            case 1:
                dateTimeLabel?.text = "Tuesday"
            case 2:
                dateTimeLabel?.text = "Wednesday"
            case 3:
                dateTimeLabel?.text = "Thursday"
            case 4:
                dateTimeLabel?.text = "Friday"
            case 5:
                dateTimeLabel?.text = "Saturday"
            case 6:
                dateTimeLabel?.text = "Sunday"
            default:
                dateTimeLabel?.text = ""
            }
        case let x where x.day ?? .zero == 1:
            dateTimeLabel?.text = "Yesterday"
        default:
            let receivingDateComponents = Calendar.current.dateComponents([.hour, .minute], from: receivingDate)
            dateTimeLabel?.text = "\(receivingDateComponents.hour ?? .zero):\(receivingDateComponents.minute ?? .zero)"
        }
    }
}
