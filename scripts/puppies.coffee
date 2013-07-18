# Description:
#   Puppies!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot puppy me - A randomly selected puppy
#   hubot puppy me <w>x<h> - A puppy of the given size
#   hubot puppy bomb me <number> - Many many puppies!
#
# Author:
#   dstrelau

module.exports = (robot) ->
  robot.respond /puppy?(?: me)?$/i, (msg) ->
    msg.send puppyMe()

  robot.respond /puppy?(?: me)? (\d+)(?:[x ](\d+))?$/i, (msg) ->
    msg.send puppyMe msg.match[1], (msg.match[2] || msg.match[1])

  robot.respond /puppy bomb(?: me)?( \d+)?$/i, (msg) ->
    puppies = msg.match[1] || 5
    msg.send(puppyMe()) for i in [1..puppies]

puppyMe = (height, width)->
  h = height ||  Math.floor(Math.random()*250) + 250
  w = width  || Math.floor(Math.random()*250) + 250
  root = "http://placedog.com"
  root += "/g" if Math.random() > 0.7 # greyscale puppies!
  return "#{root}/#{h}/#{w}#.png"
