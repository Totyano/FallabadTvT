if(!isServer) exitWith {};


clash_fnc_vbiedActions =
{
	params ["_veh"];
	// remove any existing actions
	[_veh] remoteExec ["removeAllActions", 0];
	UIsleep 3;
	// add new actions
	[
		_veh,
		"<t color='#ff0000'>VBIED: Activate Driver Deadman's Switch (1s)</t>",
		"",
		"",
		"(driver _target) isEqualTo player",
		"(driver _target) isEqualTo player",
		{},
		{},
		{
			[_this select 0, _this select 1] spawn
			{
				params ["_veh", "_caller"];
				systemChat "Deadman's switch activated on you. It will deactivate if you exit the driver's seat.";
				// while driver in-seat and ok and vehicle OK, just wait for change
				while {(((driver _veh) isEqualTo _caller) and (alive _veh) and (((lifeState _caller) isEqualTo "HEALTHY") or ((lifeState _caller) isEqualTo "INJURED")))} do
				{
					UIsleep 1;
				};
				// if vehicle dead or driver uncon/dead, explode
				if ((((driver _veh) isEqualTo _caller) and (((lifeState _caller) isEqualTo "DEAD") or ((lifeState _caller) isEqualTo "DEAD-RESPAWN") or ((lifeState _caller) isEqualTo "DEAD-SWITCHING") or ((lifeState _caller) isEqualTo "INCAPACITATED"))) or !(alive _veh)) then
				{
					systemChat "Deadman's switch activating!";
					private _nearbyUnits = _veh nearEntities ["MAN", 75];
					{
						[_x, ["clash_lastHitter", _caller]] remoteExec ["setVariable", _x];
					} forEach _nearbyUnits;
					_veh engineOn false;
					UIsleep 3;
					"Bo_Mk82" createVehicle (getpos _veh);
					_veh setDamage 1;
					_caller setDamage 1;
				};
				// if driver has exited the seat, deactivate
				if (!((driver _veh) isEqualTo _caller) and (alive _veh)) then
				{
					systemChat "Deadman's switch disabled.";
				};
			};
		},
		{},
		[],
		1,
		0,
		false,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, true];
	[
		_veh,
		"<t color='#ff0000'>VBIED: Manually Detonate Bomb (1s)</t>",
		"",
		"",
		"(driver _target) isEqualTo player",
		"(driver _target) isEqualTo player",
		{},
		{},
		{
			[_this select 0, _this select 1] spawn
			{
				params ["_veh", "_caller"];
				systemChat "Detonating bomb!";
				private _nearbyUnits = _veh nearEntities ["MAN", 75];
				{
					[_x, ["clash_lastHitter", _caller]] remoteExec ["setVariable", _x];
				} forEach _nearbyUnits;
				_veh engineOn false;
				UIsleep 3;
				"Bo_Mk82" createVehicle (getpos _veh);
				_veh setDamage 1;
				_caller setDamage 1;
			};
		},
		{},
		[],
		1,
		0,
		true,
		false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, true];
};


// Master array: [variable name, crew locked boolean, respawn in seconds, custom function, ticket cost]
CCO_vehs =
[
	//WEST
	[west_ifv_1,	true,	(20*60),	{},		4],
	[west_ifv_2,	true,	(20*60),	{},		4],
	[west_truck_1,	false,	(5*60),		{},		2],
	[west_car_1,	false,	(5*60),		{},		2],
	[west_car_2,	false,	(5*60),		{},		2],
	[west_car_3,	false,	(5*60),		{},		2],
	[west_car_4,	false,	(5*60),		{},		2],
	[west_heli_1,	true,	(20*60),	{}, 	10],
	//EAST
	[east_vbied_1,	false,	(20*60),	clash_fnc_vbiedActions,		0],
	[east_vbied_2,	false,	(20*60),	clash_fnc_vbiedActions,		0],
	[east_truck_1,	false,	(5*60),		{},		0],
	[east_truck_2,	false,	(5*60),		{},		0],
	[east_truck_3,	false,	(5*60),		{},		0],
	[east_truck_4,	false,	(5*60),		{},		0],
	[east_tech_1,	false,	(15*10),	{},		0],
	[east_tech_2,	false,	(15*60),	{},		0],
	[east_tech_3,	false,	(15*60),	{},		0],
	[east_tech_4,	false,	(15*60),	{},		0],
	[east_car_1,	false,	(5*60),		{},		0],
	[east_car_2,	false,	(5*60),		{},		0],
	[east_car_3,	false,	(5*60),		{},		0],
	[east_car_4,	false,	(5*60),		{},		0]
];

