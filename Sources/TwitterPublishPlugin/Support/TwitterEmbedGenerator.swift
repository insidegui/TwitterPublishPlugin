//
//  File.swift
//  
//
//  Created by Guilherme Rambo on 20/02/20.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class TwitterEmbedGenerator {

    struct Error: LocalizedError {
        var localizedDescription: String

        static let invalidURL = Error(localizedDescription: "Failed to construct an URL")
        static let timeout = Error(localizedDescription: "The request to Twitter's embed API timed out")
    }

    private let session = URLSession(configuration: .default)
    private let baseURL = "https://publish.twitter.com/oembed?url="

    let tweetURL: URL

    init(tweetURL: URL) {
        self.tweetURL = tweetURL
    }

    func generate() -> Result<EmbeddedTweet, Error> {
        guard let req = try? generateRequest(for: tweetURL) else {
            return .failure(.invalidURL)
        }

        var result: Result<EmbeddedTweet, Error> = .failure(.timeout)
        let sema = DispatchSemaphore(value: 0)

        let task = session.dataTask(with: req) { data, res, error in
            defer { sema.signal() }

            let suffix = "while processing the tweet \(self.tweetURL)"

            guard let res = res as? HTTPURLResponse else {
                result = .failure(Error(localizedDescription: "Unexpected response \(suffix)"))
                return
            }

            guard res.statusCode == 200 else {
                result = .failure(Error(localizedDescription: "Twitter's API returned error code \(res.statusCode) \(suffix)"))
                return
            }

            guard let data = data else {
                if let error = error {
                    result = .failure(Error(localizedDescription: "The request failed with error \(error) \(suffix)"))
                } else {
                    result = .failure(Error(localizedDescription: "The request returned no data \(suffix)"))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let tweet = try decoder.decode(EmbeddedTweet.self, from: data)

                result = .success(tweet)
            } catch {
                result = .failure(Error(localizedDescription: "Error decoding: \(error) \(suffix)"))
            }
        }

        task.resume()

        _ = sema.wait(timeout: .now() + 15)

        return result
    }

    private func generateRequest(for tweetURL: URL) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            throw Error.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "url", value: tweetURL.absoluteString)
        ]

        guard let url = components.url else {
            throw Error.invalidURL
        }

        return URLRequest(url: url)
    }

}
