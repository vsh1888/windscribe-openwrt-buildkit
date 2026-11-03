module("luci.controller.windscribe_bootstrap", package.seeall)
local fs = require "nixio.fs"
function index()
    if not fs.access("/usr/bin/windscribe-preflight") then return end
    entry({"admin", "vpn", "windscribe"}, template("windscribe_bootstrap/index"), _("Windscribe"), 90).dependent = false
end
