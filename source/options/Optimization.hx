package options;

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
import sys.io.Process;
import sys.io.File;

class Optimization extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var awaitingExploitation:Bool;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	
	override function create()
	{
		#if desktop
		if (FlxG.save.data.discord)
		DiscordClient.changePresence("In the Optimization Options Menu", null);
		#end

		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		
		    var menuBG:FlxSprite = new FlxSprite();
			menuBG.color = 0xFFea71fd;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.antialiasing = FlxG.save.data.antialiasing;
			menuBG.loadGraphic(MainMenuState.randomizeBG());
			add(menuBG);

		controlsStrings = CoolUtil.coolStringFile( 
		    (CompatTool.save.data.compatMode ? LanguageManager.getTextString('option_enable_compat') : LanguageManager.getTextString('option_disable_compat'))
			+ "\n" + (FlxG.save.data.wantShaders ? "Shaders ON" : "Shaders OFF")
			+ "\n" + (FlxG.save.data.playerLight ? "Light Player Strums ON" : "Light Player Strums OFF")
			+ "\n" + (FlxG.save.data.cpuLight ? "Light Cpu Strums ON" : "Light Cpu Strums OFF")
			+ "\n" + (FlxG.save.data.ratingsPopUp ? "Show Rating Pop Up ON" : "Show Rating Pop Up OFF")
			+ "\n" + (FlxG.save.data.stage ? "Stage ON" : "Stage OFF")
			+ "\n" + (FlxG.save.data.chars ? "Characters ON" : "Characters OFF")
			+ "\n" + (FlxG.save.data.antialiasing ? "Antialiasing ON" : "Antialiasing OFF")
			+ "\n" + (FlxG.save.data.lowQ ? "Low Quality ON" : "Low Quality OFF")
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

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.save.flush();
			CompatTool.save.flush();
			FlxG.switchState(new OptionsMenu());
		}
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			grpControls.remove(grpControls.members[curSelected]);
			switch(curSelected)
			{
				case 0:
					CompatTool.save.data.compatMode = !CompatTool.save.data.compatMode;
					updateGroupControls(CompatTool.save.data.compatMode ? LanguageManager.getTextString('option_enable_compat') : LanguageManager.getTextString('option_disable_compat'), 11, 'Vertical');	
					case 1:
					FlxG.save.data.wantShaders = !FlxG.save.data.wantShaders;
					updateGroupControls(FlxG.save.data.wantShaders ? 'Shaders ON' : 'Shaders OFF', 12, 'Vertical');	
					case 2:
					FlxG.save.data.playerLight = !FlxG.save.data.playerLight;
					updateGroupControls(FlxG.save.data.playerLight ? 'Light Player Strums ON' : 'Light Player Strums OFF', 12, 'Vertical');	
					case 3:
					FlxG.save.data.cpuLight = !FlxG.save.data.cpuLight;
					updateGroupControls(FlxG.save.data.cpuLight ? 'Light Cpu Strums ON' : 'Light Cpu Strums OFF', 12, 'Vertical');	
					case 4:
					FlxG.save.data.ratingsPopUp = !FlxG.save.data.ratingsPopUp;
					updateGroupControls(FlxG.save.data.ratingsPopUp ? 'Show Rating Pop Up ON' : 'Show Rating Pop Up OFF', 12, 'Vertical');	
					case 5:
					FlxG.save.data.stage = !FlxG.save.data.stage;
					updateGroupControls(FlxG.save.data.stage ? 'Stage ON' : 'Stage OFF', 12, 'Vertical');	
					case 6:
					FlxG.save.data.chars = !FlxG.save.data.chars;
					updateGroupControls(FlxG.save.data.chars ? 'Characters ON' : 'Characters OFF', 12, 'Vertical');
					case 7:
					FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
					updateGroupControls(FlxG.save.data.antialiasing ? 'Antialiasing ON' : 'Antialiasing OFF', 12, 'Vertical');
					case 8:
					FlxG.save.data.lowQ = !FlxG.save.data.lowQ;
					updateGroupControls(FlxG.save.data.lowQ ? 'Low Quality ON' : 'Low Quality OFF', 12, 'Vertical');
			}
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