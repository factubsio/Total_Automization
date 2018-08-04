--We don't need electric furnaces
util.prototype.remove_entity_prototype(data.raw.furnace["electric-furnace"])

--Don't want no stinking assembling machine 3
util.prototype.remove_entity_prototype(data.raw["assembling-machine"]["assembling-machine-3"])

--Scale the crafting speed of the others

for k, machine in pairs (data.raw.furnace) do
  machine.crafting_speed = SD(machine.crafting_speed * 2)
end
for k, machine in pairs (data.raw["assembling-machine"]) do
  machine.crafting_speed = SD(machine.crafting_speed * 2)
end