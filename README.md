# Godot-4.0-Mirrored-Viewport-Reflections

![image](https://user-images.githubusercontent.com/45134207/226067492-52fa62c2-81c2-4733-a1d5-20b580fe9075.png)

To use in your own scene: 

1. Simply create a mirror scene with a MeshInstance3D
2. Give the MeshInstance a StandardMaterial
3. Convert the standard material to shader (this is for the texture_albedo parameter - you can also use a custom shader of course)
4. Add the mirror.gd script to the mesh instance
5. Create a viewport child underneath the mirror mesh
6. Add the mirror scene to your main scene
7. Adjust the size and resolution of your mirror using the script parameters
8. voila!

Unforunately this only works in perspective view, as it has some weird warping effects in orthographic, but I am looking to fix this.

This is essentially a port of @JFonS' mirror for godot 4.0