// Classnames of ground crew
AllowedGroundCrew =
[
	"potato_w_vicd",
	"potato_w_vicl",
	"potato_w_vicc",
	"potato_w_ftl",
	"potato_w_sl",
	"potato_w_coy",
	"potato_w_plt",
	"potato_w_engl",

	"potato_e_vicc",
	"potato_e_coy",
	"potato_e_plt",
	"potato_e_vicl",
	"potato_e_ftl",
	"potato_e_sl",
	"potato_e_sf_sl",
	"potato_e_sf_ftl",
	"potato_e_vicd",
	"potato_e_engl"
];
// Classnames of air crew
AllowedAirCrew =
[
	"potato_w_pilot",
	"potato_w_cc",
	"potato_w_helicrew",

	"potato_e_helicrew",
	"potato_e_pilot",
	"potato_e_cc"
];

// Magazines to remove from all vehicles
VehBannedMagazines =
[
	"CUP_340Rnd_TE1_Green_Tracer_30mmHEIF_2A42_M",
	"CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M",
	"CUP_1Rnd_TE1_Green_Tracer_125mm_3BK29_M",
	"CUP_160Rnd_TE1_Green_Tracer_30mmAPBC_2A42_M",
	"CUP_160Rnd_TE1_Green_Tracer_30mmAP_2A42_M",
	"CUP_340Rnd_TE1_Green_Tracer_30mmHE_2A42_M",
	"CUP_1Rnd_TE1_Green_Tracer_125mm_3OF82_M",
	"CUP_230Rnd_TE1_Red_Tracer_25mm_M242_HE",
	"CUP_20Rnd_TE1_Red_Tracer_120mmHE_M256_Cannon_M",
	"CUP_1Rnd_TE1_Green_Tracer_125mm_3BM42M_M",
	"CUP_8Rnd_AT5_BMP2_M",
	"CUP_70Rnd_TE1_Red_Tracer_25mm_M242_APFSDS",
	"CUP_1Rnd_TOW2_M",
	"CUP_2Rnd_TOW2_M",
	"CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M"
];
// Magazines to add to vehicles: [classname, [0], amount]
ReplaceMagazines = 
[
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1], // It only adds one per mag lol
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	["CUP_1Rnd_TE1_Green_Tracer_125mm_3BM69_M", [0], 1],
	
	["CUP_160Rnd_TE1_Green_Tracer_30mmAP_2A42_M", [0], 140],
	["CUP_70Rnd_TE1_Red_Tracer_25mm_M242_APFSDS", [0], 70],
	["CUP_70Rnd_TE1_Red_Tracer_25mm_M242_APFSDS", [0], 70],
	["CUP_8Rnd_AT5_BMP2_M", [0], 2],
	["CUP_1Rnd_TOW2_M", [0], 1],
	["CUP_1Rnd_TOW2_M", [0], 1],
	["CUP_1350Rnd_TE1_Red_Tracer_30mm_GAU8_M", [0], 300] // REEEEEEEEEEEEEEEEEEEE
];

// Logistical vehicles
LogiVehicles = 
[
	"CFP_B_USARMY_2003_MTVR_Repair_DES_01"
	,"CFP_O_IQARMY_Ural_Repair_01"
	,"CUP_B_UH60M_Unarmed_US"
];

/*
END USER CONFIG
*/

// temp workaround until I find a smarter, server-only way of handling crew restrictions
publicVariable "CCO_vehs";
publicVariable "AllowedGroundCrew";
publicVariable "AllowedAirCrew";

