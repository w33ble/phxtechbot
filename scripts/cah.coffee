cahQuestions = require('./cah/questions')
cahAnswers   = require('./cah/answers')

module.exports = (robot) ->
  robot.respond /(cah|cardlib) me/i, (msg) ->
    msg.send(getResponse())

  robot.respond /(cah|cardlib) bomb( (\d+))?/i, (msg) ->
    count = parseInt(msg.match[2]) || 5
    msg.send(getResponse()) for i in [1..count]

pickQuestion = ->
  keys = Object.keys cahQuestions
  return cahQuestions[keys[keys.length * Math.random() << 0]];

pickAnswers = (count = 1) ->
  keys = Object.keys cahAnswers
  answerIDs = []
  results = []
  # pick key indexes
  while answerIDs.length < count
    pick = keys[keys.length * Math.random() << 0];
    while answerIDs.indexOf(pick) != -1
      pick = keys[keys.length * Math.random() << 0];
    answerIDs.push pick
    results.push cahAnswers[pick]

  return results

getResponse = ->
  question = pickQuestion()
  answers = pickAnswers(question.numAnswers)
  parts = question.text.split '_'
  # console.log question, answers

  if parts.length is 1
    return "#{question.text} #{answers[0].text}"

  idx = 0
  response = ""
  for part in parts
    if answers[idx]?
      response += "#{part}#{answers[idx].text}"
    else
      response += part
    ++idx
  return response
