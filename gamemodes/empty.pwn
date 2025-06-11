#include <a_samp>
#include <extra/a_mysql>
#include <extra/zcmd>
#include <extra/sscanf2>
#include <extra/foreach>
#include <extra/streamer>
#include <extra/easyDialog>
#include <extra/weapon-config>
#include <discord-cmd>
#include <discord-connector>

#define function:%0(%1) forward %0(%1); public %0(%1)

#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0


// -----------------------------------------------------------------------------------
#define COLOR_FADE1 0xFFFFFFFF
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_LIGHTGREEN  (0x9ACD32FF)
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_RADIO       (0x8D8DFFFF)
#define COLOR_PURPLE      (0xD0AEEBFF)
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_MIDNIGHTBLUE 0X191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define DEVELOPER_	"Leader"
#define COLOR_ORANGERED   (0xFF4500AA)
#define COLOR_PINK        (0xFFC0CBAA)
#define COLOR_SEAGREEN 	  (0x2E8B57AA)
#define COLOR_SPRINGGREEN (0x00FF7FAA)
#define COLOR_CLIENT      (0xAAC4E5FF)
#define COLOR_CYAN        (0xC2A2DAAA)
#define COLOR_ADMINCHAT   (0xAA3333AA)
#define COLOR_DEPARTMENT  (0xF0CC00FF)
#define COLOR_DARKBLUE    (0x1394BFFF)


// ------------------------------------------------------------------------------

#define MesajGonder(%0,%1) \
	SendClientMessageEx(%0, COLOR_GREEN, "Sunucu: {FFFFFF}"%1)

#define BilgiMesajGonder(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTBLUE, "Sunucu: {FFFFFF}"%1)

#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA

#define HataMesajGonder(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "Sunucu: {FFFFFF}"%1)

#define SendAdminAction(%0,%1) \
	SendClientMessageEx(%0, COLOR_CLIENT, " {FFFFFF}"%1)

#define 	LOBI_ANA_DIALOG		(1)

#define 	LOBI_DIALOG_1 		(2)
#define 	LOBI_DIALOG_2 		(3)
#define 	LOBI_DIALOG_3 		(4)
#define 	LOBI_DIALOG_4 		(5)
#define	 	LOBI_DIALOG_5 		(6)
#define     Ayarlar             (7)

// TDM Sistemi

#define 	MAVI_TAKIM			(1) // sinif 1 (blue)
#define 	KIRMIZI_TAKIM		(2) // sinif 2 (red)

// GW Sistemi

#define 	GROVE_GANG_TEAM			(3)
#define 	BALLAS_GANG_TEAM		(4)
#define		VAGOS_GANG_TEAM			(5)

#define 	TDM_ANA_DIALOG 		(7)

#define 	TDM__DIALOG_1		(8)
#define 	TDM__DIALOG_2		(9)


#define 	GW_ANA_DIALOG		(11)
#define 	GW_DIALOG_1			(12)
#define		GW_DIALOG_2			(13)

//------------------------------------------------------------------//
#define GM_TYPE    						"HIGHLINE"
#define GAMEMODE_NAME                   "HIGHLINE DEATHMATCH"
#define GAMEMODE_TEXT                   "H:LINE v1.0.0"
#define GAMEMODE_WEB                    "N/A"
#define GAMEMODE_LANG                   "Türkçe"
#define GAMEMODE_MAP					"Los Santos"
#define DEFAULT_SKIN					(60)
//------------------------------------------------------------------//
#define REGISTER_METHOD 				(1)
#define LOGIN_METHOD 					(2)
#define AFTER_LOGIN_METHOD 				(3)

#define ROOM_EMPTY						(1)
#define ROOM_FREEROAM					(1)
#define ROOM_DERBY						(2)

#define READING_RULE_TIME 				(5)//sec
//------------------------------------------------------------------//

#define MAX_YARDIM_KOMUTLARI (300)
enum komutEnum
{
	komutVarmi,
	komutAd[24],
	komutTanim[256],
	komutKatagori,
	komutOlusum
};
new Komutlar[MAX_YARDIM_KOMUTLARI][komutEnum];

new Text3D:katil[MAX_PLAYERS];
new botoyuncusayi;
new MySQL: conn;
//******TEXTDRAWS******//
new PlayerText:SureliKararti[MAX_PLAYERS];
new PlayerText:KayitGiris[13][MAX_PLAYERS];
//******ALL TIMERS******//
new GirisEfektSondur[MAX_PLAYERS];
new KayitGirisEkrani[MAX_PLAYERS];
new KurallariOku[MAX_PLAYERS];
new bool:Lobi[MAX_PLAYERS];
new bool:DMLobi[MAX_PLAYERS];
new bool:MobilDMLobi[MAX_PLAYERS];
new DmLobiOyuncular;
new DmLobiOyuncularMobil;
new ToplamOyuncu;
new gKillStreak[MAX_PLAYERS];
//------------------------------------------------------------------//

enum pDatas
{
	pSQLID,
	pAdminLevel,
	pRegisterOrLogin,
	pPassword[30],
	pCash,
	pKills,
	pDeaths,
	pBan,
	pFirstLogin,
	pRuleReading,
	pRoom,
	bool:pSpawnProtect
};
new playerData[MAX_PLAYERS][pDatas];


new Float:DM_SPAWN[][] =
{
	{268.1281,185.5068,1008.1719,357.4528},
	{246.4032,185.5457,1008.1719,355.0674},
	{262.3208,185.9815,1008.1719,359.3580},
	{238.3053,194.6026,1008.1719,182.0673},
	{238.5143,140.2580,1003.0234,359.3040},
	{209.8930,142.3550,1003.0234,271.6427},
	{229.7181,178.8799,1003.0313,88.2170},
	{191.9452,179.6135,1003.0234,270.2227}
};


new Float:DM_SPAWN_MOBIL[][] =
{
	{268.1281,185.5068,1008.1719,357.4528},
	{246.4032,185.5457,1008.1719,355.0674},
	{262.3208,185.9815,1008.1719,359.3580},
	{238.3053,194.6026,1008.1719,182.0673},
	{238.5143,140.2580,1003.0234,359.3040},
	{209.8930,142.3550,1003.0234,271.6427},
	{229.7181,178.8799,1003.0313,88.2170},
	{191.9452,179.6135,1003.0234,270.2227}
};

main()
{
	print("\n----------------------------------");
	printf(" %s DeathMatch >> Geliþtirici: %s", GM_TYPE, DEVELOPER_);
	print("----------------------------------\n");
}

//-------- STOCK'S --------

stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static args, str[144];

	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return true;
}

stock DeniedAuthority(playerid)
{
	SendClientMessage(playerid, 0xd90f00FF, "Leader Bu komutu kullanamazsýn.");
	return true;
}

stock GetPlayerSpeed(playerid)
{
	new Float:xx, Float:yy, Float:zz, Float:pSpeed;
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid),xx,yy,zz);
	}
	else
	{
		GetPlayerVelocity(playerid,xx,yy,zz);
	}
	pSpeed = floatsqroot((xx * xx) + (yy * yy) + (zz * zz));
	return floatround((pSpeed * 160.12));
}

stock GetPlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetUnixTimeStampValue()
{
	new unixvalue[11], year, month, day, hour, minute, second;
	getdate(year, month, day); gettime(hour, minute, second);
	//#pragma unused second
	format(unixvalue, sizeof(unixvalue), "%02d/%02d/%d - %02d:%02d", day, month, year, hour, minute);
	return unixvalue;
}

stock ConvertUnixTimeStamp(zamanlayici, _format = 0)
{
	new year=1970, day=0, month=0, hour=0, mins=0, sec=0;

	new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
	new names_of_month[12][10] = {"Ocak","Subat","Mart","Nisan","Mayis","Haziran","Temmuz","Agustos","Eylul","Ekim","Kasim","Aralik"};
	new returnstring[36];

	while(zamanlayici>31622400){
		zamanlayici -= 31536000;
		if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) zamanlayici -= 86400;
		year++;
	}

	if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
		days_of_month[1] = 29;
	else
		days_of_month[1] = 28;


	while(zamanlayici>86400){
		zamanlayici -= 86400, day++;
		if(day==days_of_month[month]) day=0, month++;
	}

	while(zamanlayici>60){
		zamanlayici -= 60, mins++;
		if( mins == 60) mins=0, hour++;
	}

	sec=zamanlayici;
	new zamanfix;
	zamanfix = hour + 3;
	if(zamanfix >= 24)
	{
		zamanfix = 0;
	}
	switch( _format ){
		case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, zamanfix, mins, sec);
		case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, zamanfix, mins, sec);
		case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,zamanfix,mins);
		case 4: format(returnstring, 31, "%02d.%02d.%d", day+1, month+1, year);
		case 5: format(returnstring, 31, "%02d/%02d/%d - %02d:%02d", day+1, month+1, year, zamanfix, mins);
		default: format(returnstring, 31, "%02d.%02d.%d - %02d:%02d:%02d", day+1, month+1, year, zamanfix, mins, sec);
	}

	return returnstring;
}

