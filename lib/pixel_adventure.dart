import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks {

  @override
  Color backgroundColor() => const Color(0xFF211F30);


  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showControls = false;
  List<String> levelNames = ['Level_01', 'Level_02'];
  int currentLevelIndex = 0 ;

  

@override

  Future<void> onLoad() async {
 //load all images en el cash
    await images.loadAllImages();

   _loadLevel();


    addJoystick();

    return super.onLoad();
  }
  
  @override
  void update(double dt) {
    if(showControls){
      updateJoystick();
    }
    
    super.update(dt);
  }
  void addJoystick() {
    joystick = JoystickComponent(
      priority: 101,
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      
    );
    if(showControls) {
          add(joystick);
          add(JumpButton());

    }

  }
  
  void updateJoystick() {

    switch(joystick.direction) {

      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
       player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }



  }

  void loadNextLevel() {
    removeWhere(component) => component is Level;

    if(currentLevelIndex < levelNames.length - 1) {
    currentLevelIndex++;
    _loadLevel();
    } else {
    }
  
  }
  
  void _loadLevel() {
    Future.delayed(Duration(seconds: 1), () {
       Level world = Level(
    player: player, 
    levelName: levelNames[currentLevelIndex],
  );

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360 );
    cam.viewfinder.anchor = Anchor.topLeft;


    addAll([cam, world]);
    });
    
  }


}
