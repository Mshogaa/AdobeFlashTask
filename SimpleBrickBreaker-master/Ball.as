package {
	import flash.display.MovieClip;

	public class Ball extends MovieClip {

		public var vx: Number;
		public var vy: Number;

		public function Ball(velX,velY:Number) {
			this.x = 300;
			this.y = 300;
			this.vx = velX;
			this.vy = velY;
		}

	}

}