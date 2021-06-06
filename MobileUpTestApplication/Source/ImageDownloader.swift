//
//  ImageDownloader.swift
//  MobileUpTestApplication
//
//  Created by Azamat Farkhiev on 06.06.2021.
//

import UIKit

class ImageDownloader {
    static let sharedInstance = ImageDownloader()

    private static var cachedImages = [String: UIImage]()

    private static let concurrentQueue = DispatchQueue(label: "ImageDownloader.concurrentQueue", attributes: .concurrent)

    private static var session: URLSession?

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        ImageDownloader.session = URLSession(configuration: configuration)
    }

    private static func checkExisting(forURL url: String, action: @escaping (_: UIImage?) -> Void) -> Bool {
        var result = false
        ImageDownloader.concurrentQueue.sync {
            if cachedImages.keys.contains(url) {
                DispatchQueue.main.async {
                    action(ImageDownloader.cachedImages[url])
                }
                result = true
            } else {
                result = false
            }
        }
        return result
    }

    func getTask(forURL urlString: String, action: @escaping (_: UIImage?) -> Void) -> URLSessionDataTask? {
        guard !urlString.isEmpty, !ImageDownloader.checkExisting(forURL: urlString, action: action), let url = URL(string: urlString) else {
            return nil
        }
        return ImageDownloader.session?.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard error == nil, let data = data else {
                return
            }
            let image = UIImage(data: data)
            ImageDownloader.concurrentQueue.async(flags: .barrier) {
                ImageDownloader.cachedImages[urlString] = image
            }
            DispatchQueue.main.async {
                action(image)
            }
        }
    }

    func resetCache() {
        ImageDownloader.concurrentQueue.async(flags: .barrier) {
            ImageDownloader.cachedImages.removeAll()
        }
    }
}
