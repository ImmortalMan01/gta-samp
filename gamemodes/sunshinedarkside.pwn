new EscortFollowPlayer = -1;
new EscortFollowTimer = -1;
    StartEscortFollow(playerid);
CMD:eskortbirak(playerid)
{
    if(playerid != EscortFollowPlayer) return HataMesajGonder(playerid, "Seni takip eden bir hayat kadini yok.");
    StopEscortFollow();
    SetActorPos(eskortnpc, 2247.7705,-1688.0438,13.7796);
    SetActorFacingAngle(eskortnpc, 182.3814);
    ApplyActorAnimation(eskortnpc, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
    MesajGonder(playerid, "Hayat kadini seni takip etmeyi birakti.");
    return 1;
}
stock StartEscortFollow(playerid)
{
    EscortFollowPlayer = playerid;
    if (EscortFollowTimer != -1) KillTimer(EscortFollowTimer);
    EscortFollowTimer = SetTimer("UpdateEscortFollow", 1000, true);
}

stock StopEscortFollow()
{
    if (EscortFollowTimer != -1) KillTimer(EscortFollowTimer);
    EscortFollowTimer = -1;
    EscortFollowPlayer = -1;
}

forward UpdateEscortFollow();
public UpdateEscortFollow()
{
    if(EscortFollowPlayer == -1) return 1;
    if(!IsPlayerConnected(EscortFollowPlayer)) { StopEscortFollow(); return 1; }
    new Float:x, Float:y, Float:z;
    if(IsPlayerInAnyVehicle(EscortFollowPlayer))
    {
        new vehicleid = GetPlayerVehicleID(EscortFollowPlayer);
        GetVehiclePos(vehicleid, x, y, z);
        SetActorPos(eskortnpc, x + 1.0, y, z + 0.1);
    }
    else
    {
        GetPlayerPos(EscortFollowPlayer, x, y, z);
        SetActorPos(eskortnpc, x - 1.0, y, z);
    }
    return 1;
}
