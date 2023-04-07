// Copyright Epic Games, Inc. All Rights Reserved.

#include "XYZGameGameMode.h"
#include "XYZGamePawn.h"

AXYZGameGameMode::AXYZGameGameMode()
{
	// set default pawn class to our flying pawn
	DefaultPawnClass = AXYZGamePawn::StaticClass();
}
