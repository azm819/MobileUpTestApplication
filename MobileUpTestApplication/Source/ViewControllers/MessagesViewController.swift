//
//  MessagesViewController.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 05.06.2021.
//

import UIKit

class MessagesViewController: UIViewController {
    @IBOutlet private var messagesTableView: UITableView?
    @IBOutlet private var nothingFoundLabel: UILabel?

    private static let apiURLString = "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json"

    private var urlSessionDataTask: URLSessionDataTask?
    private var messages = [MessageData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView?.delegate = self
        messagesTableView?.dataSource = self

        messagesTableView?.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: MessagesTableViewCell.cellReuseIdentifier)
        messagesTableView?.allowsSelection = false
        messagesTableView?.tableFooterView = UIView()
        messagesTableView?.refreshControl = UIRefreshControl()
        messagesTableView?.refreshControl?.addTarget(self, action: #selector(onRefreshControlValueChanged), for: .valueChanged)

        updateMessages()
    }

    private func displayAlert(withErrorCode errorCode: Int) {
        updateContentVisibility()
        let messageText: String
        switch errorCode {
        case NSURLErrorNotConnectedToInternet:
            messageText = "No internet connection"
        case NSURLErrorBadServerResponse:
            messageText = "No connection to server. Please, try again later"
        default:
            messageText = "Unknown error: \(errorCode)"
        }
        let alert = UIAlertController(title: nil, message: messageText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func updateContentVisibility() {
        nothingFoundLabel?.isHidden = !messages.isEmpty
        ImageDownloader.sharedInstance.resetCache()
        messagesTableView?.reloadData()
        messagesTableView?.refreshControl?.endRefreshing()
    }

    private func updateMessages() {
        messages.removeAll()
        messagesTableView?.reloadData()

        if let url = URL(string: MessagesViewController.apiURLString) {
            urlSessionDataTask?.cancel()
            urlSessionDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, error in
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        self?.displayAlert(withErrorCode: error.code)
                    }
                    return
                }

                guard let data = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    self?.messages = try decoder.decode([MessageData].self, from: data)
                    DispatchQueue.main.async {
                        self?.updateContentVisibility()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.displayAlert(withErrorCode: NSURLErrorCannotDecodeContentData)
                    }
                }
            }
            urlSessionDataTask?.resume()
        }
    }

    // MARK: - Actions

    @objc func onRefreshControlValueChanged() {
        updateMessages()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

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
        cell.setup(withUserName: message.user.nickname, userAvatarURL: message.user.avatarUrl, messageText: message.message.text, receivingDate: message.message.receivingDate)
        return cell
    }
}
