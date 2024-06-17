package funkin.play.event;

// Data from the chart
import funkin.data.song.SongData;
import funkin.data.song.SongData.SongEventData;
// Data from the event schema
import funkin.play.event.SongEvent;
import funkin.data.event.SongEventSchema;
import funkin.data.event.SongEventSchema.SongEventFieldType;
// Other imports
import funkin.play.PlayState;
import funkin.graphics.shaders.BlurredContrastFlashShader;
import flixel.tweens.FlxTween;
import openfl.filters.ShaderFilter;

@:access(funkin.graphics.shaders.BlurredContrastFlashShader)
class ObedFlashSongEvent extends SongEvent
{
  var flashShader:BlurredContrastFlashShader = new BlurredContrastFlashShader();
  var flashShaderFilter:ShaderFilter = null;

  public function new()
  {
    super('Obed Flash');
  }

  public override function handleEvent(data:SongEventData)
  {
    // Does nothing if there is no PlayState camera or stage.
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;

    flashShader.contrast = 1;
    flashShader.blur = 0;

    flashShaderFilter = new ShaderFilter(flashShader);
    PlayState.instance.camGame.setFilters([flashShaderFilter]);
    PlayState.instance.camHUD.setFilters([flashShaderFilter]);

    var contrast = data.getFloat('contrast');
    var blur = data.getFloat('blur');
    var duration = data.getFloat('duration');

    FlxTween.tween(flashShader, {contrast: contrast, blur: blur}, 0.01,
      {
        onComplete: function(twn:FlxTween) {
          FlxTween.tween(flashShader, {contrast: 1, blur: 0}, duration,
            {
              onComplete: function(twn:FlxTween) {
                PlayState.instance.camGame.setFilters([]);
                PlayState.instance.camHUD.setFilters([]);
              }
            });
        }
      });
  }

  public override function getTitle():String
  {
    return "Obed Flash";
  }

  /**
   * ```
   * {
   *   "contrast": FLOAT, // Contrast value.
   *   "blur": FLOAT, // Blur amount.
   *   "length": FLOAT, // Length of the event.
   * }
   * @return SongEventSchema
   */
  public override function getEventSchema():SongEventSchema
  {
    return new SongEventSchema([
      {
        name: 'contrast',
        title: 'Contrast',
        type: SongEventFieldType.FLOAT,
        defaultValue: 3.0,
      },
      {
        name: 'blur',
        title: 'Blur Amount',
        type: SongEventFieldType.FLOAT,
        defaultValue: 1.0,
      },
      {
        name: 'duration',
        title: 'Duration',
        type: SongEventFieldType.FLOAT,
        defaultValue: 0.5
      }
    ]);
  }
}
