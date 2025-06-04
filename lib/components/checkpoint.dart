import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({super.position, super.size}) {
    priority = 100; // Muy alto para que se dibuje arriba
  }

  bool reachedCheckpoint = false;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.spriteList(
      [Sprite(game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpointi.png'))],
      stepTime: 1,
    );
    size = Vector2.all(64);

    add(RectangleHitbox(
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckpoint) {
      _reachedCheckpoint();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    reachedCheckpoint = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false
      ),
    );
    const flagDuration = Duration(milliseconds: 1300);
    Future.delayed(flagDuration, () {
      animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
    });
  }
}
