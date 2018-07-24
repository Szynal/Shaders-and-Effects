Shader "Unlit/StainedGlass"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BumpAmt("Distortion", range(0,128)) = 10
		_BumpMap("Normalmap", 2D) = "bump" {}

	}
		SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }

		LOD 100
		GrabPass
		{
			Name "BASE"
			Tags{ "LightMode" = "Always" }
		}

		Pass
		{
			Tags{ "LightMode" = "Always" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
				float2 uvmain : TEXCOORD2;
			};

			float _BumpAmt;
			float4 _BumpMap_ST;
			float4 _MainTex_ST;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _BumpMap;
			sampler2D _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif
					o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
					o.uvgrab.zw = o.vertex.zw;
					o.uvbump = TRANSFORM_TEX(v.vertex, _BumpMap);
					o.uvmain = TRANSFORM_TEX(v.vertex, _MainTex);
					UNITY_TRANSFER_FOG(o, o.vertex);
					return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg; // we could optimize this by just reading the x & y without reconstructing the Z
				float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
				i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

				half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				half4 tint = tex2D(_MainTex, i.uvmain);
				col *= tint;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
