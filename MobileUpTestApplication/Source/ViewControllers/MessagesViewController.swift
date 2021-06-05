//
//  MessagesViewController.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 05.06.2021.
//

import UIKit

class MessagesViewController: UIViewController {
    @IBOutlet private var messagesTableView: UITableView?

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
        .zero
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.cellReuseIdentifier, for: indexPath)
    }
}