stock HazirKayitGirisMenusu(playerid, dialog_, string[] = "")
{
	new datastring[128 * 5];
	if(strlen(string) >= 1)
	{
		format(datastring, sizeof(datastring), "{CC0000}ERR: %s{FFFFFF}\n\n", string);
	}

	switch(dialog_)
	{
		case REGISTER_METHOD:
		{
			if(playerData[playerid][pRuleReading] >= 1 && playerData[playerid][pRuleReading] < READING_RULE_TIME) return true;
			format(datastring, sizeof(datastring), "%s{FFFFFF}Hoþ geldin,{1AFF1A}%s{FFFFFF}. Kayýt olmak için aþaðýdaki kutucuða bir þifre girin:", datastring, GetPlayerNameEx(playerid));
			Dialog_Show(playerid, KAYIT_MENUSU, DIALOG_STYLE_INPUT, "{1EC684}>{13DE8E}>{06FE9C}>{FFFFFF} Kayýt Sekmesi", datastring, "Onayla", "Iptal");
		}
		case LOGIN_METHOD:
		{
			if(strlen(playerData[playerid][pPassword]) < 1)
			{
				format(datastring, sizeof(datastring), "%s{FFFFFF}Tekrardan hoþ geldin, {1AFF1A}%s{FFFFFF}! Giriþ yapmak için aþaðýdaki kutucuða kayýt þifrenizi girin:", datastring, GetPlayerNameEx(playerid));
				Dialog_Show(playerid, GIRIS_MENUSU, DIALOG_STYLE_PASSWORD, "{1EC684}>{13DE8E}>{06FE9C}>{FFFFFF} Giriþ Sekmesi", datastring, "Onayla", "Iptal");
			}
			else
			{
				LoginMethodControl(playerid, playerData[playerid][pPassword]);
			}
		}
		default: Kick(playerid);
	}
	return true;
}

stock ShowServerRules(playerid)
{
	new waitingtime[32], laststring[128], dialogstring[1024 * 3], header_[128];
	if(playerData[playerid][pRuleReading] > 0)
	{
		format(waitingtime, sizeof(waitingtime), "BEKLE {FF0000}(%d)", playerData[playerid][pRuleReading]);
	}
	else if(playerData[playerid][pRuleReading] <= 0)
	{
		format(waitingtime, sizeof(waitingtime), "{47B1FF}OK");
		if(playerData[playerid][pRuleReading] == 0)
		{
			format(laststring, sizeof(laststring), "\n{DE0D0D}** KayÄ±t iÅŸlemine devam edebilirsiniz.");
		}
		else if(playerData[playerid][pRuleReading] == -1)
		{
			format(laststring, sizeof(laststring), "\n{7C7C7C}** KurallarÄ± baÅŸtan sona okudunuz ve tÃ¼mÃ¼nÃ¼ kabul ettiniz.");
		}
	}
	format(dialogstring, sizeof(dialogstring), "%s\n{FFFFFF}1.) ÃœstÃ¼nlÃ¼k saÄŸlayan modlar kullanmak YASAKTIR. (Hileler, Ã¼Ã§Ã¼ncÃ¼ parti yazÄ±lÄ±m ile eklenti eklemek vb.).\n", dialogstring);
	format(dialogstring, sizeof(dialogstring), "%s2.) Herhangi bir ceza aldÄ±ÄŸÄ±nÄ±zda, ceza sÃ¼resini beklemeden yeni hesap aÃ§mak YASAKTIR.\n", dialogstring);
	format(dialogstring, sizeof(dialogstring), "%s3.) Herkese aÃ§Ä±k kanallarda hakaret etmek ve arka arkaya hÄ±zlÄ± bir ÅŸekilde yazmak YASAKTIR.\n", dialogstring);
	if(strlen(laststring) > 0)
	{
		format(dialogstring, sizeof(dialogstring), "%s%s", dialogstring, laststring);
	}
	format(header_, sizeof(header_), "{8044A5}>{902ACE}>{BA47FF}>{FFFFFF} Zorunlu Tutulan Sunucu KurallarÄ± %s", (playerData[playerid][pRuleReading] <= 0) ? ("{6CFE44}[OKUNDU]") : ("{9D9D9D}[OKUNMADI]"));
	Dialog_Show(playerid, SUNUCU_KURALLARI, DIALOG_STYLE_MSGBOX, header_, dialogstring, waitingtime, "");
	return true;
}

//-------- FUNCTION'S --------

function:LoginMethodControl(playerid, inputtext[])
{
	if(strlen(inputtext) < 6) return HazirKayitGirisMenusu(playerid, LOGIN_METHOD, "GeÃ§ersiz ÅŸifre!");

	new query[128], Cache:getQuery;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM `oyuncular` WHERE `Nick` LIKE '%e' AND `Password` LIKE sha1('%e') LIMIT 1", GetPlayerNameEx(playerid), inputtext);
	getQuery = mysql_query(conn, query);

	if(cache_num_rows())
	{
		playerData[playerid][pRegisterOrLogin] = AFTER_LOGIN_METHOD;
		playerData[playerid][pRoom] = ROOM_FREEROAM;

		for(new i ; i < sizeof(KayitGiris); i ++)
		{
			PlayerTextDrawHide(playerid, KayitGiris[i][playerid]);
		}
		// SPAWN OLDUÐUMUZ KISIM
		new string[250];
		TogglePlayerSpectating(playerid, false);
		SpawnPlayer(playerid);
		CancelSelectTextDraw(playerid);
		SetPVarInt(playerid, "EffectValue", 1);
		Giris_TextdrawSondur(playerid);
		SetPlayerPos(playerid, 1714.6244, -1645.1664, 20.2242);
		SetPlayerFacingAngle(playerid, 228.1528);
		SetPlayerInterior(playerid, 18);
		Lobi[playerid] = true;
		MesajGonder(playerid, "Baþarýyla oyun hesabýna giriþ yaptýn, iyi eðlenceler.");
  		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
  		format(string, sizeof(string), "~g~~h~~h~~h~HOS GELDIN!~n~~w~~h~~h~~h~%s", OyuncuIsim(playerid));
  		GameTextForPlayer(playerid, string, 5000, 1);
	    if(IsPlayerAndroid(playerid))
	    {
	        MesajGonder(playerid, "SAMP istemcinin MOBIL tabanlý olduðu tespit edildi.");
	    }
	    else
		{
		    MesajGonder(playerid, "SAMP istemcinin PC tabanlý olduðu tespit edildi.");
		}
  		if(playerData[playerid][pAdminLevel] > 0)
  		{
  		    SendClientMessageToAllEx(-1, "{8470ff}* {FFFFFF}Sobeitlerin korkulu rüyasý %s %s sunucuya katýldý.", AdminRutbe(playerid), OyuncuIsim(playerid));
  		    return 1;
  		}
        if(playerData[playerid][pAdminLevel] == 0)
  		{
  		    SendClientMessageToAllEx(-1, "{8470ff}* {FFFFFF}%s aksiyona atladý. (%d/999)", OyuncuIsim(playerid), ToplamOyuncu);
  		    return 1;
  		}
	}
	else{
		HazirKayitGirisMenusu(playerid, LOGIN_METHOD, "Kullanýcý adý veya þifre yanlýþ.");
	}
	cache_delete(getQuery);
	return true;
}

function:ReplacedRandomFunc(randvalue)
{
	return random(randvalue + 1);
}

function:RconExitTimer()
{
	return SendRconCommand("exit");
}

function:LoadGamemodeSettings()
{
    mysql_log(ERROR | WARNING);
    conn = mysql_connect("localhost", "root", "", "highline");
    if(mysql_errno(conn)) return printf("--------------------------------------\n\nâ€¢[!mySQL]: Veritabani baglantisi basarisiz, sunucu kapaniyor."), SetTimer("RconExitTimer", 1000, true);

    mysql_set_charset("latin5", conn);
    printf("--------------------------------------\n\n[mySQL]: Veritabani baglantisi basariyla saglandi.");

	//------------------------------------------------//
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(12);
	SetObjectsDefaultCameraCol(true);
	ManualVehicleEngineAndLights();
	//------------------------------------------------//
	new stringsize[128];
	format(stringsize, sizeof(stringsize), "rcon_password leaderbabasifirmod1239123"); SendRconCommand(stringsize);
	format(stringsize, sizeof(stringsize), "hostname %s", GAMEMODE_NAME); SendRconCommand(stringsize);
	format(stringsize, sizeof(stringsize), "%s", GAMEMODE_TEXT); SetGameModeText(stringsize);
	format(stringsize, sizeof(stringsize), "weburl %s", GAMEMODE_WEB); SendRconCommand(stringsize);
	format(stringsize, sizeof(stringsize), "language %s", GAMEMODE_LANG); SendRconCommand(stringsize);
	format(stringsize, sizeof(stringsize), "mapname %s", GAMEMODE_MAP); SendRconCommand(stringsize);

	return true;
}

