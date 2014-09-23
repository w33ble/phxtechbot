#Description:
#  Searches for gifs on giphy.com
#  Uses random endpoint of giphy api
#  https://github.com/giphy/GiphyAPI
#
#Commands:
#  gif me |gifbot me <query>
#
module.exports = (robot) ->
  robot.hear /(gif|gifbot)( me){1} (.*)/i, (msg) ->
    query = msg.match[3]
    query = query.split(' ').join('+')
    url = 'http://api.giphy.com/v1/gifs/random'
    robot.http(url)
      .query({
        api_key: 'dc6zaTOxFJmzC'
        limit: 1
        tag: search
        })
      .get() (err, res, body) ->
        if res.statusCode is 200
          gif = JSON.parse(body)
          gif = gif.data.image_original_url

          unless gif?
            msg.send 'No gifs found for \'#{search}\''
            return

          msg.send gif

