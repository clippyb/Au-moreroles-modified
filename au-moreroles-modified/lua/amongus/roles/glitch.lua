roles.CreateTeam(ROLE.name, {
  id = TEAM_GLITCH,
  color = Color(0, 255, 21)
})

ROLE.id = ROLE_GLITCH
ROLE.desc = "Kill everyone to win."
ROLE.color = Color(0, 255, 21)
ROLE.defaultTeam = TEAM_GLITCH
ROLE.CanKill = true
ROLE.HasTasks = false
ROLE.CanVent = true

ROLE.defaultCVarData = {
  pct = 0.17,
  max = 1,
  minPlayers = 4,
  random = 50
}


-- Define a function to check if the Glitch team is alive
local function IsGlitchTeamAlive()
  return team.NumPlayers(TEAM_GLITCH) > 0 and (not GAMEMODE.RoundSettings.GlitchWinsWithCrewmates or team.NumPlayers(TEAM_CREWMATE) == 0)
end

-- Override the CheckForWin function to include the Glitch role
function GAMEMODE:CheckForWin()
  if self.gameover then return end

  local aliveCrewmates = team.NumPlayers(TEAM_CREWMATE) > 0
  local aliveImposters = team.NumPlayers(TEAM_IMPOSTER) > 0
  local aliveGlitch = team.NumPlayers(TEAM_GLITCH) > 0

  -- If there are no more crewmates alive, Imposters win
  if not aliveCrewmates then
    GAMEMODE:EndGame( WIN_IMPOSTOR, "The crew has been eliminated." )
    return
  end

  -- If there are no more imposters alive, Crew wins
  if not aliveImposters then
    GAMEMODE:EndGame( WIN_CREW, "All imposters have been eliminated." )
    return
  end

  -- If there are more alive Glitch players than Crewmates, Glitch wins
  if aliveGlitch and team.NumPlayers(TEAM_CREWMATE) < team.NumPlayers(TEAM_GLITCH) then
    GAMEMODE:EndGame( WIN_GLITCH, "The Glitches have taken over." )
    return
  end

  -- If there is only one Crewmate and one Glitch alive, and there are no more Imposters alive, the game should not end
  if aliveCrewmates == 1 and aliveGlitch == 1 and aliveImposters == 0 then
    return
  end

  -- If there is only one Crewmate and one Imposter alive, and there are no more Crewmates alive, the game should not end
  if aliveCrewmates == 0 and aliveGlitch == 1 and aliveImposters >= 1 then
    return
  end

  -- Otherwise, the game continues
end