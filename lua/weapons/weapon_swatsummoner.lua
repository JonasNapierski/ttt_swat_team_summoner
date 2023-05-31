if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.PrintName       = "FBI Open Up"
	SWEP.Author			= "Ingentius (prog. by JPudel)"
	SWEP.Contact			= "develop@jpudel.de";
	SWEP.Instructions	= "Target on a flat surface"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.IconLetter		= "M"
end

	SWEP.Base = "weapon_tttbase"
	SWEP.InLoadoutFor = nil
	SWEP.AllowDrop = true
	SWEP.IsSilent = false
	SWEP.NoSights = false
	SWEP.LimitedStock = true

	SWEP.Spawnable = true
	SWEP.AdminOnly = false

	SWEP.HoldType		= "pistol"
	SWEP.ViewModel  = "models/weapons/v_pist_deagle.mdl"
	SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
	SWEP.Kind = 42
	SWEP.CanBuy = { ROLE_TRAITOR }
	SWEP.AutoSpawnable = false

	SWEP.Primary.ClipSize		= 2
	SWEP.Primary.DefaultClip	= 2
	SWEP.Primary.Automatic		= false
	SWEP.Primary.Ammo		= "none"

	SWEP.Weight					= 7
	SWEP.DrawAmmo				= true

  function SWEP:PrimaryAttack(worldsnd)
	local tr = self.Owner:GetEyeTrace()
    local tracedata = {}
    tracedata.pos = tr.HitPos + Vector(0,0,2)
    if (!SERVER) then return end
	if self:Clip1() > 0 then
		local myPosition = self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 )
		local data = EffectData()
		data:SetOrigin( myPosition )
		util.Effect("MuzzleFlash", data)
    local spawnereasd = FindRespawnLocationCustom(tracedata.pos)
    if spawnereasd == false then
		  self.Owner:PrintMessage(HUD_PRINTTALK, "Can't Place there." )
    else
      self.Owner:EmitSound("fbi.wav") 
      place_swat_npc_shotgun(tracedata)
      place_swat_npc_shotgun(tracedata)
      place_swat_npc_pistol(tracedata)
      place_swat_npc_pistol(tracedata)
      place_swat_npc_pistol(tracedata)
      place_swat_npc_leader(tracedata)
      hook.Add("PlayerSpawn", "SetNPCDisposition", function (player)
        for _, npc in ipairs(ents.FindByClass("npc_combine_s")) do
          npc.AddEntityRelationship(player, D_HT, 99)
        end
      end)
      self:TakePrimaryAmmo(1)
		end

	else
		self:EmitSound( "Weapon_AR2.Empty" )
	end
end

function FindRespawnLocationCustom(pos)
    local offsets = {}

    for i = 0, 360, 15 do
        table.insert( offsets, Vector( math.sin( i ), math.cos( i ), 0 ) )
    end

        local midsize = Vector( 44, 44, 85 )
        local tstart   = pos + Vector( 0, 0, midsize.z / 2 )

        for i = 1, #offsets do
            local o = offsets[ i ]
            local v = tstart + o * midsize * 1.5

            local t = {
                start = v,
                endpos = v,
                filter = target,
                mins = midsize / -2,
                maxs = midsize / 2
            }

            local tr = util.TraceHull( t )

            if not tr.Hit then return ( v - Vector( 0, 0, midsize.z/2 ) ) end
        end

        return false
end

-- TODO: npc_model 
function spawn_swat_npc(tracedata, npc_type, npc_weapon, npc_model)
  if ( CLIENT ) then return end

	local sommoned_npc = ents.Create( npc_type )

	if ( !IsValid( sommoned_npc)  ) then return end
    
    local spawnereasd = FindRespawnLocationCustom(tracedata.pos)
    if spawnereasd == false then
    else
		  sommoned_npc:SetPos( spawnereasd )
      sommoned_npc:AddRelationship("npc_combine_s D_NU 99")
      sommoned_npc:SetKeyValue("additionalequipment",npc_weapon)
			sommoned_npc:Spawn()
      sommoned_npc:SetNPCState(NPC_STATE_ALERT)
      sommoned_npc:Activate()
    end
	local phys = sommoned_npc:GetPhysicsObject()
	if ( !IsValid( phys ) ) then
    sommoned_npc:Remove()
    return
  end
end

function place_swat_npc_shotgun( tracedata )
  spawn_swat_npc(tracedata,"npc_combine_s","weapon_shotgun")
end

function place_swat_npc_leader( tracedata )
	if ( CLIENT ) then return end

	local sommoned_npc = ents.Create( "npc_combine_s" )

	if ( !IsValid( sommoned_npc)  ) then return end

    local spawnereasd = FindRespawnLocationCustom(tracedata.pos)
    if spawnereasd == false then
    else
		  sommoned_npc:SetPos( spawnereasd )
      sommoned_npc:AddRelationship("npc_combine_s D_NU 99")
      sommoned_npc:SetKeyValue("additionalequipment","weapon_stunstick")
      sommoned_npc:SetKeyValue("model","models/combine_super_soldier.mdl")
			sommoned_npc:Spawn()
      sommoned_npc:SetNPCState(NPC_STATE_ALERT)
      sommoned_npc:Activate()
    end
	local phys = sommoned_npc:GetPhysicsObject()
	if ( !IsValid( phys ) ) then
    sommoned_npc:Remove()
    return
  end
end

function place_swat_npc_pistol( tracedata )
	if ( CLIENT ) then return end

	local sommoned_npc = ents.Create( "npc_combine_s" )

	if ( !IsValid( sommoned_npc)  ) then return end

    local spawnereasd = FindRespawnLocationCustom(tracedata.pos)
    if spawnereasd == false then
    else
		  sommoned_npc:SetPos( spawnereasd )
      sommoned_npc:AddRelationship("npc_combine_s D_NU 99")
      sommoned_npc:SetKeyValue("additionalequipment","weapon_smg1")
			sommoned_npc:Spawn()
      sommoned_npc:SetNPCState(NPC_STATE_ALERT)
      sommoned_npc:Activate()
    end
	local phys = sommoned_npc:GetPhysicsObject()
	if ( !IsValid( phys ) ) then
    sommoned_npc:Remove()
    return
  end
end


	function SWEP:SecondaryAttack()

		self:PrimaryAttack()

	end

	function SWEP:Reload()
		return false
	end

if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "swat-icon.png"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Summons Swat Team that target everybody. Target on upside of a flat surface"
   };
end
