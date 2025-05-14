package {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;

	public class BrickBreaker extends MovieClip {

		public const BALL_RADIUS: Number = 20;
		public const TOPBORDER: Number = BALL_RADIUS;
		public const LEFTBORDER: Number = BALL_RADIUS;
		public const RIGHTBORDER: Number = 600 - BALL_RADIUS;
		public const BOTTOMBORDER: Number = 600 - BALL_RADIUS;
		public const REVERSE: Number = -1;

		public var ball: Ball;
		public var paddle: Paddle;
		public var brick: Brick;
		public var lastTimeStamp: int;
		public var brickArray: Array;

		public var posX: Number = 75;
		public var posY: Number = 40;

		public function BrickBreaker() {
			//TASK 1: POSITION START LABEL
			startLabel.x = 300;
			startLabel.y = 300;

			//TASK 2: REGISTER EVENT LISTNENER FOR STAGE CLICK
			stage.addEventListener(MouseEvent.CLICK, start);
		}

		//EVENT HANDLER FOR STAGE CLICK
		public function start(event: Event) {
			brickArray = new Array();
			//TASK 1: MOVE THE START LABEL OFF SCREEN
			startLabel.x = -300;
			posX = 75;
			posY = 40;

			//TASK2: REMOVE EVENT LISTENER
			stage.removeEventListener(MouseEvent.CLICK, start);

			//ADD PADDLE
			paddle = new Paddle();
			addChild(paddle);

			//ADD BALL
			ball = new Ball(-5, -5);
			addChild(ball);

			//ADD BRICKS
			constructBricks();

			//Animation
			lastTimeStamp = getTimer();
			addEventListener(Event.ENTER_FRAME, moveObjects);
		}

		public function constructBricks() {

			for (var i: Number = 0; i < 4; i++) {
				for (var j: Number = 0; j < 3; j++) {
					brick = new Brick(posX, posY);
					posY += 70;
					addChild(brick);
					brickArray.push(brick);
				}
				posX += 150;
				posY = 40;
			}
		}

		public function moveObjects(event: Event) {
			movePaddle();
			moveBall();
		}

		public function movePaddle() {
			paddle.x = mouseX;
		}

		public function moveBall() {
			//compute elapsedTime
			var elapseTime = getTimer() - lastTimeStamp;
			lastTimeStamp += elapseTime;

			//compute new location
			ball.x += ball.vx + elapseTime / 1000;
			ball.y += ball.vy + elapseTime / 1000;

			//check collision
			if (ball.y < TOPBORDER) {
				ball.vy *= REVERSE;
				ball.y = TOPBORDER;
			}
			if (ball.y > BOTTOMBORDER) {
				removeChild(ball);
				ball = null;
				reset();
				return;
			}

			if (ball.x < LEFTBORDER) {
				ball.vx *= REVERSE;
				ball.x = LEFTBORDER;
			}
			if (ball.x > RIGHTBORDER) {
				ball.vx *= REVERSE;
				ball.x = RIGHTBORDER;
			}
			if (ball.hitTestObject(paddle)) {
				ball.vy *= REVERSE;
				var diff: Number = ball.x - paddle.x;
				ball.vx = diff * .07;
			}

			for (var i: int = 0; i < brickArray.length; i++) {
				if (ball.hitTestObject(brickArray[i])) {
					ball.vy *= REVERSE;
					removeChild(brickArray[i]);
					brickArray.splice(i, 1);

					if (brickArray.length < 1) {
						reset();
						return;
					}
				}
			}
		}

		public function reset() {
			removeChild(paddle);
			for (var i: int = 0; i < brickArray.length; i++) {
				removeChild(brickArray[i]);
			}
			paddle = null;
			brickArray = null;
			if (ball != null) {
				removeChild(ball);
				ball = null;
			}
			removeEventListener(Event.ENTER_FRAME, moveObjects);
			startLabel.x = 300;
			stage.addEventListener(MouseEvent.CLICK, start);

		}
	}
}