package kha.android;

import android.media.SoundPool;
import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;

class Sound extends kha.Sound {
	static var pool : SoundPool = new SoundPool(4, AudioManager.STREAM_MUSIC, 0);
	var soundid : Int;
	
	public function new(file : AssetFileDescriptor) {
		super();
		soundid = pool.load(file, 1);
	}
	
	override public function play(): SoundChannel {
		pool.play(soundid, 1, 1, 1, 0, 1);
		return null;
	}

	//override public function stop() : Void {
	//	pool.stop(soundid);
	//}
}