# Description:
#   Returns a random top rated Sky News comment
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot sn comment - Gives a random top rated Sky News comment
#
# Author:
#   GantMan

module.exports = (robot) ->
  robot.respond /sn comment/i, (msg) ->
  	robot.adapter.typing and robot.adapter.typing(msg.envelope)
  	msg.http("https://sky-news-comment.herokuapp.com/")
      .get() (err, res, body) ->
        msg.send "_*'" + JSON.parse(body).comment + "'*_ - " + JSON.parse(body).numberOfLikes + " likes " + JSON.parse(body).storyTitle 
