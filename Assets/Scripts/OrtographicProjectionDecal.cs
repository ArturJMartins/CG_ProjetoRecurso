using UnityEngine;

public class OrtographicProjectionDecal : MonoBehaviour
{
    public Material material; // Reference to the material with the shader
    public Camera projectionCamera; // Camera to simulate the projection
    public Vector3 projectionCenter = Vector3.zero; // The point from where the projection occurs
    public float projectionSize = 1f; // Size of the projected texture area

    private void Update()
    {
        // Check if the mouse button is pressed
        if (Input.GetMouseButtonDown(0)) // Left mouse button
        {
            // Calculate the projection matrix from the camera
            Matrix4x4 projectionMatrix = CalculateProjectionMatrix(projectionCamera, projectionCenter, projectionSize);

            // Set the projection matrix in the shader
            material.SetMatrix("_ProjectionMatrix", projectionMatrix);
        }
    }

    // Function to calculate the orthogonal projection matrix
    Matrix4x4 CalculateProjectionMatrix(Camera camera, Vector3 center, float size)
    {
        // Set up the orthogonal projection matrix
        Matrix4x4 projectionMatrix = Matrix4x4.Ortho(
            -size, size,       // left, right
            -size, size,       // bottom, top
            camera.nearClipPlane, camera.farClipPlane // near, far plane
        );

        // We need to translate the matrix so that the projection originates from the desired point
        Matrix4x4 translationMatrix = Matrix4x4.Translate(center);

        // Combine the translation and projection matrices
        return projectionMatrix * translationMatrix;
    }
}
