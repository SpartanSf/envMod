local nsetapi = require("nsetapi")
local enabled = nsetapi.get("envmod.settings", "ENV_ENABLED")
local path = nsetapi.get("envmod.settings", "ENV_PATH")
shell.run("newEnv.lua")

fs.setEnvironment(enabled, path)