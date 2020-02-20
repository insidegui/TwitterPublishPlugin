//
//  File.swift
//  
//
//  Created by Guilherme Rambo on 20/02/20.
//

import Foundation

public struct EmbeddedTweet: Hashable, Codable {
    public let url: String
    public let authorName: String
    public let authorUrl: URL
    public let html: String
    public let width: Int?
    public let height: Int?
}
