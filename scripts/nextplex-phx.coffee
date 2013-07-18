cheerio = require 'cheerio'
site = "http://nextplex.com"

module.exports = (robot) ->
  robot.respond /techevents\stoday/, (msg) ->
    get_events_today msg

get_events_today = (msg) ->
  msg.http("#{site}/phoenix-az/calendar")
    .get() (err, res, body) ->
      $ = cheerio.load body
      events = $('.today-cell', '#event_calendar').find('a')
      events.each (i, el) ->
        msg.send "#{$(el).html()} [#{site}#{$(el).attr('href')}]"
