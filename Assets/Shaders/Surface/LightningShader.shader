Shader "Custom/LightingShader"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_SecondTex("Second (RGB)", 2D) = "white" {}
	}

		SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		LOD 200

		CGPROGRAM
		#pragma surface surf Standard alpha:blend
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _SecondTex;
		float4 _SecondTex_ST;

		struct Input
		{
			float2 uv_MainTex;
		};

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandard o) {

			fixed4 c = tex2D(_SecondTex, TRANSFORM_TEX(tex2D(_MainTex, IN.uv_MainTex), _SecondTex));
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
