#include  <sourcemod>
#include  <discord>
#include  <calladmin>

DiscordBot gbot;

public Plugin myinfo =
{
	name = "Discord CHAT",
	author = "Cahid Armatura",
	description = "",
	version = "1.0.1",
	url = "https://github.com/zloybik/"
};

public void OnPluginStart() {
    HookEvent("player_say", SendToDiscord);
}

public void OnAllPluginsLoaded() {
	gbot = new DiscordBot("bot toke put here");
	gbot.SendMessageToChannelID("id your channel", "Server now is online!");
}

public Action SendToDiscord(Event event, const char[] name, bool dontBroadcast) {
	bool team;
	event.GetBool("teamonly", team);

	if(team == false) {

		int client = GetClientOfUserId(event.GetInt("userid"));

		char nickname[64];
		GetClientName(client, nickname, sizeof(nickname));

		char hostname[64];
		CallAdmin_GetHostName(hostname, sizeof(hostname));


		char message[2056];
		event.GetString("Text", message, sizeof(message));

		if(StrEqual(hostname, nickname)) {
			//.. nothing
		}
		else {
			char dMSG[2056];
			Format(dMSG, sizeof(dMSG), "```%s: %s ```", nickname, message);

			gbot.SendMessageToChannelID("id your channel", dMSG);
		}
	}
}

public void OnClientConnected(int client) {
	char Nickname[64];
	GetClientName(client, Nickname, sizeof(Nickname));

	int CountPlayers;	
	GetRealClientCount(CountPlayers);

	char dMSG[2056];
	
	Format(dMSG, sizeof(dMSG), "%s connected to server! Online in server %d/%d", Nickname, CountPlayers, MaxClients);
	gbot.SendMessageToChannelID("id your channel", dMSG)
}

public void OnClientDisconnect_Post(int client) {
	char Nickname[64];
	GetClientName(client, Nickname, sizeof(Nickname));

	int CountPlayers;	
	GetRealClientCount(CountPlayers);

	char dMSG[2056];
	
	Format(dMSG, sizeof(dMSG), "%s get disconnected server! Online in server %d/%d", Nickname, CountPlayers, MaxClients);
	gbot.SendMessageToChannelID("id your channel", dMSG)
}

stock GetRealClientCount(int iClients) {
    iClients = 0;

    for (new i = 1; i <= MaxClients; i++) {
        if (IsClientInGame(i) && !IsFakeClient(i)) {
            iClients++;
        }
    }

    return iClients;
} 