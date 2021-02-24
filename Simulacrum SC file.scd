// Production Note: This file uses simple algorithms to create a randomized polyphonic piece of music centered around one mode, C Phrygian Dominant, with an added percussion element. Using .choose.midicps, I define an array of pitches that the algorithm chooses randomly for each individual pitch decision. This choice is sent back to the chosen SynthDef, and is repeated via .do loops for a specified number of repetitions per rhythmic subdivison. While the scale is the same for each pitch element, I varied the range for the bass, chords and melody elements from low to high (respectively) to provide clearer separation. The entire piece revolves around a global tempo variable. The base tempo is 57 bpm, but can be changed easily via a global variable adjustment. The percussion element randomly chooses between a 16th note triplet and 32nd note triplet subdivision throughout. The chords play a random 4-note combination once per bar. The bass and melody follow varying rhythmic patterns, defined by the chosen subdivision of the beat and the number of repetitions of the .do loop. The percussion element is a simple white noise filtered by a low pass filter. The cutoff of the LPF is randomly chosen between a specified range for each percussion hit. In addition to the other randomized elements, the pan position is also randomized between a given L/R range for every element with the exception of the final loop .do loop of the bass Routine, which is centered for effect. Follow the instructions below to run the program. //

// Step 1: Make sure to boot your server via Command-B or Server-->Boot Server. //
// Step 2: Individually highlight and Evaluate (Command-Enter) each of the SynthDef's below to add them to the library. You must evaluate them individually or you will get an error. Scroll down for additional steps. //

SynthDef("Sine",
	{
	arg frequency, noteDuration, panpos, amp;
	var sound, envelope, amplitude, mix, panmix;
	sound = SinOsc.ar(frequency);
	envelope = XLine.ar(1, 0.000001, noteDuration, doneAction:2);
	amplitude = 0.1;
	mix = sound*envelope*amplitude;
	panmix = Pan2.ar(mix,panpos);
	Out.ar(0,panmix);
	}
).add

SynthDef("Saw",
	{
	arg frequency, noteDuration, panpos, amp;
	var sound, envelope, amplitude, mix, panmix, filter;
	sound = Saw.ar(frequency);
	envelope = XLine.ar(1, 0.000001, noteDuration, doneAction:2);
	amplitude = amp;
	mix = sound*envelope*amplitude;
	filter = LPF.ar(mix, 600);
	panmix = Pan2.ar(filter, panpos);
	Out.ar(0,panmix);
	}
).add

SynthDef("Perc",
	{
	arg cutoff, panpos, amp, dur;
	var wave, pan, env, mix, filter;
	wave = WhiteNoise.ar;
	env = XLine.ar(amp,0.000001,dur,doneAction:2);
	mix = wave*env;
	filter = LPF.ar(mix, cutoff);
	pan = Pan2.ar(filter,panpos);
	Out.ar(0,pan);
	}
).add;

// Step 3: After Evaluating the SynthDef's, highlight all of the global variables (delineated with a preceding ~) below at once and Evaluate them using Command-Enter. //

~bpm=57;
~beat=60/~bpm;
~bar=~beat*4;
~bassDur=1.5;
~meloDur=0.7;

// Step 4: Highlight all of the following Routines (lines 57 through 149) and Evaluate them using Command-Enter to assign them to the corresponding global variable. Be sure to highlight every character. //


~perc=Routine({
	loop{
		Synth("Perc", [\cutoff, rrand(700,7500),\panpos, rrand(-1.0,1.0),\amp, rrand(0.2,0.5),\dur,rrand(0.1,0.38)]);
		[~beat/6,~beat/12].choose.wait;
	};
});

