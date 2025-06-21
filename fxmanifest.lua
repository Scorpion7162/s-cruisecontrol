fx_version 'cerulean'
author 'Scorpion'
description 'Cruise Control script, uses ox_lib notifications.'
version '1.0.2'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'


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
