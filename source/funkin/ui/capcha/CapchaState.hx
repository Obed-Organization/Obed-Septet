package funkin.ui.capcha;

import funkin.ui.capcha.CapchaCheckmark;
import funkin.ui.capcha.CapchaSelectionItem;
import funkin.ui.title.TitleState;
import funkin.ui.MusicBeatState;
import funkin.graphics.FunkinSprite;
import funkin.audio.FunkinSound;
import funkin.input.Controls;
#if mobile
import funkin.mobile.util.TouchUtil;
#end
import funkin.Paths;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.display.BlendMode;
import lime.system.System;

class CapchaState extends MusicBeatState
{
  var msgBG:FunkinSprite;
  var msgText:FunkinSprite;

  var no:CapchaSelectionItem;
  var bus:CapchaSelectionItem;

  // false = no, true = bus
  var selection:Bool = false;
  var canSelect:Bool = false;

  var defaultItemScale:Float = 0.4;

  override public function create()
  {
    super.create();

    FlxG.camera.alpha = 0.0001;
    FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5,
      {
        onComplete: function(twn:FlxTween) {
          canSelect = true;
        }
      });

    msgBG = new FunkinSprite(FlxG.width * 0.36, FlxG.height * 0.07).loadTexture('capcha/msgBG');
    msgBG.zIndex = 10;
    msgBG.scale.set(defaultItemScale, defaultItemScale);
    msgBG.updateHitbox();
    add(msgBG);

    msgText = new FunkinSprite(msgBG.x + 35, msgBG.y + 20).loadTexture('capcha/msgText');
    msgText.zIndex = msgBG.zIndex + 10;
    msgText.scale.set(defaultItemScale, defaultItemScale);
    msgText.updateHitbox();
    add(msgText);

    no = new CapchaSelectionItem(FlxG.width / 8.12, msgText.zIndex + 10, defaultItemScale, false, false);
    add(no);

    bus = new CapchaSelectionItem(no.x * 5, msgText.zIndex + 10, defaultItemScale, true, false);
    add(bus);
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);

    no.updateSelection(!selection, defaultItemScale);
    bus.updateSelection(selection, defaultItemScale);

    if (canSelect)
    {
      if (FlxG.mouse.overlaps(no) #if mobile || TouchUtil.overlaps(no) && TouchUtil.justPressed #end)
      {
        selection = false;
        if (FlxG.mouse.justPressed #if mobile || TouchUtil.overlaps(no) && TouchUtil.justPressed #end) confirm();
      }
      else if (FlxG.mouse.overlaps(bus) #if mobile || TouchUtil.overlaps(bus) && TouchUtil.justPressed #end)
      {
        selection = true;
        if (FlxG.mouse.justPressed #if mobile || TouchUtil.overlaps(bus) && TouchUtil.justPressed #end) confirm();
      }

      if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
      {
        selection = !selection;
        FunkinSound.playOnce(Paths.sound('scrollMenu'));
      }

      if (controls.ACCEPT) confirm();
    }
  }

  function createCheckmark()
  {
    var checkmark:CapchaCheckmark = new CapchaCheckmark(msgText.x, msgText.y, 40, defaultItemScale, selection, false);
    add(checkmark);

    var checkmarkOverlay:CapchaCheckmark = new CapchaCheckmark(checkmark.x, checkmark.y, checkmark.zIndex, defaultItemScale, selection, true);
    add(checkmarkOverlay);

    checkmark.confirmAnim(false);
    checkmarkOverlay.confirmAnim();
  }

  function createItemOverlay()
  {
    var overlay:CapchaSelectionItem = new CapchaSelectionItem(selection ? bus.x : no.x, selection ? bus.zIndex : no.zIndex, defaultItemScale, selection, true);
    add(overlay);

    overlay.confirmAnim();
  }

  function confirm()
  {
    canSelect = false;
    createCheckmark();
    createItemOverlay();

    if (selection) bus.confirmAnim(false);
    else
      no.confirmAnim(false);

    FunkinSound.playOnce(Paths.sound('confirmMenu'));

    new FlxTimer().start(1, function(tmr:FlxTimer) {
      FlxTween.tween(FlxG.camera, {alpha: 0.0001}, 0.5,
        {
          onComplete: function(twn:FlxTween) {
            if (selection)
            {
              FlxG.sound.cache(Paths.music('freakyMenu/freakyMenu'));
              FlxG.switchState(() -> new TitleState());
            }
            else
              System.exit(0);
          }
        });
    });
  }
}
