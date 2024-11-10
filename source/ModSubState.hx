package;

import flixel.group.FlxGroup;
import haxe.Json;
import haxe.Http;
import flixel.math.FlxRandom;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;

class ModSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var bg:FlxBackdrop;


var menuItems:Array<ModOption> = [];

	var curSelected:Int = 0;

	var expungedSelectWaitTime:Float = 0;
	var timeElapsed:Float = 0;
	var patienceTime:Float = 0;

    var funnyTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	public static var inMods:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

for (i in TitleState.mods) {
    menuItems.push(new ModOption(i));
}

menuItems.push(new ModOption('Disable Mods'));

menuItems.push(new ModOption('Exit'));

		inMods = true;
		
		funnyTexts = new FlxTypedGroup<FlxText>();
		add(funnyTexts);

		var backBg:FlxSprite = new FlxSprite();
		backBg.makeGraphic(FlxG.width + 1, FlxG.height + 1, FlxColor.BLACK);
		backBg.alpha = 0;
		backBg.scrollFactor.set();
		add(backBg);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.alpha = 0;
		bg.antialiasing = FlxG.save.data.antialiasing;
		bg.scrollFactor.set();
		add(bg);


		FlxTween.tween(backBg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, LanguageManager.getTextString('${menuItems[i].optionName}'), true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;

		timeElapsed += elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		

		if (accepted)
		{
			selectOption();
		}

		if (controls.BACK)
			{
			close();
			inMods = false;
			}
	}
	function selectOption()
	{
		var daSelected:String = menuItems[curSelected].optionName;

		switch (daSelected)
		{
			case "Disable Mods":
			FlxG.save.data.Mod = '';
			FlxG.save.flush();
			trace(FlxG.save.data.Mod);
			close();
			inMods = false;
			if(FlxG.sound.music != null)
				FlxG.sound.music.stop();
			TitleState.initialized = false;
			TitleState.onlyforabug = false;
			FlxG.switchState(new StartStateSelector());

			case "Exit":
			close();
			inMods = false;

			default:
			FlxG.save.data.Mod = daSelected;
			FlxG.save.flush();
			trace(FlxG.save.data.Mod);
			close();
			inMods = false;
			if(FlxG.sound.music != null)
				FlxG.sound.music.stop();
			TitleState.initialized = false;
			TitleState.onlyforabug = false;
			FlxG.switchState(new StartStateSelector());
		}
	}
	override function close()
	{
		funnyTexts.clear();

		super.close();
	}

	override function destroy()
	{
		super.destroy();
	}
	
	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
class ModOption
{
	public var optionName:String;

	public function new(optionName:String)
	{
		this.optionName = optionName;
	}
	
	public static function getOption(list:Array<ModOption>, optionName:String):ModOption
	{
		for (option in list)
		{
			if (option.optionName == optionName)
			{
				return option;
			}
		}
		return null;
	}
}