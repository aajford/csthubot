# Description:
#   gets latest tweet from SW trains and checks to see if it contains names of stations 
#   that would affect trains from Syon Lane. If it does, fires an alert 
#
# Dependencies:
#   "twit": "1.1.6"
#   "underscore": "1.4.4"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot trains tweet - Show last tweet from SWT
#   hubot train alerts help - See a help document explaining how to use.
#   hubot create train alert - Creates an alert when the trains are disrupted in this channel
#   hubot list train alerts - See all alerts for this room
#   hubot list train alerts in every channel - See all standups in every room
#   hubot delete all train alerts - Deletes all train alerts for this room.
#
# Author:
#   Aaron Ford
#

_ = require "underscore"
Twit = require "twit"
cronJob = require('cron').CronJob

minutesToCheckTwitter = 100
word = ["Test","Testing"]
username = "Aaron_AJF"

config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

module.exports = (robot) ->

  # Create a cronjob to check the tweets for a channel
  alertShouldFire = (robot) ->

    twit = undefined

    # robot.respond /(trains)\s+(tweet)\s?(\d?)/i, (msg) ->
    unless config.consumer_key
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return
    unless config.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return
    unless config.access_token
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN environment variable."
      return
    unless config.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return

    unless twit
      twit = new Twit config

    count = 1
    now = new Date
    msPerMinute = 60000
    dateFrom = new Date(now - minutesToCheckTwitter * msPerMinute)

    twit.get "statuses/user_timeline",
      q: 'since:' + dateFrom
      screen_name: escape(username)
      count: count
      include_rts: false
      exclude_replies: true
    , (err, reply) ->

      #Check to see if any of a list of stations is mentioned in the latest tweet
      tweetText = _.unescape(_.last(reply)['text'])
      console.log(tweetText)
      if checkTweet()
        return true
      else 
        return false

  # Checks to see if Tweet contains any of the stations that we care about

  checkTweet = ->
    wordList.some (word) -> ~tweetText.indexOf word

  # Returns all alerts.

  getAlerts = ->
    robot.brain.get('alerts') or []

  # Returns just alerts for a given room.

  getAlertsForRoom = (room) ->
    _.where getAlerts(), room: room

  # Gets all alerts, fires ones that should be.

  checkAlerts = ->
    alerts = getAlerts()
    console.log(alerts)
    _.chain(alerts).filter(alertShouldFire).pluck('room').each doAlert
    return

  # Fires the alert message.

  doAlert = (room) ->

    message =  "@Channel - Train alert: \"" + _.unescape(_.last(reply)['text']) + "\" - https://twitter.com/NRE_SWT" if reply[0]['text']
    robot.messageRoom room, message
    return

  # Finds the room for most adaptors

  findRoom = (msg) ->
    room = msg.envelope.room
    console.log(room)
    if _.isUndefined(room)
      room = msg.envelope.user.reply_to
    room

  # Stores an alert in the brain.

  saveAlert = (room) ->
    alerts = getAlerts()
    newAlert = 
      room: room
    alerts.push newAlert
    updateBrain alerts
    return

  # Updates the brain's alert knowledge.

  updateBrain = (alerts) ->
    robot.brain.set 'alerts', alerts
    return

  clearAllAlertsForRoom = (room) ->
    alerts = getAlerts()
    alertsToKeep = _.reject(alerts, room: room)
    updateBrain alertsToKeep
    alerts.length - (alertsToKeep.length)

  clearSpecificAlertForRoom = (room, time) ->
    alerts = getAlerts()
    alertsToKeep = _.reject(alerts,
      room: room
      time: time)
    updateBrain alertsToKeep
    alerts.length - (alertsToKeep.length)

  # Check for alerts that need to be fired, once every 2 minutes

  new cronJob('1 7-18 * * * 1-5', checkAlerts, null, true)

  robot.respond /delete all train alerts/i, (msg) ->
    alertsCleared = clearAllalertsForRoom(findRoom(msg))
    msg.send 'Deleted ' + alertsCleared + ' alert' + (if alertsCleared == 1 then '' else 's') + '. No more alerts for you.'
    return
  
  robot.respond /create train alert/i, (msg) ->
    room = findRoom(msg)
    saveAlert room
    msg.send 'Ok, from now on I\'ll alert this channel when I think there\'s train disruption - any time between 7am and 6pm on weekdays'
    return

  robot.respond /train alerts status$/i, (msg) ->
    alerts = getAlertsForRoom(findRoom(msg))
    if alerts.length == 0
      msg.send 'Well this is awkward. You haven\'t got any alerts set in this channel :-/'
    else
      alertsText = [ 'There\'s alerts set for '  ].concat(_.map(alerts, (alert) ->
        'Channel: ' + alert.room 
      ))
      msg.send alertsText.join('\n')
    return

  robot.respond /train alerts help/i, (msg) ->
    message = []
    message.push 'I can alert you when I think the trains are screwed!'
    message.push 'Use me to create an alert, and then I\'ll post in this channel when @NR_SWT Twitter account says there is disruption. Here\'s how:'
    message.push ''
    message.push robot.name + ' create train alert - I\'ll alert this channel when I think there\'s train disruption - any time between 7am and 6pm on weekdays'
    message.push robot.name + ' list train alerts - See all alerts for this channel.'
    message.push robot.name + ' list train alerts in every room - Be nosey and see which other channels have alerts.'
    message.push robot.name + ' delete all train alerts - Deletes all train alerts for this room.'
    msg.send message.join('\n')
    return
  return



      
