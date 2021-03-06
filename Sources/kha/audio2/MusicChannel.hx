package kha.audio2;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import kha.audio2.ogg.vorbis.Reader;

class MusicChannel {
	private var reader: Reader;
	private var atend: Bool = false;
	private var loop: Bool;
	private var myVolume: Float;
	private var paused: Bool = false;
	
	public function new(data: Bytes, loop: Bool) {
		myVolume = 1;
		this.loop = loop;
		reader = Reader.openFromBytes(data);
	}

	public function nextSamples(samples: Vector<Float>): Void {
		if (paused) {
			for (i in 0...samples.length) {
				samples[i] = 0;
			}
			return;
		}
		
		var count = reader.read(samples, Std.int(samples.length / 2), 2, 44100, true) * 2;
		if (count < samples.length) {
			if (loop) {
				reader.currentMillisecond = 0;
			}
			else {
				atend = true;
			}
			for (i in count...samples.length) {
				samples[i] = 0;
			}
		}
	}
	
	public function play(): Void {
		paused = false;
	}

	public function pause(): Void {
		paused = true;
	}

	public function stop(): Void {
		atend = true;
	}

	public var length(get, null): Int; // Miliseconds
	
	private function get_length(): Int {
		return Std.int(reader.totalMillisecond);
	}

	public var position(get, null): Int; // Miliseconds
	
	private function get_position(): Int {
		return Std.int(reader.currentMillisecond);
	}
	
	public var volume(get, set): Float;
	
	private function get_volume(): Float {
		return myVolume;
	}

	private function set_volume(value: Float): Float {
		return myVolume = value;
	}

	public var finished(get, null): Bool;

	private function get_finished(): Bool {
		return atend;
	}
}
