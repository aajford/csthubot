# Description:
#   Provides work related stuff 
#
# Commands:
#   hubot wiki - Reply with URL for the wiki 
#   hubot jira - Reply with URL for the board 
#   hubot service desk - Reply with contact details for the DC service desk
#   hubot I'm being asked about Sky News - Tells you what to do

module.exports = (robot) ->
  robot.respond /wiki$/i, (msg) ->
    msg.send "https://developer.bskyb.com/wiki/pages/viewpage.action?spaceKey=IOCS&title=OTT+Client+Services+Home#"

  robot.respond /jira$/i, (msg) ->
    msg.send "https://developer.bskyb.com/jira/secure/RapidBoard.jspa?rapidView=439&view=detail&selectedIssue=IOCS-75"

  robot.hear /.*(Sky News).*/i, (msg) ->
  	msg.send "Enough Already! Tell them to contact the Service Desk and it'll be fixed next year. Business hours: 0113 243 2973, dcservicedesk@sky.uk, Out of Hours: 0113 243 2973" 

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
    
  robot.hear /.*( late).*/i, (msg) ->
    msg.send msg.random lateComments




