if not MAGUS then MAGUS = {} end
if not MAGUS.Firebolt then MAGUS.Firebolt = {} end
if not MAGUS.Firebolt.ValidJewelleryList then
	MAGUS.Firebolt.ValidJewelleryList = {
		"MAGE.Ring_Left_MiddleFinger_SilverSapphire",
		"MAGE.Ring_Left_RingFinger_SilverSapphire",
		"MAGE.Ring_Right_MiddleFinger_SilverSapphire",
		"MAGE.Ring_Right_RingFinger_SilverSapphire",
	}
end

MAGUS.Firebolt.Setup = function()
	MAGUS.Firebolt.castable = false
	MAGUS.Firebolt.projectiles = {}
	MAGUS.Firebolt.projectileSpeed = 1
end

function MAGUS.Firebolt.AnyOfUsingWornItem(testTargetWornItem, listOfValidEntry)
	return MAGUS.Firebolt.AnyOfUsingInventoryItem(testTargetWornItem:getItem(), listOfValidEntry)
end
function MAGUS.Firebolt.AnyOfUsingInventoryItem(testTargetInventoryItem, listOfValidEntry)
	return MAGUS.Firebolt.AnyOfUsingName(testTargetInventoryItem:getFullType(), listOfValidEntry)
end
function MAGUS.Firebolt.AnyOfUsingName(testTargetFullType, listOfValidEntry)
	for _, fullType in ipairs(listOfValidEntry) do
		if(testTargetFullType == fullType) then return true end
	end
	return false;
end

function MAGUS.Firebolt.GetMousePosAdjustGrid(isoPlayer)
	local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), 0)
	local targetX = mx + 1.5
	local targetY = my + 1.5
	local targetZ = 0
	local playerZ = isoPlayer:getZ()
	if playerZ > 0 then
		for i = playerZ, 1, -1 do
			targetX = mx + 1.5 + i
			targetY = my + 1.5 + i
			targetZ = i
			break
		end
	end
	return targetX, targetY, targetZ
end

function MAGUS.Firebolt.EncapsulateAsVector(x, y, z) return {x=x, y=y, z=z} end

function MAGUS.Firebolt.GetDirVector(fromVector, toVector)
	return {
		x = toVector.x - fromVector.x,
		y = toVector.y - fromVector.y,
		z = toVector.z - fromVector.z
	}
end

function MAGUS.Firebolt.NormalizeVector(v)
	local d = v.x + v.y + v.z
	return {
		x = v.x/d,
		y = v.y/d,
		z = v.z/d
	}
end

function MAGUS.Firebolt.GetAllGridSquareInRay()
	--https://stackoverflow.com/questions/35807686/find-cells-in-array-that-are-crossed-by-a-given-line-segment
end

function MAGUS.Firebolt.OnPlayerUpdate()
	for _, projectile in ipairs(MAGUS.Firebolt.projectiles) do
		--if projectile hits anything, stop and do appropriate damaging to that object
		----on each frame, check any object in a range of 3x3 tiles with a center point of this projectile.
		----if any of zombie is in range, stop loop and give damage. possibly torch it up as well.
		----if any tree or wall exists in range, stop loop and burn it.

		--if not, move projectile following its heading direction.
		----projectile should stay where it is until it fully goes over to next tile.

		--if it flew enough, yet didnt strike anything, burn a current gridsqaure the projectile is on.
		projectile.tick = projectile.tick + 1
	end
end

function MAGUS.Firebolt.OnWeaponSwing(isoGameCharacter, handWeapon)
	if not MAGUS.Firebolt.castable then return end

	local fromPos = MAGUS.Firebolt.EncapsulateAsVector(isoGameCharacter:getX(), isoGameCharacter:getY(), isoGameCharacter:getZ())
	local toPos = MAGUS.Firebolt.EncapsulateAsVector(MAGUS.Firebolt.GetMousePosAdjustGrid(isoGameCharacter))
	local dir = MAGUS.Firebolt.NormalizeVector(MAGUS.Firebolt.GetDirVector(fromPos, toPos))

	table.insert(MAGUS.Firebolt.projectiles, {
		caster = isoGameCharacter,
		tick = 1,
		originPos = fromPos,
		currentPos = fromPos,
		towardsDir = dir,
		nearestStaticCollidable = nil,
		projectileFacing = isoGameCharacter:getDir():toAngle()
	})
end

function MAGUS.Firebolt.OnClothingUpdated(isoGameCharacter)
	local wornItems = isoGameCharacter:getWornItems()
	local passcheck = false
	for i = 0, wornItems:size() do
		if MAGUS.Firebolt.AnyOfUsingWornItem(wornItems:get(i), MAGUS.Firebolt.ValidJewelleryList) == true then
			passcheck = true
		end
	end
	MAGUS.Firebolt.castable = passcheck
end

Events.OnLoad.Add(MAGUS.Firebolt.Setup);
Events.OnWeaponSwing.Add(MAGUS.Firebolt.OnWeaponSwing);
Events.OnPlayerUpdate.Add(MAGUS.Firebolt.);