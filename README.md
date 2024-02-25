# WX Carlock
Simple vehicle locking system for FiveM, using ox_lib and ESX.

# Features
* Locking / Unlocking owned vehicles
* Target option
* Config file
* Sounds
* Ability to share key to your vehicle with other players
* ... and more

# Exports
## Share Key to Vehicle
```lua
exports["wx_carlock"]:shareKey(
    playerId, -- [[ integer ]]
    vehiclePlate -- [[ string ]]
)
```