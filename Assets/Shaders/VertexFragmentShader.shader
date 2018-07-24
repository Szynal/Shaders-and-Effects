Shader "Unlit/VertexFragmentShader"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_SecondTex("Second Texture", 2D) = "white" {}
	}

		SubShader
	{

		Tags
			{
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _SecondTex;
			float4 _SecondTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 col = tex2D(_SecondTex, TRANSFORM_TEX(tex2D(_MainTex, i.uv), _SecondTex));
				return col;
			}
			ENDCG
		}

	}
		FallBack "Diffuse"
}
