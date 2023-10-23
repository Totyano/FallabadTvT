if (indWaves isEqualTo indMaxWaves) then {
	systemChat "[CCE Respawn] You are out of respawn waves";
} else {
	// Increment wave count
	indWaves = indWaves + 1;
	publicVariable "indWaves";
	systemChat format ["[CCE Respawn] You have used %1/%2 waves", indWaves,indMaxWaves];
	// Spawn wave
	[independent, false] remoteExec ["Tun_Respawn_fnc_force_Respawn", 2];
};