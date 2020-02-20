//
//  File.swift
//  
//
//  Created by Guilherme Rambo on 20/02/20.
//

import Foundation

public protocol TweetRenderer {
    func render(tweet: EmbeddedTweet) throws -> String
}

public final class DefaultTweetRenderer: TweetRenderer {
    public init() { }
    public func render(tweet: EmbeddedTweet) throws -> String { tweet.html }
}
