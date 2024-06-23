package funkin.ui.capcha;

import funkin.graphics.FunkinSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.display.BlendMode;

class CapchaCheckmark extends FunkinSprite
{
  public function new(?x:Float = 0, ?y:Float = 0, ?zIndex:Int = 0, ?scale:Float = 1.0, ?isRightAnswer:Bool = true, ?isAnOverlay:Bool = false)
  {
    super(x, y);

    loadTexture((isRightAnswer) ? 'capcha/correct' : 'capcha/wrong');
    this.zIndex = zIndex;
    this.y += isRightAnswer ? 5 : 2.5;
    if (isRightAnswer) this.scale.set(scale, scale);
    else
      this.scale.set(scale - 0.1, scale - 0.1);
    this.updateHitbox();
    if (isAnOverlay)
    {
      this.alpha = 0.0001;
      this.blend = BlendMode.ADD;
    }
  }

  public function confirmAnim(?isAnOverlay:Bool = true)
  {
    if (isAnOverlay)
    {
      FlxTween.tween(this, {alpha: 1}, 0.1,
        {
          ease: FlxEase.backIn,
          onComplete: function(twn:FlxTween) {
            FlxTween.tween(this, {alpha: 0.0001}, 0.1, {ease: FlxEase.backOut});
          }
        });
    }

    FlxTween.tween(this.scale, {x: this.scale.x + 0.05, y: this.scale.y + 0.05}, 0.1,
      {
        ease: FlxEase.backIn,
        onComplete: function(twn:FlxTween) {
          FlxTween.tween(this.scale, {x: this.scale.x - 0.05, y: this.scale.y - 0.05}, 0.1, {ease: FlxEase.backOut});
        }
      });
  }
}
