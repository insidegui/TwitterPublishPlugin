/**
*  Twitter plugin for Publish
*  © 2020 Guilherme Rambo
*  BSD-2 license, see LICENSE file for details
*/

import Publish
import Ink
import Foundation

public extension Plugin {
    static func twitter(renderer: TweetRenderer = DefaultTweetRenderer()) -> Self {
        Plugin(name: "Twitter") { context in
            context.markdownParser.addModifier(
                .twitterBlockquote(using: renderer)
            )
        }
    }
}

public extension Modifier {
    static func twitterBlockquote(using renderer: TweetRenderer) -> Self {
        return Modifier(target: .blockquotes) { html, markdown in
            let prefix = "tweet "
            var markdown = markdown.dropFirst().trimmingCharacters(in: .whitespaces)

            guard markdown.hasPrefix(prefix) else {
                return html
            }

            markdown = markdown.dropFirst(prefix.count).trimmingCharacters(in: .newlines)

            guard let url = URL(string: markdown) else {
                fatalError("Invalid tweet URL \(markdown)")
            }

            let generator = TwitterEmbedGenerator(tweetURL: url)

            let tweet = try! generator.generate().get()

            return try! renderer.render(tweet: tweet)
        }
    }
}
