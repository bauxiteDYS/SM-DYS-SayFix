/**
 * A plugin to fix handling of strings beginning with a quotation mark (") but not ending with one
 * by the say and say_team commands. For example: say "test would originally produce tes as the chat message.
 * If the string was only two characters long, such as in the case of say "t the server would crash.
 * Bauxite update: Messages that will cause server to crash will simply not be sent.
 */

#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

					// TODO: Are these message lengths right?
#define CHAT_MESSAGE_STRL 	192 	// Maximum length of body of chat message
#define FULL_CHAT_MESSAGE_STRL	256 	// Maximum length of entire chat message

public Plugin myinfo =
{
	name = "Dys Say Command Fix",
	author = "emjay, bauxite",
	description = "Fixes an issue with parsing a string beginning with a quote by say and say_team.",
	version = "0.1.0",
	url = "https://forums.alliedmods.net/showthread.php?p=2472497"
};

public void OnPluginStart()
{
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");
}

public Action Command_Say(int client, const char[] command, int argc)
{
	char SayParam[CHAT_MESSAGE_STRL];
	int SayParamLength = GetCmdArgString( SayParam, sizeof(SayParam) );
	
	if(SayParamLength < 1 || SayParam[SayParamLength - 1] == '"' || SayParam[0] != '"')
	{
		return Plugin_Continue;
	}
	
	return Plugin_Stop;
}