// Adds a vehicle cost to vehicles defined above
TNK_fnc_vehicleTicketCost = 
{
	params["_veh","_cost"];

	if (isNil "_cost" or _cost isEqualTo 0) exitWith {};

	private _side = str _veh splitString "_";
	private _side = _side select 0;

	if (_side isEqualTo "east") then {
		Tun_respawn_tickets_east = Tun_respawn_tickets_east - _cost;
		publicVariable "Tun_respawn_tickets_east";
		//[format ["Subtracted %1 tickets from %2",_cost,_side]] remoteExec ["systemChat", 0];
	} else {
		Tun_respawn_tickets_west = Tun_respawn_tickets_west - _cost;
		publicVariable "Tun_respawn_tickets_west";
		//[format ["Subtracted %1 tickets from %2",_cost,_side]] remoteExec ["systemChat", 0];
	}
};

// adds handlers to vehicles that start respawn process and remove themselves
JST_fnc_addVehRespawnHandlers =
{
	params ["_veh"];
	// killed: remove all handlers, start respawn loop
	_veh addMPEventHandler
	[
		"MPKilled",
		{
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			// do not run if not server
			if !(isServer) exitWith {};
			// pull data
			private _vehArray = _unit getVariable "CCO_vehArray";
			// remove all event handlers
			_unit removeAllMPEventHandlers "MPKilled";
			[_unit, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "SeatSwitched"] remoteExec ["removeAllEventHandlers", 0];
			// delete all attached objects
			{
				deleteVehicle _x;
			} forEach (attachedObjects _unit);
			// respawn on server
			[_unit, _vehArray] remoteExec ["JST_fnc_vehRespawn", 2];
			// Cost ticket
			[_unit, _vehArray select 11] remoteExec ["TNK_fnc_vehicleTicketCost", 2];
		}
	];
	// deleted: remove all handlers, start respawn loop
	_veh addEventHandler
	[
		"Deleted",
		{
			params ["_unit"];
			// do not run if not server
			if !(isServer) exitWith {};
			// pull data
			private _vehArray = _unit getVariable "CCO_vehArray";
			// remove all event handlers
			_unit removeAllMPEventHandlers "MPKilled";
			[_unit, "Deleted"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "GetIn"] remoteExec ["removeAllEventHandlers", 0];
			[_unit, "SeatSwitched"] remoteExec ["removeAllEventHandlers", 0];
			// delete all attached objects
			{
				deleteVehicle _x;
			} forEach (attachedObjects _unit);
			// respawn on server
			[_unit, _vehArray] remoteExec ["JST_fnc_vehRespawn", 2];
		}
	];
	// get in: only allow certain players to get in driver/gunner seats
	[
		_veh,
		[
			"GetIn",
			{
				params ["_vehicle", "_role", "_unit", "_turret"];
				// only run on local unit
				if !(local _unit) exitWith {};
				private _restricted = (_vehicle getVariable "CCO_vehArray") select 1;
				if (_restricted and (_vehicle isKindOf "AIR")) then
				{
					if !((typeOf _unit) in AllowedAirCrew) then
					{
						private _time = time;
						waitUntil {((vehicle _unit) isEqualTo _vehicle) or (time >= (_time + 5))};
						if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,0]])) then
						{
							//"Hint3" remoteExec ["playsound", _unit1];
							[_unit] remoteExec ["moveOut", _unit];
							["You are not authorized air crew."] remoteExec ["systemChat", _unit];
						};
					};
				};
				if (_restricted and ((_vehicle isKindOf "CAR") or (_vehicle isKindOf "TANK"))) then
				{
					if !((typeOf _unit) in AllowedGroundCrew) then
					{
						private _time = time;
						waitUntil {((vehicle _unit) isEqualTo _vehicle) or (time >= (_time + 5))};
						if (((assignedVehicleRole _unit) isEqualTo ["driver"]) or ((assignedVehicleRole _unit) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,0]])) then
						{
							//"Hint3" remoteExec ["playsound", _unit1];
							[_unit] remoteExec ["moveOut", _unit];
							["You are not authorized crew."] remoteExec ["systemChat", _unit];
						};
					};
				};
			}
		]
	] remoteExec ["addEventHandler", 0, true];
	// switch seats: prevents cheesing the seat system
	[
		_veh,
		[
			"SeatSwitched",
			{
				params ["_vehicle", "_unit1", "_unit2"];
				// only run on local unit
				if !(local _unit1) exitWith {};
				private _restricted = (_vehicle getVariable "CCO_vehArray") select 1;
				if (_restricted and (_vehicle isKindOf "AIR")) then
				{
					if !((typeOf _unit1) in AllowedAirCrew) then
					{
						if (((assignedVehicleRole _unit1) isEqualTo ["driver"]) or ((assignedVehicleRole _unit1) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit1) isEqualTo ["turret",[0]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,0]])) then
						{
							[_unit1] remoteExec ["moveOut", _unit1];
							[_unit1,_vehicle] remoteExec ["moveInCargo", _unit1];
							["You are not authorized air crew."] remoteExec ["systemChat", _unit1];
						};
					};
				};
				if (_restricted and ((_vehicle isKindOf "CAR") or (_vehicle isKindOf "TANK"))) then
				{
					if !((typeOf _unit1) in AllowedGroundCrew) then
					{
						if (((assignedVehicleRole _unit1) isEqualTo ["driver"]) or ((assignedVehicleRole _unit1) isEqualTo ["gunner"]) or ((assignedVehicleRole _unit1) isEqualTo ["turret",[0]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[1]]) or ((assignedVehicleRole _unit) isEqualTo ["turret",[0,0]])) then
						{
							[_unit1] remoteExec ["moveOut", _unit1];
							[_unit1,_vehicle] remoteExec ["moveInCargo", _unit1];
							["You are not authorized crew."] remoteExec ["systemChat", _unit1];
						};
					};
				};
			}
		]
	] remoteExec ["addEventHandler", 0, true];
};

