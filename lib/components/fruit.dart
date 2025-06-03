import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/Custom_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = 'Apple',
    position, 
    size
  }) : super(
    position: position,
    size: size,
  );
  bool _collected = false;
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(offsetX: 10
  , offsetY: 10, 
  width: 12, 
  height: 12); //Hitbox(offsetX:  offsetX, offsetY: offsetY, width: width, height: height)

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    // Capitaliza la primera letra del nombre del fruit
    final fruitCapitalized = fruit[0].toUpperCase() + fruit.substring(1).toLowerCase();
  add(RectangleHitbox(
    position:Vector2(hitbox.offsetX, hitbox.offsetY),
    size: Vector2(hitbox.width, hitbox.height),
    collisionType: CollisionType.passive,
  ));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruitCapitalized.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    return super.onLoad();
  }
  
  void collideWithPlayer() {
    if(!_collected) {
      animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/Collected.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    _collected = true;
    }
    Future.delayed(Duration(seconds: 1), () {
      removeFromParent();
    });



  }






}
