-- chat_grant_interact/init.lua
-- Grant newcomers interact only after they speak
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

chat_grant_interact = {}
chat_grant_interact.internal = {}
chat_grant_interact.internal.S = minetest.get_translator("chat_grant_interact")
chat_grant_interact.internal.logger = logging.logger("chat_grant_interact")

local MP = minetest.get_modpath("chat_grant_interact")
for _, name in ipairs({
    "tutorial",
    "trial",
}) do
    dofile(MP .. "/src/" .. name .. ".lua")
end
