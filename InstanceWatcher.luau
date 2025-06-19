--//Locals
local InstanceWatcher = {}
InstanceWatcher.__index = InstanceWatcher

--//Functions

--//Main

function InstanceWatcher.new()
    local self = setmetatable({}, InstanceWatcher)
    self.instances = {}

    return self
end

--//

function InstanceWatcher:Add(name : string, instance : Instance | {Instance}, cleanupOld : boolean?)
    local newName = (name or instance.Name)

    if ((self.instances[newName]) and (cleanupOld)) then
        self:Remove(newName)
        warn(`{script.Name}: Removed already existing Instance in {newName}!`)
    end

    self.instances[newName] = instance

    return self.instances[newName]
end

function InstanceWatcher:Get(name : string)
    return self.instances[name]
end

function InstanceWatcher:Remove(name : string)
    local instanceToRemove = self.instances[name]
    if (not instanceToRemove) then warn(`{script.Name}: Instance with name {name} does not exist!`) return end

    --//

    if (typeof(instanceToRemove) == "table") then
        for _, object : Instance in instanceToRemove do
            object:Destroy()
        end
    else
        instanceToRemove:Destroy()
    end

    self.instances[name] = nil
end

--//

function InstanceWatcher:Destroy()
    for name : string, _ in next, self.instances do
        self:Remove(name)
    end

    table.clear(self.instances)
end

--//End
return InstanceWatcher
