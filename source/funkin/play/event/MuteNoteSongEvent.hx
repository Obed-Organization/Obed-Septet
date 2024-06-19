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
import flixel.util.FlxTimer;

class MuteNoteSongEvent extends SongEvent
{
  public function new()
  {
    super('MuteNote');
  }

  public override function handleEvent(data:SongEventData)
  {
    // Does nothing if there is no PlayState camera or stage.
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;

    var difficulty = data.getString('difficulty');
    var voice = data.getString('voice');
    var duration = data.getFloat('duration');

    handleVoiceVolume(difficulty, voice, 0);

    new FlxTimer().start(duration, function(tmr:FlxTimer) {
      handleVoiceVolume(difficulty, voice, 1);
    });
  }

  function handleVoiceVolume(difficulty:String, voice:String, volume:Float)
  {
    if (PlayState.instance.currentDifficulty == difficulty)
    {
      switch (voice)
      {
        case 'enemy':
          PlayState.instance.vocals.opponentVolume = volume;
        case 'player':
          if (volume == 0) PlayState.instance.vocals.playerVolume = volume;
        case 'both':
          PlayState.instance.vocals.opponentVolume = volume;
          if (volume == 0) PlayState.instance.vocals.playerVolume = volume;
        default:
          // nothing
      }
    }
  }

  public override function getTitle():String
  {
    return "Mute Note";
  }

  /**
   * ```
   * {
   *   "Difficulty": ENUM, // Which difficulty allow that.
   *   "Voice": ENUM, // Whose voice need to be muted.
   *   "Duration": FLOAT // Time until vocals are need to be unmuted (NOTE: Player's volume restore itself)
   * }
   * @return SongEventSchema
   */
  public override function getEventSchema():SongEventSchema
  {
    return new SongEventSchema([
      {
        name: 'difficulty',
        title: 'Difficulty',
        type: SongEventFieldType.ENUM,
        keys: [
          'Easy' => 'easy',
          'Normal' => 'normal',
          'Hard' => 'hard',
          'Pussy' => 'pussy',
          'Obed' => 'obed'
        ],
        defaultValue: 'pussy'
      },
      {
        name: 'voice',
        title: 'Voice',
        type: SongEventFieldType.ENUM,
        keys: ['Enemy' => 'enemy', 'Player' => 'player', 'Both' => 'both'],
        defaultValue: 'both'
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
