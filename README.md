# Traffic Light System
# Using Arduino and programmed in DrRacket

[![NPM Version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Downloads Stats][npm-downloads]][npm-url]

The challenge your team are faced with is to design and prototype a traffic light system to safely control the flow of traffic along a road. As an example, in the road layout shown in figure 1, roadworks along the main road mean that a temporary traffic light system must be installed, with two sets of lights located at the two points marked Z, allowing traffic to flow alternately from left-to-right and then right-to-left.

![](Report\style\roadwork.png)

As this work is exploratory in nature, the client is interested in innovation and designs that creative responses to the problem, rather than the delivery of complete working products . So that means that an interesting idea or an unusual experiment may be just as good as a more functional but less innovative prototype.

## The idea...
* Three sets of traffic lights [(Z),(Z),(X)], plus the lights for the pedestrian crossing[(Y),(Y)].
* 7-Segment display to show the time for pedastrians to finish
passing the crossing before it changes back to red.
* Simulate a photocam at the way X if the car crosses on the red light.
* Buttons to trigger a pedastrian crossing.
* The sequence of traffic lights should change on it's own.

## How that was done...

One of the first things I did was to create a sequence of the traffic light events. This was a list of sorts where I listed what any given traffic light would be doing relative to the others. This is necessary as I need a precise sequence otherwise the system would be a complete failure.

| Left Z light  | Second Header | Left Z light  | Second Header |
| ------------- | ------------- | ------------- | ------------- |
| Content Cell  | Content Cell  | Content Cell  | Content Cell  |
| Content Cell  | Content Cell  | Content Cell  | Content Cell  | 

## Development setup

Describe how to install all development dependencies and how to run an automated test-suite of some kind. Potentially do this for multiple platforms.

```sh
make install
npm test
```

## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
    * The first proper release
    * CHANGE: Rename `foo()` to `bar()`
* 0.0.1
    * Work in progress

## Meta

Your Name – [@YourTwitter](https://twitter.com/dbader_org) – YourEmail@example.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
