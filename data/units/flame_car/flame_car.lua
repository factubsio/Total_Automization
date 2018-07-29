local name = require("shared").units.flame_car

local sprite_base = util.copy(data.raw.car.car)
local path = util.path("data/units/flame_car/")

local unit =
{
  type = "unit",
  name = name,
  localised_name = name,
  icon = sprite_base.icon,
  icon_size = sprite_base.icon_size,
  flags = {"player-creation"},
  map_color = {b = 0.5, g = 1},
  max_health = 115,
  radar_range = 2,
  order="b-b-b",
  subgroup="enemies",
  resistances = nil,
  healing_per_tick = 0,
  collision_box = {{-1, -1}, {1, 1}},
  selection_box = {{-1, -1}, {1, 1}},
  collision_mask = {"not-colliding-with-itself", "player-layer"},
  max_pursue_distance = 64,
  min_persue_time = SU(60 * 15),
  --sticker_box = {{-0.2, -0.2}, {0.2, 0.2}},
  distraction_cooldown = SU(30),
  move_while_shooting = true,
  can_open_gates = true,
  attack_parameters =
  {
    type = "projectile",
    ammo_category = "bullet",
    cooldown = SU(1),
    range = 16,
    min_attack_distance = 10,
    projectile_creation_distance = 1.5,
    cyclic_sound =
    {
      begin_sound =
      {
        {
          filename = path.."flamethrower_shoot_start.ogg",
          volume = 0.5
        }
      },
      middle_sound =
      {
        {
          filename = path.."flamethrower_shoot_mid.ogg",
          volume = 0.5
        }
      },
      end_sound =
      {
        {
          filename = path.."flamethrower_shoot_end.ogg",
          volume = 0.5
        }
      }
    },
    ammo_type =
    {
      category = "bullet",
      target_type = "direction",
      action =
      {
        {
          type = "direct",
          repeat_count = 2,
          action_delivery =
          {
            type = "projectile",
            projectile = name.." Projectile",
            starting_speed = SD(0.5),
            starting_speed_deviation = SD(0.025),
            direction_deviation = 0.3,
            range_deviation = 0.2,
            starting_frame_deviation = 5,
            max_range = 18
          }
        }
      }
    },
    animation = sprite_base.animation
  },
  vision_distance = 40,
  has_belt_immunity = true,
  movement_speed = SD(0.35),
  distance_per_frame = 0.15,
  pollution_to_join_attack = 1000,
  destroy_when_commands_fail = false,
  --corpse = name.." Corpse",
  dying_explosion = "explosion",
  vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
  working_sound =
  {
    sound =
    {
      filename = "__base__/sound/car-engine.ogg",
      volume = 0.6
    }
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
  run_animation = sprite_base.animation
}

local projectile = util.copy(data.raw.projectile["shotgun-pellet"])
projectile.name = name.." Projectile"
projectile.collision_box = {{-0.1, -0.1},{0.1, 0.1}}
projectile.force_condition = "not-same"
projectile.height = 0
projectile.action = 
{
  type = "direct",
  action_delivery =
  {
    type = "instant",
    target_effects =
    {
      {
        type = "damage",
        damage = {amount = 0.25 , type = util.damage_type("flame_car")}
      },
      {
        type = "create-sticker",
        sticker = "Afterburn Sticker"
      }
    }
  }
}
projectile.acceleration = SA(-0.0075)
projectile.final_action = nil
projectile.animation = require("data/tf_util/tf_fire_util").create_fire_pictures({animation_speed = SD(1), scale = 0.5})


local item = {
  type = "item",
  name = name,
  localised_name = name,
  icon = unit.icon,
  icon_size = unit.icon_size,
  flags = {},
  subgroup = "iron-units",
  order = "b-"..name,
  stack_size = 1
}

local recipe = {
  type = "recipe",
  name = name,
  localised_name = name,
  category = require("shared").deployers.iron_unit,
  enabled = true,
  ingredients =
  {
    {"iron-plate", 4}
  },
  energy_required = 5,
  result = name
}


data:extend{unit, projectile, item, recipe}
