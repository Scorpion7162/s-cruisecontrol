fx_version 'cerulean'
author 'Scorpion'
description 'Cruise Control script, uses ox_lib notifications.'
version '1.0.0'
game 'gta5'


client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}
