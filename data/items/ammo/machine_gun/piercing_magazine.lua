local name = names.ammo.piercing_magazine
local ammo = util.copy(data.raw.ammo["firearm-magazine"])
ammo.name = name
ammo.localised_name = name
ammo.magazine_size = 15
ammo.stack_size = 8
ammo.reload_time = SU(75)
ammo.ammo_type =
{
  category = util.ammo_category("machine_gun"),
  target_type = "direction",
  action =
  {
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {
          {
            type = "create-explosion",
            entity_name = "explosion-gunshot"
          }
        }
      }
    },
    {
      type = "direct",
      action_delivery =
      {
        type = "projectile",
        projectile = name,
        starting_speed = SD(1.2),
        direction_deviation = 0.01,
        range_deviation = 0.01,
        max_range = 45
      }
    }
  }
}

local projectile = util.copy(data.raw.projectile["cannon-projectile"])
projectile.name = name
projectile.localised_name = name
projectile.force_condition = "not-same"
projectile.action =
{
  type = "direct",
  action_delivery =
  {
    type = "instant",
    target_effects =
    {
      {
        type = "create-entity",
        entity_name = "explosion-hit"
      },
      {
        type = "damage",
        damage = {amount = 12 , type = util.damage_type("machine_gun")}
      }
    }
  }
}
projectile.final_action = nil
util.recursive_hack_something(projectile.animation, "blend_mode", "additive")

data:extend{ammo, projectile}


