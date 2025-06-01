local nsetapi = require("nsetapi")

local oldFS = {}
for k, v in pairs(fs) do
    oldFS[k] = v
end

nsetapi.useFS(oldFS)
nsetapi.setDefault("envmod.settings", "ENV_ENABLED", false)
nsetapi.setDefault("envmod.settings", "ENV_PATH", "/")

local function normalize(path)
    local result = {}

    for part in string.gmatch(path, "[^/]+") do
        if part == ".." then
            if #result == 0 then
                error("Not a directory", 0)
            end
            table.remove(result)
        elseif part ~= "." and part ~= "" then
            table.insert(result, part)
        end
    end

    return table.concat(result, "/")
end

fs.unsetEnvironment = function()
    local newDir = fs.combine(nsetapi.get("envmod.settings", "ENV_PATH"), shell.dir())
    nsetapi.save("envmod.settings", "ENV_ENABLED", false)
    nsetapi.save("envmod.settings", "ENV_PATH", "/")

    for k, v in pairs(oldFS) do
        for k2, _ in pairs(fs) do
            if k2 == k then fs[k] = v end
        end
    end
    shell.setDir(newDir)
end

fs.setEnvironment = function(enabled, path)
    nsetapi.save("envmod.settings", "ENV_ENABLED", enabled)
    nsetapi.save("envmod.settings", "ENV_PATH", path)

    local newFS = {}

    newFS.getPathParts = function(path)
        local t = {}
        for str in string.gmatch(path, "[^/]+") do
            table.insert(t, str)
        end
        return t
    end

    newFS.sanitizePath = function(path)
        if nsetapi.get("envmod.settings", "ENV_ENABLED") then
            local norm = normalize(oldFS.combine(path))
            if not norm then
                return nil
            end

            local parts = newFS.getPathParts(norm)
            if parts[1] ~= "rom" then
                return oldFS.combine(nsetapi.get("envmod.settings", "ENV_PATH"), norm)
            end

            return norm
        end
        return path
    end


    newFS.find = function(path)
        return oldFS.find(fs.sanitizePath(path))
    end
    newFS.isDriveRoot = function(path)
        return oldFS.isDriveRoot(fs.sanitizePath(path))
    end
    newFS.list = function(path)
        path = fs.sanitizePath(path)
        local list = oldFS.list(path)

        -- this makes the machine think rom exists, even when it doesn't
        if path == nsetapi.get("envmod.settings", "ENV_PATH") then table.insert(list, "rom") end
        return list
    end
    newFS.getName = function(path)
        return oldFS.getName(fs.sanitizePath(path))
    end
    newFS.getDir = function(path)
        return oldFS.getDir(fs.sanitizePath(path))
    end
    newFS.getSize = function(path)
        return oldFS.getSize(fs.sanitizePath(path))
    end
    newFS.exists = function(path)
        return oldFS.exists(fs.sanitizePath(path))
    end
    newFS.isDir = function(path)
        return oldFS.isDir(fs.sanitizePath(path))
    end
    newFS.isReadOnly = function(path)
        return oldFS.isReadOnly(fs.sanitizePath(path))
    end
    newFS.makeDir = function(path)
        return oldFS.makeDir(fs.sanitizePath(path))
    end
    newFS.move = function(path, dest)
        return oldFS.move(fs.sanitizePath(path), fs.sanitizePath(dest))
    end
    newFS.copy = function(path, dest)
        return oldFS.copy(fs.sanitizePath(path), fs.sanitizePath(dest))
    end
    newFS.delete = function(path)
        return oldFS.delete(fs.sanitizePath(path))
    end
    newFS.open = function(path, mode)
        return oldFS.open(fs.sanitizePath(path), mode)
    end
    newFS.getDrive = function(path)
        return oldFS.getDrive(fs.sanitizePath(path))
    end
    newFS.getFreeSpace = function(path)
        return oldFS.getFreeSpace(fs.sanitizePath(path))
    end
    newFS.getCapacity = function(path)
        return oldFS.getCapacity(fs.sanitizePath(path))
    end
    newFS.attributes = function(path)
        return oldFS.attributes(fs.sanitizePath(path))
    end

    for k, _ in pairs(fs) do
        for k2, v2 in pairs(newFS) do
            if k2 == k then fs[k] = v2 end
        end
    end

    fs.sanitizePath = newFS.sanitizePath
    fs.getPathParts = newFS.getPathParts
end
