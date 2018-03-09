-- Load our animation through modmain.
Assets = {
	Asset("ANIM", "anim/customanim.zip"),
}

-- Make all stuff below global in order to not crash.
local require = GLOBAL.require
local State = GLOBAL.State
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local ACTIONS = GLOBAL.ACTIONS
local FRAMES = GLOBAL.FRAMES

-- New stategraph state for the new animation: --
local custom_state = State{
        name = "custom_state",
        tags = { "custom_tag" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			
			inst.AnimState:PlayAnimation("customanim")
        end,

        events =
        {
			-- events like "firedamage", etc. go here. 
			-- Check out Steam/SteamApps/common/Don't Starve Together/scripts/stategraphs/SGwilson.lua to learn more.
        },

        onexit = function(inst)
			-- define what happens while we're exiting our custom state
        end,
    }

local function SGWilsonPostInit(sg)
    sg.states["custom_state"] = custom_state
end

AddStategraphState("SGwilson", custom_state)
AddStategraphPostInit("wilson", SGWilsonPostInit) 

-- "Play Animation" Action
-- Here we define what happens after we pass through our ComponentAction check (written below) and go to our stategraph state.
-- Actions happen after we execute then in stategraph with inst:PerformBufferedAction(). Check out Steam/SteamApps/common/Don't Starve Together/scripts/stategraphs/SGwilson.lua to learn more.
-- Actions are serverside, so here we can do component/variable checks.
-- To learn more, check Steam/SteamApps/common/Don't Starve Together/scripts/actions.lua
local DOCUSTOMANIM = GLOBAL.Action({ priority= 10 })	
DOCUSTOMANIM.str = "Play Animation"
DOCUSTOMANIM.id = "DOCUSTOMANIM"
DOCUSTOMANIM.fn = function(act)
    return true
end
AddAction(DOCUSTOMANIM)

-- Stategraph ActionHandler. Name is pretty self-explanatory. It handles actions, so that the stategraph can execute them.
-- Check out Steam/SteamApps/common/Don't Starve Together/scripts/stategraphs/SGwilson.lua to learn more.
local docustomanim_handler = ActionHandler(ACTIONS.DOCUSTOMANIM, "custom_state")
AddStategraphActionHandler("wilson", docustomanim_handler)
AddStategraphActionHandler("wilson_client", docustomanim_handler)

-- ComponentAction. This makes it so we get a prompt to use our action.
-- ComponentActions also exist on clients. Things like components and variables aren't networked, so don't check for these.
-- The best way is to check tags or replicable components.
-- Check Steam/SteamApps/common/Don't Starve Together/scripts/componentactions.lua to learn more.
AddComponentAction("SCENE", "health", function(inst, doer, actions, right)
    if right and inst and inst:HasTag("player") and doer and doer == inst then
        table.insert(actions, ACTIONS.DOCUSTOMANIM)
    end
end)