function:LoadPlayerTextDraws(playerid)
{
	SureliKararti[playerid] = CreatePlayerTextDraw(playerid, 318.000000, 0.000000, "_");
	PlayerTextDrawFont(playerid, SureliKararti[playerid], 1);
	PlayerTextDrawLetterSize(playerid, SureliKararti[playerid], 0.600000, 50.000000);
	PlayerTextDrawTextSize(playerid, SureliKararti[playerid], 298.500000, 650.000000);
	PlayerTextDrawSetOutline(playerid, SureliKararti[playerid], 1);
	PlayerTextDrawSetShadow(playerid, SureliKararti[playerid], 0);
	PlayerTextDrawAlignment(playerid, SureliKararti[playerid], 2);
	PlayerTextDrawColor(playerid, SureliKararti[playerid], 255);
	PlayerTextDrawBackgroundColor(playerid, SureliKararti[playerid], 255);
	PlayerTextDrawBoxColor(playerid, SureliKararti[playerid], 255);
	PlayerTextDrawUseBox(playerid, SureliKararti[playerid], 1);
	PlayerTextDrawSetProportional(playerid, SureliKararti[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, SureliKararti[playerid], 0);
	PlayerTextDrawShow(playerid, SureliKararti[playerid]);

	KayitGiris[0][playerid] = CreatePlayerTextDraw(playerid, 123.000000, 106.000000, "_");
	PlayerTextDrawFont(playerid, KayitGiris[0][playerid], 1);
	PlayerTextDrawLetterSize(playerid, KayitGiris[0][playerid], 0.579165, 28.099998);
	PlayerTextDrawTextSize(playerid, KayitGiris[0][playerid], 298.500000, 180.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid, KayitGiris[0][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[0][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[0][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[0][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[0][playerid], 336860415);
	PlayerTextDrawUseBox(playerid, KayitGiris[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[0][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[0][playerid], 0);

	KayitGiris[1][playerid] = CreatePlayerTextDraw(playerid, 126.000000, 123.000000, "HIGHLINE DM");
	PlayerTextDrawFont(playerid, KayitGiris[1][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KayitGiris[1][playerid], 0.274998, 1.299998);
	PlayerTextDrawTextSize(playerid, KayitGiris[1][playerid], 400.000000, 249.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[1][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[1][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[1][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[1][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[1][playerid], 50);
	PlayerTextDrawUseBox(playerid, KayitGiris[1][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KayitGiris[1][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[1][playerid], 0);

	KayitGiris[2][playerid] = CreatePlayerTextDraw(playerid, 123.000000, 173.000000, "~l~Bu kullanici adina ait hesap ~r~~h~yok~l~.");
	PlayerTextDrawFont(playerid, KayitGiris[2][playerid], 1);
	PlayerTextDrawLetterSize(playerid, KayitGiris[2][playerid], 0.170833, 0.899999);
	PlayerTextDrawTextSize(playerid, KayitGiris[2][playerid], 400.000000, 180.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[2][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[2][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[2][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[2][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[2][playerid], 100);
	PlayerTextDrawBoxColor(playerid, KayitGiris[2][playerid], -1061109660);
	PlayerTextDrawUseBox(playerid, KayitGiris[2][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[2][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[2][playerid], 0);

	KayitGiris[3][playerid] = CreatePlayerTextDraw(playerid, 68.000000, 215.000000, "_");
	PlayerTextDrawFont(playerid, KayitGiris[3][playerid], 1);
	PlayerTextDrawLetterSize(playerid, KayitGiris[3][playerid], -0.099999, 1.650002);
	PlayerTextDrawTextSize(playerid, KayitGiris[3][playerid], 263.500000, 16.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[3][playerid], 1);
	PlayerTextDrawSetShadow(playerid, KayitGiris[3][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[3][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[3][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[3][playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, KayitGiris[3][playerid], 1296911871);
	PlayerTextDrawUseBox(playerid, KayitGiris[3][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[3][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[3][playerid], 0);

	KayitGiris[4][playerid] = CreatePlayerTextDraw(playerid, 61.000000, 214.000000, "HUD:radar_gangy");
	PlayerTextDrawFont(playerid, KayitGiris[4][playerid], 4);
	PlayerTextDrawLetterSize(playerid, KayitGiris[4][playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KayitGiris[4][playerid], 13.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[4][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[4][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[4][playerid], 1);
	PlayerTextDrawColor(playerid, KayitGiris[4][playerid], 1097458160);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[4][playerid], 0);
	PlayerTextDrawBoxColor(playerid, KayitGiris[4][playerid], 0);
	PlayerTextDrawUseBox(playerid, KayitGiris[4][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KayitGiris[4][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[4][playerid], 0);

	KayitGiris[5][playerid] = CreatePlayerTextDraw(playerid, 80.000000, 216.000000, "_");
	PlayerTextDrawFont(playerid, KayitGiris[5][playerid], 1);
	PlayerTextDrawLetterSize(playerid, KayitGiris[5][playerid], 0.183330, 1.400002);
	PlayerTextDrawTextSize(playerid, KayitGiris[5][playerid], 185.000000, 104.500000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[5][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[5][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[5][playerid], 1);
	PlayerTextDrawColor(playerid, KayitGiris[5][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[5][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[5][playerid], 1296911849);
	PlayerTextDrawUseBox(playerid, KayitGiris[5][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[5][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[5][playerid], 0);

	KayitGiris[6][playerid] = CreatePlayerTextDraw(playerid, 81.000000, 218.000000, "Leader");
	PlayerTextDrawFont(playerid, KayitGiris[6][playerid], 1);
	PlayerTextDrawLetterSize(playerid, KayitGiris[6][playerid], 0.158333, 0.949998);
	PlayerTextDrawTextSize(playerid, KayitGiris[6][playerid], 186.000000, 10.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[6][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[6][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[6][playerid], 1);
	PlayerTextDrawColor(playerid, KayitGiris[6][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[6][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[6][playerid], 50);
	PlayerTextDrawUseBox(playerid, KayitGiris[6][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KayitGiris[6][playerid], 1);

	KayitGiris[7][playerid] = CreatePlayerTextDraw(playerid, 123.000000, 245.000000, "KAYIT OL");
	PlayerTextDrawFont(playerid, KayitGiris[7][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KayitGiris[7][playerid], 0.187500, 1.350003);
	PlayerTextDrawTextSize(playerid, KayitGiris[7][playerid], 10.000000, 128.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[7][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[7][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[7][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[7][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[7][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[7][playerid], 1433087944);
	PlayerTextDrawUseBox(playerid, KayitGiris[7][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[7][playerid], 1);

	KayitGiris[8][playerid] = CreatePlayerTextDraw(playerid, 123.000000, 263.000000, "OYUN KURALLARI");
	PlayerTextDrawFont(playerid, KayitGiris[8][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KayitGiris[8][playerid], 0.187500, 1.350003);
	PlayerTextDrawTextSize(playerid, KayitGiris[8][playerid], 10.000000, 128.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[8][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[8][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[8][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[8][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[8][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[8][playerid], 1296911716);
	PlayerTextDrawUseBox(playerid, KayitGiris[8][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[8][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[8][playerid], 1);

	KayitGiris[9][playerid] = CreatePlayerTextDraw(playerid, 126.000000, 144.000000, "V1.0");
	PlayerTextDrawFont(playerid, KayitGiris[9][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KayitGiris[9][playerid], 0.216665, 1.099997);
	PlayerTextDrawTextSize(playerid, KayitGiris[9][playerid], 400.000000, 249.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[9][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[9][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[9][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[9][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[9][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[9][playerid], 50);
	PlayerTextDrawUseBox(playerid, KayitGiris[9][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KayitGiris[9][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[9][playerid], 0);

	KayitGiris[10][playerid] = CreatePlayerTextDraw(playerid, 57.000000, 203.000000, "Sifrenizi hic degistiremeyeceginizi unutmayin!");
	PlayerTextDrawFont(playerid, KayitGiris[10][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KayitGiris[10][playerid], 0.095833, 0.850000);
	PlayerTextDrawTextSize(playerid, KayitGiris[10][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[10][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[10][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[10][playerid], 1);
	PlayerTextDrawColor(playerid, KayitGiris[10][playerid], -204);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[10][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[10][playerid], 50);
	PlayerTextDrawUseBox(playerid, KayitGiris[10][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KayitGiris[10][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[10][playerid], 0);

	KayitGiris[11][playerid] = CreatePlayerTextDraw(playerid, 59.000000, 304.000000, "~r~>>~w~ Hos geldin!~n~~n~Her zevke uygun oyun modlari olusuturulmaya devam edilecektir. Eglenceye katilmak icin zaman kaybetme!");
	PlayerTextDrawFont(playerid, KayitGiris[11][playerid], 1);
	PlayerTextDrawLetterSize(playerid, KayitGiris[11][playerid], 0.141665, 0.949998);
	PlayerTextDrawTextSize(playerid, KayitGiris[11][playerid], 187.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[11][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[11][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[11][playerid], 1);
	PlayerTextDrawColor(playerid, KayitGiris[11][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[11][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[11][playerid], 50);
	PlayerTextDrawUseBox(playerid, KayitGiris[11][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KayitGiris[11][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[11][playerid], 0);

	KayitGiris[12][playerid] = CreatePlayerTextDraw(playerid, 123.000000, 281.000000, "HESAP SIZIN MI?");
	PlayerTextDrawFont(playerid, KayitGiris[12][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KayitGiris[12][playerid], 0.187500, 1.350003);
	PlayerTextDrawTextSize(playerid, KayitGiris[12][playerid], 10.000000, 128.000000);
	PlayerTextDrawSetOutline(playerid, KayitGiris[12][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KayitGiris[12][playerid], 0);
	PlayerTextDrawAlignment(playerid, KayitGiris[12][playerid], 2);
	PlayerTextDrawColor(playerid, KayitGiris[12][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KayitGiris[12][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KayitGiris[12][playerid], 1296911716);
	PlayerTextDrawUseBox(playerid, KayitGiris[12][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KayitGiris[12][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KayitGiris[12][playerid], 1);
	return true;
}

function:Giris_TextdrawSondur(playerid)
{
	if(GetPVarInt(playerid, "EffectValue") >= 1)
	{
		SetPVarInt(playerid, "EffectValue", GetPVarInt(playerid, "EffectValue") - 1);
		PlayerTextDrawHide(playerid, SureliKararti[playerid]);
		PlayerTextDrawColor(playerid, SureliKararti[playerid], GetPVarInt(playerid, "EffectValue"));
		PlayerTextDrawBackgroundColor(playerid, SureliKararti[playerid], GetPVarInt(playerid, "EffectValue"));
		PlayerTextDrawBoxColor(playerid, SureliKararti[playerid], GetPVarInt(playerid, "EffectValue"));
		PlayerTextDrawShow(playerid, SureliKararti[playerid]);

		//printf("%d", GetPVarInt(playerid, "EffectValue"));
		if(GetPVarInt(playerid, "EffectValue") <= 1)
		{
			PlayerTextDrawHide(playerid, SureliKararti[playerid]);
			KillTimer(GirisEfektSondur[playerid]);
		}
	}
	return true;
}

function:ApplyLoginEffect(playerid)
{
	GirisEfektSondur[playerid] = SetTimerEx("Giris_TextdrawSondur", 120, true, "i", playerid);
	KayitGirisEkrani[playerid] = SetTimerEx("RegisterLoginScreen", 1800, false, "i", playerid);
	return true;
}

function:GetFirstVariable(playerid)
{
	cache_get_value_name_int(0, "id", playerData[playerid][pSQLID]);
	//-------
	cache_get_value_name_int(0, "AdminLevel", playerData[playerid][pAdminLevel]);
	cache_get_value_name_int(0, "Cash", playerData[playerid][pCash]);
	cache_get_value_name_int(0, "Oldurmeler", playerData[playerid][pKills]);
	cache_get_value_name_int(0, "Olmeler", playerData[playerid][pDeaths]);
	cache_get_value_name_int(0, "ban", playerData[playerid][pBan]);
	return true;
}

function:RegisterLoginScreen(playerid)
{
	PlayerTextDrawSetSelectable(playerid, KayitGiris[7][playerid], true);
	SetSpawnInfo(playerid, NO_TEAM, DEFAULT_SKIN, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	//---
	new query[128], Cache:getQuery;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM `oyuncular` WHERE `Nick` LIKE '%e'", GetPlayerNameEx(playerid));
	getQuery = mysql_query(conn, query);
	if(cache_num_rows())
	{
		playerData[playerid][pRuleReading] = -1;

		PlayerTextDrawSetString(playerid, KayitGiris[2][playerid], "~l~Bu kullanici adina ait hesap ~b~~h~mevcut~l~.");
		PlayerTextDrawSetString(playerid, KayitGiris[6][playerid], GetPlayerNameEx(playerid));
		PlayerTextDrawSetString(playerid, KayitGiris[7][playerid], "GIRIS YAP");
		PlayerTextDrawShow(playerid, KayitGiris[12][playerid]);

		playerData[playerid][pRegisterOrLogin] = LOGIN_METHOD;
		GetFirstVariable(playerid);
	}
	else
	{
		playerData[playerid][pRuleReading] = READING_RULE_TIME;

		PlayerTextDrawSetString(playerid, KayitGiris[2][playerid], "~l~Bu kullanici adina ait hesap ~r~~h~yok~l~.");
		PlayerTextDrawSetString(playerid, KayitGiris[6][playerid], GetPlayerNameEx(playerid));
		PlayerTextDrawSetString(playerid, KayitGiris[7][playerid], "KAYIT OL");
		playerData[playerid][pRegisterOrLogin] = REGISTER_METHOD;
	}

	cache_delete(getQuery);

	for(new i ; i < sizeof(KayitGiris); i ++)
	{
		if(i == 12) {continue;}
		PlayerTextDrawShow(playerid, KayitGiris[i][playerid]);
	}
	SelectTextDraw(playerid, 0xFFFF00FF);
	return true;
}

function:ResetPlayerVariables(playerid)
{
	playerData[playerid][pSQLID] = 0;
	playerData[playerid][pAdminLevel] = 0;
	playerData[playerid][pRegisterOrLogin] = 0;
	playerData[playerid][pCash] = 0;
	playerData[playerid][pKills] = 0;
	playerData[playerid][pDeaths] = 0;
	playerData[playerid][pBan] = 0;
	playerData[playerid][pFirstLogin] = false;
	playerData[playerid][pRuleReading] = READING_RULE_TIME;
	playerData[playerid][pRoom] = ROOM_EMPTY;
	playerData[playerid][pSpawnProtect] = false;
	format(playerData[playerid][pPassword], 30, "");
	//----

	//----
	//TogglePlayerSpectating(playerid, true);
	return true;
}

function:MovePlayerScreen(playerid)
{
	InterpolateCameraPos(playerid, 2159.720947, 2155.392089, 10.163599, 2270.509765, 2127.194824, 47.957729, 50000);
	InterpolateCameraLookAt(playerid, 2164.625244, 2154.479492, 10.501465, 2275.256103, 2128.061767, 46.646144, 50000);
	return true;
}

function:SpawnEx(playerid)
{
 	SpawnPlayer(playerid);
	MovePlayerScreen(playerid);
	ApplyLoginEffect(playerid);
	return true;
}

function:StopAllTimers(playerid)
{
	KillTimer(GirisEfektSondur[playerid]);
	KillTimer(KayitGirisEkrani[playerid]);
	return true;
}

function: UpdateRuleTiming(playerid)
{
	if(playerData[playerid][pRuleReading] < 1)
	{
		KillTimer(KurallariOku[playerid]);
		//--
		PlayerTextDrawHide(playerid, KayitGiris[7][playerid]);
		PlayerTextDrawSetSelectable(playerid, KayitGiris[7][playerid], true);
		PlayerTextDrawShow(playerid, KayitGiris[7][playerid]);

		if(playerData[playerid][pRuleReading] <= 0)
		{
			if(SearchDatabaseByName(GetPlayerNameEx(playerid)) == 0)
			{
				new query[128];
				mysql_format(conn, query, sizeof(query), "INSERT INTO `oyuncular` (`Nick`, `Password`, `Date`) VALUES ('%e', sha1('%e'), '%d')", GetPlayerNameEx(playerid), playerData[playerid][pPassword], gettime());
				mysql_query(conn, query);

				Dialog_Show(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "{BB3434}>{E11F1F}>{FF5C5C}>{FFFFFF} Bilgilendirme KutucuÄŸu", "â€¢ Hesap ÅŸifreniz otomatik olarak getirildi, GÄ°RÄ°Åž YAP butonuna basabilirsiniz.\n\n{7C7C7C}** Kurallara uygun ÅŸekilde davranmayÄ± unutmayÄ±n...", "{FF0000}OK", "");
				RegisterLoginScreen(playerid);
			}
		}
	}
	else
	{
		playerData[playerid][pRuleReading]--;
	}
	ShowServerRules(playerid);
	return true;
}

function:SearchDatabaseByName(name[])
{
    new query[128], bool:loop = true, Cache:queryData;
    mysql_format(conn, query, sizeof(query), "SELECT * FROM `oyuncular` WHERE `Nick` = '%e'", name);
    queryData = mysql_query(conn, query);
    if(cache_num_rows() == 0){ loop = false; }
    cache_delete(queryData);
    return _:loop;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
	{
	    case LOBI_ANA_DIALOG:
			{
				switch(listitem)
				{
					case 0:
					{
					    if(DmLobiOyuncular == 10) return HataMesajGonder(playerid, "Bu lobiye daha fazla oyuncu katýlamaz.");
						if(!response) return 1;
						DmLobiOyuncular++;
						new string[250];
						new randomspawn = random(sizeof(DM_SPAWN));SetPlayerPos(playerid, DM_SPAWN[randomspawn][0], DM_SPAWN[randomspawn][1], \
							DM_SPAWN[randomspawn][2]); SetPlayerFacingAngle(playerid, DM_SPAWN[randomspawn][3]); SetCameraBehindPlayer(playerid);
						SetPlayerInterior(playerid, 3);
						SilahVer(playerid, 24, 100);
						MesajGonder(playerid, "DM lobisine katýlým saðladýn.");
						Lobi[playerid] = false;
						DMLobi[playerid] = true;
						format(string, sizeof(string), "{74E8CD}[Sunucu]: {FFFFFF}%s adlý oyuncu DM lobisine katýldý. (%i/10)", OyuncuIsim(playerid), DmLobiOyuncular);
 						SendClientMessageToAll(-1, string);
					}
					case 1:
					{
					    if(DmLobiOyuncularMobil == 10) return HataMesajGonder(playerid, "Bu lobiye daha fazla oyuncu katýlamaz.");
						if(!response) return 1;
						if(IsPlayerAndroid(playerid))
						{
							DmLobiOyuncularMobil++;
							new string[250];
							new randomspawn = random(sizeof(DM_SPAWN_MOBIL));SetPlayerPos(playerid, DM_SPAWN_MOBIL[randomspawn][0], DM_SPAWN_MOBIL[randomspawn][1], \
								DM_SPAWN_MOBIL[randomspawn][2]); SetPlayerFacingAngle(playerid, DM_SPAWN_MOBIL[randomspawn][3]); SetCameraBehindPlayer(playerid);
							SetPlayerInterior(playerid, 3);
						 	SetPlayerVirtualWorld(playerid, 2);
							SilahVer(playerid, 24, 100);
							MesajGonder(playerid, "DM lobisine katýlým saðladýn.");
							Lobi[playerid] = false;
							MobilDMLobi[playerid] = true;
							format(string, sizeof(string), "{74E8CD}[Sunucu]: {FFFFFF}%s adlý oyuncu DM lobisine katýldý. (%i/10)", OyuncuIsim(playerid), DmLobiOyuncularMobil);
	 						SendClientMessageToAll(-1, string);
						}
						else
						{
							HataMesajGonder(playerid, "Bu lobi sadece mobil istemcilere özel.");
						}
					}
				}
			}
        case Ayarlar:
	    {
	        if(!response) return 1;

	        switch(listitem)
	        {
	            case 0:
	            {
	                new string[2000];
					format(string,sizeof(string),"Hesap: {4a804d}%s\n{ffffff}Admin Seviyesi: {4a804d}%s\n{ffffff}Vip: {4a804d}YAKINDA\n\n» Ayarlar",
					OyuncuIsim(playerid),AdminRutbe(playerid));
					ShowPlayerDialog(playerid, Ayarlar, DIALOG_STYLE_LIST, "Oyun Hesabý",string,"Ayarlar","Kapat");
	            }
	            case 1:
	            {
	                new string[2000];
					format(string,sizeof(string),"Hesap: {4a804d}%s\n{ffffff}Admin Seviyesi: {4a804d}%s\n{ffffff}Vip: {4a804d}YAKINDA\n\n» Ayarlar",
					OyuncuIsim(playerid),AdminRutbe(playerid));
					ShowPlayerDialog(playerid, Ayarlar, DIALOG_STYLE_LIST, "Oyun Hesabý",string,"Ayarlar","Kapat");
	            }
	            case 2:
	            {
	                new string[2000];
					format(string,sizeof(string),"Hesap: {4a804d}%s\n{ffffff}Admin Seviyesi: {4a804d}%s\n{ffffff}Vip: {4a804d}YAKINDA\n\n» Ayarlar",
					OyuncuIsim(playerid),AdminRutbe(playerid));
					ShowPlayerDialog(playerid, Ayarlar, DIALOG_STYLE_LIST, "Oyun Hesabý",string,"Ayarlar","Kapat");
	            }
	            case 3:
	            {
	                new string[2000];
					format(string,sizeof(string),"Hud");
					ShowPlayerDialog(playerid,1890,DIALOG_STYLE_LIST,"» AYAR MENÜSÜ",string,"Kapat","");
	            }
	        }
	    }
	    case 1890:
	    {
	        if(!response) return 1;

	        switch(listitem)
	        {
	            case 0:
				{
	   			new string[2000];
				format(string,sizeof(string),"Hudu Aç\nHudu Kapat");
				ShowPlayerDialog(playerid,99,DIALOG_STYLE_LIST,"» AYAR MENÜSÜ",string,"Kapat","");
				}
	        }
	    }

	//
	}
	return 1;
 }

//------- DIALOG'S -------

Dialog:SUNUCU_KURALLARI(playerid, response, listitem, inputtext[])
{
	if(playerData[playerid][pRuleReading] > 0)
	{
		ShowServerRules(playerid);
	}
	return true;
}

Dialog:KAYIT_MENUSU(playerid, response, listitem, inputtext[])
{
	if(!response) return true;
	if(strlen(inputtext) < 6) return HazirKayitGirisMenusu(playerid, REGISTER_METHOD, "Girdiðiniz þifre 6 karakterin altýnda olamaz.");
	if(strlen(inputtext) > 32) return HazirKayitGirisMenusu(playerid, REGISTER_METHOD, "Girdiðiniz þifre 32 karakterin üstünde olamaz.");

	format(playerData[playerid][pPassword], 30, inputtext);
	if(playerData[playerid][pRuleReading] >= READING_RULE_TIME){

		PlayerTextDrawHide(playerid, KayitGiris[7][playerid]);
		PlayerTextDrawSetSelectable(playerid, KayitGiris[7][playerid], false);
		PlayerTextDrawShow(playerid, KayitGiris[7][playerid]);
		PlayerTextDrawSetString(playerid, KayitGiris[7][playerid], "GIRIS YAP");
		Dialog_Show(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "{45A93C}>{34DE25}>{61FC53}>{FFFFFF} Bilgilendirme", "{FF0000}â€¢{FFFFFF} Kayýt olmak için {29C4D6}OYUN KURALLARI{FFFFFF} sekmesine týklayýn.", "TAMAM", "");
		return true;
	}
	if(playerData[playerid][pRuleReading] <= 0)
	{
		if(SearchDatabaseByName(GetPlayerNameEx(playerid)) == 0)
		{
			new query[128];
			mysql_format(conn, query, sizeof(query), "INSERT INTO `oyuncular` (`Nick`, `Password`, `Date`) VALUES ('%e', sha1('%e'), '%d')", GetPlayerNameEx(playerid), playerData[playerid][pPassword], gettime());
			mysql_query(conn, query);

			Dialog_Show(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "{BB3434}>{E11F1F}>{FF5C5C}>{FFFFFF} Bilgilendirme", "Hesabýnýz otomatik açýldý, Giriþ yapabilirsiniz.", "{FF0000}OK", "");
			RegisterLoginScreen(playerid);
		}
	}
	return true;
}


Dialog:GIRIS_MENUSU(playerid, response, listitem, inputtext[])
{
	if(!response) return true;

	LoginMethodControl(playerid, inputtext);

	return true;
}

//------- CALLBACKS -------

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == KayitGiris[7][playerid])
	{
		switch(playerData[playerid][pRegisterOrLogin])
		{
			case REGISTER_METHOD, LOGIN_METHOD:
			{
				HazirKayitGirisMenusu(playerid, playerData[playerid][pRegisterOrLogin], "");
	    	}
	    	default: Kick(playerid);
    	}
    }
    else if(playertextid == KayitGiris[8][playerid])
    {
    	if(playerData[playerid][pPassword] >= 6)
    	{
	    	if(playerData[playerid][pRuleReading] == READING_RULE_TIME && SearchDatabaseByName(GetPlayerNameEx(playerid)) == 0)
	    	{
	    		KurallariOku[playerid] = SetTimerEx("UpdateRuleTiming", 1000, true, "i", playerid);
	    	}
	    	else if(SearchDatabaseByName(GetPlayerNameEx(playerid)) == 1)
	    	{
	    		playerData[playerid][pRuleReading] = -1;
	    	}
	    	ShowServerRules(playerid);
    	}
    	else
    	{
    		Dialog_Show(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "{BB3434}>{E11F1F}>{FF5C5C}>{FFFFFF} Bilgilendirme KutucuÄŸu", "{FFFFFF}â€¢ Ã–ncelik olarak bir ÅŸifreye ihtiyacÄ±nÄ±z var. {CDCDCD}KAYIT OL{FFFFFF} butonuna tÄ±klayÄ±n ve ÅŸifrenizi tanÄ±mlayÄ±n.", "{FF0000}OK", "");
    	}
    }
    else if(playertextid == KayitGiris[12][playerid])
    {
    	Dialog_Show(playerid, EMPTY_DIALOG, DIALOG_STYLE_MSGBOX, "{008710}>{00BA16}>{00FA1D}>{FFFFFF} Hesap Sizin Mi?", "{FFFFFF}\
    		Bu sizin hesabÄ±nÄ±z deÄŸilse, lÃ¼tfen SA-MP baÅŸlatÄ±cÄ±sÄ±nda takma\nadÄ±nÄ±zÄ± deÄŸiÅŸtirin ve sunucuya yeniden girin.\n\n\
    		HenÃ¼z baÅŸkasÄ± tarafÄ±ndan kaydedilmemiÅŸ bir nick bulmaya Ã§alÄ±ÅŸÄ±n.\
    	", "OK", "");
    }
    return true;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(_:clickedid == INVALID_TEXT_DRAW)
    {
    	switch(playerData[playerid][pRegisterOrLogin])
    	{
        	case REGISTER_METHOD, LOGIN_METHOD:SelectTextDraw(playerid, 0xFFFF00FF);
    	}
    }
    return true;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)
	{
		PlayerPlaySound(playerid,1054,0.0,0.0,0.0),
		SendClientMessage(playerid,-1,"{ffffff}[{FF0000}HATA{ffffff}]: Bilinmeyen veya hatalý komut! /yardim komutunu kullanmayý deneyebilirsin.");
	}
	return 1;
}

public OnGameModeInit()
{
    UpdateDiscordClientStatus();
    KomutYukle();
    LoadGamemodeSettings();
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

	UsePlayerPedAnims();
	DisableInteriorEnterExits();

	// actors

	CreateActor(117, 1721.7240,-1652.3704,20.0625,2.0452);
	Create3DTextLabel("{ffffff}Deathmatch Lobi\n\n{FFFF00}Bilgi: {6699ff}'N' tusuna basarak etkilesime gecebilirsiniz.", -1, 1721.7240,-1652.3704,20.0625, 4.0, 0, bool:0);

	// actors - 2

	CreateActor(117, 1724.5681,-1655.6816,20.0625,266.0139);
	Create3DTextLabel("{ffffff}TDM (Teamdeathmatch)\n\n{FFFF00}Bilgi: {6699ff}'N' tusuna basarak etkilesime gecebilirsiniz.", -1, 1724.5681,-1655.6816,20.0625, 4.0, 0, bool:0);

	// actors - 3

	CreateActor(117, 1721.8406,-1658.5881,20.0625,180.0441);
	Create3DTextLabel("{ffffff}Gang Wars\n\n{FFFF00}Bilgi: {6699ff}'N' tusuna basarak etkilesime gecebilirsiniz.", -1, 1721.8406,-1658.5881,20.0625, 4.0, 0, bool:0);

	// actors - 4

	CreateActor(117, 1718.9990,-1655.6215,20.0625,89.7794);
	Create3DTextLabel("{ffffff}Top Skor\n\n{FFFF00}Bilgi: {6699ff}'N' tusuna basarak etkilesime gecebilirsiniz.", -1, 1718.9990,-1655.6215,20.0625, 4.0, 0, bool:0);
	return true;
}

public OnGameModeExit()
{
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(playerData[playerid][pRegisterOrLogin] != AFTER_LOGIN_METHOD)
	{
		SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
		SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
		SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);

		TogglePlayerSpectating(playerid, true);
		SetTimerEx("SpawnEx", 1000, false, "i", playerid);
	}
	else
	{
		SetSpawnInfo(playerid, NO_TEAM, DEFAULT_SKIN, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
	}
	return true;
}

public OnPlayerSpawn(playerid)
{
	if(Lobi[playerid] == true)
	{
 		SetPlayerPos(playerid, 1714.6244, -1645.1664, 20.2242);
		SetPlayerFacingAngle(playerid, 228.1528);
		SetPlayerInterior(playerid, 18);
	}
	else if(playerData[playerid][pRoom] == ROOM_EMPTY)
	{
		MovePlayerScreen(playerid);
	}
	// bundan sonrasýna yapýlacak, bunun üstü ellenmeyecek
	if(DMLobi[playerid] == true)
	{
		new randomspawn = random(sizeof(DM_SPAWN));SetPlayerPos(playerid, DM_SPAWN[randomspawn][0], DM_SPAWN[randomspawn][1], \
			DM_SPAWN[randomspawn][2]); SetPlayerFacingAngle(playerid, DM_SPAWN[randomspawn][3]); SetCameraBehindPlayer(playerid);
		SilahVer(playerid, 24, 100);
		MesajGonder(playerid, "DM lobisinde tekrar spawn oldun.");
	}
	if(MobilDMLobi[playerid] == true)
	{
		new randomspawn = random(sizeof(DM_SPAWN_MOBIL));SetPlayerPos(playerid, DM_SPAWN_MOBIL[randomspawn][0], DM_SPAWN_MOBIL[randomspawn][1], \
			DM_SPAWN_MOBIL[randomspawn][2]); SetPlayerFacingAngle(playerid, DM_SPAWN_MOBIL[randomspawn][3]); SetCameraBehindPlayer(playerid);
		SilahVer(playerid, 24, 100);
		MesajGonder(playerid, "Mobil DM lobisinde tekrar spawn oldun.");
	}
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new szBuffer[500];
	if(newkeys & KEY_NO)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1721.7240,-1652.3704,20.0625))
		{
			format(szBuffer, sizeof(szBuffer), "LVPD(%i/10)\nMobil LVPD(%i/10)", DmLobiOyuncular, DmLobiOyuncularMobil);
			ShowPlayerDialog(playerid, LOBI_ANA_DIALOG, DIALOG_STYLE_LIST, "{00FF00}DeathMatch", szBuffer, "Gir", "Kapat");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1724.5681,-1655.6816,20.0625))
		{

			ShowPlayerDialog(playerid, TDM_ANA_DIALOG, DIALOG_STYLE_LIST, "{e6e6fa}TDM Ekrani", "{00ffff}Mavi Takim\n{ff0033}Kirmizi Takim", "Katil", "Iptal");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1721.8406,-1658.5881,20.0625))
		{
			ShowPlayerDialog(playerid, GW_ANA_DIALOG, DIALOG_STYLE_LIST, "{ffffff}Gang Wars", "{00FF00}Grove Street\n{A020F0}Ballas Gang\n{FFFF00}Vagos", "Katil", "Iptal");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1718.9990,-1655.6215,20.0625))
		{
			SendClientMessage(playerid, -1, "{ffffff}Bu Sistem devre disidir! (ReveR)");
		}
	}
	return 1;
}

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
	if(Lobi[playerid] == true)
	{
		MesajGonder(issuerid, "Lobide kimseye vuramazsýn.");
		return 0;
	}
	return true;
}

public OnPlayerUpdate(playerid)
{
	if(playerData[playerid][pSpawnProtect] == true)
	{
		if(GetPlayerSpeed(playerid) > 1)
		{
			playerData[playerid][pSpawnProtect] = false;
		}
	}
	return true;
}

public OnPlayerConnect(playerid)
{
    new str[300];
    if(IsPlayerAndroid(playerid))
    {
		format(str, sizeof(str), "%s(%d) sunucuya katildi! (( Platform: Mobil ))", OyuncuIsim(playerid), playerid);
		DCC_SendChannelMessage(DCC_FindChannelById("1382400408672141505"), str);
	}
	else
	{
		format(str, sizeof(str), "%s(%d) sunucuya katildi! (( Platform: PC ))", OyuncuIsim(playerid), playerid);
		DCC_SendChannelMessage(DCC_FindChannelById("1382400408672141505"), str);
	}
    botoyuncusayi++;
    UpdateDiscordClientStatus();
    EkranTemizle(playerid);
	ToplamOyuncu++;
	LoadPlayerTextDraws(playerid);
	ResetPlayerVariables(playerid);
	//--
	StopAllTimers(playerid);
	SetPVarInt(playerid, "EffectValue", 255);


  	new query[128], playerName[25];
    GetPlayerName(playerid, playerName, sizeof(playerName)); // Oyuncu adýný al

    printf("[DEBUG] Oyuncu: %s", playerName);

    mysql_format(conn, query, sizeof(query),
        "SELECT ban FROM oyuncular WHERE Nick = '%e'",
        playerName
    );
    printf("[DEBUG] Sorgu: %s", query); // Sorguyu logla
    mysql_tquery(conn, query, "OnBanCheck", "i", playerid);
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	new str[300];
    format(str, sizeof(str), "%s(%d) sunucudan cikis yapti.", OyuncuIsim(playerid), playerid);
	DCC_SendChannelMessage(DCC_FindChannelById("1382400408672141505"), str);
    botoyuncusayi--;
    UpdateDiscordClientStatus();
    Lobi[playerid] = true;
    DMLobi[playerid] = false;
    MobilDMLobi[playerid] = false;
	ToplamOyuncu--;
	if(DMLobi[playerid] == true)
	{
	    DmLobiOyuncular--;
	}
	if(MobilDMLobi[playerid] == true)
	{
	    DmLobiOyuncularMobil--;
	}
    StopAllTimers(playerid);
    PlayerTextDrawDestroy(playerid, SureliKararti[playerid]);

    new query[512];
    mysql_format(conn, query, sizeof(query),
        "UPDATE oyuncular SET AdminLevel = %d, Cash = %d, Oldurmeler = %d, Olmeler = %d, ban = %d WHERE id = %d",
        playerData[playerid][pAdminLevel],
        playerData[playerid][pCash],
        playerData[playerid][pKills],
        playerData[playerid][pDeaths],
        playerData[playerid][pBan],
        playerData[playerid][pSQLID]
    );
    mysql_tquery(conn, query);

    printf("[Veritabaný] %s sunucudan ayrýldý. Tüm verileri kaydedildi.", GetPlayerNameEx(playerid));
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(playerData[playerid][pAdminLevel] >= 0)
    {
        new str[256], isim[MAX_PLAYER_NAME];
        GetPlayerName(playerid, isim, sizeof(isim));
        format(str, sizeof(str), "%s %s(%d): %s", AdminRutbe(playerid), isim, playerid, text);

        SendClientMessageToAll(-1, str);
	}
   	new str[300];
	format(str, sizeof(str), "[%s] %s(%d): %s", TarihSaat(), OyuncuIsim(playerid), playerid, TurkceHarf(text));
	DCC_SendChannelMessage(DCC_FindChannelById("1382400408672141505"), str);
    return 0;
}


public OnPlayerDeath(playerid, killerid, reason)
{
	new gunname[32];
	GetWeaponName(reason, gunname, sizeof(gunname));
	MesajGonder(playerid, "%s seni %s ile öldürdü.", OyuncuIsim(killerid), gunname);
	if(DMLobi[playerid] == true || MobilDMLobi[playerid] == true)
	{
	 	if(killerid != INVALID_PLAYER_ID)
	    {
	    	gKillStreak[killerid]++;
	    	if(gKillStreak[killerid] == 5)
	  		{
	            new isim[MAX_PLAYER_NAME];
	            GetPlayerName(killerid, isim, sizeof(isim));
	            new str[128];
	            format(str, sizeof(str), "{b22222}[!]: {228b22}%s {FFFFFF}5 öldürme serisine ulaþtý!", isim);
	            SendClientMessageToAll(-1, str);
             	katil[killerid] = Create3DTextLabel("Seri Katil", 0xFF0000FF, 30.0, 40.0, 50.0, 40.0, 0);
		    	Attach3DTextLabelToPlayer(katil[killerid], killerid, 0.0, 0.0, 0.3);
	        }
	        if(gKillStreak[playerid] >= 5)
	        {
	            GivePlayerMoney(killerid, 100);
	            new kisim[MAX_PLAYER_NAME], pisim[MAX_PLAYER_NAME], str[128];
	            GetPlayerName(killerid, kisim, sizeof(kisim));
	            GetPlayerName(playerid, pisim, sizeof(pisim));
	            format(str, sizeof(str), "{b22222}[!]: {228b22}%s, {8b2323}%s {FFFFFF}adlý oyuncunun öldürme serisini bitirdi!", kisim, pisim);
	            SendClientMessageToAll(-1, str);
	            Delete3DTextLabel(katil[playerid]);
	        }
		}
	    gKillStreak[playerid] = 0;
	}
	return true;
}

CMD:a(playerid, params[])
{
	if(playerData[playerid][pAdminLevel] < 1) return DeniedAuthority(playerid);
	if(isnull(params)) return HataMesajGonder(playerid, "/a(dmin) [metin girin]");

	foreach(new i : Player)
	{
		if(playerData[i][pAdminLevel] > 0)
		{
			SendClientMessageEx(i, 0xe84a4aFF, "** %s %s: %s", AdminRutbe(playerid), GetPlayerNameEx(playerid), params);
		}
	}
	return true;
}



CMD:lobi(playerid, params[])
{
    LobiGonder(playerid);
	return 1;
}

CMD:kill(playerid, params[])
{
	if(Lobi[playerid])
	{
		HataMesajGonder(playerid, "Lobide bu komutu kullanamazsýn.");
	}
	else
	{
	    SetPlayerHealth(playerid, 0.0);
	    MesajGonder(playerid, "Kendini öldürdün.");
	}
	return 1;
}

CMD:setadmin(playerid, params[])
{
    if(playerData[playerid][pAdminLevel] < 5) return DeniedAuthority(playerid);
    new targetid, level;
    if(sscanf(params, "ud", targetid, level))
        return HataMesajGonder(playerid, "/setadmin [playerid] [seviye]");
    if(!IsPlayerConnected(targetid))
        return HataMesajGonder(playerid, "Böyle bir ID bulunamadý.");
    if(level < 0 || level > 5)
        return HataMesajGonder(playerid, "Maksimum admin seviyesi 5 olabilir.");
    playerData[targetid][pAdminLevel] = level;
    new query[256];
    mysql_format(conn, query, sizeof(query), "UPDATE oyuncular SET AdminLevel = %d WHERE SQLID = %d", level, playerData[targetid][pSQLID]);
    mysql_query(conn, query);
    new rutbe[32];
    switch(level)
    {
        case 0: format(rutbe, sizeof(rutbe), "{FFFFFF}Oyuncu{FFFFFF}");
        case 1: format(rutbe, sizeof(rutbe), "{ffa500}Tester{FFFFFF}");
        case 2: format(rutbe, sizeof(rutbe), "{008b00}Admin{FFFFFF}");
        case 3: format(rutbe, sizeof(rutbe), "{8b1a1a}Administrator{FFFFFF}");
        case 4: format(rutbe, sizeof(rutbe), "{b22222}Management{FFFFFF}");
        case 5: format(rutbe, sizeof(rutbe), "{1c1c1c}Developer{FFFFFF}");
    }
    MesajGonder(targetid, "%s adlý yetkili senin admin rütbeni %s (%d) olarak deðiþtirdi.", OyuncuIsim(playerid), rutbe, level);
    MesajGonder(playerid, "%s adlý oyuncunun admin rütbesini %s (%d) olarak ayarladýn.", OyuncuIsim(targetid), rutbe, level);
    return 1;
}

CMD:dm(playerid, params[])
{
	new szBuffer[250];
    format(szBuffer, sizeof(szBuffer), "LVPD(%i/10)\nMobil LVPD(%i/10)", DmLobiOyuncular, DmLobiOyuncularMobil);
	ShowPlayerDialog(playerid, LOBI_ANA_DIALOG, DIALOG_STYLE_LIST, "{00FF00}DeathMatch", szBuffer, "Gir", "Kapat");
	return 1;
}

CMD:kick(playerid, params[])
{
    static
        userid,
        reason[128];
        //query[512];

    if(playerData[playerid][pAdminLevel] < 2) return DeniedAuthority(playerid);

    if (sscanf(params, "us[128]", userid, reason))
        return BilgiMesajGonder(playerid, "/kick [ID/Isim] [Sebep]");

    if (!IsPlayerConnected(userid))
        return HataMesajGonder(playerid, "Belirttiginiz oyuncu oyunda deðil !");

    if (playerData[playerid][pAdminLevel] > playerData[playerid][pAdminLevel])
        return HataMesajGonder(playerid, "Belirtilen oyuncu sizden yuksek yetkiye sahiptir.");
   	SendClientMessageToAllEx(COLOR_RED, "* ((%s)) ( %s adlý oyuncu %s tarafindan %s sebebiyle sunucudan atýldý. )", TarihSaat(), OyuncuIsim(userid), OyuncuIsim(playerid),  reason);
    SetTimerEx("KickTimer", 1000, false, "i", userid);
    return 1;
}

CMD:yardim(playerid)
{
	new str[550];
	strcat(str, "{AFAFAF}» {FFFFFF}Genel Komutlar\n");
	Dialog_Show(playerid, Yardim, DIALOG_STYLE_LIST, "{ff9933}Yardim", str, "Seç", "{FF6347}Kapat");
	return 1;
}
Dialog:Yardim(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new string[2056], baslik[50];
		format(baslik, sizeof(baslik), "{ff9933}%s", inputtext);

		for (new i = 0; i != MAX_YARDIM_KOMUTLARI; i ++)
		{
	 		if (Komutlar[i][komutVarmi] && Komutlar[i][komutKatagori] == listitem && Komutlar[i][komutOlusum] == -1)
			{
				new komutstr[512];
				format(komutstr, sizeof(komutstr), "{FF6347}• %s »» :{FFFFFF}%s\n", Komutlar[i][komutAd], Komutlar[i][komutTanim]);
				strcat(string, komutstr);
			}
		}
		Dialog_Show(playerid, YardimGeriTusu, DIALOG_STYLE_MSGBOX, baslik, string, "Tamam", "{FF6347}<< Geri");
	}
	return 1;
}

KomutEkle(ad[], tanim[], katagori, olusum = -1)
{
	for (new i = 0; i != MAX_YARDIM_KOMUTLARI; i ++)
	{
 		if (!Komutlar[i][komutVarmi])
		{
		    Komutlar[i][komutVarmi] = true;
            Komutlar[i][komutKatagori] = katagori;
            Komutlar[i][komutOlusum] = olusum;

           	format(Komutlar[i][komutAd], 24, ad);
           	format(Komutlar[i][komutTanim], 256, tanim);

			return i;
		}
	}
	return -1;
}
KomutYukle()
{
	// -------------------------- Genel Komutlar ------------------------ //
	KomutEkle("/ayarlar", "Hesap ayarlarina eriþim.", 0);
	return 1;
}

CMD:ban(playerid,params[])
{
    if(playerData[playerid][pAdminLevel] < 3) return DeniedAuthority(playerid);
    if(IsPlayerConnected(playerid))
    {
		new targetid ,reason[105], string[256];
		if(sscanf(params, "us[105]", targetid,reason)) return HataMesajGonder(playerid, "{C0C0C0}KULLANIM: /ban [playerid] [sebep]");
		if(!IsPlayerConnected(targetid)) return HataMesajGonder(playerid, "Kullanýcý daha giriþ yapmamýþ.");
		format(string, sizeof(string), "* (( {FFFFFF}%s {DC143C}adlý oyuncu {FFFFFF}%s {DC143C}tarafýndan sunucudan yasaklandý. Sebep: %s ))",OyuncuIsim(targetid), OyuncuIsim(playerid), reason);
		SendClientMessageToAll(-1,string);
		format(string,sizeof(string), "Sunucudan kalýcý olarak yasaklandýn!\n\n{DC143C}Admin{ffffff}: %s\n{DC143C}Sebep{ffffff}: %s\n\nBan affý için:\n{FFFF33}www.samp-venturasfun.discord veya discord.gg/ffGrKsnUuV",OyuncuIsim(playerid), reason);
  		ShowPlayerDialog(targetid,999,DIALOG_STYLE_MSGBOX,"{DC143C}BANLANDIN!",string,"Kapat","");
  		new query[256];
    	mysql_format(conn, query, sizeof(query), "UPDATE oyuncular SET ban = 1 WHERE SQLID = %d", playerData[targetid][pSQLID]);
    	mysql_query(conn, query);
		SetTimerEx("KickPlayer",100,false,"i",targetid);
		playerData[targetid][pBan] = 1;
	}
	return 1;
}

CMD:ayarlar(playerid)
{
	new string[2000];
	format(string,sizeof(string),"Hesap: {4a804d}%s\n{ffffff}Admin Seviyesi: {4a804d}%s\n{ffffff}Vip: {4a804d}YAKINDA\n\n» Ayarlar",
	OyuncuIsim(playerid),AdminRutbe(playerid));
	ShowPlayerDialog(playerid, Ayarlar, DIALOG_STYLE_LIST, "Oyun Hesabý",string,"Ayarlar","Kapat");
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	Kick(playerid);
	return 1;
}

stock AdminRutbe(playerid)
{
    static rutbe[32];
    switch(playerData[playerid][pAdminLevel])
    {
        case 0: format(rutbe, sizeof(rutbe), "");
        case 1: format(rutbe, sizeof(rutbe), "{ffa500}Tester{FFFFFF}");
        case 2: format(rutbe, sizeof(rutbe), "{008b00}Admin{FFFFFF}");
        case 3: format(rutbe, sizeof(rutbe), "{8b1a1a}Administrator{FFFFFF}");
        case 4: format(rutbe, sizeof(rutbe), "{b22222}Management{FFFFFF}");
        case 5: format(rutbe, sizeof(rutbe), "{1c1c1c}Developer{FFFFFF}");
        default: format(rutbe, sizeof(rutbe), "Bilinmiyor");
    }
    return rutbe;
}


stock LobiGonder(playerid)
{
	Lobi[playerid] = true;
	SilahSifirla(playerid);
	if(MobilDMLobi[playerid] == true)
 	{
  		MobilDMLobi[playerid] = false;
  		DmLobiOyuncularMobil--;
	}
	if(DMLobi[playerid] == true)
 	{
  		DMLobi[playerid] = false;
  		DmLobiOyuncular--;
	}
	SetPlayerPos(playerid, 1714.6244, -1645.1664, 20.2242);
	SetPlayerFacingAngle(playerid, 228.1528);
	SetPlayerInterior(playerid, 18);
}

stock SilahSifirla(playerid)
{
	ResetPlayerWeapons(playerid);
}


stock OyuncuIsim(playerid)
{
	new isim[24];
	GetPlayerName(playerid, isim, 24);
 	return isim;
}

stock SilahVer(playerid, silahid, mermi)
{
	GivePlayerWeapon(playerid, silahid, mermi);
 	return 1;
}

stock EkranTemizle(playerid)
{
	for (new i; i < 25; i++)
	{
	    SendClientMessage(playerid, 0xFFFFFFFF, "");
	}
	return 1;
}

stock SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
    static
        args,
        str[512];

    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) == 2)
    {
        SendClientMessageToAll(color, text);
    }
    else
    {
        while (--args >= 2)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessageToAll(color, str);

        #emit RETN
    }
    return 1;
}

forward KickTimer(playerid);
public KickTimer(playerid)
{
    Kick(playerid);
    return 1;
}

forward OnBanCheck(playerid);
public OnBanCheck(playerid)
{
    new rows, playerName[25];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    cache_get_row_count(rows);
    printf("[DEBUG] Oyuncu: %s, Sorgu sonucu satýr sayýsý: %d", playerName, rows);

    if(rows)
    {
        new banStatus;
        cache_get_value_name_int(0, "ban", banStatus);
        printf("[DEBUG] Oyuncu: %s, Ban durumu: %d", playerName, banStatus);
        if(banStatus == 1)
        {
            new string[300];
            format(string,sizeof(string), "Bu sunucudan yasaklýsýn.\n\n{ffffff}Ban affý için topluluðumuzu  takip et.\n{FFFF33}www.highline-dm.com veya discord.gg/highlinedm\n{ffffff}");
	        ShowPlayerDialog(playerid,9999,DIALOG_STYLE_MSGBOX,"HESAP YASAKLANMIS",string,"Kapat","");
	        SetTimerEx("KickTimer", 1000, false, "i", playerid);
        }
    }
    return 1;
}

stock UpdateDiscordClientStatus()
{
	new string[32];
 	format(string, sizeof(string), ">> (%d/50) ile", botoyuncusayi);
 	DCC_SetBotActivity(string);
}

stock TurkceHarf(car[]) {
  new tmp[300];
  set(tmp,car);
  tmp=strreplacea("ð", "g",tmp);
  tmp=strreplacea("|", "",tmp);
  tmp=strreplacea("Ð", "G",tmp);
  tmp=strreplacea("þ", "s",tmp);
  tmp=strreplacea("Þ", "S",tmp);
  tmp=strreplacea("ý", "i",tmp);
  tmp=strreplacea("I", "I",tmp);
  tmp=strreplacea("Ý", "I",tmp);
  tmp=strreplacea("ö", "o",tmp);
  tmp=strreplacea("Ö", "O",tmp);
  tmp=strreplacea("ç", "c",tmp);
  tmp=strreplacea("Ç", "C",tmp);
  tmp=strreplacea("ü", "u",tmp);
  tmp=strreplacea("Ü", "U",tmp);
  return tmp;
}

stock set(dest[],source[]) {
	new count = strlen(source);
	new i=0;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
	}
	dest[count]=0;
}

stock strreplacea(trg[],newstr[],src[]) {
    new f=0;
    new s1[256];
    new tmp[256];
    format(s1,sizeof(s1), "%s",src);
    f = strfind(s1,trg);
    tmp[0]=0;
    while (f>=0) {
        strcat(tmp,ret_memcpy(s1, 0, f));
        strcat(tmp,newstr);
        format(s1,sizeof(s1), "%s",ret_memcpy(s1, f+strlen(trg), strlen(s1)-f));
        f = strfind(s1,trg);
    }
    strcat(tmp,s1);
    return tmp;
}
ret_memcpy(source[],index=0,numbytes) {
	new tmp[256];
	new i=0;
	tmp[0]=0;
	if (index>=strlen(source)) return tmp;
	if (numbytes+index>=strlen(source)) numbytes=strlen(source)-index;
	if (numbytes<=0) return tmp;
	for (i=index;i<numbytes+index;i++) {
		tmp[i-index]=source[i];
		if (source[i]==0) return tmp;
	}
	tmp[numbytes]=0;
	return tmp;
}

TarihSaat()
{
	static
	    date[36];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	format(date, sizeof(date), "%02d/%02d/%d, %02d:%02d", date[0], date[1], date[2], date[3], date[4]);
	return date;
}

stock getDate()
{
	new Tarih[3], m[256];
	getdate(Tarih[0], Tarih[1], Tarih[2]);

	format(m, sizeof m, "%d/%d/%d", Tarih[2], Tarih[1], Tarih[0]);
	return m;
}

stock getTime()
{
	new Saat[3], m[256];
	gettime(Saat[0], Saat[1], Saat[2]);

	format(m, sizeof m, "%02d:%02d", Saat[0], Saat[1]);
	return m;
}
