Config = {}

Config.Locale = 'en'
Config.Command = 'placeobj'
Config.CancelArg = 'cancel' -- /placeobj cancel

Config.Objects = {
    ['prop_mp_cone_02'] = {prop = 'cone', jobs = {'police'}},
    ['prop_mp_barrier_02b'] = {prop = 'barrier', jobs = {'police', 'ambulance'}}
}

Config.Locales = {
    ['es'] = {
        Delete = 'Eliminar Objeto',
        NotAllowed = 'No tienes permiso para poner este objeto.',
        AlreadyPlaceObj = 'Ya estás ~g~colocando~w~ un ~b~objeto~w~ puedes parar poniendo ~r~/'..Config.Command..' '..Config.CancelArg
    },
    ['en'] = {
        Delete = 'Delete Object',
        NotAllowed = 'You do not have permission to place this object',
        AlreadyPlaceObj = 'You are already placing an object you can stop by placing /'..Config.Command..' '..Config.CancelArg
    }
}