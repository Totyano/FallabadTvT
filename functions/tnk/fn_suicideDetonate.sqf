/*
	CCE_fnc_suicideDetonate
	By: Troy "tanaKa" Billsen

	Called from suicide vest event ACE action. Creates a massive explosion at the player.

	Params: 
		None
	Returns:
		Nothing
  	Locality:
		Local only
*/

params["_unit"];

// play sound
_sound = selectRandom ["allah1","allah2","allah3","allah4"];
[_unit, _sound, 300] call CBA_fnc_globalSay3d;
uisleep 1;
// spawn the bomb/explosion
"Bo_GBU12_LGB" createVehicle (getposATL _unit);
// Remove ace action
[player,1,["ACE_SelfActions","GTA"]] call ace_interact_menu_fnc_removeActionFromObject;
// Make sure player dies
_unit setDamage 1;
// Remove event handler just in case
player removeAllEventHandlers "Take";
player removeAllEventHandlers "Put";