local command_center = {}
local data = {}
local names = require("shared").entities
defines.events["on_command_center_killed"] = script.generate_event_name()

local on_entity_died = function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if entity.name == names.command_center then
    script.raise_event(defines.events.on_command_center_killed, event)
  end
end

local on_command_center_killed = function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  local related = data[entity.unit_number]
  if not related then return end
  for k, ent in pairs (related) do
    ent.destroy()
  end
end

local script_raised_built = function(event)
  game.print("THIS LOOKS LIKE A JOB FOR ME")
  local entity = event.created_entity
  if not (entity and entity.valid) then return end
  if not (entity.name == names.command_center) then return end
  local position = entity.position
  local surface = entity.surface
  local force = entity.force
  local components = {}
  local roboport = surface.create_entity{name = names.command_center.." Roboport", position = position, force = force}
  roboport.operable = false
  roboport.destructible = false
  roboport.insert({name = names.command_center.." Robot", count = 50})
  table.insert(components, roboport)
  local chest = surface.create_entity{name = names.command_center.." Chest", position = position, force = force}
  chest.destructible = false
  table.insert(components, chest)
  data[entity.unit_number] = components

end

local events =
{
  [defines.events.script_raised_built] = script_raised_built,
  [defines.events.on_entity_died] = on_entity_died,
  [defines.events.on_command_center_killed] = on_command_center_killed
}

command_center.create = function(surface, position, force)
  local force = force or "player"
  local offsets = {
    {-12,-12},
    {-12, 12},
    {12, 12},
    {12, -12} 
  }
  local command_center = surface.create_entity{name = names.command_center, position = position, force = force}
  local components = {}
  local roboport = surface.create_entity{name = names.command_center.." Roboport", position = position, force = force}
  roboport.operable = false
  roboport.destructible = false
  roboport.insert({name = names.command_center.." Robot", count = 50})
  table.insert(components, roboport)
  local chest = surface.create_entity{name = names.command_center.." Chest", position = position, force = force}
  chest.destructible = false
  table.insert(components, chest)
  data[command_center.unit_number] = components

end

remote.add_interface("command_center", {create = function(surface, position, force) command_center.create(surface, position, force) end})

command_center.on_event = handler(events)

command_center.on_init = function()
  global.command_center = data
end

command_center.on_load = function()
  data = global.command_center or data
end

return command_center