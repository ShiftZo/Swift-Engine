package;

#if cpp
import Discord.DiscordClient;
import sys.thread.Thread;
#end
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
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.Lib;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

class SaveOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var popup:Bool = false;
	var aming:Alphabet;
	var ok:Alphabet;
	var curframefloat:Float = 1;
	var menuBG:FlxSprite;
	var camFollow:FlxObject;
	var flashing:Bool = false;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var descBG:FlxSprite;
	override function create()
	{
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		controlsStrings = CoolUtil.coolStringFile("\n" + 'Reset All Save Data');
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
			{                                  //100
			var ctrl:Alphabet = new Alphabet(0, (80 * i) + 60, controlsStrings[i], true, false);
		    ctrl.ID = i;
			ctrl.y += 102;
			ctrl.x += 50;
		    grpControls.add(ctrl);
			}//70

			camFollow = new FlxObject(0, 0, 1, 1);
		    add(camFollow);

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.screenCenter(X);
		descBG.scrollFactor.set();
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeSelection();
		///so shit gets highlighted


		var aming:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('this-setting-will-apply-on-restart'), true, false);
		aming.isMenuItem = false;
		aming.targetY = curSelected - 0;
		aming.screenCenter(X);

		var ok:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('ok'), true, false);
		ok.isMenuItem = true;
		ok.targetY = curSelected - 0;
		ok.screenCenter(X);

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Miscellaneous Options Menu", null);
		#end


		super.create();
	}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				{
					FlxG.switchState(new MenuState());
				}
				if (controls.UP_P && !flashing)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						curSelected -= 1;
						for (item in grpControls.members)
							{
								if (item.targetY == 0)
								{
								
									camFollow.setPosition(item.getGraphicMidpoint().x + 600, item.getGraphicMidpoint().y);
									FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
										
									// item.setGraphicSize(Std.int(item.width));
								}
							}
					}
		
				if (controls.DOWN_P && !flashing)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						curSelected += 1;
						for (item in grpControls.members)
							{
								if (item.targetY == 0)
								{
								
									camFollow.setPosition(item.getGraphicMidpoint().x + 600, item.getGraphicMidpoint().y + 200);
									FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
										
										
									// item.setGraphicSize(Std.int(item.width));
								}
							}
					}
			

			if (curSelected < 0)
				curSelected = 0;
				
			if (curSelected > 0)
				curSelected = 0;
					

			grpControls.forEach(function(sex:Alphabet)
				{
		
					if (sex.ID == curSelected)
						sex.alpha = 1;
					else
						sex.alpha = 0.7;
				});

				/*grpControls.forEach(function(sex:Alphabet)
					{
						if (sex.ID == curSelected)
						{
							camFollow.setPosition(sex.getGraphicMidpoint().x + 600, sex.getGraphicMidpoint().y + 200);
							FlxG.camera.follow(camFollow, null, 0.06);
						}
					});*/
				var bullShit:Int = 0;

				for (item in grpControls.members)
					{
						item.targetY = bullShit - curSelected;
						bullShit++;

						item.alpha = 0.7;
						// item.setGraphicSize(Std.int(item.width * 0.8));
			
						if (item.targetY == 0)
						{
							item.alpha = 1;
							// item.setGraphicSize(Std.int(item.width));
						}
					}
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			if (curSelected == 0)
				versionShit.text = "Reset all saved options.";

			if (curSelected == 1)
				versionShit.text = "Reset all saved song scores.";


			if (controls.ACCEPT)
			{
                                flashing = true;				
								FlxG.sound.play(Paths.sound('confirmMenu'));
								FlxFlicker.flicker(grpControls.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
									{
										flashing = false;
										//FlxTransitionableState.skipNextTransIn = true;
										//FlxTransitionableState.skipNextTransOut = true;	
										switch(curSelected)
										{
											case 0:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.freeplaysongs = !FlxG.save.data.freeplaysongs;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, ('Reset All Option Saves'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 0;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
												Settings.resettodefaultsettings();
												TitleState.resetBinds();
											/*case 1:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.discordrpc = !FlxG.save.data.discordrpc;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, ('Reset All Song Score Saves'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 1;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));*/	
										}
										//flick.destroy();
									});	
			}
	}

	var isSettingControl:Bool = false;

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


	override function beatHit()
		{
			super.beatHit();


			if (accepted)
				{
					bopOnBeat();
					///iconBop();
					trace(curBeat);
				}
		}

		function bopOnBeat()
			{
				if (accepted)
				{
					if (Conductor.bpm == 180 && curBeat >= 168 && curBeat < 200)
						{
							if (curBeat % 1 == 0)
								{
									FlxG.camera.zoom += 0.030;
								}
						}
						    if (curBeat % 1 == 0)
						    	{
								  if (FlxG.save.data.camzooming)
											{
												FlxG.camera.zoom += 0.015;
												camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
												trace('zoom');
											}
											else
											{
												trace('no');
											}
							    }

				}
			}

			function truncateFloat( number : Float, precision : Int): Float {
				var num = number;
				num = num * Math.pow(10, precision);
				num = Math.round( num ) / Math.pow(10, precision);
				return num;
				}

	var accepted:Bool = true;


}	



