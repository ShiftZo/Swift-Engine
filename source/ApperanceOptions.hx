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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.Lib;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
#if sys
import lime.system.DisplayMode;
import flash.system.System;
#end

class ApperanceOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var controlsStrings:Array<String> = [];
	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var descBG:FlxSprite;
	var camFollow:FlxObject;
	var sex:Alphabet;
	var menuBG:FlxSprite;
	var flashing:Bool = false;
	var canselectoptions:Bool = false;
	public static var currentcap:Int;
	override function create()
	{
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD") + "\n" + (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF") + "\n" + (FlxG.save.data.hittimings ? "MS Timing info ON" : "MS Timing info OFF") + "\n" + (FlxG.save.data.showratings ? "judgment counter ON" : "judgment counter OFF") + "\n" + (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION off")+ "\n" + (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off")+ "\n" + (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF") + "\n" + (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF") + "\n" + (FlxG.save.data.nps ? "NPS ON" : "NPS OFF") + "\n" + (FlxG.save.data.healthcolor ? 'new healthbar on' : 'new healthbar off') + "\n" + (FlxG.save.data.newhealthheadbump ? 'new healthhead bump on' : 'new healthhead bump off') + "\n" + (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF") + "\n" + (FlxG.save.data.togglecap ? "FPS CAP ON" : "FPS CAP OFF") + "\n" + (FlxG.save.data.memoryMonitor ? "memoryMonitor ON" : "memoryMonitor OFF") + "\n" + (FlxG.save.data.middlecam ? "Camera focusing ON" : "Camera focusing OFF") + "\n" + (FlxG.save.data.camfollowspeedon ? "Camera speed modif on" : "Camera speed modif off") + "\n" + (FlxG.save.data.enablesickpositions ? 'custom rating position on' : 'custom rating position off') + "\n" + (FlxG.save.data.songinfo ? 'song info popup on' : 'song info popup off') + "\n" + (FlxG.save.data.combotext ? 'combo text on' : 'combo text off') + "\n" + (FlxG.save.data.combonumber ? 'combo counter on' : 'combo counter off')  + "\n" + "Edit in-game appearance" + "\n" + "EDIT Scoretext preference" + "\n" + (FlxG.save.data.minscore ? 'old scoretext on' : 'old scoretext off') + "\n" + (FlxG.save.data.notesplashes ? 'notesplashes on' : 'notesplashes off') + "\n" + "Custom BF Animations" + "\n" + "HUD transparency" + "\n" + (FlxG.save.data.showratinggraphic ? 'show ratings on' : 'show ratings off'));
		
		trace(controlsStrings);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

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

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.scrollFactor.set();
		descBG.screenCenter(X);
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);


		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Appearance Options Menu", null);
		#end
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		currentcap = FlxG.save.data.fpsCap + 4;

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				{
					FlxG.switchState(new MenuState());
				}
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			
				
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
		
				if (curSelected > 28)
					curSelected = 28;
	
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
			
			if (curSelected == 14)
				{
					var multiply:Float = 1;

					if (FlxG.keys.pressed.SHIFT && FlxG.save.data.fpsCap < 1000 && FlxG.save.data.fpsCap > 30 && FlxG.save.data.togglecap)
						multiply = 10;
			
					if (FlxG.keys.justPressed.RIGHT && FlxG.save.data.fpsCap < 1000 && FlxG.save.data.togglecap)
						{
								{
									FlxG.save.data.fpsCap += 1 * multiply;
									(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
									FlxG.updateFramerate = FlxG.save.data.fpsCap;
				                    FlxG.drawFramerate = FlxG.save.data.fpsCap;
								}
						}
					if (FlxG.keys.justPressed.LEFT && FlxG.save.data.fpsCap > 20 && FlxG.save.data.togglecap)
						{
								{
									FlxG.save.data.fpsCap -= 1 * multiply;
									(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
									FlxG.updateFramerate = FlxG.save.data.fpsCap;
				                    FlxG.drawFramerate = FlxG.save.data.fpsCap;
								}
						}
			
					if (FlxG.keys.justPressed.R && FlxG.save.data.togglecap)
					{
						/*#if sys
						FlxG.save.data.fpsCap = System.DisplayMode.refreshRate; // get monitors refresh rate
						#else
						FlxG.save.data.fpsCap = 138; // default to 144fps
						#end*/
						FlxG.save.data.fpsCap = 140; // default to 144fps
						(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
					}
				}

				if (FlxG.keys.justPressed.N && curSelected == 25)
					{
					if (!FlxG.save.data.cpunotesplashes)
						{
							FlxG.save.data.cpunotesplashes = true;
						}
						else if (FlxG.save.data.cpunotesplashes)
							{
								FlxG.save.data.cpunotesplashes = false;
							}
					    trace(FlxG.save.data.cpunotesplashes);
					}

					if (FlxG.keys.justPressed.H && curSelected == 25)
						{
						if (!FlxG.save.data.notesplashhold)
							{
								FlxG.save.data.notesplashhold = true;
							}
							else if (FlxG.save.data.notesplashhold)
								{
									FlxG.save.data.notesplashhold = false;
								}
							trace(FlxG.save.data.notesplashhold);
						}

						if (FlxG.keys.justPressed.C && curSelected == 3)
							{
							if (!FlxG.save.data.combo)
								{
									FlxG.save.data.combo = true;
								}
								else if (FlxG.save.data.combo)
									{
										FlxG.save.data.combo = false;
									}
								trace(FlxG.save.data.combo);
							}
		
							if (FlxG.keys.justPressed.H && curSelected == 3)
								{
								if (!FlxG.save.data.highestcombo)
									{
										FlxG.save.data.highestcombo = true;
									}
									else if (FlxG.save.data.highestcombo)
										{
											FlxG.save.data.highestcombo = false;
										}
									trace(FlxG.save.data.highestcombo);
								}

								if (FlxG.keys.justPressed.M && curSelected == 3)
									{
									if (!FlxG.save.data.showmisses)
										{
											FlxG.save.data.showmisses = true;
										}
										else if (FlxG.save.data.showmisses)
											{
												FlxG.save.data.showmisses = false;
											}
										trace(FlxG.save.data.showmisses);
									}

				if (curSelected == 17)
					{
						var multiply:Float = 1;
	
						if (FlxG.keys.pressed.SHIFT && FlxG.save.data.camfollowspeed < 1000 && FlxG.save.data.camfollowspeed > 0 && FlxG.save.data.camfollowspeedon)
							multiply = 10;
				
						if (FlxG.keys.justPressed.RIGHT && FlxG.save.data.camfollowspeed < 1000 && FlxG.save.data.camfollowspeedon)
							{
									{
										FlxG.save.data.camfollowspeed += 1 * multiply;
									}
							}
						if (FlxG.keys.justPressed.LEFT && FlxG.save.data.camfollowspeed > 0 && FlxG.save.data.camfollowspeedon)
							{
									{
										FlxG.save.data.camfollowspeed -= 1 * multiply;
									}
							}
				
						if (FlxG.keys.justPressed.SPACE && FlxG.save.data.camfollowspeedon)
						{
							FlxG.save.data.camfollowspeed = 60;
						}
					}
					if (curSelected == 27)
						{
							if (FlxG.keys.justPressed.RIGHT && FlxG.save.data.camHUDALPHA < 1)
								FlxG.save.data.camHUDALPHA += 0.1;
							if (FlxG.keys.justPressed.LEFT && FlxG.save.data.camHUDALPHA > 0.2)
								FlxG.save.data.camHUDALPHA -= 0.1;
					
							if (FlxG.keys.justPressed.R)
								{
								FlxG.save.data.camHUDALPHA = 1;
								}
						}


			if (curSelected == 0)
				versionShit.text = "Hide all text and the healthbar.";

			if (curSelected == 1)
				versionShit.text = "Hide all UI, strumline, and notes.";

			if (curSelected == 2)
				versionShit.text = "Show in miliseconds how long it took for you to hit a note.";

			if (curSelected == 3)
				versionShit.text = "Show a column of judgments to the side. (Show highest combo? " + FlxG.save.data.highestcombo + " | Show combo? " + FlxG.save.data.combo + " | Show misses? " + FlxG.save.data.showmisses + ', toggle with H, C and M.)';

			if (curSelected == 4)
				versionShit.text = "Show what position in the song you are.";

			if (curSelected == 5)
				versionShit.text = "Wether or not to have note trails transparent or not transparent.";

			if (curSelected == 6)
				versionShit.text = "Wether or not to have the CPU strums light up.";

			if (curSelected == 7)
				versionShit.text = "Wether or not to have the player strums light up.";

			if (curSelected == 8)
				versionShit.text = "Wether or not to have the camera zoom in on beat.";

			if (curSelected == 9)
				versionShit.text = "Wether or not to show engine watermarks. (will not remove botplay text)";

			if (curSelected == 10)
				versionShit.text = "Wether or not to show notes per second.";

			if (curSelected == 11)
				versionShit.text = "If the healthbar should be the color of the player (1 or 2).";

			if (curSelected == 12)
				versionShit.text = "If the healthbar heads should act like the ones from week 7. (new healthhead bump)";

			if (curSelected == 13)
				versionShit.text = "Toggle the FPS counter on and off.";
			
			if (curSelected == 14)
				versionShit.text = "Set the FPS cap. FPS: " + currentcap + " (Left, Right, R to reset, Shift to go faster)";

			if (curSelected == 15)
				versionShit.text = "Toggle the memory monitor on and off.";

			if (curSelected == 16)
				versionShit.text = "Toggle if the camera should point at player 1 and 2 when they are singing.";

			if (curSelected == 17)
				versionShit.text = "Set the custom camera panning speed. (lower values = faster pan) cur speed: " + FlxG.save.data.camfollowspeed + " (Left, Right, Space to reset, Shift to go faster)";

			if (curSelected == 18)
				versionShit.text = "Enable The ratings to be bigger and draggable to a place on the screen. (Kade Engine ratings)";

			if (curSelected == 19)
				versionShit.text = "Display song composer info when a song starts.";

			if (curSelected == 20)
				versionShit.text = "Show 'combo' text next to the combo number.";

			if (curSelected == 21)
				versionShit.text = "Show what your combo is next to the combo text.";

			if (curSelected == 22)
				versionShit.text = "Customize were your ratings should be and other gameplay elements.";

			if (curSelected == 23)
				versionShit.text = "Edit Your prefered scoretext Layout.";

			if (curSelected == 24)
				versionShit.text = "enable old scoring text.";

			if (curSelected == 25)
				versionShit.text = "enable notesplashes. CPU note splashes: " + FlxG.save.data.cpunotesplashes + " (toggle with N) " + "show notesplashes with holdnotes: " + FlxG.save.data.notesplashhold + " (toggle with H)";

			if (curSelected == 26)
				versionShit.text = "Select a custom BF to use.";

			if (curSelected == 27)
				versionShit.text = "Edit HUD transparency. " + '(' + FlxG.save.data.camHUDALPHA + ')' + " - Left and Right to change, R to reset." ;
			if (curSelected == 28)
				versionShit.text = "Hide or show the rating graphic." ;
			if (controls.ACCEPT)
			{		
								flashing = true;
								FlxG.sound.play(Paths.sound('confirmMenu'));
								FlxFlicker.flicker(grpControls.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
									{
										//FlxTransitionableState.skipNextTransIn = true;
										//FlxTransitionableState.skipNextTransOut = true;
										//flick.destroy();
										flashing = false;

										switch(curSelected)
										{
											case 0:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.hideHUD = !FlxG.save.data.hideHUD;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 0;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 1:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.cinematic = !FlxG.save.data.cinematic;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 1;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											 case 2:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.hittimings = !FlxG.save.data.hittimings;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.hittimings ? "MS Timing info ON" : "MS Timing info OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 2;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 3:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.showratings = !FlxG.save.data.showratings;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.showratings ? "judgment counter on" : "judgment counter off"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 3;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											 case 4:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 4;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											 case 5:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.transparency = !FlxG.save.data.transparency;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 5;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 6:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.strumlights = !FlxG.save.data.strumlights;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 6;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 7:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.playerstrumlights = !FlxG.save.data.playerstrumlights;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 7;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 8:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.camzooming = !FlxG.save.data.camzooming;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 8;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 9:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.watermarks = !FlxG.save.data.watermarks;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 9;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 10:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.nps = !FlxG.save.data.nps;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.nps ? "NPS ON" : "NPS OFF"), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 10;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 11:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.healthcolor = !FlxG.save.data.healthcolor;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.healthcolor ? 'new healthbar on' : 'new healthbar off'), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 11;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 12:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.newhealthheadbump = !FlxG.save.data.newhealthheadbump;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.newhealthheadbump ? 'new healthhead bump on' : 'new healthhead bump off'), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 12;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 13:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.fps = !FlxG.save.data.fps;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF"), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 13;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
												(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
											case 14:
												FlxG.save.data.togglecap = !FlxG.save.data.togglecap;
												if (!FlxG.save.data.togglecap)
													{
														(cast (Lib.current.getChildAt(0), Main)).setFPSCap(138);
														FlxG.updateFramerate = 138;
														FlxG.drawFramerate = 138;
													}
												else if (FlxG.save.data.togglecap)
													{
														(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
														FlxG.updateFramerate = FlxG.save.data.fpsCap;
														FlxG.drawFramerate = FlxG.save.data.fpsCap;
													}
												grpControls.remove(grpControls.members[curSelected]);
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.togglecap ? "FPS CAP ON" : "FPS CAP OFF"), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 14;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
												trace("pressed");
											case 15:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.memoryMonitor = !FlxG.save.data.memoryMonitor;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.memoryMonitor ? "memoryMonitor ON" : "memoryMonitor OFF"), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 15;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
												(cast (Lib.current.getChildAt(0), Main)).togglememoryMonitor(FlxG.save.data.memoryMonitor);
											case 16:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.middlecam = !FlxG.save.data.middlecam;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.middlecam ? "camera focusing ON" : "camera focusing Off"), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 16;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 17:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.camfollowspeedon = !FlxG.save.data.camfollowspeedon;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.camfollowspeedon ? "Camera speed modif on" : "Camera speed modif off"), true, false);
												ctrl.x += 50;
												ctrl.y += 102;
												ctrl.targetY = curSelected - 17;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 18:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.enablesickpositions = !FlxG.save.data.enablesickpositions;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.enablesickpositions ? 'custom rating position on' : 'custom rating position off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 18;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 19:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.songinfo = !FlxG.save.data.songinfo;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.songinfo ? 'song info popup on' : 'song info popup off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 19;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 20:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.combotext = !FlxG.save.data.combotext;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.combotext ? 'combo text on' : 'combo text off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 20;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 21:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.combonumber = !FlxG.save.data.combonumber;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.combonumber ? 'combo counter on' : 'combo counter off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 20;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 22:
												LoadingStateRemovedSongs.loadAndSwitchState(new GameplayCustomizeState());
											case 23:
												FlxG.switchState(new ScoretextselectState());	
											case 24:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.minscore = !FlxG.save.data.minscore;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.minscore ? 'old scoretext on' : 'old scoretext off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 23;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 25:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.notesplashes = !FlxG.save.data.notesplashes;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.notesplashes ? 'notesplashes on' : 'notesplashes off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 24;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));	
											case 26:
												#if debug
												FlxG.switchState(new CharacterSelectState());
												#else
												FlxG.sound.play(Paths.sound('denied'));	
												#end
											case 27:
											FlxG.sound.play(Paths.sound('scrollMenu'));
											case 28:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.showratinggraphic = !FlxG.save.data.showratinggraphic;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.showratinggraphic ? 'show ratings on' : 'show ratings off'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 20;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));										   	
										}
									});	
							
					
			}

		
				
	}

	var isSettingControl:Bool = false;


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

	var accepted:Bool = true;
}
