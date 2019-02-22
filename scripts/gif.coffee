#Description:
#  Searches for gifs on giphy.com
#  Uses random endpoint of giphy api
#  https://github.com/giphy/GiphyAPI
#
#Commands:
#  gif me <query>
#
module.exports = (robot) ->
  robot.hear /(gif)( me){1} (.*)/i, (msg) ->
    query = msg.match[3]
    url = 'http://api.giphy.com/v1/gifs/random'
    if not process.env.HUBOT_GIPHY_KEY
      return msg.reply "HUBOT_GIPHY_KEY must be defined. Visit http://api.giphy.com to get one."
    robot.http(url)
      .query({
        api_key: process.env.HUBOT_GIPHY_KEY
        limit: 1
        tag: query.split(' ').join('+')
        })
      .get() (err, res, body) ->
        if res.statusCode is 200
          gif = JSON.parse(body)
          gif = gif.data.image_original_url

          unless gif?
            msg.send "No gifs found for \"#{query}\""
            return

          msg.send gif