//
//  MessagesViewController.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 05.06.2021.
//

import UIKit

class MessagesViewController: UIViewController {
    @IBOutlet private var messagesTableView: UITableView?

    private var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView?.delegate = self
        messagesTableView?.dataSource = self

        messagesTableView?.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: MessagesTableViewCell.cellReuseIdentifier)
        messagesTableView?.allowsSelection = false
        messagesTableView?.tableFooterView = UIView()
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        messages.isEmpty ? .zero : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.cellReuseIdentifier, for: indexPath) as? MessagesTableViewCell,
              indexPath.row < messages.count
        else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        cell.setup(withUserName: message.user.nickname, userAvatarURL: message.user.avatarUrl, messageText: message.data.text, receivingDate: message.data.receivingDate)
        return cell
    }
}
