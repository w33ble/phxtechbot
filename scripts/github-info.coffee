url = require 'url'

module.exports = (robot) ->
  robot.hear /(https?:\/\/(www\.)?github\.com\/)(.*)/i, (msg) ->
    url_parsed = url.parse(msg.match[0])
    path = url_parsed.path.substring(1)

    if path
      msg.http("https://api.github.com/repos/#{path}")
        .query({
          alt: 'json'
        }).get() (err, res, body) ->
          if res.statusCode is 200
            data = JSON.parse(body)
            description = data.description
            msg.send "Github #{data.full_name}: #{data.description}"
