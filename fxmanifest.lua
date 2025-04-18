fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'phil mcracken'
description 'electric chair'
version '1.0.0'

client_scripts {
    'client.lua',
	'@ox_lib/init.lua'
    
}

server_scripts {
    'server.lua'
    
}

dependencies {
    'rsg-core',
    'ox_lib'
}

lua54 'yes'