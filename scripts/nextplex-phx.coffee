# Description:
#   Displays upcoming tech events in Phoenix
#
# Dependencies:
#   "cheerio": "~0.12.0"
#
# Commands:
#   techevents today - Shows list of events today, with links
#   techevents upcoming <count> - Shows upcoming events (default 8)
#
# Author:
#   @w33ble

cheerio = require 'cheerio'
site = "http://nextplex.com"

module.exports = (robot) ->

  robot.respond /techevents\stoday/, (msg) ->
    get_events_today msg
  robot.respond /techevents\supcoming?\s*(\d+)?/, (msg) ->
    count = msg.match[1] || 8
    get_events_upcoming msg, count

fetch_site = (msg, cb) ->
  msg.http("#{site}/phoenix-az/calendar")
    .get() cb

get_events_upcoming = (msg, count) ->
  fetch_site msg, (err, res, body) ->
    evts = []
    $ = cheerio.load body
    events = $('#event-listing').find('.date-and-name')
    if count <= events.length
      events.length = count
    events.each (i, el) ->
      el = $(el)
      month = el.find('time .day').html()
      date = el.find('time .date').html()
      time = $(el).find('.event-name p').html().trim().match( /([0-9\:]+[a|p]m)/i )[0]
      link = $(el).find('.event-name a')
      title = link.html()
      link = "#{site}#{link.attr('href')}"
      msg.send "#{month} #{date} @ #{time} - #{title} [#{link}]"

get_events_today = (msg) ->
  fetch_site msg, (err, res, body) ->
    evts = []
    $ = cheerio.load body
    events = $('.today-cell', '#event_calendar').find('a')
    events.each (i, el) ->
      msg.send "#{$(el).html()} [#{site}#{$(el).attr('href')}]"
