/*
    Extended vehicle functions by Emmet_

	Thanks to:

	- [uL]Pottus -> GetVehicleTopSpeed idea
	- kvann -> SetVehicleInterior idea
	- Hanger -> Top speed data
*/

#if !defined INVALID_SEAT_ID
	#define INVALID_SEAT_ID 		-1
#endif

#if !defined INVALID_PAINTJOB_ID
	#define INVALID_PAINTJOB_ID     -1
#endif

#if !defined IsValidVehicle
	native IsValidVehicle(vehicleid);
#endif

enum e_OffsetTypes {
	VEHICLE_OFFSET_BOOT,
	VEHICLE_OFFSET_HOOD,
	VEHICLE_OFFSET_ROOF
};

#define GetVehicleBoot(%0,%1,%2,%3) \
	(GetVehicleOffset((%0), VEHICLE_OFFSET_BOOT, %1, %2, %3))


stock GetVehicleOffset(vehicleid, type, &Float:x, &Float:y, &Float:z)
{
    new Float:fPos[4], Float:fSize[3];

	if (!IsValidVehicle(vehicleid))
	{
		x = 0.0;
		y = 0.0;
		z = 0.0;

		return 0;
	}
	else
	{
		GetVehiclePos(vehicleid, fPos[0], fPos[1], fPos[2]);
		GetVehicleZAngle(vehicleid, fPos[3]);
		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]);

		switch (type)
		{
		    case VEHICLE_OFFSET_BOOT:
		    {
				x = fPos[0] - (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3], degrees));
				y = fPos[1] - (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3], degrees));
 				z = fPos[2];
			}
			case VEHICLE_OFFSET_HOOD:
			{
			    x = fPos[0] + (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3], degrees));
				y = fPos[1] + (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3], degrees));
	 			z = fPos[2];
			}
			case VEHICLE_OFFSET_ROOF:
			{
			    x = fPos[0];
			    y = fPos[1];
			    z = fPos[2] + floatsqroot(fSize[2]);
			}
		}
	}
	return 1;
}