package funkin.ui.capcha;

import openfl.display.BlendMode;
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
  var canSelect:Bool = false;

  var defaultItemScale:Float = 0.4;

  override public function create()
  {
    super.create();

    FlxG.camera.fade(FlxColor.BLACK, 0.5, true, function() {
      canSelect = true;
    });

    msgBG = new FunkinSprite().loadTexture('capcha/msgBG');
    msgBG.zIndex = 10;
    msgBG.scale.set(defaultItemScale + 0.1, defaultItemScale);
    msgBG.y += 50;
    msgBG.updateHitbox();
    msgBG.screenCenter(X);
    add(msgBG);

    msgText = new FunkinSprite().loadTexture('capcha/msgText');
    msgText.zIndex = 20;
    msgText.scale.set(defaultItemScale, defaultItemScale);
    msgText.y = msgBG.y + 20;
    msgText.updateHitbox();
    msgText.screenCenter(X);
    add(msgText);

    no = new FunkinSprite(FlxG.width / 8).loadTexture('capcha/no');
    no.zIndex = 30;
    no.scale.set(defaultItemScale, defaultItemScale);
    no.updateHitbox();
    no.screenCenter(Y);
    add(no);

    bus = new FunkinSprite(no.x * 5).loadTexture('capcha/bus');
    bus.zIndex = 40;
    bus.scale.set(defaultItemScale - 0.05, defaultItemScale - 0.05);
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
      bus.scale.set(defaultItemScale, defaultItemScale);
      no.scale.set(defaultItemScale - 0.05, defaultItemScale - 0.05);
    }
    else
    {
      bus.alpha = 0.5;
      no.alpha = 1;
      bus.scale.set(defaultItemScale - 0.05, defaultItemScale - 0.05);
      no.scale.set(defaultItemScale, defaultItemScale);
    }
  }

  function confirm()
  {
    canSelect = false;
    createCheckmark();
    createOverlayItem();
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
    if (selection) checkmark.scale.set(defaultItemScale, defaultItemScale);
    else
      checkmark.scale.set(defaultItemScale - 0.1, defaultItemScale - 0.1);
    checkmark.updateHitbox();
    add(checkmark);

    var overlay:FunkinSprite = new FunkinSprite(checkmark.x, checkmark.y).loadTexture((selection) ? 'capcha/correct' : 'capcha/wrong');
    overlay.zIndex = checkmark.zIndex;
    if (selection) overlay.scale.set(defaultItemScale, defaultItemScale);
    else
      overlay.scale.set(defaultItemScale - 0.1, defaultItemScale - 0.1);
    overlay.updateHitbox();
    overlay.alpha = 0.0001;
    overlay.blend = BlendMode.ADD;
    add(overlay);

    FlxTween.tween(overlay, {alpha: 1}, 0.1,
      {
        onComplete: function(twn:FlxTween) {
          FlxTween.tween(overlay, {alpha: 0.0001}, 0.1,
            {
              onComplete: function(twn:FlxTween) {
                overlay.destroy();
              }
            });
        }
      });
  }

  function createOverlayItem()
  {
    var item:FunkinSprite = new FunkinSprite(selection ? bus.x - 20 : no.x).loadTexture(selection ? 'capcha/bus' : 'capcha/no');
    item.zIndex = selection ? bus.zIndex : no.zIndex;
    item.scale.set(defaultItemScale, defaultItemScale);
    item.updateHitbox();
    item.screenCenter(Y);
    item.blend = BlendMode.ADD;
    add(item);

    item.scale.set(defaultItemScale + 0.02, defaultItemScale + 0.02);
    if (selection) bus.scale.set(defaultItemScale + 0.02, defaultItemScale + 0.02);
    else
      no.scale.set(defaultItemScale + 0.02, defaultItemScale + 0.02);

    FlxTween.tween(item, {alpha: 1}, 0.1,
      {
        onComplete: function(twn:FlxTween) {
          FlxTween.tween(item, {alpha: 0.0001}, 0.1,
            {
              onComplete: function(twn:FlxTween) {
                item.scale.set(defaultItemScale, defaultItemScale);
                if (selection) bus.scale.set(defaultItemScale, defaultItemScale);
                else
                  no.scale.set(defaultItemScale, defaultItemScale);

                item.destroy();
              }
            });
        }
      });
  }
}
