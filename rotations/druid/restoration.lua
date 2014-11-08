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
  -- Pause Rotation
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },
  --{ "pause", "player.seal = 1" }, -- Bear Form
  --{ "pause", "player.seal = 2" }, -- Cat Form

  { "Treant Form", { "!player.buff(Treant Form)", "!modifier.last" } },

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
  { "Rejuvenation", { "player.health < 100", "!player.buff(Rejuvenation)" }, "player" },
  { "Wild Mushroom", { "player.health < 100", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "player" }, -- If Glyph of the Sprouting Mushroom then use NeedHealsAroundUnit with lowest.ground target
  { "Regrowth", { "player.health < 70", "!player.buff(Regrowth)", "!player.moving" }, "player" },
  { "Swiftmend", { "player.health < 90", "player.buff(Rejuvenation)" }, "player" },
  { "Swiftmend", { "player.health < 90", "player.buff(Regrowth)" }, "player" },

  -- TANK HEALING
  { {
    { "Ironbark", "boss1target.health < 80", "boss1target" },
    { "Lifebloom", "!boss1target.buff(Lifebloom)", "boss1target" },
    { "Rejuvenation", "!boss1target.buff(Rejuvenation)", "boss1target" },
    { "Wild Mushroom", { "boss1target.health < 90", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "boss1target" }, -- If Glyph of the Sprouting Mushroom then use NeedHealsAroundUnit with lowest.ground target
    { "Swiftmend", { "boss1target.health < 80", "boss1target.buff(Rejuvenation)" }, "boss1target" },
    { "Swiftmend", { "boss1target.health < 80", "boss1target.buff(Regrowth)" }, "boss1target" },
  },{
    "@bbLib.isTank('boss1target')", "boss1target.alive", "boss1target.distance < 40",
  } },
  { {
    { "Ironbark", "focus.health <= 80", "focus" },
    { "Lifebloom", "!focus.buff(Lifebloom)", "focus" },
    { "Rejuvenation", "!focus.buff(Rejuvenation)", "focus" },
    { "Wild Mushroom", { "focus.health < 100", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "focus" },
    { "Swiftmend", { "focus.health <= 80", "focus.buff(Rejuvenation)" }, "focus" },
    { "Swiftmend", { "focus.health <= 80", "focus.buff(Regrowth)" }, "focus" },
  },{
    "focus.exists", "@bbLib.isNotTank('boss1target')", "focus.alive", "!focus.enemy", "focus.distance < 40",
  } },

  -- MOUSEOVER HEALS
  { "Rejuvenation", { "mouseover.exists", "!mouseover.enemy", "!mouseover.buff(Rejuvenation)", "mouseover.range < 40" }, "mouseover" },
  { "Regrowth", { "toggle.mouseover", "!mouseover.buff(Regrowth)", "mouseover.health < 100", "!mouseover.range > 40" }, "mouseover" },
  { "Healing Touch", { "toggle.mouseover", "mouseover.buff(Regrowth)", "mouseover.health < 100", "!mouseover.range > 40" }, "mouseover" },

  -- RAID HEALING
  { "Regrowth", { "lowest.health < 100", "!lowest.buff(Regrowth)", "player.buff(Clearcasting)" }, "lowest" },
  { "774", { "lowest.health < 100", "!lowest.buff(774)" }, "lowest" },
  { "Wild Growth", { "lowest.health <= 90", "!player.moving", "@coreHealing.needsHealing(90, 2)" }, "lowest" },
  { "Swiftmend", { "lowest.health <= 80", "lowest.buff(Rejuvenation)" }, "lowest" },
  { "Swiftmend", { "lowest.health <= 80", "lowest.buff(Regrowth)" }, "lowest" },
  { "Wild Mushroom", { "lowest.health < 100", "!player.moving", (function() return GetTotemInfo(1) == false end) }, "lowest" },
  { "Regrowth", { "lowest.health <= 80", "!lowest.buff(Regrowth)", "!player.moving" }, "lowest" },
  { "Healing Touch", { "lowest.health < 100", "!player.moving" }, "lowest" },

  { "Wrath", "lowest.health > 99", "target" },

}, {
-- OUT OF COMBAT ROTATION
  -- PAUSE
  { "pause", "modifier.lalt" },
  { "pause", "player.buff(Food)" },

  -- BUFFS
  { "Mark of the Wild", { (function() return select(1,GetRaidBuffTrayAuraInfo(1)) == nil end), "lowest.distance <= 30", "player.form = 0" }, "lowest" },

  -- REZ
  { "50769", { "target.exists", "target.dead", "!player.moving", "target.player" }, "target" }, -- Revive (50769)

  -- HEAL
  { "Lifebloom", { "focus.exists", "focus.alive", "!focus.buff(Lifebloom)" }, "focus" },
  { "Rejuvenation", { "lowest.health < 99", "!lowest.buff(Rejuvenation)" }, "lowest" },
  { "Regrowth", { "lowest.health < 99", "!lowest.buff(Regrowth)" }, "lowest" },

  -- PAUSE FORM
  { "/cancelform", { "target.exists", "target.friend", "!player.form = 0", "target.range < 1" } },
  { "pause", { "target.exists", "target.friend", "target.range < 1", "@bbLib.isNPC('target')" } },

  -- AUTO FORM
  { "Travel Form", { "!player.buff(Travel Form)", "player.moving", "!target.enemy", (function() return not IsIndoors() end) } },
  { "Cat Form", { "!player.form = 2", "!player.buff(Travel Form)", "player.moving", "!target.enemy" } },

  -- AUTO FOLLOW
  { "Mark of the Wild", { "toggle.autofollow", "focus.exists", "focus.alive", (function() return GetFollowTarget() == nil end), (function() SetFollowTarget('focus') end) } }, -- TODO: NYI: isFollowing()

},
function()
  PossiblyEngine.toggle.create('dispel', 'Interface\\Icons\\ability_shaman_cleansespirit', 'Dispel', 'Toggle Dispel')
  PossiblyEngine.toggle.create('mouseover', 'Interface\\Icons\\spell_nature_resistnature', 'Mouseover Regrowth', 'Toggle Mouseover Regrowth For SoO NPC Healing')
  PossiblyEngine.toggle.create('autofollow', 'Interface\\Icons\\achievement_guildperk_everybodysfriend', 'Auto Follow', 'Automaticaly follows your focus target. Must be another player.')
end)
