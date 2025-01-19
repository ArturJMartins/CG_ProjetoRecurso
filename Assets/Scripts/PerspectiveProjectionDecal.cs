using UnityEngine;

public class PerspectiveProjectionDecal : MonoBehaviour
{
    public Material material; // Reference to the material with the shader
    public Camera projectionCamera; // Camera to simulate the projection
    public Vector3 projectionCenter = Vector3.zero; // The point from where the projection occurs
    public float projectionFov = 60f; // Field of view for the perspective projection
    public float projectionAspect = 1.0f; // Aspect ratio for the projection
    public float projectionNear = 0.1f; // Near clipping plane
    public float projectionFar = 1000f; // Far clipping plane

    private void Update()
    {
        // Check if the mouse button is pressed
        if (Input.GetMouseButtonDown(0)) // Left mouse button
        {
            // Calculate the projection matrix from the camera
            Matrix4x4 projectionMatrix = CalculatePerspectiveProjectionMatrix(projectionFov, projectionAspect, projectionNear, projectionFar, projectionCenter);

            // Set the projection matrix in the shader
            material.SetMatrix("_ProjectionMatrix", projectionMatrix);
        }
    }

    // Function to calculate the perspective projection matrix
    Matrix4x4 CalculatePerspectiveProjectionMatrix(float fov, float aspect, float near, float far, Vector3 center)
    {
        // Perspective projection matrix (field of view, aspect ratio, near and far planes)
        Matrix4x4 projectionMatrix = Matrix4x4.Perspective(fov, aspect, near, far);

        // We need to translate the matrix so that the projection originates from the desired point
        Matrix4x4 translationMatrix = Matrix4x4.Translate(center);

        // Combine the translation and projection matrices
        return projectionMatrix * translationMatrix;
    }
}
