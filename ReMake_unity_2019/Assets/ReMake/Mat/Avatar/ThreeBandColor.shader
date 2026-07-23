Shader "Custom/ThreeBandColor"
{
    Properties
    {
        _Color1 ("Color1", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (1,1,1,1)
        _Color3 ("Color3", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing // Insert for GPU instancing

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
                float3 worldPos : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float2 uv : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float3 _Color1;
            float3 _Color2;
            float3 _Color3;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = v.uv;
                o.normal = v.normal;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);

                //float edges = pow(dot(i.localPos, i.coord) + 0.7, 16);
                

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                half edges = 1.0 - saturate(dot(normalize(viewDir), normalize(i.normal)));

                if (i.uv.x < 0.1)
                    return float4(_Color1 * edges, 0);
                else if (i.uv.x < 0.2)
                    return float4(_Color2 * edges, 0);
                else if (i.uv.x < 0.3)
                    return float4(_Color3 * edges, 0);
                else
                    return float4(float3(1,1,1) * edges, 0);
            }
            ENDCG
        }
    }
}
