package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;

	var bgShader:Shaders.GlitchEffect;
	var awaitingExploitation:Bool;

	var languages:Array<Language> = new Array<Language>();
	var currentLanguage:Int = 0;
	var curLanguage:String = LanguageManager.save.data.language;
	var songBarOptions = [
		'ShowTime',
		'ShowTimeOld',
		'SongName',
	];
	var curSongBarOptionSelected:Int;
	public static var onPlayState:Bool = false;
	var numberOption:String = "";

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Options Menu", null);
		#end
		var menuBG:FlxSprite = new FlxSprite();

		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');

		if (awaitingExploitation)
		{
			menuBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			menuBG.scrollFactor.set();
			menuBG.antialiasing = false;
			add(menuBG);
			
			if (FlxG.save.data.wantShaders) {
			bgShader = new Shaders.GlitchEffect();
			bgShader.waveAmplitude = 0.1;
			bgShader.waveFrequency = 5;
			bgShader.waveSpeed = 2;
			
			menuBG.shader = bgShader.shader;
			}
		}
		else
		{
			menuBG.color = 0xFFea71fd;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.antialiasing = true;
			menuBG.loadGraphic(MainMenuState.randomizeBG());
			add(menuBG);
		}
		
		languages = LanguageManager.getLanguages();
		curSongBarOptionSelected = songBarOptions.indexOf(FlxG.save.data.songBarOption);

		controlsStrings = CoolUtil.coolStringFile( 
			LanguageManager.getTextString('option_change_keybinds')
			+ "\n" + (FlxG.save.data.newInput ? LanguageManager.getTextString('option_ghostTapping_on') : LanguageManager.getTextString('option_ghostTapping_off')) 
			+ "\n" + (FlxG.save.data.downscroll ? LanguageManager.getTextString('option_downscroll') : LanguageManager.getTextString('option_upscroll'))
			+ "\n" + (FlxG.save.data.songPosition ? LanguageManager.getTextString('option_songPosition_on') : LanguageManager.getTextString('option_songPosition_off'))
			+ "\n" +  LanguageManager.getTextString('option_songBarType_${songBarOptions[curSongBarOptionSelected]}')
			+ "\n" + (FlxG.save.data.eyesores ? LanguageManager.getTextString('option_eyesores_enabled') : LanguageManager.getTextString('option_eyesores_disabled')) 
			+ "\n" + (FlxG.save.data.selfAwareness ? LanguageManager.getTextString('option_selfAwareness_on') : LanguageManager.getTextString('option_selfAwareness_off'))
			+ "\n" + (FlxG.save.data.donoteclick ? LanguageManager.getTextString('option_hitsound_on') : LanguageManager.getTextString('option_hitsound_off'))
			+ "\n" + (FlxG.save.data.noteCamera ? LanguageManager.getTextString('option_noteCamera_on') : LanguageManager.getTextString('option_noteCamera_off'))
			+ "\n" + LanguageManager.getTextString('option_change_langauge')
			+ "\n" + (FlxG.save.data.disableFps ? LanguageManager.getTextString('option_enable_fps') : LanguageManager.getTextString('option_disable_fps'))
			+ "\n" + (CompatTool.save.data.compatMode ? LanguageManager.getTextString('option_enable_compat') : LanguageManager.getTextString('option_disable_compat'))
			+ "\n" + (FlxG.save.data.modchart ? 'Mod Chart OFF' : 'Mod Chart ON')
			+ "\n" + (FlxG.save.data.noteSplash ? 'Note Splash ON' : 'Note Splash OFF') 
			+ "\n" + (FlxG.save.data.lessLag ? 'Less Lag OFF' : 'Less Lag ON')
			+ "\n" + (FlxG.save.data.freeplayCuts ? "Freeplay Cutscenes ON" : "Freeplay Cutscenes OFF")
			+ "\n" + (FlxG.save.data.ogHold ? "OG Hold Note Style ON" : "OG Hold Note Style OFF")
			+ "\n" + ("Sustain Transparency")
			+ "\n" + (FlxG.save.data.vanScoreSys ? "New Score System ON" : "New Score System OFF")
			+ "\n" + (FlxG.save.data.vanMissSys ? "New Miss System ON" : "New Miss System OFF")
			+ "\n" + (FlxG.save.data.middleScroll ? "Middlescroll ON" : "Middlescroll OFF")
			+ "\n" + (FlxG.save.data.wantShaders ? "Shaders ON" : "Shaders OFF")
			);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.screenCenter(X);
				controlLabel.itemType = 'Vertical';
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		versionShit = new FlxText(5, FlxG.height - 35, 0, numberOption + "\nOffset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.save.data.wantShaders) {
		if (bgShader != null)
		{
			bgShader.shader.uTime.value[0] += elapsed;
		}
	}

		if (controls.BACK)
		{
			if(onPlayState) {
			FlxG.save.flush();
			CompatTool.save.flush();
			LoadingState.loadAndSwitchState(new PlayState());
			FlxG.sound.music.volume = 0;
			onPlayState = false;
			} else {
			FlxG.save.flush();
			CompatTool.save.flush();
			FlxG.switchState(new MainMenuState());
			}
		}
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.RIGHT_R)
		{
			FlxG.save.data.offset++;
			versionShit.text = numberOption + "\nOffset (Left, Right): " + FlxG.save.data.offset;
		}

		if (controls.LEFT_R)
		{
			FlxG.save.data.offset--;
			versionShit.text = numberOption + "\nOffset (Left, Right): " + FlxG.save.data.offset;
		}	
		if (controls.ACCEPT)
		{
			grpControls.remove(grpControls.members[curSelected]);
			switch(curSelected)
			{
				case 0:
					new FlxTimer().start(0.01, function(timer:FlxTimer)
					{
						FlxG.switchState(new ChangeKeybinds());
					});
					updateGroupControls(LanguageManager.getTextString('option_change_keybinds'), 0, 'Vertical');
				case 1:
					FlxG.save.data.newInput = !FlxG.save.data.newInput;
					updateGroupControls((FlxG.save.data.newInput ? LanguageManager.getTextString('option_ghostTapping_on') : LanguageManager.getTextString('option_ghostTapping_off')), 1, 'Vertical');		
				case 2:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					updateGroupControls((FlxG.save.data.downscroll ? LanguageManager.getTextString('option_downscroll') : LanguageManager.getTextString('option_upscroll')), 2, 'Vertical');
				case 3:
					FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
					updateGroupControls((FlxG.save.data.songPosition ? LanguageManager.getTextString('option_songPosition_on') : LanguageManager.getTextString('option_songPosition_off')), 3, 'Vertical');	
				case 4:
					curSongBarOptionSelected++;
					if (curSongBarOptionSelected > songBarOptions.length - 1)
					{
						curSongBarOptionSelected = 0;
					}
					FlxG.save.data.songBarOption = songBarOptions[curSongBarOptionSelected];
					updateGroupControls(LanguageManager.getTextString('option_songBarType_${songBarOptions[curSongBarOptionSelected]}'), 4, 'Vertical');	
				case 5:
					FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
					updateGroupControls((FlxG.save.data.eyesores ? LanguageManager.getTextString('option_eyesores_enabled') : LanguageManager.getTextString('option_eyesores_disabled')), 5, 'Vertical');
				case 6:
					FlxG.save.data.selfAwareness = !FlxG.save.data.selfAwareness;
					updateGroupControls((FlxG.save.data.selfAwareness ? LanguageManager.getTextString('option_selfAwareness_on') : LanguageManager.getTextString('option_selfAwareness_off')), 6, 'Vertical');
				case 7:
					FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
					updateGroupControls((FlxG.save.data.donoteclick ? LanguageManager.getTextString('option_hitsound_on') : LanguageManager.getTextString('option_hitsound_off')), 7, 'Vertical');
				case 8:
					FlxG.save.data.noteCamera = !FlxG.save.data.noteCamera;
					updateGroupControls((FlxG.save.data.noteCamera ? LanguageManager.getTextString('option_noteCamera_on') : LanguageManager.getTextString('option_noteCamera_off')), 8, 'Vertical');
				case 9:
					updateGroupControls(LanguageManager.getTextString('option_change_langauge'), 9, 'Vertical');
					FlxG.switchState(new ChangeLanguageState());
				case 10:
					FlxG.save.data.disableFps = !FlxG.save.data.disableFps;
					Main.fps.visible = !FlxG.save.data.disableFps;
					updateGroupControls(FlxG.save.data.disableFps ? LanguageManager.getTextString('option_enable_fps') : LanguageManager.getTextString('option_disable_fps'), 10, 'Vertical');
				case 11:
					CompatTool.save.data.compatMode = !CompatTool.save.data.compatMode;
					updateGroupControls(CompatTool.save.data.compatMode ? LanguageManager.getTextString('option_enable_compat') : LanguageManager.getTextString('option_disable_compat'), 11, 'Vertical');
				case 12:
					if (!awaitingExploitation) FlxG.save.data.modchart = !FlxG.save.data.modchart;
					updateGroupControls(FlxG.save.data.modchart ? 'Mod Chart OFF' : 'Mod Chart ON', 12, 'Vertical');	
				case 13:
					FlxG.save.data.noteSplash = !FlxG.save.data.noteSplash;
					updateGroupControls((FlxG.save.data.noteSplash ? 'Note Splash ON' : 'Note Splash OFF'), 1, 'Vertical');		
				case 14:
					FlxG.save.data.lessLag = !FlxG.save.data.lessLag;
					updateGroupControls(FlxG.save.data.lessLag ? 'Less Lag OFF' : 'Less Lag ON', 12, 'Vertical');	
				case 15:
					FlxG.save.data.freeplayCuts = !FlxG.save.data.freeplayCuts;
					updateGroupControls(FlxG.save.data.freeplayCuts ? 'Freeplay Cutscenes ON' : 'Freeplay Cutscenes OFF', 12, 'Vertical');	
				case 16:
					FlxG.save.data.ogHold = !FlxG.save.data.ogHold;
					updateGroupControls(FlxG.save.data.ogHold ? 'OG Hold Note Style ON' : 'OG Hold Note Style OFF', 12, 'Vertical');	
				case 17:
					if (FlxG.save.data.susTransparent < 0.9) {
					FlxG.save.data.susTransparent += 0.1;
					} else {
					FlxG.save.data.susTransparent = 0.1;	
					}
					updateGroupControls('Sustain Transparency', 12, 'Vertical');
					numberOption = 'Sustain Transparency: ' + FlxG.save.data.susTransparent;
					versionShit.text = numberOption + "\nOffset (Left, Right): " + FlxG.save.data.offset;
				case 18:
					FlxG.save.data.vanScoreSys = !FlxG.save.data.vanScoreSys;
					updateGroupControls(FlxG.save.data.vanScoreSys ? 'New Score System ON' : 'New Score System OFF', 12, 'Vertical');	
				case 19:
					FlxG.save.data.vanMissSys = !FlxG.save.data.vanMissSys;
					updateGroupControls(FlxG.save.data.vanMissSys ? 'New Miss System ON' : 'New Miss System OFF', 12, 'Vertical');	
				case 20:
					FlxG.save.data.middleScroll = !FlxG.save.data.middleScroll;
					updateGroupControls(FlxG.save.data.middleScroll ? 'Middlescroll ON' : 'Middlescroll OFF', 12, 'Vertical');	
					case 21:
					FlxG.save.data.wantShaders = !FlxG.save.data.wantShaders;
					updateGroupControls(FlxG.save.data.wantShaders ? 'Shaders ON' : 'Shaders OFF', 12, 'Vertical');	
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
			{
			FlxG.save.flush();
			CompatTool.save.flush();
			FlxG.switchState(new AdminOptionsMenu());
			}	
	}

	var isSettingControl:Bool = false;

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}
	function updateGroupControls(controlText:String, yIndex:Int, controlTextItemType:String)
	{
		var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, controlText, true, false);
		ctrl.screenCenter(X);
		ctrl.isMenuItem = true;
		ctrl.targetY = curSelected - yIndex;
		ctrl.itemType = controlTextItemType;
		grpControls.add(ctrl);
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}