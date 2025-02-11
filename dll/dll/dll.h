/* Copyright (C) 2019 Mr Goldberg
   This file is part of the Goldberg Emulator

   The Goldberg Emulator is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.

   The Goldberg Emulator is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the Goldberg Emulator; if not, see
   <http://www.gnu.org/licenses/>.  */

#ifndef __INCLUDED_DLL_H__
#define __INCLUDED_DLL_H__

#include "steam_client.h"

#ifdef STEAMCLIENT_DLL
#define STEAMAPI_API static
#define STEAMCLIENT_API S_API_EXPORT
#else
#define STEAMAPI_API S_API_EXPORT
#define STEAMCLIENT_API static
#endif

Steam_Client *get_steam_client();
bool steamclient_has_ipv6_functions();

HSteamUser flat_hsteamuser();
HSteamPipe flat_hsteampipe();
HSteamUser flat_gs_hsteamuser();
HSteamPipe flat_gs_hsteampipe();


#endif // __INCLUDED_DLL_H__
