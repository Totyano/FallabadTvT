/*
	CCE_fnc_suicideInit
	By: Troy "tanaKa" Billsen

	Adds an event handler to all fedayeen groups that allows suicide vest usage

	Params: 
		None
	Returns:
		Nothing
  	Locality:
		Local only
*/
if (side player isEqualTo EAST) then {
	// EH for vest pickup
	player addEventHandler ["Take", {
		params ["_unit", "_container", "_item"];

		// Exit if not a suicide vest
		if (_item isNotEqualTo "PLOT_ARMOR_V_HarnessOGL_brn") exitWith {};

		// else add the ace suicide action
		systemChat "Suicide is now an option";
		suicideAction = ["GTA","GO TO ALLAH","",{[player] spawn CCE_fnc_suicideDetonate},{true}] call ace_interact_menu_fnc_createAction;
		[player, 1, ["ACE_SelfActions"], suicideAction, true] call ace_interact_menu_fnc_addActionToObject;
	}];

	// EH for vest put down
	player addEventHandler ["Put", {
		params ["_unit", "_container", "_item"];

		if (_item isNotEqualTo "V_TacVest_khk") exitWith {};

		// else remove the suicide action
		systemChat "Suicide is no longer an option";
		[player, 1, ["ACE_SelfActions","GTA"]] call ace_interact_menu_fnc_removeActionFromObject;
	}];
};