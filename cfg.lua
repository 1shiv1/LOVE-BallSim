local config = {
    general = {
        particleCount = 300
    },

    window = {
        width = 800,
        height = 800,
        title = "Physics Engine Project"
    },

    physics = {
        gravity = 0.07, --0.07 default
        airFriction = 0.02,
        BroadphaseGridSize = 800,
        BroadphasePasses = 3 --how many times collision is hcecked per frame (prevents soup, as 1 pass can leave stuf finside eachother after movement)
    }
}

return config