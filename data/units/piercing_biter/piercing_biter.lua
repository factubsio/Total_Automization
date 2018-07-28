local path = util.path("data/units/scatter_spitter")
local name = require("shared").units.piercing_biter

local unit = util.copy(data.raw.unit["big-biter"])
unit.name = name
unit.localised_name = name
unit.collision_mask = {"not-colliding-with-itself", "player-layer"}
unit.can_open_gates = true
unit.destroy_when_commands_fail = false
--unit.move_while_shooting = true
unit.radar_range = 2
unit.movement_speed = SD(0.2)
unit.max_pursue_distance = 64
unit.min_persue_time = 8 * 60
unit.map_color = {b = 0.5, g = 1}
--unit.collision_box = {{-1, -1},{1, 1}}
--unit.selection_box = {{-1, -1},{1, 1}}
unit.max_health = 200

local animation = util.copy(unit.attack_parameters.animation)
local sound = util.copy(unit.attack_parameters.sound)
animation.layers[2].apply_runtime_tint = true
unit.run_animation.layers[2].apply_runtime_tint = true
unit.attack_parameters = 
{
  type = "projectile",
  range = 2,
  cooldown = SU(80),
  cooldown_deviation = 0.2,
  ammo_category = "melee",
  ammo_type =
  {
    category = "melee",
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = 20, type = util.damage_type("beetle")}
        }
      }
    }
  },
  sound = sound,
  animation = animation
}
--util.recursive_hack_scale(unit, 0.2)

local item = {
  type = "item",
  name = name,
  localised_name = name,
  icon = unit.icon,
  icon_size = unit.icon_size,
  flags = {},
  subgroup = "bio-units",
  order = name,
  stack_size= 1
}

local recipe = {
  type = "recipe",
  name = name,
  localised_name = name,
  category = require("shared").deployers.bio_unit,
  enabled = true,
  ingredients =
  {
    {"iron-plate", 4},
    {type = "fluid", name = "water", amount = 1}
  },
  energy_required = 5,
  result = name
}

data:extend{unit, item, recipe}


