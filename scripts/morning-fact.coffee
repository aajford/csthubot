# Description:
#   Have Hubot give you random Facts.
#   hh:mm must be in the same timezone as the server Hubot is on. Probably UTC.
#
#   This is configured to work for Hipchat. You may need to change the 'create fact' command
#   to match the adapter you're using.
#
# Configuration:
#
# Commands:
#   hubot fact help - See a help document explaining how to use.
#   hubot create fact hh:mm - Creates a Fact at hh:mm every weekday for this room
#   hubot create fact hh:mm UTC+2 - Creates a Fact at hh:mm every weekday for this room (relative to UTC)
#   hubot list facts - See all Facts for this room
#   hubot list facts in every room - See all Facts in every room
#   hubot delete hh:mm fact - If you have a Fact at hh:mm, deletes it
#   hubot delete all facts - Deletes all Facts for this room.
#
# Dependencies:
#   underscore
#   cron
#   http
###jslint node: true###

cronJob = require('cron').CronJob
_ = require('underscore')
http = require 'http'

module.exports = (robot) ->
  # Compares current time to the time of the Fact
  # to see if it should be fired.



  FactShouldFire = (Fact) ->
    FactTime = Fact.time
    utc = Fact.utc
    now = new Date
    currentHours = undefined
    currentMinutes = undefined
    if utc
      currentHours = now.getUTCHours() + parseInt(utc, 10)
      currentMinutes = now.getUTCMinutes()
      if currentHours > 23
        currentHours -= 23
    else
      currentHours = now.getHours()
      currentMinutes = now.getMinutes()
    FactHours = FactTime.split(':')[0]
    FactMinutes = FactTime.split(':')[1]
    try
      FactHours = parseInt(FactHours, 10)
      FactMinutes = parseInt(FactMinutes, 10)
    catch _error
      return false
    if FactHours == currentHours and FactMinutes == currentMinutes
      return true
    false

  # Returns all Facts.

  getFacts = ->
    robot.brain.get('Facts') or []

  # Returns just Facts for a given room.

  getFactsForRoom = (room) ->
    _.where getFacts(), room: room

  # Gets all Facts, fires ones that should be.

  checkFacts = ->
    Facts = getFacts()
    _.chain(Facts).filter(FactShouldFire).pluck('room').each getFact
    return


  getFact = (msg, query, callback, room) ->
    http.get ('http://www.unkno.com/'), (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk.toString()
      res.on 'end', () ->

        # Parse html
        if data.match(/<div id="content">([^<]+)./i)
	        matchedText = data.match(/<div id="content">([^<]+)./i)
	        textBody = matchedText[0]
	        textBodyNoWhite = textBody.replace /^\s+|\s+$/g, ""
	        theFact1 = textBodyNoWhite.replace /<[^>]*>/g, ""
	        theFact2 = theFact1.replace /[\W_]+/g," "
	        message = 'Fact of the day: '+ theFact2
	        robot.messageRoom room, message 
    return

  findRoom = (msg) ->
    room = msg.envelope.room
    if _.isUndefined(room)
      room = msg.envelope.user.reply_to
    room

  # Stores a Fact in the brain.

  saveFact = (room, time, utc) ->
    Facts = getFacts()
    newFact = 
      time: time
      room: room
      utc: utc
    Facts.push newFact
    updateBrain Facts
    return

  # Updates the brain's Fact knowledge.

  updateBrain = (Facts) ->
    robot.brain.set 'Facts', Facts
    return

  clearAllFactsForRoom = (room) ->
    Facts = getFacts()
    FactsToKeep = _.reject(Facts, room: room)
    updateBrain FactsToKeep
    Facts.length - (FactsToKeep.length)

  clearSpecificFactForRoom = (room, time) ->
    Facts = getFacts()
    FactsToKeep = _.reject(Facts,
      room: room
      time: time)
    updateBrain FactsToKeep
    Facts.length - (FactsToKeep.length)

  'use strict'
 
  # Check for Facts that need to be fired, once a minute
  # Monday to Friday.
  new cronJob('1 * * * * 1-5', checkFacts, null, true)
  robot.respond /delete all facts/i, (msg) ->
    FactsCleared = clearAllFactsForRoom(findRoom(msg))
    msg.send 'Deleted ' + FactsCleared + ' Fact' + (if FactsCleared == 1 then '' else 's') + '. No more facts for you.'
    return
  robot.respond /delete ([0-5]?[0-9]:[0-5]?[0-9]) fact/i, (msg) ->
    time = msg.match[1]
    FactsCleared = clearSpecificFactForRoom(findRoom(msg), time)
    if FactsCleared == 0
      msg.send 'Nice try. You don\'t even have a fact at ' + time
    else
      msg.send 'Deleted your ' + time + ' Fact.'
    return
  robot.respond /create fact ((?:[01]?[0-9]|2[0-4]):[0-5]?[0-9])$/i, (msg) ->
    time = msg.match[1]
    room = findRoom(msg)
    saveFact room, time
    msg.send 'Ok, from now on I\'ll post a fact in this room every weekday at ' + time
    return
  robot.respond /create fact ((?:[01]?[0-9]|2[0-4]):[0-5]?[0-9]) UTC([+-]([0-9]|1[0-3]))$/i, (msg) ->
    time = msg.match[1]
    utc = msg.match[2]
    room = findRoom(msg)
    saveFact room, time, utc
    msg.send 'Ok, from now on I\'ll post a fact in this room every weekday at ' + time + ' UTC' + utc
    return
  robot.respond /list Facts$/i, (msg) ->
    Facts = getFactsForRoom(findRoom(msg))
    if Facts.length == 0
      msg.send 'Well this is awkward. You haven\'t got any fact alerts set :-/'
    else
      FactsText = [ 'Here are your fact times:' ].concat(_.map(Facts, (Fact) ->
        if Fact.utc
          Fact.time + ' UTC' + Fact.utc
        else
          Fact.time
      ))
      msg.send FactsText.join('\n')
    return
  robot.respond /list facts in every room/i, (msg) ->
    Facts = getFacts()
    if Facts.length == 0
      msg.send 'No, because there aren\'t any.'
    else
      FactsText = [ 'Here\'s the fact alerts for every room:' ].concat(_.map(Facts, (Fact) ->
        'Room: ' + Fact.room + ', Time: ' + Fact.time
      ))
      msg.send FactsText.join('\n')
    return
  robot.respond /fact help/i, (msg) ->
    message = []
    message.push 'I can give you a daily fact!'
    message.push 'Use me to create a time you want to hear your fact, and then I\'ll post in this room every weekday at the time you specify. Here\'s how:'
    message.push ''
    message.push robot.name + ' create fact hh:mm - I\'ll give you a fact in this room at hh:mm every weekday.'
    message.push robot.name + ' create fact hh:mm UTC+2 - I\'ll give you a fact in this room at hh:mm every weekday.'
    message.push robot.name + ' list facts - See all fact times for this room.'
    message.push robot.name + ' list facts in every room - Be nosey and see when other rooms are delivered their facts.'
    message.push robot.name + ' delete hh:mm fact - If you have a fact at hh:mm, I\'ll delete it.'
    message.push robot.name + ' delete all facts - Deletes all fact alerts for this room.'
    msg.send message.join('\n')
    return
  return