// process that handles the actual respawn wait and spawn
JST_fnc_vehRespawn =
{
	params ["_unit", "_vehArray"];
	if (!isServer) exitWith {};
	// pull respawn data from dead unit
	_vehArray params ["_unitVar", "_restricted", "_time", "_pos", "_vDirAndUp", "_class", "_config", "_name", "_attObjs", "_fnc", "_sideLocInfo", "_ticketCost"];
	// wait respawn time
	UIsleep _time;
	// find nearest safe position to respawn point
	private _safePos = _pos findEmptyPosition [0, 50, _class];
	// respawn vehicle
	_unitVar = createVehicle [_class, [(_safePos select 0), (_safePos select 1), ((_safePos select 2) + 10000)], [], 0, "NONE"];
	_unitVar setVehicleVarName _name;
	_unitVar setVectorDirAndUp _vDirAndUp;
	_unitVar setPos [(_safePos select 0), (_safePos select 1), ((_safePos select 2) + 1.5)];
	_unitVar setVectorDirAndUp _vDirAndUp;
	[_unitVar, _config select 0, _config select 1] call BIS_fnc_initVehicle;
	// add to zeuses
	{
		_x addCuratorEditableObjects [[_unitVar], true]
	} forEach allCurators;
	// add handlers
	[_unitVar] call JST_fnc_addVehRespawnHandlers;
	// save respawn data onto vehicle
	_unitVar setVariable ["CCO_vehArray", _vehArray, true];
	// safety check
	UIsleep 1;
	_unitVar setDamage 0;
	UIsleep 1;
	_unitVar setDamage 0;
	// Remove banned magazines
	{
		_unitVar removeMagazinesTurret [_x, [0]];
	} forEach VehBannedMagazines;
	// Add custom magazines
	{
		_unitVar addMagazineTurret _x
	} forEach ReplaceMagazines;
	// Save loadout for ace rearm
	_unitVar setVariable ["ace_rearm_scriptedLoadout", true, true];
	// Logi supply
	if (_class in LogiVehicles) then {
		[_unitVar, 999] call ace_cargo_fnc_setSpace;
		[_unitVar, 30, "ACE_Track", true] call ace_repair_fnc_addSpareParts;
		[_unitVar, 30, "ACE_Wheel", true] call ace_repair_fnc_addSpareParts;
	};
	// recreate attached objects, if any
	if ((count _attObjs) > 0) then
	{
		{
			_x params ["_type", "_relPos", "_vDirAndUp"];
			private _posSafe = [(_pos select 0), (_pos select 1), 100];
			private _obj = createVehicle [_type, _posSafe, [], 0, "CAN_COLLIDE"];
			_obj enableSimulationGlobal false;
			_obj setPos (_unitVar modelToWorld _relPos);
			_obj setVectorDirAndUp _vDirAndUp;
			[_obj, _unitVar] call BIS_fnc_attachToRelative;
		} forEach _attObjs;
	};
	// recreate setVariable'd sideLocInfo, if any
	_unitVar setVariable ["sideLocInfo", _sideLocInfo, true];
	// run any functions assigned to this vehicle
	[_unitVar] call _fnc;
	// Broadcast respawn notification
	{
		[
			"RespawnVehicle",
			[
				getText (configfile >> "CfgVehicles" >> typeOf _unitVar >> "displayName"),
				(_sideLocInfo select 1),
				getText (configfile >> "CfgVehicles" >> typeOf _unitVar >> "picture")
			]
		] remoteExec ["BIS_fnc_showNotification", _x];
	} forEach (_sideLocInfo select 0);
};

