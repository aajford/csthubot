# Description:
#   Provides konami code
#
# Commands:
#   hubot konami code - respond with konami code


module.exports = (robot) ->
  robot.respond /konami code$/i, (msg) ->
    msg.send "Up Up Down Down Left Right Left Right B A Enter"

