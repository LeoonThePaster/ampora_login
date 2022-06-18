fx_version 'cerulean'
games { 'gta5' }
author 'Elias'
client_scripts {
    "config.lua",
    "client.lua"
}

ui_page "nui/index.html"

files {
    "nui/index.html",
    "nui/script/app.js",
    "nui/css/style.css",
    "nui/css/font/*.otf"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "config.lua",
    "server.lua"
}

lua54 'yes'