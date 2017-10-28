(
SynthDef("meditation", { arg gate=1, freq=432, vol=0.01;
    var env, n=64;
    env = Env(
                [0]++{1.0.rand.squared}.dup(n-1) ++ [0],
                {rrand(1.5,3.0)}.dup(n),
                \lin, n-8, 8 );
	Out.ar(0, Pan2.ar(EnvGen.kr(env, gate, doneAction: 2) * LFTri.ar(freq,0,vol)),-0.1)
}).add;
)

(
SynthDef("ping-pong", { arg out=0, freq=1200, dens=4, vol=0.5;
	var trig = Dust.kr(2);
    Out.ar(out,
		Pan2.ar(BLowPass4.ar(Dust.ar(dens, vol), freq, 0.5, 0.5),TRand.kr(-1.0, 1.0, trig))
    )
}).add;
)

(
SynthDef.new("beach", { arg gate=1, noiserate=15, mintime=0.005, maxtime=0.4, lcut=100, pan=0.3, vol=0.75;
    var env, n=64;
    env = Env(
                [0]++{1.0.rand.squared}.dup(n-1) ++ [0],
                {rrand(mintime,maxtime)}.dup(n),
                \lin, n-8, 8 );
	Out.ar(0, Pan2.ar(BLowPass4.ar(EnvGen.kr(env, gate, doneAction: 2) * LFNoise1.ar(noiserate, vol),lcut,0.1,0.5),pan))
}).add;
)

(
SynthDef.new("wind", { arg gate=1, freq=800, mintime=0.1, maxtime=0.8;
    var env, n=64;
    env = Env(
                [0]++{1.0.rand.squared}.dup(n-1) ++ [0],
                {rrand(mintime,maxtime)}.dup(n),
                \lin, n-8, 8 );
	Out.ar(0, Pan2.ar(BLowPass4.ar(EnvGen.kr(env, gate, doneAction: 2) * PinkNoise.ar(0.05),(EnvGen.kr(env, gate, doneAction: 2)*200)+freq,0.1,0.5),(EnvGen.kr(env, gate, doneAction: 2)*2.0)-1.0))
}).add;
)


// intro
g = Synth.new("wind", ["freq", 100, "mintime", 0.5, "maxtime", 1.8]);
f = Synth.new("wind", ["freq", 200]);
g.release;
f.release;


// part ones
x = Synth.new("beach");
y = Synth.new("beach", ["noiserate", 5, "mintime", 0.05, "maxtime", 0.6, "lcut", 400, "pan", -0.5]);
z = Synth.new("beach", ["noiserate", 30, "maxtime", 0.6, "lcut", 1400, "pan", 0.5, "vol", 0.7]);
a = Synth.new("beach", ["noiserate", 15, "maxtime", 0.6, "lcut", 3400, "pan", 0.75, "vol", 0.6]);
x.release;
y.release;
z.release;
a.release;

b = Synth.new("beach", ["noiserate", 500, "mintime", 0.05, "maxtime", 0.6, "vol", 0.1]);
k = Synth.new("beach", ["noiserate", 1000, "mintime", 0.5, "maxtime", 1.6, "vol", 0.1]);
l = Synth.new("beach", ["noiserate", 4000, "mintime", 0.05, "maxtime", 0.4, "vol", 0.1]);
b.release;
k.release;
l.release;

p = Synth.new("ping-pong", ["dens", 100, "freq", 4000, "vol", 0.25]);
q = Synth.new("ping-pong", ["dens", 40, "freq", 1000, "vol", 0.2]);
r = Synth.new("ping-pong", ["dens", 20, "freq", 8000, "vol", 0.05]);
s = Synth.new("ping-pong", ["dens", 40, "freq", 16000, "vol", 0.03]);
p.free;
q.free;
r.free;
s.free;

h = Synth.new("meditation", ["freq", 440, "pan", 0.3]);
i = Synth.new("meditation");
j = Synth.new("meditation", ["freq", 600, "vol", 0.005, "pan", -0.3]);
h.release;
i.release;
j.release;


(
{
    var p, a, b;
    p = Impulse.ar(8);
    a = SinOsc.ar(90, 0, Decay2.ar(p, 0.005, 0.1));
    b = SinOsc.ar(120,  0, Decay2.ar(PulseDivider.ar(p, MouseX.kr(1,8).round(1)), 0.005, 0.5));

    [a, b] * 0.05
}.play;
)
