// taken from https://www.shadertoy.com/view/MlVGDK
float hash2( float n ) { return frac(sin(n)*753.5453123); }

float perlin( in float3 x )
{
    float3 p = floor(x);
    float3 f = frac(x);
    f = f*f*(3.0-2.0*f);
	
    float n = p.x + p.y*157.0 + 113.0*p.z;
    return lerp(lerp(lerp( hash2(n+  0.0), hash2(n+  1.0),f.x),
                   lerp( hash2(n+157.0), hash2(n+158.0),f.x),f.y),
               lerp(lerp( hash2(n+113.0), hash2(n+114.0),f.x),
                   lerp( hash2(n+270.0), hash2(n+271.0),f.x),f.y),f.z);
}