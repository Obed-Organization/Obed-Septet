package funkin.ui.capcha;

import lime.system.System;
import funkin.graphics.FunkinSprite;
import funkin.ui.title.TitleState;
import funkin.audio.FunkinSound;
import funkin.ui.MusicBeatState;
import funkin.input.Controls;
import funkin.Paths;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;

class CapchaState extends MusicBeatState
{
  var msgBG:FunkinSprite;
  var msgText:FunkinSprite;

  var no:FunkinSprite;
  var bus:FunkinSprite;

  // false = no, true = bus
  var selection:Bool = false;
  var canSelect:Bool = true;

  override public function create()
  {
    super.create();

    msgBG = new FunkinSprite().loadTexture('capcha/msgBG');
    msgBG.zIndex = 10;
    msgBG.scale.set(0.5, 0.4);
    msgBG.y += 50;
    msgBG.updateHitbox();
    msgBG.screenCenter(X);
    add(msgBG);

    msgText = new FunkinSprite().loadTexture('capcha/msgText');
    msgText.zIndex = 20;
    msgText.scale.set(0.4, 0.4);
    msgText.y = msgBG.y + 20;
    msgText.updateHitbox();
    msgText.screenCenter(X);
    add(msgText);

    no = new FunkinSprite(FlxG.width / 8).loadTexture('capcha/no');
    no.zIndex = 30;
    no.scale.set(0.4, 0.4);
    no.updateHitbox();
    no.screenCenter(Y);
    add(no);

    bus = new FunkinSprite(no.x * 5).loadTexture('capcha/bus');
    bus.zIndex = 40;
    bus.scale.set(0.35, 0.35);
    bus.alpha = 0.5;
    bus.updateHitbox();
    bus.screenCenter(Y);
    add(bus);
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);

    if (canSelect)
    {
      if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
      {
        selection = !selection;
        FunkinSound.playOnce(Paths.sound('scrollMenu'));
        updateSelection();
      }

      if (controls.ACCEPT) confirm();
    }
  }

  function updateSelection()
  {
    if (selection)
    {
      bus.alpha = 1;
      no.alpha = 0.5;
      bus.scale.set(0.4, 0.4);
      no.scale.set(0.35, 0.35);
    }
    else
    {
      bus.alpha = 0.5;
      no.alpha = 1;
      bus.scale.set(0.35, 0.35);
      no.scale.set(0.4, 0.4);
    }
  }

  function confirm()
  {
    canSelect = false;
    createCheckmark();
    FunkinSound.playOnce(Paths.sound('confirmMenu'));

    new FlxTimer().start(1, function(tmr:FlxTimer) {
      FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
        if (selection)
        {
          FlxG.sound.cache(Paths.music('freakyMenu/freakyMenu'));
          FlxG.switchState(() -> new TitleState());
        }
        else
          System.exit(0);
      });
    });
  }

  function createCheckmark()
  {
    var checkmark:FunkinSprite = new FunkinSprite(FlxG.width / 2.5, msgText.y).loadTexture((selection) ? 'capcha/correct' : 'capcha/wrong');
    checkmark.zIndex = 50;
    checkmark.y += selection ? 5 : 2.5;
    if (selection) checkmark.scale.set(0.4, 0.4);
    else
      checkmark.scale.set(0.3, 0.3);
    checkmark.updateHitbox();
    add(checkmark);
  }
}
