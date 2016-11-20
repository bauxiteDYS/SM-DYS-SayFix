Say Command Fix
==================================

There is an issue with string parsing for client side chat (the say and say_team commands) in Dystopia that will cause a server to crash; it does not manifest itself when using the say command, server side. To explain it, I will first describe a feature of the client side version of the commands: if the first character of the passed argument is ", then the first, and final characters will be truncated. I imagine the rationale for this design choice is so that chat messages can be surrounded by quotes (this will be done to any message submitted through the chat prompt).

So, if the submitted string is only two characters long, or shorter, this essentially creates an empty string. I believe the empty string condition is what crashes the server. This can work in unexpected ways to cause crashes, even from the chat prompt, which surrounds all messages with quotes. Consider the input ";. The chat prompt would cause this to be submitted as say "";". ; has the syntactical significance of indicating the end of a command, so it would be interpreted as: `say "" <END OF COMMAND> "`. This produces the same empty string condition.

Further evidence to support this is that the SourceMod server addon will prevent the crash if `say ""` is entered. I believe the section of code responsible for this is near the comment that starts with "The server normally won't display empty say commands, but in this case it does" here: https://github.com/alliedmodders/sourcemod/blob/master/core/ChatTriggers.cpp The reason SourceMod does not block all incidences of the empty string condition, is that the check only occurs if the first and last characters are quotes, and the processing performed by SourceMod occurs before that performed by the game.

----------------------------------

This plugin is written in the SourcePawn transitional syntax, and seeks to remedy the issue. It will do so by checking arguments passed to the say and say_team commands by a client. If the argument begins with a " but does not end with one, then produced chat message will consist of the entire string, with no characters truncated. Otherwise, the plugin will allow the standard behavior of the command.

There were different ways that I could have handled the special case, and I think the way chosen for this plugin is fairly sane. My rationale for simply printing the entire string, is to default to the behavior of the server side say command.
