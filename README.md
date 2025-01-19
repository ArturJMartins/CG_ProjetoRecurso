# Computação Gráfica: Projeto Final Recurso

## Used Git Repo: <https://github.com/ArturJMartins/CG_ProjetoRecurso>

## Author

Artur Martins a22304625

## Goal

The goal of this project is to build something that involves computer graphics
 extensively. The project that I chose was to implement decals in Unity
 (difficulty 3).

## Description

### Decals

Decals, also known as decalcomania or transfer prints, were invented in England and flourished between the 1850s and 1970s, although they are still used today. Applied to a wide variety of materials, they were used primarily for decoration, trademarking, and advertisement on many surfaces.

Game engines and render scenes in the digital environment use many technologies
 to create a realistic image. One of them is decals. Decals is pre-made
 2D or 3D graphics that are added to the surfaces of objects, resulting in a
 more realistic image. Decals are like stickers, they allow you to apply many
 textures to a single object or a section of an object over a base texture. The
 decals can come from an image file that was imported or a texture resource that
 was included in the file.

### Techniques to make decals

- Projecting texture

A texture projected onto a surface. Decals are usually applied above a texture.

- Depth blending

It manipulates the depth information to ensure that the decal appears to conform
 closely to the geometry of the underlying object without visible gaps.

- UV mapping

Using UV coordinates, where a portion of a texture map is reserved for the decal
 image.

- Geometry clipping

Provides an alternative to depth blending. Geometry clipping involves cutting or
 trimming the decal geometry so that it conforms precisely to the surface of the
 underlying object.

- Stencil buffer

Defines a mask that restricts rendering to specific areas where the decal should
 appear.

- Deferred decal rendering

Rendering decals is a common method used to apply more detail to 3D worlds
 dynamically, applied after the main geometry is rendered.

## Implementing projective texture technique

The objective of this technique will be to project one texture onto another
 object surface based on a projection matrix.

### Projection

What is projection? Projection involves transforming the coordinates of a
 texture (or image) so it appears as if it's being cast onto the surface of a
 3D object. This transformation is achieved using a projection matrix.

There are 3 key steps to do this:

- Defining the decal's texture position and orientation in the world, like a
  "projector".
- Using a projection matrix to calculate where the decal texture lands on the
 target object's surface.
- Blending the projected texture with the target surface.

Texture projection is a technique used in computer graphics to apply textures
 onto 3D objects in a realistic and accurate manner. This process involves
 mapping a 2D texture onto a 3D surface, taking into account the object's shape,
 orientation, and position in the scene. By projecting the texture onto the
 object, it can appear as if the texture is painted directly onto the surface,
 enhancing the visual quality of the rendered image.

### Unity implementation of projective texture

First I tried to project my texture with orthographic projection, that means
 the projection will ignore the Z axis and won’t take into account how far that
 vertex is from the point of view.

![Image 1](./Images/OrthoVision.png "Orthographic camera view")

Then I tried with perspective projection, that means the projection should have
 into account the distance of every vertex with the camera. The left cube has
 the script `PerspectiveProjectionDecal` that is taking into consideration a
 perspective view and the right cube has the script `OrthographicProjectionDecal`
 that is taking into consideration a orthographic view.

![Image 2](./Images/PerspectiveVision.png "Perspective camera view")

As we can see, the orthographic projection is a type of projection where objects
 are mapped to flat. Even if the objects gets dragged far way, the size of the
 texture maintains the same with no distortion. The transformation is done using
 an orthographic matrix, which has parallel projection lines. The texture
 coordinates are calculated using a orthogonal projection matrix with the method
 `Matrix4x4.Ortho()`. On the other hand, the perspective projection takes into
 account depth, the z axis. What we see based on the camera’s perspective or the
 viewer perspective. The transformation is done using a perspective projection
 matrix. The result is that the textures that are closer to the camera appear
 larger, while those further away appear smaller, just like objects in the real
 world. The texture coordinates are calculated using a perspective projection
 matrix with the method `Matrix4x4.Perspective()`.

One of the problems of projecting texture is that there are no boundaries to
 clip the decal to a specific area. Explain more here...

