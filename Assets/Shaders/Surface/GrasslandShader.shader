Shader "Custom/GrasslandShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_UVScale("Second layer scale", Range(-1,-16)) = -7
		_Desaturation("Second layer desaturation percentage", Range(0,1)) = 0.25
		_Brightness("Brightness adjustment", Range(1,2)) = 1.5

	}

		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0
			//-----------------------------------------------

			sampler2D  _MainTex;
			fixed4 _Color;
			float _UVScale;
			float _Desaturation;
			float _Brightness;

			struct Input
			{
				float2 uv_MainTex;
			};

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				fixed4 c1 = tex2D(_MainTex, IN.uv_MainTex) * _Color * _Brightness;
				fixed4 c2 = tex2D(_MainTex, IN.uv_MainTex / _UVScale) * _Color * _Brightness;
				o.Albedo = c1 * lerp(c2, Luminance(c2), _Desaturation);

			}
			ENDCG
		}
			FallBack "Diffuse"
}
