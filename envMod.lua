local args = {...}

if #args ~= 1 then error("envMod [path or '/']", 0) end

if args[1] ~= "/" then
    fs.setEnvironment(true, args[1])
else
    fs.unsetEnvironment()
end