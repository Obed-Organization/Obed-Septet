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
  public function new()
  {
    super('Obed Flash');
  }

  public override function handleEvent(data:SongEventData)
  {
    // Does nothing if there is no PlayState camera or stage.
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;

    var contrast = data.getFloat('contrast');
    var blur = data.getFloat('blur');
    var duration = data.getFloat('duration');
    var type = data.getString('type');

    createFlashShader(contrast, blur, duration, type);
  }

  private function createFlashShader(contrast:Float, blur:Float, duration:Float, type:String)
  {
    if (PlayState.instance.camGame.filters == null) PlayState.instance.camGame.filters = [];
    if (PlayState.instance.camHUD.filters == null) PlayState.instance.camHUD.filters = [];

    final flashShader:BlurredContrastFlashShader = new BlurredContrastFlashShader();
    flashShader.contrast = 1;
    flashShader.blur = 0;

    final flashShaderFilter:ShaderFilter = new ShaderFilter(flashShader);
    PlayState.instance.camGame.filters.push(flashShaderFilter);
    PlayState.instance.camHUD.filters.push(flashShaderFilter);

    FlxTween.tween(flashShader, {contrast: (type == 'out') ? contrast : 1, blur: (type == 'out') ? blur : 0}, 0.01,
      {
        onComplete: function(twn:FlxTween) {
          FlxTween.tween(flashShader, {contrast: (type == 'out') ? 1 : contrast, blur: (type == 'out') ? 0 : blur}, duration,
            {
              onComplete: function(twn:FlxTween) {
                PlayState.instance.camGame.filters.remove(flashShaderFilter);
                PlayState.instance.camHUD.filters.remove(flashShaderFilter);
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
   *   "type": ENUM, // Type of the event.
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
      },
      {
        name: 'type',
        title: 'Type',
        type: SongEventFieldType.ENUM,
        keys: ['In' => 'in', 'Out' => 'out'],
        defaultValue: 'out'
      }
    ]);
  }
}
