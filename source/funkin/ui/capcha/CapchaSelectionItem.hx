package funkin.ui.capcha;

import funkin.graphics.FunkinSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.display.BlendMode;

class CapchaSelectionItem extends FunkinSprite
{
  public function new(?x:Float = 0, ?zIndex:Int = 0, ?scale:Float = 1.0, ?isRightAnswer:Bool = true, ?isAnOverlay:Bool = false)
  {
    super(x, 0);

    loadTexture((isRightAnswer) ? 'capcha/bus' : 'capcha/no');
    this.zIndex = zIndex;
    this.scale.set(scale, scale);
    this.updateHitbox();
    this.screenCenter(Y);
    if (isAnOverlay)
    {
      this.alpha = 0.0001;
      this.blend = BlendMode.ADD;
    }
  }

  public function updateSelection(?isSelected = false, ?scale = 1.0)
  {
    var requiredAlpha:Float = isSelected ? 1.0 : 0.5;
    var requiredScale:Float = isSelected ? scale : scale - 0.05;

    if (this.alpha != requiredAlpha) FlxTween.tween(this, {alpha: requiredAlpha}, 0.05);
    if (this.scale.x != requiredScale && this.scale.y != requiredScale) FlxTween.tween(this.scale, {x: requiredScale, y: requiredScale}, 0.05);
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
