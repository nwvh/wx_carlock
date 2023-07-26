fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'wx / woox'
description 'Simple car-locking script for ESX'

version '1.0.0'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

shared_scripts {'@ox_lib/init.lua','configs/*.lua'}
