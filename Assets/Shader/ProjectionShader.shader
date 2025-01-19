Shader "Custom/ProjectionShader"
{
    Properties
    {
        _MainTex ("Base Texture", 2D) = "white" {}
        _DecalTex ("Decal Texture", 2D) = "white" {}
        _ApplyDecal ("Apply Decal", Float) = 0.0
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
            float _ApplyDecal; // Flag to apply the decal to the whole object

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
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Base texture
                fixed4 baseColor = tex2D(_MainTex, i.uv);

                // If the decal flag is set, apply the decal to the whole object
                if (_ApplyDecal > 0.5)
                {
                    // Sample the decal texture
                    fixed4 decalColor = tex2D(_DecalTex, i.uv);

                    // Blend the decal with the base texture
                    return lerp(baseColor, decalColor, decalColor.a);
                }

                // Otherwise, return the base texture
                return baseColor;
            }
            ENDCG
        }
    }
}
