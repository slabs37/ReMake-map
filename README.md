# What is this?
These are the source files for a Beat Saber custom map made using the Vivify mod.

- [Gameplay Video](https://www.youtube.com/watch?v=zpUYzbnTnbY)
- [Map Download](https://beatsaver.com/maps/5301c)
- [Song](https://www.youtube.com/watch?v=67m9E6uDgxs)

# Why is it uploaded
So that others can learn from this map and hopefully fix something or improve in their own Vivify maps.

This map contains assets from the games Beat Saber and Smash Drums which are slightly modified.

# How to build
Open the project in Unity and build the bundles via [Vivify Template](https://github.com/Swifter1243/VivifyTemplate) -> Build Configuration Window

You need to run [Remapper](https://github.com/Swifter1243/ReMapper/wiki/Installing-ReMapper) twice, once with line 305 of src/main.ts set to 'true' and once with 'false'.

That will create two outputs in the parent directory.

You then need to copy Scripts/DiffSeparator.py to the parent directory, and then run it.

That will create a folder ReMade with the final level.

# How are the characters animated?
Thanks to [py-bsor](https://github.com/Schippi/py-bsor) i had the replay files turned to jsons, i then had the idea to use the data to write to Unity's animation yaml.

My prefab had objects with the names "head" "left_hand" "right_hand" which got animated when the .anim file was copied into Unity.

There probably is a more proper way of doing this within Unity itself, but this method worked.

There was quite a bit of pain getting unity to directly accept quaternions and not convert them to eulers upon import.
