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

function MAGUS.Firebolt.OnWeaponSwing(isoGameCharacter, handWeapon)
	if not MAGUS.Firebolt.castable then return end

	
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