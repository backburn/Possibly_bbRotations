-- PossiblyEngine Rotation
-- Restoration Druid - WoD 6.0.2
-- Updated on Oct 25th 2014

-- PLAYER CONTROLLED:
-- TALENTS: Feline Swiftness, Ysera's Gift, Typhoon, Incarnation: Tree of Life, Mighty Bash, Nature's Vigil
-- GLYPHS: Glyph of Rebirth, Glyph of Healing Touch, Glyph of Rejuvination, Glyph of Grace (minor)
-- CONTROLS: Pause - Left Control

-- TODO: Actually use talents, mouseover rez/rebirth, OOC rotation.

PossiblyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return PossiblyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
})

PossiblyEngine.rotation.register_custom(105, "bbDruid Restoration", {
-- COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lcontrol" },
  { "pause", "@bbLib.bossMods" },

  { "Treant Form", { "!player.buff(Treant Form)", "!player.buff(Dash)", "!modifier.last", "player.ininstance" } },

  -- BATTLE REZ
  --{ "Rebirth", { "target.exists", "target.dead", "!player.moving", "target.player" }, "target" },

  -- DISPELLS
  { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Aqua Bomb)" }, "mouseover" }, -- Proving Grounds
  { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Shadow Word: Bane)" }, "mouseover" }, -- Fallen Protectors
  { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Lingering Corruption)" }, "mouseover" }, -- Norushen
  { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Mark of Arrogance)", "player.buff(Power of the Titans)" }, "mouseover" }, -- Sha of Pride
  { "Nature's Cure", { "toggle.dispel", "mouseover.debuff(Corrosive Blood)" }, "mouseover" }, -- Thok

  -- HEALING COOLDOWNS
  { "Tranquility", "@coreHealing.needsHealing(70, 8)" },
  --{ "Genesis", { "raid.health < 70", "lowest.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0" }, "lowest" },
  --{ "Genesis", { "lowest.health < 40", "lowest.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0" }, "lowest" },
  { "Nature's Swiftness", "lowest.health < 90" },

  -- SELF HEALING
  { "Rejuvenation", { "player.health < 95", "!player.buff(Rejuvenation)" }, "player" },
  { "Wild Mushroom", { "!player.glyph(146654)", "player.health < 90", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "player" }, -- If Glyph of the Sprouting Mushroom then use NeedHealsAroundUnit with lowest.ground target
  { "Wild Mushroom", { "player.glyph(146654)", "player.health < 90", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "player.ground" },
  { "Swiftmend", { "player.health < 70", "player.buff(Rejuvenation)" }, "player" },
  { "Swiftmend", { "player.health < 70", "player.buff(Regrowth)" }, "player" },
  { "Regrowth", { "player.health < 70", "!player.buff(Regrowth)", "!player.moving" }, "player" },

  -- TANK HEALING
  { {
    { "Ironbark", "boss1target.health < 70", "boss1target" },
    { "Lifebloom", "!boss1target.buff(Lifebloom)", "boss1target" },
    { "Rejuvenation", "!boss1target.buff(Rejuvenation)", "boss1target" },
    { "Rejuvenation", { "talent(7, 2)", "boss1target.buff(Rejuvenation).count < 2" }, "boss1target" },
    { "Wild Mushroom", { "!player.glyph(146654)", "boss1target.health < 90", "!boss1target.moving", (function() return GetTotemInfo(1) == false end) }, "boss1target" }, -- If Glyph of the Sprouting Mushroom then use NeedHealsAroundUnit with lowest.ground target
    { "Wild Mushroom", { "player.glyph(146654)", "boss1target.health < 90", "!boss1target.moving", (function() return GetTotemInfo(1) == false end) }, "boss1target.ground" },
    { "Swiftmend", { "boss1target.health < 75", "boss1target.buff(Rejuvenation)" }, "boss1target" },
    { "Swiftmend", { "boss1target.health < 75", "boss1target.buff(Regrowth)" }, "boss1target" },
  },{
    "@bbLib.isTank('boss1target')", "boss1target.alive", "boss1target.distance < 40",
  } },
  { {
    { "Ironbark", "focus.health <= 70", "focus" },
    { "Lifebloom", "!focus.buff(Lifebloom)", "focus" },
    { "Rejuvenation", "!focus.buff(Rejuvenation)", "focus" },
    { "Rejuvenation", { "talent(7, 2)", "focus.buff(Rejuvenation).count < 2" }, "focus" },
    { "Wild Mushroom", { "!player.glyph(146654)", "focus.health < 90", "!focus.moving", (function() return GetTotemInfo(1) == false end) }, "focus" },
    { "Wild Mushroom", { "player.glyph(146654)", "focus.health < 90", "!focus.moving", (function() return GetTotemInfo(1) == false end) }, "focus.ground" },
    { "Swiftmend", { "focus.health <= 75", "focus.buff(Rejuvenation)" }, "focus" },
    { "Swiftmend", { "focus.health <= 75", "focus.buff(Regrowth)" }, "focus" },
  },{
    "focus.exists", "@bbLib.isNotTank('boss1target')", "focus.alive", "!focus.enemy", "focus.distance < 40",
  } },

  { {
    { "Genesis", { "@coreHealing.needsHealing(50, 3)", "player.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0" }, "player" },
    { "Genesis", { "focus.exists", "@coreHealing.needsHealing(50, 3)", "focus.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0" }, "focus" },
    { "Genesis", { "party1.exists", "@coreHealing.needsHealing(50, 3)", "party1.buff(Rejuvenation)", "player.spell(Swiftmend).cooldown > 0" }, "party1" },
    { "Rejuvenation", { "party1.exists", "party1.health < 95", "!party1.buff(Rejuvenation)", "party1.distance < 40" }, "party1" },
    { "Rejuvenation", { "party2.exists", "party2.health < 95", "!party2.buff(Rejuvenation)", "party2.distance < 40" }, "party2" },
    { "Rejuvenation", { "party3.exists", "party3.health < 95", "!party3.buff(Rejuvenation)", "party3.distance < 40" }, "party3" },
    { "Rejuvenation", { "party4.exists", "party4.health < 95", "!party4.buff(Rejuvenation)", "party4.distance < 40" }, "party4" },
  },{
    "player.ininstance(party)",
  } },

  -- MOUSEOVER HEALS
  { "Rejuvenation", { "mouseover.exists", "!mouseover.enemy", "!mouseover.buff(Rejuvenation)", "mouseover.distance < 40" }, "mouseover" },
  { "Regrowth", { "toggle.mouseover", "!mouseover.buff(Regrowth)", "mouseover.health < 70", "mouseover.distance < 40" }, "mouseover" },

  -- RAID HEALING

  { "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)", "player.buff(Clearcasting)" }, "lowest" },
  { "Swiftmend", { "lowest.health <= 50", "lowest.buff(Rejuvenation)" }, "lowest" },
  { "Swiftmend", { "lowest.health <= 50", "lowest.buff(Regrowth)" }, "lowest" },
  { "Regrowth", { "lowest.health <= 70", "!lowest.buff(Regrowth)", "!player.moving" }, "lowest" },
  { "Rejuvenation", { "lowest.health < 100", "!lowest.buff(Rejuvenation)" }, "lowest" },
  { "Wild Growth", { "lowest.health <= 80", "!player.moving", "@coreHealing.needsHealing(80, 3)" }, "lowest" },
  { "Wild Mushroom", { "!player.glyph(146654)", "lowest.health < 90", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "lowest" },
  --{ "Wild Mushroom", { "player.glyph(146654)", "lowest.health < 90", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "lowest.ground" },
  { "Healing Touch", { "lowest.health < 98", "!player.moving" }, "lowest" },

  --{ "Wrath", "lowest.health > 99", "target" },

}, {
-- OUT OF COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lalt" },
  { "pause", "@bbLib.bossMods" },

  -- BUFFS
  { "Mark of the Wild", "!player.buffs.stats" },

  -- HEALING
  { "Renewal", { "talent(2, 2)", "player.health < 80" }, "player" },
  { "Rejuvenation", { "player.health < 90", "!player.buff(Rejuvenation)" }, "player" },
  { "Healing Touch", { "player.health < 70" }, "player" },
  { "Lifebloom", { "focus.exists", "focus.alive", "!focus.buff(Lifebloom)", "focus.distance < 40" }, "focus" },
  { "Rejuvenation", { "lowest.health < 90", "!lowest.buff(Rejuvenation)", "lowest.distance < 40" }, "lowest" },
  { "Regrowth", { "lowest.health < 80", "!lowest.buff(Regrowth)", "lowest.distance < 40" }, "lowest" },

  -- REZ
  { "Revive", { "target.exists", "target.player", "target.dead", "!player.moving"  }, "target" },

  -- Cleanse Debuffs
  { "Remove Corruption", "player.dispellable(Remove Corruption)", "player" },

  -- AUTO FOLLOW
  { "Mark of the Wild", { "toggle.autofollow", "focus.exists", "focus.alive", (function() return GetFollowTarget() == nil end), (function() SetFollowTarget('focus') end) } }, -- TODO: NYI: isFollowing()

  -- AUTO FORMS
  { {
    { "pause", { "target.exists", "target.istheplayer" } },
    { "/cancelform", { "target.isfriendlynpc", "!player.form = 0", "!player.ininstance", "target.range <= 2" } },
    { "pause", { "target.isfriendlynpc", "target.range <= 2" } },
    { "Travel Form", { "!player.form = 3", "!target.exists", "!player.ininstance", "player.moving", "player.outdoors" } },
    { "Cat Form", { "!player.form = 2", "!player.form = 3", "!target.exists", "player.moving" } },
    { "Treant Form", { "!player.buff(Treant Form)", "!modifier.last", "player.ininstance" } },
  },{
    "toggle.forms", "!player.flying", "!player.buff(Dash)",
  } },

},
function()
  PossiblyEngine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  PossiblyEngine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_faeriefire', 'Mouseover Regrowth', 'Toggle Mouseover Regrowth For SoO NPC Healing')
  PossiblyEngine.toggle.create('forms', 'Interface\\Icons\\ability_druid_treeoflife', 'Auto Form', 'Toggle usage of smart forms out of combat. Does not work with stag glyph!')
  PossiblyEngine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target, including NPCs.')
end)
