# Description:
#   Provides work related stuff 
#
# Commands:
#   hubot wiki - Reply with URL for the wiki 
#   hubot android build server - Reply with URL for Android Build Server
#   hubot iphone config - Reply with URL for iPhone config
#   hubot android config - Reply with URL for Android config
#   hubot live stream - Reply with URL for live stream
#   hubot service desk - Reply with contact details for the DC service desk


module.exports = (robot) ->
  robot.respond /wiki$/i, (msg) ->
    msg.send "http://wiki.scoop.bskyb.com/wiki/Main_Page"


  robot.respond /android build server$/i, (msg) ->
    msg.send "http://mobile-build.scoop.bskyb.com/"


  robot.respond /iphone config$/i, (msg) ->
    msg.send "http://app.news.sky.com/ios/config.json"


  robot.respond /android config$/i, (msg) ->
    msg.send "http://app.news.sky.com/android/config.json"


  robot.respond /live stream$/i, (msg) ->
    msg.send "http://skydvn-ssmtv-mobile-prod.mobile-tv.sky.com/ssmtv-skynews/1404/sn.m3u8"


  robot.respond /service desk$/i, (msg) ->
    msg.send "Business hours: 0113 243 2973, dcservicedesk@sky.uk, Out of Hours: 0113 243 2973" 

  banter = [
    "You mean that guy who sold out and went to Gravy town?",
    "Who? He is nothing to me.",
    "He'll never fit in. He doesn't eat enough gravy.",
    "GRRAAAVVEEEHHHH",
    "*KAVEY",
    "Aw I miss that guy... NOT",
    "Pretty sure it's his turn to run a retro",
    "Ooo he said he would bring everyone some donuts!",
    "Does he support Leeds United yet?",
    "He is a strong independent man.",
    "I heard he killed a guy",
    "Nope, don't know him",
    "WHAT A BEARD",
    "Get that man a tequila",
    "Will anyone keep him company in his spare bedroom?",
    "Stratford was better",
    "Fiesty one he is",
    "Bad boy 4 lyf",
    "Think he's missed a semicolon again"
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

  robot.hear /.*(kavi).*/i, (msg) ->
    msg.send msg.random banter 


  robot.hear /.*(Leeds).*/i, (msg) ->
    msg.send "GRAAAAAYVVVEEEH"
    
  robot.hear /.*(late ).*/i, (msg) ->
    msg.send msg.random lateComments




