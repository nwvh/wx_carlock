wx = {}

wx.targetSupport = true -- You can enable ox_target support!

wx.progressLength = 850 -- In ms, how long should it take to unlock the vehicle

wx.checkRadius = 5.0 -- Radius to check for vehicles around the player

wx.commandOnLock = 'me Locking vehicle'
wx.commandOnUnLock = 'me Unlocking vehicle'

wx.Sounds = true -- Play sound in small radius on lock/unlock

wx.Notifications = { -- Which notifications to display?
    Locked = true, -- When locking vehicle
    Unlocked = true, -- When unlocking vehicle
    NotYourVehicle = true, -- When the nearest vehicle doesn't belong to player
    NoNearbyVehicles = true -- When there's no nearby vehicles
}

wx.ToDisable = { -- Which one of these should be disabled while locking/unlocking vehicles?
    car = true, -- Disable car movement
    move = false, -- Disable player movement
    combat = true -- Disable shooting,aiming and other combat stuff
}

wx.Anim = {
    dict = 'anim@mp_player_intmenu@key_fob@',
    clip = 'fob_click'
}

wx.Locale = {
    ["ProgressLocking"] = "Locking...",
    ["ProgressUnLocking"] = "Unlocking...",

    ["TargetLabel"] = "Lock/Unlock Vehicle",

    ["NotifyTitle"] = "WX Car Lock",
    ["NotifyLocked"] = "You have locked your vehicle.",
    ["NotifyUnLocked"] = "You have unlocked your vehicle.",
    ["NoVehicleNearby"] = "There are no nearby vehicles.",
    ["NotOwned"] = "This isn't your vehicle.",
    ["LockedWhileInside"] = "You can't get out while your vehicle is locked!",
}