~bass=Routine({
	8.do{
		12.do{
		var scale;
		scale = [36,37,40,41,43,44,46,48,49,52].choose.midicps;
		Synth("Saw",[\frequency,scale,\noteDuration,~bassDur,\amp,rrand(0.3,0.4),\panpos,rrand(-0.8,0.8)]);
		(~beat/3).wait;
		};
	};
	8.do{
		16.do{
		var scale;
		scale = [36,37,40,41,43,44,46,48,49,52].choose.midicps;
		Synth("Saw",[\frequency,scale,\noteDuration,~bassDur,\amp,rrand(0.3,0.4),\panpos,rrand(-0.8,0.8)]);
		(~beat/4).wait;
		};
	};
	8.do{
		24.do{
		var scale;
		scale = [36,37,40,41,43,44,46,48,49,52].choose.midicps;
		Synth("Saw",[\frequency,scale,\noteDuration,~bassDur,\amp,rrand(0.3,0.4),\panpos,rrand(-0.8,0.8)]);
		(~beat/6).wait;
		};
	};
	20.do{
		1.do{
		var scale;
		scale = [36,37,40,41,43,44,46,48,49,52].choose.midicps;
		Synth("Saw",[\frequency,scale,\noteDuration,6,\amp,rrand(0.3,0.4)]);
		(~beat).wait;
		};
	};
});

~melodyTrip=Routine({
	23.do{
		6.do{
		var scale;
		scale = [73,76,77,79,80,82,84,85,88,89,91,92,94,96].choose.midicps;
		Synth("Sine",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.15,0.23)]);
		Synth("Saw",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.45,0.6)]);
		(~beat/6).wait;
		};
		8.do{
		var scale;
		scale = [73,76,77,79,80,82,84,85,88,89,91,92,94,96].choose.midicps;
		Synth("Sine",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.15,0.23)]);
		Synth("Saw",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.45,0.6)]);
		(~beat/8).wait;
		};
		6.do{
		var scale;
		scale = [73,76,77,79,80,82,84,85,88,89,91,92,94,96].choose.midicps;
		Synth("Sine",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.15,0.23)]);
		Synth("Saw",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.45,0.6)]);
		(~beat/12).wait;
		};
		1.do{
		var scale;
		scale = [73,76,77,79,80,82,84,85,88,89,91,92,94,96].choose.midicps;
		Synth("Sine",[\frequency,scale,\noteDuration,7,\panpos,rrand(-0.85,0.85),\amp,rrand(0.4,0.43)]);
		Synth("Saw",[\frequency,scale,\noteDuration,7,\panpos,rrand(-0.85,0.85),\amp,rrand(0.55,0.6)]);
		(~beat/2).wait;
		};
		24.do{
		var scale;
		scale = [73,76,77,79,80,82,84,85,88,89,91,92,94,96].choose.midicps;
		Synth("Sine",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.15,0.23)]);
		Synth("Saw",[\frequency,scale,\noteDuration,~meloDur,\panpos,rrand(-0.85,0.85),\amp,rrand(0.45,0.6)]);
		(~beat/12).wait;
		};
	};
});

~chords=Routine({
	24.do{
		4.do{
			var scale;
			scale = [60,61,64,65,67,68,70,72,73,76,77,79].choose.midicps;
			Synth("Sine",[\frequency,scale,\noteDuration,12,\panpos,rrand(-0.85,0.85),\amp,rrand(0.1,0.17)]);
			Synth("Saw",[\frequency,scale,\noteDuration,12,\panpos,rrand(-0.85,0.85),\amp,rrand(0.2,0.24)]);
		};
		(~bar).wait;
	};
});

// Step 5: Lastly, click anywhere within line 153 and hit Command-Enter to call the Routines and start the piece. If you want to stop and restart, do the same for line 154 and start again. At 57 bpm, the piece goes for approximately 2 minutes. Note: you must manually stop the piece at the very end by evaluating line 154 or hitting Command-period, as the percussion element is on an infinite loop. //

~chords.reset;~chords.play; ~bass.reset;~bass.play; ~melodyTrip.reset;~melodyTrip.play; ~perc.reset;~perc.play;
~chords.stop; ~bass.stop; ~melodyTrip.stop; ~perc.stop;
