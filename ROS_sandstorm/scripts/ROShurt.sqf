// Requires ROSsandstorm.sqf v4.6 by RickOShay

params ["_endtime","_debug"];

_sounds = ["hurt1","hurt2","hurt3","hurt4","hurt5","hurt6","hurt7"];

sleep 21;

if (vehicle player == player && goggles player == "") then {hint "Put on protective eyewear or get under cover";};

sleep 2;

if (_debug) then {hint "Start Hurt loop";};

While {time < _endtime} do {
	// not in vehicle - or building
	if (vehicle player == player && !SS_inBuilding) then {
		// not wearing goggles => hurt + extra filmgrain
		if (goggles player == "") then {
			SS_hndlFGrain ppEffectAdjust [0.08, 1.25, 2.2, 0.75, 1, 0];
	    	SS_hndlFGrain ppEffectCommit 5;
			_hurt = selectRandom _sounds;
	   		player say3d _hurt;
			sleep 5 + random 5;
			_damage = damage player;
			player setDamage (_damage + 0.02);
		};
	};

sleep 0.2;

};

