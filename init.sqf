
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Example: Start sandstorms using ROS Sandstorm scheduler.
// For more info read the ROS_Sandstorm_Scheduler.sqf and ROS_Sandstorm.sqf script headers in the ROS_Sandstorm\scripts folder.
//
// Number of storms are from server start time to 24h00.
// Usage: [minimum number of storms, maximum number of storms, length of storm] in seconds.
// Minimum sandstorm length is 150 secs.

// Recommended storm lengths are 150 + (55 x n) = (150,205,260,315,370,425,480,535. Or 0 for random length.)

// Example 1: [4, 4, 150] execvm "ROS_Sandstorm\scripts\ROS_Sandstorm_Scheduler.sqf";
// Above example = run 4 storms from current time to 24:00 with a length of 150 secs.

// Example 2: [0, 1, 260] execvm "ROS_Sandstorm\scripts\ROS_Sandstorm_Scheduler.sqf";
// Above example = run from 0 to 1 storm from current time to 24:00 with length of 260 secs.
// ie. 50% chance of no storm and 50% of 1 storm from current time to 24:00.

// Example 3: [0, 4, 0] execvm "ROS_Sandstorm\scripts\ROS_Sandstorm_Scheduler.sqf";
// Above example = run from 0 to 4 storms from current mission time to 24:00 with random storm length (max length is 535 secs).
// i.e. there is a 20% chance of 0,1,2,3,4 storms from current time to 24:00.

// Add the next line into the init.sqf file to start random sandstorms.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
[6, 12, 370] execvm "ROS_Sandstorm\scripts\ROS_Sandstorm_Scheduler.sqf";
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

