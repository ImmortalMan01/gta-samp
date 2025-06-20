/**********************************************
 *                                            *
 *   @Author:    ZeeX                         *
 *   @Version:   0.3.2                        *
 *   @Released:  31.10.2009                   *
 *   @Updated:   02.07.2016 by Abyss Morgan   *
 *                                            *
 **********************************************/

#if defined _zcmd_included
	#endinput
#endif
#define _zcmd_included

#if defined CMD
	#error Detected another command system
#endif

#define CMD_SUCCESS 		1
#define CMD_FAILURE 		0

#define MAX_FUNC_NAME 		32
#define MAX_CMD_NAME		27
#define MAX_BUFFER_LEN		128

#define COMMAND:%1(%2)		forward cmd_%1(%2); public cmd_%1(%2)
#define CMD:%1(%2)			COMMAND:%1(%2)
#define command(%1,%2,%3)	COMMAND:%1(%2, %3)
#define cmd(%1,%2,%3) 		COMMAND:%1(%2, %3)

#if !defined isnull
	#define isnull(%1)		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

forward OnPlayerCommandReceived(playerid, cmdtext[]);
forward OnPlayerCommandPerformed(playerid, cmdtext[], success);

static bool:zcmd_g_HasOPCS = false, bool:zcmd_g_HasOPCE = false;

//Hook: OnFilterScriptInit
public OnFilterScriptInit(){
	zcmd_g_HasOPCS = funcidx("OnPlayerCommandReceived") != -1;
	zcmd_g_HasOPCE = funcidx("OnPlayerCommandPerformed") != -1;
	return CallLocalFunction("zcmd_OnFilterScriptInit", "");
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit zcmd_OnFilterScriptInit
forward zcmd_OnFilterScriptInit();

//Hook: OnGameModeInit
public OnGameModeInit(){
	zcmd_g_HasOPCS = funcidx("OnPlayerCommandReceived") != -1;
	zcmd_g_HasOPCE = funcidx("OnPlayerCommandPerformed") != -1;
	if(funcidx("zcmd_OnGameModeInit") != -1){
		return CallLocalFunction("zcmd_OnGameModeInit", "");
	}
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit zcmd_OnGameModeInit
forward zcmd_OnGameModeInit();

//Hook: OnPlayerCommandText
public OnPlayerCommandText(playerid, cmdtext[]){
	if(zcmd_g_HasOPCS && !CallLocalFunction("OnPlayerCommandReceived", "is", playerid, cmdtext)) return 1;
	new pos, funcname[MAX_FUNC_NAME];
	while(cmdtext[++pos] > ' ' && pos < MAX_FUNC_NAME-4){
		#if defined DISABLE_IGNORE_CASE
			funcname[pos-1] = cmdtext[pos];
		#else
			funcname[pos-1] = tolower(cmdtext[pos]);
		#endif
	}
	format(funcname, sizeof(funcname), "cmd_%s", funcname);
	while(cmdtext[pos] == ' ') pos++;
	if(!cmdtext[pos]){
		if(zcmd_g_HasOPCE) return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, "\1"));
		return CallLocalFunction(funcname, "is", playerid, "\1");
	}
	if(zcmd_g_HasOPCE) return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, cmdtext[pos]));

	return CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
}

#if defined _ALS_OnPlayerCommandText
	#undef OnPlayerCommandText
#else
	#define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText zcmd_OnPlayerCommandText
forward zcmd_OnPlayerCommandText(playerid, cmdtext[]);

//EOF