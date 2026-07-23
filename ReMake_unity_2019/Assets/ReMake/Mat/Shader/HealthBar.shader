Shader "Custom/HealthBar" {

	Properties {
		_Color ("Color", Color) = (0.2,0.2,0.2,0.2)
		_MainTex ("Main Tex (RGBA)", 2D) = "white" {}
		_Health ("Health", Range(0.0,1.0)) = 0.0
	}
	
	SubShader {
		Tags  {"RenderType"="Opaque"}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _Color;
			uniform float _Health;

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f vert (appdata v) {
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv = v.uv;
				
				return o;
			}
			
			float4 frag( v2f i ) : SV_TARGET {
				float4 tex = tex2D( _MainTex, i.uv);
				tex *= i.uv.x < _Health;
				clip(tex);
				return float4(tex*_Color);
			}
			
			ENDCG
			
		}
	}
	
}