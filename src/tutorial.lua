-- chat_grant_interact/src/tutorial.lua
-- Register tutorial if teacher mod is present
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

if not minetest.global_exists("teacher") then return end

local S = chat_grant_interact.internal.S
-- local logger = chat_grant_interact.internal.logger:sublogger("tutorial")

chat_grant_interact.TEACHER_ENABLED = true

teacher.register_turorial("chat_grant_interact:chat_grant_interact", {
    title = S("Why can't I do anything?"),
    {
        texture = "chat_grant_interact_teacher_1.png",
        text = S("To unlock the ability to interact, you have to speak in the chatroom. " ..
                "To start chatting:") .. "\n\n" ..
            S("On Mobile Phones or iPads: Look at the top right corner of your screen. " ..
                "Tap the chat box icon.") .. "\n\n" ..
            S("On PC or Mac: Press the \"T\" key on your keyboard to open the chat box."),
    },
})