// wait for mission start
waitUntil {time > 3};

// handle vehicles at start: save data, remove banned magazines, add handlers
{
	// find data
	private _unitVar = _x select 0;
	private _restricted = _x select 1;
	private _time = _x select 2;
	private _pos = getPos _unitVar;
	private _vDir = vectorDir _unitVar;
	private _vUp = vectorUp _unitVar;
	private _class = typeOf _unitVar;
	private _config = [_unitVar] call BIS_fnc_getVehicleCustomization;
	private _name = vehicleVarName _unitVar;
	private _fnc = _x select 3;
	private _configSide = (getNumber (configfile >> "CfgVehicles" >> typeOf _unitVar >> "side"));
	private _ticketCount = _x select 4;
	// custom mission maker input for respawn notification [array of sides to notify, location name]
	// defaults to generic stuff if no input
	private _sideLocInfo = _unitVar getVariable ["sideLocInfo", [[_configSide],"MAIN"]];
	// find attached objects, if any
	private _attObjs = [];
	{ 
		private _type = typeOf _x;
		private _relPos = _unitVar worldToModel (getPos _x);
		private _vDir = vectorDir _x;
		private _vUp = vectorUp _x;
		_attObjs pushBack [_type, _relPos, [_vDir, _vUp]];
	} forEach (attachedObjects _unitVar);
	// store data on vehicle
	private _vehArray = [_unitVar, _restricted, _time, _pos, [_vDir, _vUp], _class, _config, _name, _attObjs, _fnc, _sideLocInfo, _ticketCount];
	_unitVar setVariable ["CCO_vehArray", _vehArray, true];
	// Remove banned magazines
	{
		_unitVar removeMagazinesTurret [_x, [0]];
	} forEach VehBannedMagazines;
	// Add custom magazines
	{
		_unitVar addMagazineTurret _x
	} forEach ReplaceMagazines;
	if (_class in LogiVehicles) then {
		[_unitVar, 999] call ace_cargo_fnc_setSpace;
		[_unitVar, 30, "ACE_Track", true] call ace_repair_fnc_addSpareParts;
		[_unitVar, 30, "ACE_Wheel", true] call ace_repair_fnc_addSpareParts;
	};
	// Save loadout for ace rearm
	_unitVar setVariable ["ace_rearm_scriptedLoadout", true, true];
	// run any functions assigned to this vehicle
	[_unitVar] spawn _fnc;
	// add handlers
	[_unitVar] spawn JST_fnc_addVehRespawnHandlers;
	// short sleep to avoid overload
	UIsleep 0.25;
} forEach CCO_vehs;