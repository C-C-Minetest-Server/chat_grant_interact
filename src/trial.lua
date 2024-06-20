-- chat_grant_interact/src/trial.lua
-- DO the main logic
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

local S = chat_grant_interact.internal.S
local logger = chat_grant_interact.internal.logger:sublogger("trial")

local on_join_message = minetest.get_color_escape_sequence("orange") ..
    S("To unlock the ability to interact, you have to speak in the chatroom.")

local on_pass_message = minetest.get_color_escape_sequence("orange") ..
    S("You've just sent your first chat message. Welcome playing!")

local function chat_send_player_safe(name, msg)
    if not minetest.get_player_by_name(name) then return end
    minetest.chat_send_player(name, msg)
end

minetest.register_on_newplayer(function(player)
    local name = player:get_player_name()
    local privs = minetest.get_player_privs(name)
    if privs.interact then
        -- Revoke and start the trial
        logger:action(string.format("New player %s joining, starting trial", name))

        privs.interact = nil
        minetest.set_player_privs(name, privs)

        player:get_meta():set_int("chat_grant_interact_trial", 1)
    end
end)

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    local meta = player:get_meta()
    if meta:get_int("chat_grant_interact_trial") ~= 0 then
        if minetest.check_player_privs(name, { interact = true }) then
            -- Some moderator granted interact, stop the trial
            meta:set_int("chat_grant_interact_trial", 0)
            return
        end

        if chat_grant_interact.TEACHER_ENABLED then
            -- If teacher exists, show tutorial

            if not minetest.global_exists("temp_password") or not temp_password.is_using_temporary_password(name) then
                -- Don't override temp password formspec
                -- Forcely renew unlock time
                teacher.unlock_and_show(player, "chat_grant_interact:chat_grant_interact", nil, true)
            end
        end

        -- Send a notice to the player
        minetest.after(-1, chat_send_player_safe, name, on_join_message)
    end
end)

minetest.register_on_chat_message(function(name, message)
    if string.sub(message, 1, 1) == "/" then return end

    local player = minetest.get_player_by_name(name)
    if not player then return end

    local meta = player:get_meta()
    if meta:get_int("chat_grant_interact_trial") ~= 0 then
        -- Passed the trial, re-grant interact
        logger:action(string.format("Player %s passed the trial, granting interact", name))

        local privs = minetest.get_player_privs(name)
        privs.interact = true
        minetest.set_player_privs(name, privs)
        player:get_meta():set_int("chat_grant_interact_trial", 0)

        minetest.after(-1, chat_send_player_safe, name, on_pass_message)
    end
end)
