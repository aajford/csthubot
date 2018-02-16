# Description:
#   Provides work related stuff
#
# Commands:
#   hubot wiki - Reply with URL for the wiki
#   hubot jira - Reply with URL for the kanban board
#   hubot PCMS - Replies with prod PCMS URLs
#   hubot backlog - Replies with URL for the planning board


module.exports = (robot) ->
  robot.respond /wiki$/i, (msg) ->
    msg.send "https://github.com/sky-uk/atlas-mobile/wiki"

  robot.respond /jira$/i, (msg) ->
    msg.send "https://developer.bskyb.com/jira/secure/RapidBoard.jspa?rapidView=7981"

  robot.respond /backlog$/i, (msg) ->
    msg.send "https://developer.bskyb.com/jira/secure/RapidBoard.jspa?rapidView=8041&view=planning.nodetail&versions=visible&epics=visible"

  robot.respond /pcms$/i, (msg) ->
    msg.send "UK Prod: https://cms.atom.nowtv.com/editor/, EU Prod: https://cms.eu.atom.sky.com/editor/#/home, UK E2E: https://e2e.pcms.awscsi.com/editor/, EU E2E: https://eu-e2e.pcms.awscsi.com/editor/#/home"


  banter = [
    "That guy who was obsessed with Monzo?",
    "Who? He is nothing to me.",
    "Aw I miss that guy... NOT",
    "Pretty sure it's his turn to run a retro",
    "I heard he killed a guy",
    "Apparently he's in prison now",
    "Nope, don't know him",
    "WHAT A BEARD",
    "Eugh, definition of hipster",
    "Think he's missed a semicolon again"
    "Wasn't he one of those grads?"
  ]

  lateComments = [
    "TEN POINTS FROM GRYFFINDOR",
    "Late? A wizard is never late",
    "Tut tut",
    "*tutting noise*",
    "Ummmmm... I'm telling",
    "TEN POINTS FROM SLYTHERIN",
    "TEN POINTS FROM RAVENCLAW",
    "TEN POINTS FROM HUFFLEPUFF",
    "*Better three hours too soon than a minute too late* - William Shakespeare",
    "*A man who dreads trials and difficulties cannot become a revolutionary. If he is to become a revolutionary with an indomitable fighting spirit, he must be tempered in the arduous struggle from his youth. As the saying goes, early training means more than late earning.* - Kim Jong Il"
  ]

  robot.hear /.*( Dom ).*/i, (msg) ->
    msg.send msg.random banter


  robot.hear /.*(Leeds).*/i, (msg) ->
    msg.send "GRAAAAAYVVVEEEH"

  robot.hear /.*( late ).*/i, (msg) ->
    msg.send msg.random lateComments
