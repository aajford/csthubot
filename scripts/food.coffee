# Description:
#   Returns the menu for NHC4
#
# Dependencies:
#   "pdf-text": ""
#
# Configuration:
#   None
#
# Commands:
#   hubot menu nhc4 - Returns the menu for NHC4
#
# Author:
#   Aaron

pdfText = require "pdf-text"

module.exports = (robot) ->
  robot.respond /nhc4/i, (msg) ->
  	robot.adapter.typing and robot.adapter.typing(msg.envelope)

  	# request and save menu


  	# Parse menu



  	# Send message containing menu
     

