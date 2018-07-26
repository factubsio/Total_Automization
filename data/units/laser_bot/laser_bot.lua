local path = util.path("data/units/smg_guy")
local name = require("shared").units.laser_bot

local base = util.copy(data.raw["combat-robot"]["destroyer"])
--for k, layer in pairs (base.animations[1].idle_with_gun.layers) do
--  layer.frame_count = 1
--end
table.insert(base.idle.layers, base.shadow_idle)
table.insert(base.in_motion.layers, base.shadow_in_motion)
local bot =
{
  type = "unit",
  name = name,
  localised_name = name,
  icon = base.icon,
  icon_size = base.icon_size,
  flags = {"player-creation"},
  map_color = {b = 0.5, g = 1},
  max_health = 125,
  radar_range = 2,
  order="b-b-b",
  subgroup="enemies",
  resistances =
  {
    {
      type = "physical",
      decrease = 4,
    }
  },
  healing_per_tick = 0,
  collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
  collision_mask = {"not-colliding-with-itself", "player-layer", "object-layer"},
  max_pursue_distance = 64,
  min_persue_time = 60 * 15,
  selection_box = {{-0.3, -0.3}, {0.3, 0.3}},
  sticker_box = {{-0.2, -0.2}, {0.2, 0.2}},
  distraction_cooldown = SU(30),
  move_while_shooting = true, --Not merged
  
  attack_parameters =
  {
    type = "beam",
    ammo_category = "electric",
    cooldown = SU(1),
    --cooldown_deviation = 0.15,
    range = 32,
    min_attack_distance = 28,
    --projectile_center = {-0.09375, -0.2},
    projectile_creation_distance = 1.4,
    source_direction_count = 8,
    --source_offset = {0, -0.1},
    ammo_type =
    {
      category = "laser-turret",
      energy_consumption = "800kJ",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "beam",
          beam = name.." Beam",
          max_length = 24,
          duration = SU(2),
          --source_offset = {0.15, -0.5},
        }
      }
    },
    animation = base.idle
  },
  vision_distance = 16,
  has_belt_immunity = true,
  movement_speed = SD(0.22),
  distance_per_frame = 0.15,
  pollution_to_join_attack = 1000,
  destroy_when_commands_fail = false,
  --corpse = name.." Corpse",
  dying_explosion = "explosion",
  working_sound = {
    sound =
    {
      { filename = "__base__/sound/flying-robot-1.ogg", volume = 0 }
    },
    max_sounds_per_type = 3,
    probability = SU(1 / (3 * 60)) -- average pause between the sound is 3 seconds
  },
  dying_sound =
  {
    {
      filename = "__base__/sound/fight/small-explosion-1.ogg",
      volume = 0.5
    },
    {
      filename = "__base__/sound/fight/small-explosion-2.ogg",
      volume = 0.5
    }
  },
  run_animation = base.in_motion
}
util.recursive_hack_make_hr(bot)
util.recursive_hack_scale(bot, 1.5)
util.scale_boxes(bot, 1.5)

local beam = util.copy(data.raw.beam["laser-beam"])
beam.name = name.." Beam"
beam.damage_interval = SU(1)
beam.action =
{
  type = "direct",
  action_delivery =
  {
    type = "instant",
    target_effects =
    {
      {
        type = "damage",
        damage = { amount = 0.3, type = "electric"}
      }
    }
  }
}

local item = {
  type = "item",
  name = name,
  icon = bot.icon,
  icon_size = bot.icon_size,
  flags = {},
  subgroup = "circuit-units",
  order = name,
  stack_size = 1
}

local recipe = {
    type = "recipe",
    name = name,
    category = require("shared").deployers.circuit_unit,
    enabled = true,
    ingredients =
    {
      {"iron-plate", 4}
    },
    energy_required = 5,
    result = name
}

data:extend{bot, beam, item, recipe}