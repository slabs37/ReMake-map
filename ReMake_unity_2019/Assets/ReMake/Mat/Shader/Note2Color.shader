Shader "Custom/2Color"
{
    Properties
    {
        /*
        These are fed in by Vivify per saber.
        In fact, Vivify will attempt to feed these values into every child of a saber prefab.
        */
        [Toggle(REV)] _Rev ("Reverse", Int) = 0
        _Color ("Saber Color", Color) = (1,1,1)
        _Cutout ("Cutout", Range(0,1)) = 1
        _CutoutEdgeWidth("Cutout Edge Width", Range(0,0.1)) = 0.02
        _ColorMod ("Modify Color", Color) = (1,1,1)
        _RimPower ("Rim Power", float) = 1
        _Glow ("Glow opacity", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        ColorMask RGBA
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing // Insert for GPU instancing
            // Ensure to check "Enable GPU Instancing" on the material
            #pragma shader_feature REV

            #include "UnityCG.cginc"
            #include "Assets/VivifyTemplate/Utilities/Shader Functions/Noise.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 localPos : TEXCOORD2;
                float3 normal : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID // Insert for GPU instancing
                UNITY_VERTEX_OUTPUT_STEREO
            };

            // Register GPU instanced properties (apply per-saber)
            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float3, _Color)
            UNITY_DEFINE_INSTANCED_PROP(float, _Cutout)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // Insert for GPU instancing
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.uv = v.uv;
                o.localPos = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            
            float3 _ColorMod;
            float _RimPower;
            float _Glow;
            float _CutoutEdgeWidth;

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // Insert for GPU instancing

                float Cutout = UNITY_ACCESS_INSTANCED_PROP(Props, _Cutout);
                // The color of the note
                float3 Color = UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
                // This "c" value will quantify the note's visibility, where negatives are invisible
                float c = 0;
                // Calculate 3D simplex noise based on the fragment position
                float noise = simplex(i.localPos * 2);
                // Use cutout to lower the values of the noise into the negatives, clipping them
                c = noise - Cutout;
                // Negative values of c will discard the pixel
                clip(c);
                // Positive values of c close to zero will return a border color (white)
                if (c < _CutoutEdgeWidth) {
                    return 1;
                }

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                half rim = 1.0 - saturate(dot(normalize(viewDir), normalize(i.normal)));
                float3 finalColor = lerp(0, Color.rgb, pow(rim, 0.1));
                finalColor = finalColor - _ColorMod;
                #if REV
                    finalColor = pow(finalColor.bgr, _RimPower);
                #else
                    finalColor = pow(finalColor, _RimPower);
                #endif
                return float4(finalColor * 2, _Glow);
            }
            ENDCG
        }
    }
}
