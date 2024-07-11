Shader "CustomShader/Focus"
{
	Properties
	{
		_MainTex("RGB", 2D) = "white"{}
		_Color("Color", COLOR) = (1,1,1,1)	
	}

	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}

		Pass
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }
			ZTest Always 
			ZWrite Off 
			Cull Off


			HLSLPROGRAM

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/PostProcessing/Common.hlsl"   	

			#pragma prefer_hlslcc gles	
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag			

			float4 _MainTex_ST;
			float4 _Color;
			sampler2D _MainTex;

			float _Amount;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};


			struct v2f
			{
				float4 vertex  	: SV_POSITION;
				float2 uv : TEXCOORD0;

			};			

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv.xy;
				return o;
			}
			
			half4 frag(v2f i) : SV_Target
			{
                float2 mainTexUV = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                float4 col = tex2D(_MainTex, mainTexUV);
                float3 grayscale = (col.r + col.g + col.b) * 0.3333f;
                
               
                col.rgb = lerp(col.rgb,  grayscale, _Amount);
                
                return col;
			}
			ENDHLSL
		}

		}
}