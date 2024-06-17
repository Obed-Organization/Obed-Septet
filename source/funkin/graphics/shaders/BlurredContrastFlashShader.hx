package funkin.graphics.shaders;

import flixel.addons.display.FlxRuntimeShader;
import funkin.Paths;
import openfl.utils.Assets;

class BlurredContrastFlashShader extends FlxRuntimeShader
{
  public var contrast(default, set):Float = 3;

  function set_contrast(value:Float):Float
  {
    this.setFloat('contrast', value);
    return contrast = value;
  }

  public var blur(default, set):Float = 1;

  function set_blur(value:Float):Float
  {
    this.setFloat('blurAmount', value);
    return blur = value;
  }

  public var time(default, set):Float = 1;

  function set_time(value:Float):Float
  {
    this.setFloat('uTime', value);
    return time = value;
  }

  function new()
  {
    super(Assets.getText(Paths.frag("blurredContrastFlash")));
  }

  public function update(elapsed:Float):Void
  {
    time += elapsed;
  }
}
