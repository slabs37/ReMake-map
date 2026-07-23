Shader "Custom/SaberGlow"
{
    Properties
    {
        /*
        These are fed in by Vivify per saber.
        In fact, Vivify will attempt to feed these values into every child of a saber prefab.
        */
        _Color ("Saber Color", Color) = (1,1,1)
        _ColorAdd ("Color Add", Color) = (0,0,0)
        _Glow ("Glow opacity", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags {"RenderType"="Opaque" "Queue"="Transparent"}
        ColorMask RGBA
        ZWrite Off
        ZTest On
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing // Insert for GPU instancing
            // Ensure to check "Enable GPU Instancing" on the material

            #include "UnityCG.cginc"

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
                float3 normal : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID // Insert for GPU instancing
                UNITY_VERTEX_OUTPUT_STEREO
            };

            // Register GPU instanced properties (apply per-saber)
            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float3, _Color)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // Insert for GPU instancing
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float _Glow;
            float3 _ColorAdd;

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i); // Insert for GPU instancing

                float3 Color = UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
                return float4(Color.rgb + _ColorAdd.rgb, _Glow);
            }
            ENDCG
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On ZTest LEqual
            // add all fragment modifications here with the final v2f output being SHADOW_CASTER_FRAGMENT(i)
        }
    }
}
