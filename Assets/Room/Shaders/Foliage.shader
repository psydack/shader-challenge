Shader "Unlit/Foliage"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CutoutTex ("Cutout Texture", 2D) = "white" {}
        [Range(0,1)]
        _Cutout ("Cutout", Float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            Cull Off
            
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
            sampler2D _CutoutTex;
            float4 _CutoutTex_ST;
            float _Cutout;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 cutout = tex2D(_CutoutTex, i.uv);
                fixed4 col = tex2D(_MainTex, i.uv);

                if (cutout.a <= _Cutout)
                {
                    discard;
                }

                return col;
            }
            ENDCG
        }
    }
}