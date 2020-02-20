# TwitterPublishPlugin

A plugin for [Publish](https://github.com/JohnSundell/Publish) that let's you easily embed tweets in your posts.

To embed a tweet in your post, use a blockquote in markdown, but add the "tweet" prefix, like so:

```
> tweet https://twitter.com/_inside/status/1049808231818760192
```

To install the plugin, add it to your site's publishing steps:

```swift
try mysite().publish(using: [
    .installPlugin(.twitter()),
    // ...
])
```