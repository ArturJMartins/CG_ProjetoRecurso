Shader "Custom/ProjectedTexture3"
{
    Properties
    {
        _MainTex ("Base Texture", 2D) = "white" {}
        _DecalTex ("Decal Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            sampler2D _MainTex;
            sampler2D _DecalTex;
            float4x4 _ProjectionMatrix; // Projection matrix passed from script

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // Get the world position of the vertex
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Project the world position to texture coordinates using the projection matrix
                float4 projectedTexCoords = mul(_ProjectionMatrix, float4(i.worldPos, 1.0));
                
                // Normalize texture coordinates (perspective divide)
                projectedTexCoords.xy /= projectedTexCoords.w;

                // Sample the base texture
                fixed4 baseColor = tex2D(_MainTex, i.uv);

                // Sample the decal texture using the projected coordinates
                fixed4 decalColor = tex2D(_DecalTex, projectedTexCoords.xy);

                // Blend the decal with the base texture
                return lerp(baseColor, decalColor, decalColor.a);
            }
            ENDCG
        }
    }
}