## Overview of the Unity technique implementation

The goal was to project a secondary texture to look like a decal texture. The
 projection maps the texture onto a surface geometry blending it with the first
 texture. This technique is achieved through a combination of shader programming
 and matrix4x4 transformations in Unity.

- Shader implementation(Orthogonal)

This shader code handles the texture projection and the blending.

Vertex transformation:

Transforms the vertex from object space to clip space using Unity's built-in
 function, preparing it for rendering on the screen.

```shell
o.pos = Unity o.pos = UnityObjectToClipPos(v.vertex);
```

World Position Calculation:

Converts the vertex position to world space. This is necessary for the texture
 projection in the fragment shader.

```shell
o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
```

Projecting world coordinates:

The world-space position of the fragment is transformed using the projection
 matrix. The division by “w” ensures proper normalization for orthographic
 projection.

```shell
float4 projectedTexCoords = mul(_ProjectionMatrix, float4(i.worldPos, 1.0)); 
projectedTexCoords.xy /= projectedTexCoords.w;
```

Base Texture:

```shell
fixed4 baseColor = tex2D(_MainTex, i.uv);
```

Decal Texture:

```shell
fixed4 decalColor = tex2D(_DecalTex, projectedTexCoords.xy);
```

Blending:

```shell
return lerp(baseColor, decalColor, decalColor.a);
```

- Script implementation(Orthogonal)

This script complements the shader by calculating and passing the projection
 matrix.

Orthographic Projection Matrix:

Creates an orthogonal projection matrix. This matrix projects the decal texture
 onto the surface without perspective distortion.

```shell
Matrix4x4.Ortho(-size, size, -size, size, camera.nearClipPlane, camera.farClipPlane);
```

Translation Matrix:

Ensures the projection is centered at the desired world-space position
 (projectionCenter).

```shell
Matrix4x4.Translate(center);
```

Matrix Combination:

Combines the projection and translation matrices to produce the final
 transformation.

```shell
return projectionMatrix * translationMatrix;
```

- Shader implementation(Perspective)
  
Same as the Orthogonal shader. The only difference is on this line of code, will
 divide the x and y coordinates by w to account for perspective distortion. It
 ensures the texture mapping to reflect depth.

```shell
projectedTexCoords.xy /= projectedTexCoords.w;
```

- Script implementation(Perspective)

Perspective Projection Matrix:

Generates a perspective projection matrix based on the field of view (FOV),
 aspect ratio, and near/far clipping planes. This matrix simulates a frustum
 that represents the camera’s perspective.

```shell
Matrix4x4.Perspective(fov, aspect, near, far);
```

Translation Matrix:

Centers the projection at the specified world-space position (projectionCenter).

```shell
Matrix4x4.Translate(center);
```

Matrix Combination:

Combines the perspective projection matrix with the translation matrix. This
 allows the projection to originate from the desired position.

```shell
return projectionMatrix * translationMatrix;
```

## References

### Learning curses (Tamats)

- Computer Graphics 3D Projection: <https://docs.google.com/presentation/d/13crrSCPonJcxAjGaS5HJOat3MpE0lmEtqxeVr4tVLDs/edit#slide=id.i0>

### Google scholar

- Deferred Decal Rendering: <https://books.google.pt/books?hl=pt-PT&lr=&id=WNfD2u8nIlIC&oi=fnd&pg=PA271&dq=decal+shader&ots=eQmJSvoaJ_&sig=QHnwkCLjvJB26e1ki2WjkvPxmv0&redir_esc=y#v=onepage&q=decal%20shader&f=false>
- Sage Journals: <https://journals.sagepub.com/doi/abs/10.1177/155019061501100402>

### Unity Documentation

- Decal: <https://docs.unity3d.com/6000.0/Documentation/Manual/urp/renderer-feature-decal.html>

### Sites

- Lotpixel: <https://www.lotpixel.com/blog/decals-all-you-need-to-know>
- a23d: <https://www.a23d.co/blog/what-are-decals>
- Medium: <https://babylonjs.medium.com/another-take-at-decals-ef8ec19221a1>
