package;

#if cpp
import Discord.DiscordClient;
#end
import flixel.addons.display.FlxBackdrop;
import openfl.Lib;
import Section.SwagSection;
import Controls.KeyboardScheme;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import lime.media.openal.ALSource;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	public static var isnotweb = true;
	public static var stage:String = 'stage';
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var addedbptext:Bool = false;
	public static var addedratingstext:Bool = false;
	public static var addedhealthbarshit:Bool = false;
	public static var addedsongpos:Bool = false;
	public static var reloadhealthbar:Bool = false;
	public static var reset:Bool = false;
	public static var countdownnow:Bool = false;
	public static var restartedarrows:Bool = true;
	public static var dontstopold:Bool = true;
	public var startTimer:FlxTimer;
	var onbeat:Bool = false; // set to true for bf to idle on beats only
	var shouldidleafterrelease:Bool = true; /// set this to false if you don't want boyfriend instantly going to idle after releasing a keypress from a sustain note. by default its true cuz of how default FNF does it. if its set to false, boyfriend will act more like how player 2 does. it really just depends on the chart.
	var oldidlecode:Bool = false; // set to true if you want the characters (player2) to run the old idling code.
	var donotidleinbetweenclosenotes:Bool = false; // set to true if you want boyfriend to not play the idle animation for a spit second inbetween notes.
	var CYAN:FlxColor = 0xFF00FFFF;
	public static var noteangle:Float;
	/// please add lua dude
	// shut the fuck up
	

	var halloweenLevel:Bool = false;
	public static var babyArrow:FlxSprite;
	public static var coolText:FlxText;
	public var Rating:String = "sick";
	

	public static var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	var trailon:Bool = false;
	var trail:FlxTrailArea;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public static var strumLine:FlxSprite;
	private var curSection:Int = 0;
	var songs:Array<String> = [];

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite>;
	public static var playerStrums:FlxTypedGroup<FlxSprite>;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;
	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	private var cpuNoteSplashes:FlxTypedGroup<NoteSplash>;
	private var shouldSplash:Bool = false;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	public static var generatedStaticArrows:Bool = false;
	public static var startTime = 0.0;
	public static var triggeredalready:Bool = false;

	private var camZooming:Bool = false;
	public static var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var highestcombo:Int = 0;
	private var combo:Int = 1;
	private var truecombo:Int = 0;
	private var misses:Int = 0;
	private var sicks:Int = 0;
	private var goods:Int = 0;
	private var bads:Int = 0;
	private var shits:Int = 0;
	

	public static var healthBarBG:FlxSprite;
	public static var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	public static var needstopitch:Bool = false;

	public static var iconP1:HealthIcon;
	public static var iconP2:HealthIcon;
	public static var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var totalPlayed:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	//var instold:String = SONG.song;
	var inst:String = Paths.inst(PlayState.SONG.song);
	var voices:String = Paths.voices(PlayState.SONG.song);
	public static var gamespeed:Float = FreeplayState.gamespeed;
	public static var resetalpha:Bool = false;
	public static var resetlength:Bool = false;
	public static var resetgamespeed:Bool = false;
	public static var altAnim:String = "";
	public static var altAnim2:String = "";
	public static var altAnim3:String = "";

	// no sex in this household
	// fr fr

	var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;
	var addedoffset:Bool = true;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var wiregroup:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var cityLights:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var camPos:FlxPoint;
	var lane:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var bg:FlxSprite;
	var fuckBackground:FlxSprite;
	var bgHex:FlxSprite;
	var stageFrontHex:FlxSprite;
	var whiteSquare:FlxSprite;
	var keyP:Bool = false;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	public static var moveminscore:Bool = true;
	public static var moveminscoreback:Bool = true;
	var accuracytext:FlxText;
	public static var sniperenginemark:FlxText;
	var botPlayState:FlxText;
	public static var downscrollbotplay:FlxText;
	public static var songlengthtext:FlxText;
	public static var version:FlxText;
	public static var nightlyandtest:FlxText;
	var ratings:FlxText;
	///that is alot of FlxTexts am i right
	//shut the fuck up
	public static var songInfo:FlxText;
	public static var songInfo2:FlxText;
	public static var blackBorder:FlxSprite;
	public static var blackBorder2:FlxSprite;
	var songwithoutdashes:String = '';
	var SONGISVALID:Bool = true;

	public static var campaignScore:Int = 0;
	public static var debug:Bool = false;
	public static var theFunne:Bool = true;
	public static var BOTPLAY:Bool = true;
	public static var blueballed:Int = 0;
	var notesHitArray:Array<Date> = [];
	var notesHit:Float = 0;
	var cpunotesHit:Float = 0;
	var notesnotmissed:Float = 0;
	var notesPassing:Float = 0;
	var baseText2:String = "N/A";
	var songRating:String = "?";
	var songRatingPsyche:String = "?";
	var fullcombotext:String = "N/A";
	var baseText:String = "N/A";
	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;
	var songName:FlxText;
	private var songPositionBar:Float = 0;
	var songLength:Float = 0;
	var yomamatime:Float = 0;
	var SFC:Bool = true;
	var GFC:Bool = true;
	var BFC:Bool = true;
	var fc:Bool = true;
	var daNote:Note;
	public var noteScore:Float = 1;
	public static var swagWidth:Float = 160 * 0.7;
	var doof:DialogueBox;
	var conducttext:FlxText;
	public static var triggeredcamera:Bool = false;
	var warningtext:FlxText;
	var ischeating:Bool = false;


	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var inCutscene:Bool = false;
	var usedTimeTravel:Bool = false;

	#if cpp
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	public static var botplayd:String = "";
	public static var practicemodeon:String = "";
	var detailsPausedText:String = "";
	public static var ratingsd:String = "";
	#end

	var BGSprite:FlxSprite;

	public var songStarted = false;

	override public function create()
	{
		ischeating = false;
		if (FlxG.save.data.botplay)
			SONGISVALID = false;
		#if web
		isnotweb = false;
		#end
		instance = this;
		resetalpha = false;
		resetlength = false;
		resetgamespeed = false;
		restartedarrows = true;
		dontstopold = true;
		reset = false;
		moveminscore = true;
		moveminscoreback =true;
		#if debug
		debug = true;
		#end
		addedratingstext = false;
		addedbptext = false;
		addedhealthbarshit = false;
		addedsongpos = false;
		paused = false;
		needstopitch = false;
		notesHit = 0;
		triggeredcamera = false;
		trailon = false;
		//blueballed = 0;
		if (!Settings.enablebotplay)
			FlxG.save.data.botplay = false;

		if (FreeplayState.gamespeed >= 0) // going under 0 freezes ur game
			FlxG.timeScale = FreeplayState.gamespeed;	
		else
			gamespeed = FreeplayState.gamespeed;

			if (FlxG.mouse.visible = true)
				FlxG.mouse.visible = false;


		    // this shit here loads our keybinds	
			controls.loadKeyBinds();
			PlayerSettings.player1.controls.loadKeyBinds();
			// load settings again just if they were changed
			Settings.loadsettings();
			botplaycheck();
			if (FlxG.save.data.songinfo)
			getsonginfo();

		if (FlxG.save.data.smoothanims)
			SONG.player1 = 'bf-smooth';	
		if (FlxG.save.data.sqishyanims)
			SONG.player1 = 'bf-sqishy';
					

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		if (FlxG.save.data.camHUDTRAN)
		    camHUD.alpha = FlxG.save.data.camHUDALPHA;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		camHUD.visible = true;	
				
		if (FlxG.save.data.cinematic)
			camHUD.visible = false;			

		sicks = 0;
		goods = 0;	
		bads = 0;	
		shits = 0;

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('test');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		/*#if windows
			sys.thread.Thread.create(() ->
			{
				antiCheat();
			});
			#end*/

		switch (SONG.song.toLowerCase())
		{
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		#if cpp
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = " (Easy)" + " | " + "Speed: " + FreeplayState.gamespeed;
			case 1:
				storyDifficultyText = " (Normal)" + " | " + "Speed: " + FreeplayState.gamespeed;
			case 2:
				storyDifficultyText = " (Hard)" + " | " + "Speed: " + FreeplayState.gamespeed;
		}

		iconRPC = SONG.player2;
		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (StoryMenuState.isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek + " | ";
		}
		else
		{
			detailsText = "Freeplay" + " | ";
		}

		if (FlxG.save.data.botplay)
			{
				botplayd = " | botplay";
			}
			else
				{
					botplayd = "";	
				}	

		if (PauseSubState.practicemode)
			{
				practicemodeon = " - (PRACTICE MODE)";
			}
			else
				{
					practicemodeon = "";	
				}
				
	
		if (FlxG.save.data.showratings)
			{
				ratingsd = " | Sicks: " + sicks + "\n" + "\n" + "Goods: " + goods + "\n" + "\n" + "Bads: " + bads + "\n" + "\n" + "Shits: " + shits + "\n" + "";
			}
			else
				{
					ratingsd = "";	
				}
					

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
		#end

	// defaults if no stage was found in chart
		if (SONG.stage == null)
		{
			switch (storyWeek)
			{
				case 2:
					stage = 'spooky';
				case 3:
					stage = 'philly';
				case 4:
					stage = 'limo';
				case 5:
					if (SONG.song.toLowerCase() == 'winter-horrorland')
					{
						stage = 'mallEvil';
					}
					else
					{
						stage = 'mall';
					}
				case 6:
					if (SONG.song.toLowerCase() == 'thorns')
					{
						stage = 'schoolEvil';
					}
					else
					{
						stage = 'school';
					}
					// i should check if its stage (but this is when none is found in chart anyway)
			}
		}
		else
		{
			stage = SONG.stage;
		}

		//switch (SONG.song.toLowerCase())
		  switch (SONG.stage)
		{
                        case 'spooky': 
                        {
                                curStage = 'spooky';
	                          halloweenLevel = true;
							 
								var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

	                          halloweenBG = new FlxSprite(-200, -100);
		                      halloweenBG.frames = hallowTex;
	                          halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	                          halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	                          halloweenBG.animation.play('idle');
							  if (FlxG.save.data.antialiasing)
							      halloweenBG.antialiasing = true;
	                          add(halloweenBG);

		                  isHalloween = true;
		          }
		          case 'philly': 
                        {
		                  curStage = 'philly';

		                  var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
		                  bg.scrollFactor.set(0.1, 0.1);
						  if (FlxG.save.data.antialiasing)
						      bg.antialiasing = true;
		                  add(bg);

	                          var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
		                  city.scrollFactor.set(0.3, 0.3);
		                  city.setGraphicSize(Std.int(city.width * 0.85));
		                  city.updateHitbox();
						  if (FlxG.save.data.antialiasing)
						      city.antialiasing = true;
		                  add(city);

		                  phillyCityLights = new FlxTypedGroup<FlxSprite>();
		                  add(phillyCityLights);
						  if (FlxG.save.data.optimizations)
							{
								var cityLights:FlxSprite = new FlxSprite().loadGraphic(Paths.image('philly/win0', 'week3'));
								cityLights.scrollFactor.set(0.3, 0.3);
								cityLights.visible = true;
								cityLights.setGraphicSize(Std.int(cityLights.width * 0.85));
								cityLights.updateHitbox();
								add(cityLights);
								if (FlxG.save.data.antialiasing)
								    cityLights.antialiasing = true;
							}
							else
								{
									for (i in 0...5)
										{
												var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
												light.scrollFactor.set(0.3, 0.3);
												light.visible = false;
												light.setGraphicSize(Std.int(light.width * 0.85));
												light.updateHitbox();
												if (FlxG.save.data.antialiasing)
												    light.antialiasing = true;
												phillyCityLights.add(light);
										}
								}

		                  var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
						  if (FlxG.save.data.antialiasing)
						      streetBehind.antialiasing = true;
		                  add(streetBehind);

	                          phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
							  if (FlxG.save.data.antialiasing)
							      phillyTrain.antialiasing = true;
		                      add(phillyTrain);

		                  trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'shared'));
		                  FlxG.sound.list.add(trainSound);

		                  // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		                  var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
						  if (FlxG.save.data.antialiasing)
						      street.antialiasing = true;
	                      add(street);
		          }
		          case 'limo':
		          {
		                  curStage = 'limo';
		                  defaultCamZoom = 0.90;

		                  var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
		                  skyBG.scrollFactor.set(0.1, 0.1);
						  if (FlxG.save.data.antialiasing)
						      skyBG.antialiasing = true;
		                  add(skyBG);

		                  var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		                  bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
		                  bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
		                  bgLimo.animation.play('drive');
		                  bgLimo.scrollFactor.set(0.4, 0.4);
						  if (FlxG.save.data.antialiasing)
						      bgLimo.antialiasing = true;
		                  add(bgLimo);

		                  grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		                  add(grpLimoDancers);

		                  for (i in 0...5)
		                  {
		                          var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		                          dancer.scrollFactor.set(0.4, 0.4);
		                          grpLimoDancers.add(dancer);
		                  }

		                  var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
		                  overlayShit.alpha = 0.5;
		                  // add(overlayShit);

		                  // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

		                  // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

		                  // overlayShit.shader = shaderBullshit;

		                  var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

		                  limo = new FlxSprite(-120, 550);
		                  limo.frames = limoTex;
		                  limo.animation.addByPrefix('drive', "Limo stage", 24);
		                  limo.animation.play('drive');
						  if (FlxG.save.data.antialiasing)
						      limo.antialiasing = true;

		                  fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
						  if (FlxG.save.data.antialiasing)
						      fastCar.antialiasing = true;
		                  // add(limo);
		          }
		          case 'mall':
		          {
	                          curStage = 'mall';

		                  defaultCamZoom = 0.80;

		                  var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('bgWalls', 'week5'));
						  if (FlxG.save.data.antialiasing)
						      bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);
						  
						  upperBoppers = new FlxSprite(-240, -90);
						  upperBoppers.frames = Paths.getSparrowAtlas('upperBop', 'week5');
						  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						  if (FlxG.save.data.antialiasing)
						      upperBoppers.antialiasing = true;
						  upperBoppers.scrollFactor.set(0.33, 0.33);
						  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
						  upperBoppers.updateHitbox();
						  add(upperBoppers);
								

		                  var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('bgEscalator', 'week5'));
						  if (FlxG.save.data.antialiasing)
						      bgEscalator.antialiasing = true;
		                  bgEscalator.scrollFactor.set(0.3, 0.3);
		                  bgEscalator.active = false;
		                  bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		                  bgEscalator.updateHitbox();
		                  add(bgEscalator);

		                  var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmasTree', 'week5'));
						  if (FlxG.save.data.antialiasing)
						      tree.antialiasing = true;
		                  tree.scrollFactor.set(0.40, 0.40);
		                  add(tree);
                          
						  bottomBoppers = new FlxSprite(-300, 140);
					      bottomBoppers.frames = Paths.getSparrowAtlas('bottomBop', 'week5');
						  bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						  if (FlxG.save.data.antialiasing)
							  bottomBoppers.antialiasing = true;
						  bottomBoppers.scrollFactor.set(0.9, 0.9);
						  bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						  bottomBoppers.updateHitbox();
						  add(bottomBoppers);

		                  var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('fgSnow', 'week5'));
		                  fgSnow.active = false;
						  if (FlxG.save.data.antialiasing)
						      fgSnow.antialiasing = true;
		                  add(fgSnow);
						  
                                    santa = new FlxSprite(-840, 150);
		                  santa.frames = Paths.getSparrowAtlas('santa', 'week5');
		                  santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
						  if (FlxG.save.data.antialiasing)
						      santa.antialiasing = true;
		                  add(santa);
		          }
		          case 'mallEvil':
		          {
		                  curStage = 'mallEvil';
		                  var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('evilBG', 'week5'));
						  if (FlxG.save.data.antialiasing)
						      bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
		                  add(bg);

		                  var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('evilTree', 'week5'));
						  if (FlxG.save.data.antialiasing)
						      evilTree.antialiasing = true;
		                  evilTree.scrollFactor.set(0.2, 0.2);
		                  add(evilTree);

		                  var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("evilSnow", 'week5'));
							  if (FlxG.save.data.antialiasing)
							      evilSnow.antialiasing = true;
		                  add(evilSnow);
                        }
		          case 'school':
		          {
		                  curStage = 'school';

		                  // defaultCamZoom = 0.9;

		                  var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'shared'));
		                  bgSky.scrollFactor.set(0.1, 0.1);
		                  add(bgSky);

		                  var repositionShit = -200;

		                  var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'shared'));
		                  bgSchool.scrollFactor.set(0.6, 0.90);
		                  add(bgSchool);

		                  var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'shared'));
		                  bgStreet.scrollFactor.set(0.95, 0.95);
		                  add(bgStreet);

		                  var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'shared'));
		                  fgTrees.scrollFactor.set(0.9, 0.9);
		                  add(fgTrees);

		                  var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
		                  var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'shared');
		                  bgTrees.frames = treetex;
		                  bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		                  bgTrees.animation.play('treeLoop');
		                  bgTrees.scrollFactor.set(0.85, 0.85);
		                  add(bgTrees);

		                  var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
		                  treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'shared');
		                  treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		                  treeLeaves.animation.play('leaves');
		                  treeLeaves.scrollFactor.set(0.85, 0.85);
		                  add(treeLeaves);

		                  var widShit = Std.int(bgSky.width * 6);

		                  bgSky.setGraphicSize(widShit);
		                  bgSchool.setGraphicSize(widShit);
		                  bgStreet.setGraphicSize(widShit);
		                  bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		                  fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		                  treeLeaves.setGraphicSize(widShit);

		                  fgTrees.updateHitbox();
		                  bgSky.updateHitbox();
		                  bgSchool.updateHitbox();
		                  bgStreet.updateHitbox();
		                  bgTrees.updateHitbox();
		                  treeLeaves.updateHitbox();
						  bgGirls = new BackgroundGirls(-100, 190);
						  bgGirls.scrollFactor.set(0.9, 0.9);
						  bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
						  bgGirls.updateHitbox();
						  add(bgGirls);		
		                  if (SONG.song.toLowerCase() == 'roses')
						      bgGirls.getScared();
		                      
		          }
		          case 'schoolEvil':
		          {
		                  curStage = 'schoolEvil';

		                  var posX = 400;
	                      var posY = 200;

		                  var bg:FlxSprite = new FlxSprite(posX, posY);
		                  bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'shared');
		                  bg.animation.addByPrefix('idle', 'background 2', 24);
		                  bg.animation.play('idle');
		                  bg.scrollFactor.set(0.8, 0.9);
		                  bg.scale.set(6, 6);
		                  add(bg);
				  }
		          default:
		          {
		                  defaultCamZoom = 0.9;
		                  curStage = 'stage';
		                  var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		                  bg.scrollFactor.set(0.9, 0.9);
						  if (FlxG.save.data.antialiasing)
						      bg.antialiasing = true;
		                  add(bg);

		                  var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		                  stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		                  stageFront.updateHitbox();
						  if (FlxG.save.data.antialiasing)
						      stageFront.antialiasing = true;
		                  stageFront.scrollFactor.set(0.9, 0.9);
		                  stageFront.active = false;
		                  add(stageFront);

		                  var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		                  stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		                  stageCurtains.updateHitbox();
						  if (FlxG.save.data.antialiasing)
						      stageCurtains.antialiasing = true;
		                  stageCurtains.scrollFactor.set(1.3, 1.3);
		                  stageCurtains.active = false;

		                  add(stageCurtains);
		          }
				  case 'void':
		          {
		                  defaultCamZoom = 0.9;
		                  curStage = 'stage';
		                  whiteSquare.makeGraphic(-600, 200, FlxColor.WHITE);
		                  whiteSquare.scrollFactor.set(0.9, 0.9);
						  if (FlxG.save.data.antialiasing)
						      whiteSquare.antialiasing = true;
		                  add(whiteSquare);
		          }	   	   
              }


		gf = new Character(400, 130, SONG.gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

				
		dad = new Character(100, 100, SONG.player2);
				

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (curSong.toLowerCase() == 'tutorial')
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bf-pixel':
				dad.y += 480;
		}
		
     boyfriend = new Boyfriend(770, 450, SONG.player1);
        // REPOSITIONING PER STAGE

		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.4, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);
		trail = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.6, 14, false, true, null);
		trail.add(dad);
		trail.redMultiplier = 1;
		trail.blueMultiplier = 1;
		trail.visible = false;
		trail.x = dad.x + 50;
		add(trail);
		add(dad);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

				
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		Conductor.songPosition = -5000;
                                  ///50
		//strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine = new FlxSprite(100, 50).makeGraphic(100, 10);
		//strumLine.x = 50;
		strumLine.x = 100;	
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;
        if (FlxG.save.data.middlescrollBG && FlxG.save.data.middlescroll)
			{
				lane = new FlxSprite(396, 50 - 100).makeGraphic((Std.int(strumLine.width + 380)),Std.int(strumLine.height + 900),FlxColor.BLACK);
				lane.alpha = FlxG.save.data.middlescrollalpha;
				lane.cameras = [camHUD];
				add(lane);
			}


		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();
		if (FlxG.save.data.notesplashes)
			{
				grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

				var sploosh = new NoteSplash(100, 100, 0);
				sploosh.alpha = 0.1;
		
				grpNoteSplashes.add(sploosh);
				add(grpNoteSplashes);
			}

        if (FlxG.save.data.cpunotesplashes && FlxG.save.data.notesplashes)
			{
				cpuNoteSplashes = new FlxTypedGroup<NoteSplash>();

				var sploosh = new NoteSplash(100, 100, 0);
				sploosh.alpha = 0.1;
		
				cpuNoteSplashes.add(sploosh);
				add(cpuNoteSplashes);
			}
           if (StoryMenuState.isStoryMode)
			{
				switch (SONG.noteskin)
				{
				  case "pixel":
				  case "default":
				  generateStaticArrows(0);
				  generateStaticArrows(1);
				  default:
				  generateStaticArrows(0);
				  generateStaticArrows(1);
				}
			}
			else
				{
					generateStaticArrows(0);
					generateStaticArrows(1);	
				}

			if (SONG.hasshader)
			{
				var customShader = new CustomShader();
				//var customShader = new LuaShader(PlayState.SONG.fragcode, PlayState.SONG.vertexcode);
				var shaderFilter = new ShaderFilter(customShader);
				camHUD.setFilters([shaderFilter]);
				trace('SHADER ADDED');
			}


		// startCountdown();

		generateSong(SONG.song);

		if (SONG.song == null)
			trace('SONG IS NULL!?!?!?!?!?!??!?!?!?!');

		// add(strumLine)

		var index = 0;

		if (startTime != 0 || ChartingState.startfrompos)
		{
			var toBeRemoved = [];
			for (i in 0...unspawnNotes.length)
			{
				var dunceNote:Note = unspawnNotes[i];

				if (dunceNote.strumTime <= startTime)
					toBeRemoved.push(dunceNote);
			}

			for (i in toBeRemoved)
				unspawnNotes.remove(i);

		}

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		if (FlxG.save.data.camfollowspeedon)
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / FlxG.save.data.camfollowspeed));
		else	
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		/// greetings kadedevoloper
		///FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition)  // I dont wanna talk about this code :( // its ok buddy you don't have to
			{
				songPosBG = new FlxSprite(0, 22).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				songPosBG.alpha = 0;
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
				songPosBar.alpha = 0;
				add(songPosBar);

				if (FlxG.save.data.downscroll)
				songlengthtext = new FlxText(550, 700, "", 20);
				else
				songlengthtext = new FlxText(550, 23, "", 20);
				songlengthtext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				songlengthtext.scrollFactor.set();
				if (FlxG.save.data.antialiasing)
				    songlengthtext.antialiasing = false;
	          addedsongpos = true;
			}
	
				
		if (FlxG.save.data.downscroll)
			{
				if (FlxG.save.data.minscore)
				scoreTxt = new FlxText(500, 100, "", 20);
	        	else
				scoreTxt = new FlxText(0, 100, FlxG.width, "", 20);
				if (FlxG.save.data.minscore)
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
				else
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				//scoreTxt.autoSize = false;
				//scoreTxt.alignment = CENTER;
				
				if (FlxG.save.data.antialiasing)
				    scoreTxt.antialiasing = false;
					add(scoreTxt);
			}
				else
				{
					if (FlxG.save.data.minscore)
					scoreTxt = new FlxText(500, 698, "", 20);
					else
					scoreTxt = new FlxText(0, 695, FlxG.width, "", 20);
					if (FlxG.save.data.minscore)
					scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
					else
					scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					scoreTxt.scrollFactor.set();
					if (FlxG.save.data.antialiasing)
					    scoreTxt.antialiasing = false;
						add(scoreTxt);
				}
				#if debug
				conducttext = new FlxText(500, 500, 'Pos: ' + Conductor.songPosition + "\n" + "Step: " + curStep + "\n" + 'Beat: ' + curBeat, 20);
				add(conducttext);
				#end
		scoreTxt.cameras = [camHUD];
		if (FlxG.save.data.showratings)
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition && addedsongpos)
			{
				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
			}	
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		if (FlxG.save.data.notesplashes)
		grpNoteSplashes.cameras = [camHUD];
		if (FlxG.save.data.cpunotesplashes && FlxG.save.data.notesplashes)
		cpuNoteSplashes.cameras = [camHUD];
		startingSong = true;

	if (FlxG.save.data.songinfo)
	{
		songInfo = new FlxText(20, 15, 0, "", 32);
		songInfo.text += songwithoutdashes;
		songInfo.scrollFactor.set();
		songInfo.setFormat(Paths.font("vcr.ttf"), 32);
		songInfo.updateHitbox();
		songInfo.alpha = 0;
		songInfo.x = FlxG.width - (songInfo.width + 20);
		songInfo.cameras = [camHUD];

		songInfo2 = new FlxText(20, 50, 0, "", 20);
		songInfo2.text += 'Composed by ' + SONG.composer;
		songInfo2.scrollFactor.set();
		songInfo2.setFormat(Paths.font("vcr.ttf"), 20);
		songInfo2.updateHitbox();
		songInfo2.alpha = 0;
		songInfo2.x = FlxG.width - (songInfo2.width + 20);
		songInfo2.cameras = [camHUD];
		
		blackBorder = new FlxSprite(songInfo2.x, 20).makeGraphic((Std.int(songInfo2.width + 50)),Std.int(songInfo2.height + 40),FlxColor.BLACK);
		blackBorder.alpha = 0;
		blackBorder.cameras = [camHUD];
		
		add(blackBorder);
		add(songInfo);
		add(songInfo2);
	}

		if (StoryMenuState.isStoryMode)
		{
				{
					if (!ischeating)
						{
							switch (curSong.toLowerCase())
							{
									
									case "winter-horrorland":
										var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
										add(blackScreen);
										blackScreen.scrollFactor.set();
										camHUD.visible = false;
						
										new FlxTimer().start(0.1, function(tmr:FlxTimer)
										{
											remove(blackScreen);
											FlxG.sound.play(Paths.sound('Lights_Turn_On'));
											camFollow.y = -2050;
											camFollow.x += 200;
											FlxG.camera.focusOn(camFollow.getPosition());
											FlxG.camera.zoom = 1.5;
						
											new FlxTimer().start(0.8, function(tmr:FlxTimer)
											{
												if (FlxG.save.data.cinematic)
												    camHUD.visible = false;
													else
													    camHUD.visible = true;
													
												remove(blackScreen);
												FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
													ease: FlxEase.quadInOut,
													onComplete: function(twn:FlxTween)
													{
														startCountdown();
													}
												});
											});
										});
									case 'senpai':
										schoolIntro(doof);
									case 'roses':
										if (FlxG.save.data.usedeprecatedloading)
										FlxG.sound.play(Paths.sound('ANGRY'));
										else
											{
												new FlxTimer().start(0.15, function(tmr:FlxTimer)
													{
													FlxG.sound.play(Paths.sound('ANGRY'));
													});
											}
										schoolIntro(doof);
									case 'thorns':
										schoolIntro(doof);
									default:
										startCountdown();
									
							}
						}
				}
		}
		else
			{
				if (!ischeating)
					{
						switch (curSong.toLowerCase())
						{	
							default:
							startCountdown();	
						}
					}
			}

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		if (!ischeating)
			{
				inCutscene = true;
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				add(black);
		
				var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
				red.scrollFactor.set();
		
				var senpaiEvil:FlxSprite = new FlxSprite();
				senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
				senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
				senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
				senpaiEvil.scrollFactor.set();
				senpaiEvil.updateHitbox();
				senpaiEvil.screenCenter();
		
				if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
				{
					remove(black);
		
					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(red);
						inCutscene = true;
					}
				}
		
		
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
		
					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
						{
		
							if (SONG.song.toLowerCase() == 'thorns')
							{
								add(senpaiEvil);
								senpaiEvil.alpha = 0;
								new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
								{
									senpaiEvil.alpha += 0.15;
									if (senpaiEvil.alpha < 1)
									{
										swagTimer.reset();
									}
									else
									{
										senpaiEvil.animation.play('idle');
										FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
										{
											remove(senpaiEvil);
											remove(red);
											FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
											{
												add(dialogueBox);
											}, true);
										});
										new FlxTimer().start(3.2, function(deadTime:FlxTimer)
										{
											FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
										});
									}
								});
							}
							else
							{
								add(dialogueBox);
							}
						}
						else
							startCountdown();
		
						remove(black);
					}
				});		
			}
	}

	var perfectMode:Bool = false;
	public var restartedSong:Bool = false;

	public function restart()
	{
		ChartingState.startfrompos = false;
		if (FlxG.sound.music.playing)
			FlxG.sound.music.stop();
		if (vocals.playing)
			vocals.stop();
		Conductor.songPosition = 0;
		restartedSong = true;
		startedCountdown = false;
		boyfriend.stunned = false;
		persistentUpdate = true;
		persistentDraw = true;
		paused = false;
		if (storyWeek == 3)
			trainReset();
		for (i in members)
		{
			remove(i);
		}
		triggeredalready = false;
		songScore = 0;
		unspawnNotes = [];
		notes.clear();
		totalNotesHit = 0;
		notesHit = 0;
		totalPlayed = 0;
		songTime = 0;
		combo = 1;
		truecombo = 0;
		highestcombo = 0;
		accuracy = 0;
		baseText2 = "N/A";
		baseText = "N/A";
		songRating = "?";
		notesPassing = 0;
		if (FlxG.save.data.pscyheenginescoretext)
		songRatingPsyche = "?";
		startingSong = false;
		misses = 0;
		health = 1;
		fc = true;
		SFC = true;
		GFC = true;
		BFC = true;
		sicks = 0;
		goods = 0;	
		bads = 0;	
		shits = 0;
		defaultstagezoom();
		if (FlxG.save.data.songinfo)
		getsonginfo();
		prevCamFollow = camFollow;
		trailon = false;
		create();
	}

	public function repeat()
		{
			ChartingState.startfrompos = false;
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();
			if (vocals.playing)
				vocals.stop();
			Conductor.songPosition = 0;
			restartedSong = true;
			startedCountdown = false;
			boyfriend.stunned = false;
			persistentUpdate = true;
			persistentDraw = true;
			paused = false;
			if (storyWeek == 3)
				trainReset();
			for (i in members)
			{
				remove(i);
			}
			songScore = 0;
			unspawnNotes = [];
			notes.clear();
			totalNotesHit = 0;
			totalPlayed = 0;
			notesHit = 0;
			songTime = 0;
			combo = 1;
			truecombo = 0;
			highestcombo = 0;
			accuracy = 0;
			baseText2 = "N/A";
			baseText = "N/A";
			songRating = "?";
			notesPassing = 0;
			if (FlxG.save.data.pscyheenginescoretext)
			songRatingPsyche = "?";
			startingSong = false;
			misses = 0;
			health = 1;
			fc = true;
			SFC = true;
			GFC = true;
			BFC = true;
			sicks = 0;
			goods = 0;	
			bads = 0;	
			shits = 0;
			trailon = false;
			defaultstagezoom();
			prevCamFollow = camFollow;
	
			create();
		}

	public function loadnextsong()
		{
			ChartingState.startfrompos = false;
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();
			if (vocals.playing)
				vocals.stop();
			Conductor.songPosition = 0;
			startedCountdown = false;
			boyfriend.stunned = false;
			persistentUpdate = true;
			persistentDraw = true;
			paused = false;
			triggeredalready = false;
			for (i in members)
			{
				remove(i);
			}
			if (storyWeek == 3)
				trainReset();
			songScore = 0;
			unspawnNotes = [];
			notes.clear();
			totalNotesHit = 0;
			totalPlayed = 0;
			songTime = 0;
			combo = 1;
			truecombo = 0;
			highestcombo = 0;
			accuracy = 0;
			baseText2 = "N/A";
			baseText = "N/A";
			songRating = "?";
			startingSong = false;
			misses = 0;
			health = 1;
			fc = true;
			SFC = true;
			GFC = true;
			BFC = true;
			sicks = 0;
			goods = 0;	
			bads = 0;	
			shits = 0;
			notesPassing = 0;
			var difficulty:String = "";
			
			if (storyDifficulty == 0)
			difficulty = '-easy';
			
			if (storyDifficulty == 2)
				difficulty = '-hard';
			
			
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				prevCamFollow = camFollow;
			
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);

				if (SONG == null)
					SONG = Song.loadFromJson('test');
		
				Conductor.mapBPMChanges(SONG);
				Conductor.changeBPM(SONG.bpm);
		
				switch (SONG.song.toLowerCase())
				{
					case 'senpai':
						dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
					case 'roses':
						dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
					case 'thorns':
						dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
				}
		
				#if cpp
				// Making difficulty text for Discord Rich Presence.
				switch (storyDifficulty)
				{
					case 0:
						storyDifficultyText = "Easy";
					case 1:
						storyDifficultyText = "Normal";
					case 2:
						storyDifficultyText = "Hard";
				}
		
				iconRPC = SONG.player2;
				// To avoid having duplicate images in Discord assets
				switch (iconRPC)
				{
					case 'senpai-angry':
						iconRPC = 'senpai';
					case 'monster-christmas':
						iconRPC = 'monster';
					case 'mom-car':
						iconRPC = 'mom';
				}
		
				// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
				if (StoryMenuState.isStoryMode)
				{
					detailsText = "Story Mode: Week " + storyWeek;
				}
				else
				{
					detailsText = "Freeplay";
				}
		
				// String for when the game is paused
				detailsPausedText = "Paused - " + detailsText;
				
				// Updating Discord Rich Presence.
				DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
				#end
				defaultstagezoom();
				if (FlxG.save.data.songinfo)
				getsonginfo();
			create();
		}

	function startCountdown():Void
	{
		if (!ischeating)
			{
				inCutscene = false;
				talking = false;
				startedCountdown = true;
				Conductor.songPosition = 0;
				Conductor.songPosition -= Conductor.crochet * 5;
				var swagCounter:Int = 0;
		
				startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
				{
					if (!dad.animation.curAnim.name.startsWith('sing'))
					dad.dance();
					gf.dance();
					if (!boyfriend.animation.curAnim.name.startsWith('sing'))
					boyfriend.playAnim('idle');		
		
					var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
					introAssets.set('default', ['ready', "set", "go"]);
					introAssets.set('school', [
						'weeb/pixelUI/ready-pixel',
						'weeb/pixelUI/set-pixel',
						'weeb/pixelUI/date-pixel'
					]);
					introAssets.set('schoolEvil', [
						'weeb/pixelUI/ready-pixel',
						'weeb/pixelUI/set-pixel',
						'weeb/pixelUI/date-pixel'
					]);
		
					var introAlts:Array<String> = introAssets.get('default');
					var altSuffix:String = "";
		
					for (value in introAssets.keys())
					{
						if (value == curStage)
						{
							introAlts = introAssets.get(value);
							altSuffix = '-pixel';
						}
					}
		
					switch (swagCounter)
		
					{
						case 0:
							FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
						case 1:
							var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
							ready.scrollFactor.set();
							ready.updateHitbox();
		
							if (SONG.noteskin == 'pixel')
								ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
		
							///ready.screenCenter();
							ready.screenCenter(X);
							ready.screenCenter(Y);
							add(ready);
							FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									ready.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
						case 2:
							var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
							set.scrollFactor.set();
		
							if (SONG.noteskin == 'pixel')
								set.setGraphicSize(Std.int(set.width * daPixelZoom));
		
							///set.screenCenter();
							set.screenCenter(X);
							set.screenCenter(Y);
							add(set);
							FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									set.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
						case 3:
							var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
							go.scrollFactor.set();
		
							if (SONG.noteskin == 'pixel')
								go.setGraphicSize(Std.int(go.width * daPixelZoom));
		
							go.updateHitbox();
		
							///go.screenCenter();
							go.screenCenter(X);
							go.screenCenter(Y);
							add(go);
							FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									go.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
						case 4:
							FlxG.sound.music.volume = 1;
							vocals.volume = 1;
							canPause = true;
					}
		
					swagCounter += 1;
				}, 5);
			}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	public static var songMultiplier = 1.0;
	///default: 1.0

	/*#if windows
	function antiCheat()
	{
		var output = new sys.io.Process("tasklist", []).stdout.readAll().toString().toLowerCase();
		var blockedShit:Array<String> = ["fnfbot.exe", "fnfbot20.exe", "Friday Night Fakin'.exe", "fnfbot720p.exe", "Friday Night Funkin' Bot.exe", "FNF.exe"];

		trace('checkin for smth sussy');

		for (cheat in blockedShit)
		{
			if (output.contains(cheat))
			{
				ischeating = true;
				canPause = true;
				warningtext = new FlxText(400, 300, 0, "Please disable all cheats on your system.", 32);
				warningtext.scrollFactor.set();
				warningtext.setFormat(Paths.font("vcr.ttf"), 32);
				warningtext.updateHitbox();
				warningtext.alpha = 1;
				warningtext.screenCenter();
				warningtext.cameras = [camHUD];
				blackBorder2 = new FlxSprite(400, 300).makeGraphic((Std.int(warningtext.width)),Std.int(warningtext.height + 40),FlxColor.BLACK);
				blackBorder2.alpha = 0.6;
				blackBorder2.cameras = [camHUD];	
				blackBorder2.screenCenter();
				add(blackBorder2);
				add(warningtext);
			}
		}
	}
	#end*/

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		if (FlxG.timeScale == 1)
		FlxG.sound.music.onComplete = endSong;
		if (!paused)
		vocals.play();
		songLength = FlxG.sound.music.length;
		if (vocals != null)
			vocals.time = startTime;
		Conductor.songPosition = startTime;
		startTime = 0;
		if (ChartingState.startfrompos)
			{
				startTime = ChartingState.startpos;
				Conductor.songPosition = startTime;
			}

			if (FlxG.save.data.songPosition && addedsongpos)
				{
					remove(songPosBG);
					remove(songPosBar);
	
					songPosBG = new FlxSprite(0, 22).loadGraphic(Paths.image('healthBar'));
					if (FlxG.save.data.downscroll)
						songPosBG.y = FlxG.height * 0.9 + 45; 
					songPosBG.screenCenter(X);
					songPosBG.scrollFactor.set();
					add(songPosBG);
	
					songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
						'songPositionBar', 0, songLength - 1000);
					songPosBar.numDivisions = 1000;
					songPosBar.scrollFactor.set();
					songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
					add(songPosBar);
					if (FlxG.save.data.downscroll)
					songlengthtext = new FlxText(600, 700, "", 20);
					else
					songlengthtext = new FlxText(600, 23, "", 20);
				    songlengthtext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				    songlengthtext.scrollFactor.set();
				    if (FlxG.save.data.antialiasing)
						songlengthtext.antialiasing = false;
					add(songlengthtext);
		
	
					songPosBG.cameras = [camHUD];
					songPosBar.cameras = [camHUD];
					songlengthtext.cameras = [camHUD];
				}
		#if cpp
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			{
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				//trace('vocals loaded');
				//trace('INFOMATION ABOUT WAT U PLAYIN WIT:' + '\nOFFSET: ' + FlxG.save.data.offset + '\nSONG: ' + SONG.song + '\nSTAGE: ' + curStage + '\nDIFFICULTY: ' + PlayState.storyDifficulty + '\nP1: ' + SONG.player1 + '\nP2: ' + SONG.player2 + '\nTS: ' + Conductor.timeScale + '\nBOTPLAY: ' + FlxG.save.data.botplay);
			}
		else
			{
				vocals = new FlxSound();
			}

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + FlxG.timeScale - 1;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;


				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.altNote = songNotes[3];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public static function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			if (FlxG.save.data.middlescroll)              ///0
			babyArrow = new FlxSprite(-278, strumLine.y);
			else
			babyArrow = new FlxSprite(35, strumLine.y);	

			switch (SONG.noteskin)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

			        case 'default':
					if (FlxG.save.data.downscroll)
						{
							babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_downscroll');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
							if (FlxG.save.data.antialiasing)
								babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
							switch (Math.abs(i))
							{
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
						}
						else
							{
								babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
								babyArrow.animation.addByPrefix('green', 'arrowUP');
								babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
								babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
								babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
			
								if (FlxG.save.data.antialiasing)
								    babyArrow.antialiasing = true;
								babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			
								switch (Math.abs(i))
								{
									case 0:
										babyArrow.x += Note.swagWidth * 0;
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									case 1:
										babyArrow.x += Note.swagWidth * 1;
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									case 2:
										babyArrow.x += Note.swagWidth * 2;
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									case 3:
										babyArrow.x += Note.swagWidth * 3;
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
							}		

				    default:
					if (FlxG.save.data.downscroll)
						{
							babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_downscroll');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
							if (FlxG.save.data.antialiasing)
							    babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
							switch (Math.abs(i))
							{
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
						}
						else
							{
								babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
								babyArrow.animation.addByPrefix('green', 'arrowUP');
								babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
								babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
								babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
			
								if (FlxG.save.data.antialiasing)
								    babyArrow.antialiasing = true;
								babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			
								switch (Math.abs(i))
								{
									case 0:
										babyArrow.x += Note.swagWidth * 0;
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									case 1:
										babyArrow.x += Note.swagWidth * 1;
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									case 2:
										babyArrow.x += Note.swagWidth * 2;
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									case 3:
										babyArrow.x += Note.swagWidth * 3;
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
							}

			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!StoryMenuState.isStoryMode && !FlxG.save.data.repeat)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;
			

			switch (player)
			{
				case 0:
				    cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			cpuStrums.forEach(function(spr:FlxSprite)
				{					
					spr.centerOffsets(); //CPU arrows start out slightly off-center
				});


			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			generatedStaticArrows = true;
		}
	}


	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	function tweenCamInSlow():Void
		{
			FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
		}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null)
				if (!startTimer.finished)
					startTimer.active = false;
		}


		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}
			
			if (FlxG.save.data.camHUDTRAN)
				camHUD.alpha = FlxG.save.data.camHUDALPHA;

			if (startTimer != null)
				if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			playerStrums.forEach(function(spr:FlxSprite)
				{
					
							if (spr.animation.curAnim.name != 'confirm')
								{		
											spr.animation.play('static');
											spr.centerOffsets();
								}

								if (spr.animation.curAnim.name != 'pressed')
									{		
												spr.animation.play('static');
												spr.centerOffsets();
									}
				});

			#if cpp
			if (!ischeating)
				{
					if (startTimer.finished)
						{
						DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses , iconRPC, true, songLength - Conductor.songPosition);
						}
						else
						{
						DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
						}
				}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if cpp
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
			DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
			DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if cpp
		if (health > 0 && !paused)
		{
		DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
		/*#if cpp
		if (FlxG.timeScale != 1)
			{
				if (FreeplayState.gamespeed > 1)
					{
						@:privateAccess
						{
							if (FlxG.sound.music.playing)
							lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
							if (vocals.playing)
								lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
							//me looking for a way to pitch vocals without cpp
						}
						///trace("pitched inst and vocals to " + FlxG.timeScale);
					 
					}			
		

		if (FreeplayState.gamespeed < 1)
			{
				{
					@:privateAccess
					{
						if (FlxG.sound.music.playing)
						lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
						if (vocals.playing)
							lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
						//me looking for a way to pitch vocals without cpp
					}
					///trace("pitched inst and vocals to " + gamespeed);
				}
			}
			}
		#end*/	
	}

	public static var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;


	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end


		if (dad.animation.curAnim.name.startsWith('sing') && dad.animation.curAnim.finished)
			{
				dad.dance();
			}

			#if debug
			if (songStarted && !endingSong)
            conducttext.text = 'Pos: ' + Conductor.songPosition + "\n" + "Step: " + curStep + "\n" + 'Beat: ' + curBeat;
			#end


		if (FlxG.save.data.middlescroll)
			{
				for (str in cpuStrums){
					str.alpha = 0;
				}
			}

				if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (trail.x < -150 && trailon)
							trail.x = dad.x + 50;
					}

			#if debug
		if (FlxG.keys.justPressed.C)
			{
				FlxG.camera.zoom += 0.1;
				defaultCamZoom += 0.1;
				camHUD.zoom += 0.1;
			}


			if (FlxG.keys.justPressed.V)
				{
					FlxG.camera.zoom -= 0.1;
					defaultCamZoom -= 0.1;
					camHUD.zoom -= 0.1;
				}
				#end

			if (FlxG.save.data.botplay && !addedbptext)
				{
					
						{
							downscrollbotplay = new FlxText(1206,2,"BOTPLAY", 12);
							downscrollbotplay.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
							downscrollbotplay.scrollFactor.set();
							if (FlxG.save.data.antialiasing)
							    downscrollbotplay.antialiasing = false;
							add(downscrollbotplay);
							addedbptext = true;
							downscrollbotplay.cameras = [camHUD];
						}
				}
				else if (addedbptext && !FlxG.save.data.botplay)
					{
						remove(downscrollbotplay);
					}

		if (FlxG.save.data.showratings && !addedratingstext)
			{
				ratings = new FlxText(4, 300, "" , 20);
				ratings.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				ratings.scrollFactor.set();
				
				if (FlxG.save.data.antialiasing)
				    ratings.antialiasing = false;
					add(ratings);
					ratings.cameras = [camHUD];
					addedratingstext = true;
			}
			else if (addedratingstext && !FlxG.save.data.showratings)
				{
					remove(ratings);
				}

				if (FlxG.save.data.hideHUD && addedhealthbarshit)
					{
						remove(healthBarBG);
						remove(healthBar);
						remove(iconP1);
						remove(iconP2);
						addedhealthbarshit = false;		
					}
					else if (!FlxG.save.data.hideHUD && !addedhealthbarshit)
							{
								healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
								if (FlxG.save.data.downscroll)
									healthBarBG.y = 50;
								healthBarBG.screenCenter(X);
								healthBarBG.scrollFactor.set();
								add(healthBarBG);
								healthBarBG.cameras = [camHUD];
				
								healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
								'health', 0, 2);
							healthBar.scrollFactor.set();
							if (FlxG.save.data.healthcolor)
							healthBar.createFilledBar(FlxColor.fromRGB(dad.playercolorR , dad.playercolorG, dad.playercolorB, dad.playercolorA), FlxColor.fromRGB(boyfriend.playercolorR , boyfriend.playercolorG, boyfriend.playercolorB, boyfriend.playercolorA));
							else
								healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
							// healthBar
							add(healthBar);
							healthBar.cameras = [camHUD];

							iconP1 = new HealthIcon(SONG.player1, true);
							iconP1.y = healthBar.y - (iconP1.height / 2);
							add(iconP1);
							iconP1.cameras = [camHUD];	
									
					
							iconP2 = new HealthIcon(SONG.player2, false);
							iconP2.y = healthBar.y - (iconP2.height / 2);
							add(iconP2);
							iconP2.cameras = [camHUD];	
							addedhealthbarshit = true;
							}

							if (moveminscore && FlxG.save.data.minscore)
								{
									scoreTxt.x = healthBarBG.x + healthBarBG.width - 190;
									scoreTxt.y = healthBarBG.y + 30;
									moveminscore = false;
									scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
								}
				
								if (moveminscoreback && !FlxG.save.data.minscore)
									{
										scoreTxt.x = 0;
										if (FlxG.save.data.downscroll)
										scoreTxt.y = 110;
										else	
										scoreTxt.y = 690;
										moveminscoreback = false;
										scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
									}
	 if (reloadhealthbar)
		{
			remove(healthBarBG);
			remove(healthBar);
			remove(iconP1);
			remove(iconP2);

			healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				healthBarBG.y = 50;
			healthBarBG.screenCenter(X);
			healthBarBG.scrollFactor.set();
			add(healthBarBG);
			healthBarBG.cameras = [camHUD];	

			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (FlxG.save.data.healthcolor)
			healthBar.createFilledBar(FlxColor.fromRGB(dad.playercolorR , dad.playercolorG, dad.playercolorB, dad.playercolorA), FlxColor.fromRGB(boyfriend.playercolorR , boyfriend.playercolorG, boyfriend.playercolorB, boyfriend.playercolorA));
			else
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);
		healthBar.cameras = [camHUD];

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);
		iconP1.cameras = [camHUD];	
				

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		iconP2.cameras = [camHUD];
		reloadhealthbar = false;
		trace('reloaded');	
		}


		/*#if cpp
		if (songStarted && !needstopitch && dontstopold)
			{
				if (FlxG.timeScale != 1)
					{
							if (FreeplayState.gamespeed > 1)
								{
									@:privateAccess
									{
										if (FlxG.sound.music.playing)
										lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
										if (vocals.playing)
											lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
										//sniper gaming looking for a way to pitch vocals without cpp
									}
									///trace("pitched inst and vocals to " + FlxG.timeScale);
								 
								}			
					}
	
					if (FreeplayState.gamespeed < 1)
						{
							{
								@:privateAccess
								{
									if (FlxG.sound.music.playing)
									lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
									if (vocals.playing)
										lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
									//sniper gaming looking for a way to pitch vocals without cpp
								}
								///trace("pitched inst and vocals to " + gamespeed);
							}
						}
				
			}
			else if (needstopitch && songStarted && !dontstopold)
				{
					if (FlxG.timeScale != 1)
						{
								if (FreeplayState.gamespeed > 1)
									{
										@:privateAccess
										{
											if (FlxG.sound.music.playing)
											lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
											if (vocals.playing)
												lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
											//sniper gaming looking for a way to pitch vocals without cpp
										}
										///trace("pitched inst and vocals to " + FlxG.timeScale);
									 
									}			
						}
		
						if (FreeplayState.gamespeed < 1)
							{
								{
									@:privateAccess
									{
										if (FlxG.sound.music.playing)
										lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
										if (vocals.playing)
											lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
										//sniper gaming looking for a way to pitch vocals without cpp
									}
									///trace("pitched inst and vocals to " + gamespeed);
								}
							}
					
				}*/
				//#end

				if (FlxG.timeScale != 1)
					{
						if (generatedMusic)
							{
								if (songStarted && !endingSong)
								{
									
									// Song ends abruptly on slow rate even with second condition being deleted,
									// and if it's deleted on songs like cocoa then it would end without finishing instrumental fully,
									// so no reason to delete it at all
									// seeing if length will work		
											for (i in 0...unspawnNotes.length)
												{
													if (unspawnNotes.length == 0 && FlxG.sound.music.time == 0 && notes.length <= 0)
														{
															endSong();
														}
												}
								}
							}
					}
						if (songStarted && !endingSong)
							{
								if (!ChartingState.startfrompos)
									{
										for (i in 0...unspawnNotes.length)
											if (unspawnNotes[i].strumTime < startTime)
												unspawnNotes.remove(unspawnNotes[i]);
									}
							}

		yomamatime = FlxG.sound.music.length - Conductor.songPosition;

         ///this is here cuz for some reason the one down at line 4665 does not check very often, leaving notes glowing.
		 if (FlxG.save.data.botplay)
			{
				playerStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.animation.finished)
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});
			}
            #if debug
			if (FlxG.keys.justPressed.A)
				{
					if (babyArrow.alpha == 1)
						{
							babyArrow.alpha = 0;
							for (str in playerStrums){
								str.alpha = babyArrow.alpha;
							}
				
							for (str in cpuStrums){
								str.alpha = babyArrow.alpha;
							}
						}
						else
							{
								babyArrow.alpha = 1;
								for (str in playerStrums){
									str.alpha = babyArrow.alpha;
								}
					
								for (str in cpuStrums){
									str.alpha = babyArrow.alpha;
								}
							}
				}

				if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future, credit: Shadow Mario#9396
					if (!usedTimeTravel && Conductor.songPosition + 10000 < FlxG.sound.music.length) 
					{
						usedTimeTravel = true;
						FlxG.sound.music.pause();
						vocals.pause();
						Conductor.songPosition += 10000;
						notes.forEachAlive(function(daNote:Note)
						{
							if(daNote.strumTime - 500 < Conductor.songPosition) {
								daNote.active = false;
								daNote.visible = false;
		
							
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
							for (i in 0...unspawnNotes.length)
								{
									var dunceNote:Note = unspawnNotes[i];
									if(dunceNote.strumTime - 500 < Conductor.songPosition) {
										dunceNote.active = false;
										dunceNote.visible = false;
										dunceNote.kill();
										notes.remove(dunceNote, true);
										dunceNote.destroy();
									}

									
									
								}
						});
		
						FlxG.sound.music.time = Conductor.songPosition;
						FlxG.sound.music.play();
		
						vocals.time = Conductor.songPosition;
						vocals.play();
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
							{
								usedTimeTravel = false;
							});
					}
				}	
				#end

				if (FlxG.save.data.songPosition && !addedsongpos && startTimer.finished)
					{
						remove(songPosBG);
						remove(songPosBar);
		
						songPosBG = new FlxSprite(0, 22).loadGraphic(Paths.image('healthBar'));
						if (FlxG.save.data.downscroll)
							songPosBG.y = FlxG.height * 0.9 + 45; 
						songPosBG.screenCenter(X);
						songPosBG.scrollFactor.set();
						add(songPosBG);
		
						songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
							'songPositionBar', 0, songLength - 1000);
						songPosBar.numDivisions = 1000;
						songPosBar.scrollFactor.set();
						songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
						add(songPosBar);
						if (FlxG.save.data.downscroll)
						songlengthtext = new FlxText(600, 700, "", 20);
						else
						songlengthtext = new FlxText(600, 23, "", 20);
						songlengthtext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						songlengthtext.scrollFactor.set();
						if (FlxG.save.data.antialiasing)
						{
							songlengthtext.antialiasing = false;
						}
						else
							{
								songlengthtext.antialiasing = true;
							}
						add(songlengthtext);
			
		
						songPosBG.cameras = [camHUD];
						songPosBar.cameras = [camHUD];
						songlengthtext.cameras = [camHUD];
						addedsongpos = true;
					}
					else if (addedsongpos && !FlxG.save.data.songPosition)
						{
							remove(songPosBG);
						    remove(songPosBar);
							remove(songlengthtext);
							addedsongpos = false;
						}

        {
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		///FlxG.elapsed = FlxG.timeScale*(_step/1000.f);

		if (inCutscene)
			scoreTxt.text = "";
	    else
		{
			switch (FlxG.save.data.Scoretext)
			{
				case 'minscore':
				    scoreTxt.text = "Score:" + songScore;
				case 'swiftenginescoretext':
					if (accuracy == 0 && !inCutscene)
						scoreTxt.text = "Score: " + songScore + " | Current Accuracy: " + baseText2 + " | Overall Accuracy: " + "N/A" + " | Misses: " + misses + " | " + fullcombotext + " (" + songRating + ")" + (FlxG.save.data.nps ? " | NPS: " + nps : "");	
						else if (!inCutscene)
						scoreTxt.text = "Score: " + songScore + " | Current Accuracy: " + baseText2 + " | Overall Accuracy: " + truncateFloat(accuracy, 2) + "%" + " | Misses: " + misses + " | " + fullcombotext + " (" + songRating + ")" + (FlxG.save.data.nps ? " | NPS: " + nps : "");
				case 'swiftenginecompact':
					if (accuracy == 0 && !inCutscene)
						scoreTxt.text = "Score: " + songScore + (FlxG.save.data.nps ? " - NPS: N/A" : "") + " - Accuracy: " + "N/A" + " - Misses: " + misses + " - " + songRating;
					else if (!inCutscene)
						scoreTxt.text = "Score: " + songScore + (FlxG.save.data.nps ? " - NPS: " + nps : "") + " - Accuracy: " + truncateFloat(accuracy, 2) + "%" + " - Misses: " + misses + " - " + songRating + " - [" + fullcombotext + "]";
				case 'kadeengine142scoretext':
					scoreTxt.text = (FlxG.save.data.nps ? "NPS: " + nps + " | " : "") + "Score:" + songScore + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
				case 'kadeengine10scoretext':
					scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% " + (fc ? "| FC" : misses == 0 ? "| A" : accuracy <= 75 ? "| BAD" : "");
				case 'unknownenginescoretext':
					scoreTxt.text = "Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% |" + " Score:" + songScore;
				case 'sniperenginealphascoretext':
					scoreTxt.text = " Score: " + songScore + " | " + "Misses: " + misses;
				case 'pscyheenginescoretext':
					scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + misses + (FlxG.save.data.nps ? ' | NPS: ' + nps : "") + ' | Rating: ' + songRatingPsyche;
				case 'basefnfscoretext':
					scoreTxt.text = "Score: " + songScore;
				case 'kadeengine18scoretext':
					scoreTxt.text = " | " + "Score:" + songScore + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + " %" + " | " + generateRanking();
				case 'fpsplusenginescoretext':
					scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "%";
				case 'noscoretext':
					scoreTxt.text = "";	
			}
		}
							if (FlxG.save.data.showratings && addedratingstext && startedCountdown)
								{
									if (!inCutscene)
									ratings.text = "" + (FlxG.save.data.highestcombo ? "Highest Combo: " + highestcombo + "\n" + "\n" + "" : "") + (FlxG.save.data.combo ? "Combo: " + truecombo + "\n" + "\n" + "" : "") + "Sicks: " + sicks + "\n" + "\n" + "Goods: " + goods + "\n" + "\n" + "Bads: " + bads + "\n" + "\n" + "Shits: " + shits + "\n" + "\n" + "" + (FlxG.save.data.showmisses ? "Miss: " + misses + "\n" + "\n" + "" : "");	
								}
					
					 if (misses == 0 && accuracy == 0)
						{
							  fullcombotext = "N/A";	// default to this when no notes have been hit
						}
						else if (misses == 0 && SFC)
							{
								fullcombotext = "SFC"; // Sick full combo (only sicks have been hit)	
							}
							else if (misses == 0 && GFC)
								{
									fullcombotext = "GFC"; // Good full combo (Sicks and Goods have been hit)	
								}
								else if (misses == 0 && BFC)
									{
										fullcombotext = "BFC"; // Bad full combo (Sicks, Goods, and at least 1 Bad has been hit)	
									}
									else if (misses == 0)
										{
											fullcombotext = "FC"; // Full combo (default when the player has gotten all above ratings including a Shit)
										}
										else if (misses < 10)
											{
												fullcombotext = "SDM"; // Single Digit Miss (misses are under 10)
											}
											else if (misses >= 10)
												{
													fullcombotext = "Clear"; // Default when misses are over 10. Thank you for coming to my ted talk lol
												}

		if (FlxG.save.data.songPosition && addedsongpos)
			{
				songlengthtext.text = "" + Math.round(yomamatime* 1);  
			}

			{
				if (accuracy == 0)
					{
						baseText2 = "N/A";
					}
					else if (SFC && accuracy != 0 && misses == 0)
						baseText2 = "100%";
					else if (accuracy != 0)
					{
						var baseText:String = "N/A";

						if (notesPassing != 0) {
							baseText = Math.round((notesHit/notesPassing) * 100) + "%";
						}
						else 
						{
							baseText2 = "100%";
						}
						
						if (notesPassing != 0) {
							baseText2 = Math.round((notesHit/notesPassing) * 100) + "%";
						} 
						else 
						{
							baseText2 = "100%";
						}
					}
			}

			{
				if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
					{
						persistentUpdate = false;
						persistentDraw = true;
						paused = true;
			
						// 1 / 1000 chance for Gitaroo Man easter egg
						if (FlxG.random.bool(0.1))
						{
							// gitaroo man easter egg
							FlxG.switchState(new GitarooPause());
						}
						else
							openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					
						if (FlxG.save.data.cinematic && canPause)
							{
								camHUD.visible = true;
							}
							
						#if cpp
						DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
						#end
					}
			}
			


		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
		}

		if (FlxG.keys.justPressed.FIVE)
			{
			  if (donotidleinbetweenclosenotes)
				{
					donotidleinbetweenclosenotes = false;
				}
				else
					{
						donotidleinbetweenclosenotes = true;
					}
			}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		if (!FlxG.save.data.hideHUD && addedhealthbarshit)
			{
				if (FlxG.save.data.newhealthheadbump)
					{
						{
							iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.85)));
							iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.85)));
						}	
					//iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.15)));
					//iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.15)));
					}
					else
						{
						iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
						iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));
						}

						iconP1.updateHitbox();
						iconP2.updateHitbox();
				
						var iconOffset:Int = 26;
				
						iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
						iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
				
						if (health > 2)
							health = 2;
				
						if (healthBar.percent < 20)
							iconP1.animation.curAnim.curFrame = 1;
						else
							iconP1.animation.curAnim.curFrame = 0;
				
						if (healthBar.percent > 80)
							iconP2.animation.curAnim.curFrame = 1;
						else
							iconP2.animation.curAnim.curFrame = 0;
			}

		

		///if (healthBar.percent < 20)
			///iconP2.animation.curAnim.curFrame = 3;
			// winning icon code for referance


		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));

		if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new AnimationDebug(SONG.player1));
		

		if (startingSong)
		{
			if (startedCountdown)
			{
				if (ChartingState.startfrompos)
				Conductor.songPosition = ChartingState.startpos + FlxG.elapsed * 1000;
				else
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (ChartingState.startfrompos)
					{
						if (Conductor.songPosition >= ChartingState.startpos)
							startSong();
					}
					else if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			if (ChartingState.startfrompos)
			Conductor.songPosition = ChartingState.startpos + FlxG.elapsed * 1000;
			else
			Conductor.songPosition += FlxG.elapsed * 1000;
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}
			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !FlxG.save.data.middlecam)
				{
					camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
					switch (curStage)
					{
						case 'school':
							camFollow.x = gf.getMidpoint().x - 300;
							camFollow.y = gf.getMidpoint().y - 200;
						case 'schoolEvil':
							camFollow.x = gf.getMidpoint().x - 300;
							camFollow.y = gf.getMidpoint().y - 200;
					}	
				}
				
			else if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].gfsection)
							camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
							else if (camFollow.x == dad.getMidpoint().x + 150 && SONG.notes[Math.floor(curStep / 16)].gfsection)
							camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
							else if (camFollow.x != dad.getMidpoint().x + 150 && SONG.notes[Math.floor(curStep / 16)].gfsection)
							camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
							else
							camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					}
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}
            if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100 && !FlxG.save.data.middlecam)
				{
					camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
					switch (curStage)
					{
						case 'school':
							camFollow.x = gf.getMidpoint().x - 300;
							camFollow.y = gf.getMidpoint().y - 200;
						case 'schoolEvil':
							camFollow.x = gf.getMidpoint().x - 300;
							camFollow.y = gf.getMidpoint().y - 200;
					}	
				}
			else if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
				{
					camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
	
					switch (curStage)
					{
						case 'limo':
							camFollow.x = boyfriend.getMidpoint().x - 300;
						case 'mall':
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'school':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'schoolEvil':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
					}
				}
		}

		if (FlxG.save.data.camzooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
				{
					if (controls.RESET && FlxG.save.data.reset && !FlxG.save.data.botplay && !PauseSubState.practicemode)
						{
							blueballed += 1;
							if (FlxG.save.data.instantRespawn)
								{
									if (FlxG.save.data.usedeprecatedloading)
										FlxG.resetState();
									else
										restart();
								}
								else
									{
										if (FlxG.save.data.oldinput)
										boyfriend.stunned = true;
		
										persistentUpdate = false;
										persistentDraw = false;
										paused = true;
							
										vocals.stop();
										FlxG.sound.music.stop();
							
										openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
							
										// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
										
										#if cpp
										// Game Over doesn't get his own variable because it's only used here
										DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + "" + storyDifficultyText + "", iconRPC);
										#end
										//health = 0;
							            //trace("RESET = True");        
									}
						}
				}
			
			
		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}
		if (health <= 0 && FlxG.save.data.instantRespawn)
			{
				if (!FlxG.save.data.usedeprecatedloading)
				restart();
				else
					FlxG.resetState();
				blueballed += 1;
			}
			else if (health <= 0 && !PauseSubState.practicemode)
				{
		
					blueballed += 1;
					if (FlxG.save.data.oldinput)	
					boyfriend.stunned = true;
		
					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					
					#if cpp
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + "" + storyDifficultyText + "", iconRPC);
					#end
				}


		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
			var pressArray:Array<Bool> = [
				controls.LEFT_P,
				controls.DOWN_P,
				controls.UP_P,
				controls.RIGHT_P
			];
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				{
					// Force good note hit regardless if it's too late to hit it or not as a fail safe
					if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
					FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
					{
						goodNoteHit(daNote);
						boyfriend.holdTimer = daNote.sustainLength;
						if (FlxG.save.data.hitsounds && !daNote.isSustainNote)
							{
								FlxG.sound.play(Paths.sound('normal-hitnormal'), 0 + FlxG.save.data.hitsoundvolume);	
							}	
					}
				}

                if (FlxG.save.data.songspeed)
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.speedamount, 2)));
				else
				   daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				if (daNote.mustPress && FlxG.save.data.middlescroll)
					{
						//daNote.x = 500; this is a bad idea
						if (daNote.isSustainNote)
							{
								if (FlxG.save.data.transparency)
								daNote.alpha = 0.6;	
								else
								daNote.alpha = 1;
							}
							else
							daNote.alpha = 1;	
					}
					else if (FlxG.save.data.middlescroll && !daNote.wasGoodHit)
						{
							daNote.alpha = 0;
						}


				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}
				if (resetalpha)
					{
						for (i in 0...unspawnNotes.length)
							{
								var dunceNote:Note = unspawnNotes[i];
								if (FlxG.save.data.transparency && dunceNote.isSustainNote)
									{
										dunceNote.alpha = 0.6;	
									}
									else if (dunceNote.isSustainNote)
										{
											dunceNote.alpha = 1.0;	
										}
							}
					}
					if (resetlength)
						{
							for (i in 0...unspawnNotes.length)
								{
									var dunceNote:Note = unspawnNotes[i];
									if (FlxG.save.data.songspeed && dunceNote.isSustainNote && dunceNote != null)
										{
											
										}
										else if (dunceNote.isSustainNote && dunceNote != null)
											{
													
											}
											resetlength = false;
								}
						}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (!daNote.isSustainNote)
					cpunotesHit += 1;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
						else
							altAnim = '';
					}

					if (daNote.altNote)
						{
							altAnim = '-alt';
						}

					if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].crossFade)
								{
									if (trailon)
										{
											//trail.velocity.x = -200;
											new FlxTimer().start(0.3, function(tmr:FlxTimer)
												{
													trail.velocity.x = 0;
												});	
										}
										else if (!trailon)
											{
												trail.velocity.x = 0;
											}
								}
						}
					if (SONG.notes[Math.floor(curStep / 16)].gfsection)
						{
							var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + altAnim;
							gf.playAnim(animToPlay, true);
							gf.holdTimer = daNote.sustainLength; //0
						}
						else
							{
								var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + altAnim;
								dad.playAnim(animToPlay, true);
								dad.holdTimer = daNote.sustainLength; //0
							}

					if (FlxG.save.data.notesplashes && !daNote.isSustainNote && !FlxG.save.data.middlescroll && FlxG.save.data.cpunotesplashes)
						{
							var recycledNote = grpNoteSplashes.recycle(NoteSplash);
							recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
							grpNoteSplashes.add(recycledNote);
						}
						else if (FlxG.save.data.notesplashes && daNote.isSustainNote && FlxG.save.data.notesplashhold && !FlxG.save.data.middlescroll && FlxG.save.data.cpunotesplashes)
							{
								var recycledNote = grpNoteSplashes.recycle(NoteSplash);
								recycledNote.setupNoteSplash(daNote.x - 25, daNote.y, daNote.noteData);
								grpNoteSplashes.add(recycledNote);
							}
					

					{
						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								if (FlxG.save.data.botplay)
									{
										if (FlxG.save.data.strumlights)
											{
												spr.animation.play('confirm', true);	
											}	
									}
									else
										{
											if (FlxG.save.data.strumlights)
												{
													spr.animation.play('confirm', true);	
												}	
										}		
							}
							if (spr.animation.curAnim.name == 'confirm' && SONG.noteskin != 'pixel')
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
									if (!FlxG.save.data.strumlights && spr.animation.curAnim.name == 'confirm')
										{
											spr.animation.play('static', true);	
											spr.centerOffsets();
										}
					
		
						});
					}
		
					{
						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.animation.finished)
							{
								if (FlxG.save.data.strumlights)
									{
										spr.animation.play('static');
										spr.centerOffsets();
									}
							}
						});
					}

					if (SONG.needsVoices)
						vocals.volume = 1;

					//if ((daNote.y < -daNote.height +135 && !FlxG.save.data.downscroll || daNote.y >= -strumLine.y +135 && FlxG.save.data.downscroll)) // stop sustains from being cut off early? i really don't know how to fix it.
						{
							if (daNote.isSustainNote)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
								#if debug
							    trace('deleted sust note');
							    #end
							}
					}
                    if (!daNote.isSustainNote)
						{
							daNote.active = false;
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							#if debug
							trace('deleted note');
							#end
						} // finish fixing note shit!!!!
					//daNote.kill();
					//notes.remove(daNote, true);
					//daNote.destroy();			
				}




						
	
                if (FlxG.save.data.songspeed)
					{
						if (FlxG.save.data.downscroll)                                             ///-0.45
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.speedamount, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.speedamount, 2)));
					}
					else
						{
							if (FlxG.save.data.downscroll)                                             ///-0.45
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
							else
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
						}
				// WIP interpolation shit? Need to fix the pause issue
				// "the pause issue"
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else if (theFunne)
						{
								{
									if (FlxG.save.data.botplay)
										{
										  #if debug
										  trace('no miss');
										  #end
										}
									   else
									   	{
											noteMiss(daNote.noteData, daNote);
											notesPassing += 1;
											health -= 0.075;
											vocals.volume = 0;
										}
											
								}
						}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
					#if debug
					trace('deleted note');
					#end
						
				}

			});
		}

		cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					if (FlxG.save.data.strumlights)
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
				}
			});
		

		if (!inCutscene)
			keyShit();
			

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		
		#end
        // JANK anti mash code
		notes.forEachAlive(function(daNote:Note)
			{
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				if (FlxG.save.data.antimash && FlxG.save.data.ghosttapping && pressArray.contains(true) && !FlxG.save.data.botplay) //pressArray.contains(true)
					{ 
						if (daNote.y >= strumLine.y && daNote.canBeHit && daNote.mustPress)
							{
							   if (!daNote.wasGoodHit)
								{
									FlxG.save.data.ghosttapping = false;
									new FlxTimer().start(1.0, function(tmr:FlxTimer)
										{
											FlxG.save.data.ghosttapping = true;
										});	
								}
							}
					} 		
			});
	}
	
	public static function botplaycheck()
		{
			if (FlxG.save.data.botplay)
				{
					///Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 0;
					/// set to 0 so like it doesn't hit early
					Conductor.safeZoneOffset = (Conductor.safeFrames / 30 )* 0;
				}
				else
					{                                                          //1000
						Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000;
					}
					if (FlxG.save.data.botplay)
						{
							BOTPLAY = false;
						}
						else
							{
								BOTPLAY = true;	
							}
							#if cpp
							if (FlxG.save.data.botplay)
								{
									botplayd = " | botplay";
								}
								else
									{
										botplayd = "";	
									}
							#end				
		}

	function endSong():Void
	{
		if (FlxG.save.data.repeat)
			{
				if (!FlxG.save.data.usedeprecatedloading)
				repeat();
				else
					{
						var difficulty:String = "";
			
						if (storyDifficulty == 0)
							difficulty = '-easy';
		
						if (storyDifficulty == 2)
							difficulty = '-hard';
		
						trace('LOADING ' + PlayState.SONG.song.toLowerCase() + difficulty + ' AGAIN');
		
						prevCamFollow = camFollow;
		
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
		
						PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + difficulty, PlayState.SONG.song);
						FlxG.sound.music.stop();
		
						LoadingState.loadAndSwitchState(new PlayState());
					}
			}
			else
				{
					canPause = false;
					FlxG.sound.music.volume = 0;
					vocals.volume = 0;
					paused = true;
				    FlxG.sound.music.pause();
				    vocals.pause();
					FlxG.sound.music.stop();
					vocals.stop();

					if (!FlxG.save.data.botplay && SONGISVALID)
						{
							if (SONG.validScore)
								{
									#if !switch
									Highscore.saveScore(SONG.song, songScore, storyDifficulty);
									#end
								}
						}
			
					if (StoryMenuState.isStoryMode)
					{
						campaignScore += songScore;
			
						storyPlaylist.remove(storyPlaylist[0]);
			
						if (storyPlaylist.length <= 0)
						{
							Conductor.changeBPM(102);
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							FlxG.switchState(new StoryMenuState());
							FlxG.timeScale = 1;
			
							// if ()
							StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
							if (!FlxG.save.data.botplay && SONGISVALID)
								{
									if (SONG.validScore)
										{
												{
													//NGio.unlockMedal(60961);
													Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
												}
										}
								}
			
							FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
							FlxG.save.flush();
						}
						else
						{
							if (!FlxG.save.data.usedeprecatedloading)// && isnotweb)
							loadnextsong(); //  new way for loadin songs, cuz it is to performance heavy to reload the state every time
							else
								{
							var difficulty:String = "";
			
							if (storyDifficulty == 0)
								difficulty = '-easy';
			
							if (storyDifficulty == 2)
								difficulty = '-hard';
			
							triggeredalready = false;
			
							if (SONG.song.toLowerCase() == 'eggnog')
							{
								var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
									-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
								blackShit.scrollFactor.set();
								add(blackShit);
								camHUD.visible = false;
			
								FlxG.sound.play(Paths.sound('Lights_Shut_off'));
							}
			
							//FlxTransitionableState.skipNextTransIn = true;
							//FlxTransitionableState.skipNextTransOut = true;

							/*if (FlxG.save.data.ingametransitions)
								{
									FlxTransitionableState.skipNextTransIn = false;
									FlxTransitionableState.skipNextTransOut = false;
								} ADD LATER!!!*/

							prevCamFollow = camFollow;
			
							PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
							FlxG.sound.music.stop();
							if (FlxG.save.data.songinfo)
							getsonginfo();
			
							LoadingState.loadAndSwitchState(new PlayState());       
								}
						}
					}
					else
					{
						#if web
						FlxG.switchState(new FreeplayStateHTML5());
						FlxG.timeScale = 1;
						#else
						FlxG.switchState(new FreeplayState());
						FlxG.timeScale = 1;
						#end	
					}
				}
	}

	var endingSong:Bool = false;
	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		///var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		///private function popUpScore(strumtime:Float):Void
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		if (truecombo >= highestcombo)
			highestcombo = truecombo;

		var placement:String = Std.string(combo);

		if (FlxG.save.data.enablesickpositions)
			{
			coolText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			}
			else
				{
					coolText = new FlxText(0, 0, 0, placement, 32);
					coolText.screenCenter();
					coolText.x = FlxG.width * 0.55;
				}

		//
		var rating:FlxSprite = new FlxSprite();
		var score:Int = 300;
	
		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.3 && !FlxG.save.data.botplay)
			{
				SFC = false;
			}

		if (noteDiff > Conductor.safeZoneOffset * 0.5 && !FlxG.save.data.botplay)
			{
				GFC = false;
			}

			if (noteDiff > Conductor.safeZoneOffset * 0.55 && !FlxG.save.data.botplay)
				{
					BFC = false;
				}


		if (FlxG.save.data.botplay)
			{
				if (noteDiff > Conductor.safeZoneOffset * 0.9)
					{
						daRating = 'sick';
					}
					else if (noteDiff > Conductor.safeZoneOffset * 0.75)
					{
						daRating = 'sick';
					}
					else if (noteDiff > Conductor.safeZoneOffset * 0.2)
					{
						daRating = 'sick';
					}
			
			
					if (daRating == 'sick')
					{	
						if (FlxG.save.data.notesplashes)
							{
								var recycledNote = grpNoteSplashes.recycle(NoteSplash);
								recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
								grpNoteSplashes.add(recycledNote);
							}
						 notesHit += 1;
						 sicks +=1;
						totalNotesHit += 1;
						notesnotmissed += 1;
						notesPassing -= 0.25;
						if (notesHit > notesPassing) {
							notesHit = notesPassing;
						}
					}
			}
			else
				{
							if (noteDiff > Conductor.safeZoneOffset * 0.55)
								{
									daRating = 'shit';
									score = 50;
									notesHit += 0.25;
									notesnotmissed += 1;
									totalNotesHit -= 2;
									shits +=1;
								}
								else if (noteDiff > Conductor.safeZoneOffset * 0.5)
								{
									daRating = 'bad';
									score = 100;
									notesHit += 0.25;
									notesnotmissed += 1;
									totalNotesHit += 0.2;
									bads +=1;
								}
								else if (noteDiff > Conductor.safeZoneOffset * 0.3)
								{
									daRating = 'good';
									score = 200;
									notesHit += 0.95;
									notesnotmissed += 1;
									totalNotesHit += 0.65;
									goods +=1;
								}
							
						if (daRating == 'sick')
						{
							if (FlxG.save.data.notesplashes)
								{
									var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}
							sicks +=1;
							notesHit += 1;
							totalNotesHit += 1;
							notesnotmissed += 1;
							notesPassing -= 0.25;
							if (notesHit > notesPassing) {
								notesHit = notesPassing;
							}
						}
				
				}
		songScore += score;
		Rating = daRating;

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';
		var keshit1:String = '';
		var keshit2:String = '';

		if (SONG.noteskin == 'pixel')
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (FlxG.save.data.ke142ratings)
			{
			    keshit1 = '-keold';
			}

		if (FlxG.save.data.ke154ratings)
			{
				keshit2 = '-kenew';
			}	
	

		if (SONG.noteskin == 'pixel')
			{
				if (FlxG.save.data.antialiasing)
					{
						rating.antialiasing = false;
					}
					else
						{
							rating.antialiasing = true;
						}
			}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + keshit1 + keshit2 + pixelShitPart2));
		rating.antialiasing = FlxG.save.data.antialiasing;
		if (FlxG.save.data.enablesickpositions)
			{
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			}
			else
				{
							rating.x = coolText.x - 40;
							if (SONG.noteskin == 'pixel')
							rating.y += 270; // -=60
							else
							rating.y += 220; // -=60
							rating.acceleration.y = 550;
							rating.velocity.y -= FlxG.random.int(140, 175);
							rating.velocity.x -= FlxG.random.int(0, 10);
				}
			
			


		var msTiming = truncateFloat(noteDiff, 3);
		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		if (SONG.noteskin == 'pixel')
		comboSpr.antialiasing = false;
		else
		comboSpr.antialiasing = FlxG.save.data.antialiasing;
		if (FlxG.save.data.enablesickpositions)
			{
				comboSpr.screenCenter();
				comboSpr.x = rating.x + 100;
				comboSpr.y = rating.y + 70;
				comboSpr.acceleration.y = 600;
				comboSpr.velocity.y -= 150;
	
				comboSpr.velocity.x += FlxG.random.int(1, 10);
			}
			else
				{
						comboSpr.x = coolText.x + 50;
						comboSpr.y = rating.y + 120;
						comboSpr.acceleration.y = 600;
						comboSpr.velocity.y -= 150;
				}

				if (FlxG.save.data.enablesickpositions)
					{
						comboSpr.cameras = [camHUD];
						rating.cameras = [camHUD];
					}
				

		if (FlxG.save.data.hittimings)
			{

				if (currentTimingShown != null)
					remove(currentTimingShown);
	
			}
		if (FlxG.save.data.hittimings)
			{
				if (currentTimingShown != null)
					remove(currentTimingShown);
		
				currentTimingShown = new FlxText(0,0,0,"0ms");
				timeShown = 0;
				switch(daRating)
				{
					case 'shit' | 'bad':
						if (!FlxG.save.data.ke142ratings && !FlxG.save.data.ke154ratings)
							{
								currentTimingShown.color = FlxColor.GRAY;
							}
							else
						currentTimingShown.color = FlxColor.RED;
					case 'good':
						if (!FlxG.save.data.ke142ratings && !FlxG.save.data.ke154ratings)
							{
								currentTimingShown.color = FlxColor.WHITE;
							}
							else
						currentTimingShown.color = FlxColor.GREEN;
					case 'sick':
						if (!FlxG.save.data.ke142ratings && !FlxG.save.data.ke154ratings)
							{
								currentTimingShown.color = FlxColor.WHITE;
							}
							else
						currentTimingShown.color = FlxColor.CYAN;
				}
				currentTimingShown.borderStyle = OUTLINE;
				currentTimingShown.borderSize = 1;
				currentTimingShown.borderColor = FlxColor.BLACK;
				if (FlxG.save.data.botplay)
					 currentTimingShown.text = "0" + "ms";
					else
				     currentTimingShown.text = msTiming + "ms";
				currentTimingShown.size = 20;
		
		
				if (currentTimingShown.alpha != 1)
					currentTimingShown.alpha = 1;
		
				add(currentTimingShown);
		
			}
		comboSpr.velocity.x += FlxG.random.int(1, 10);
		if (FlxG.save.data.hittimings)
			{
				if (FlxG.save.data.enablesickpositions)
					{
						if (SONG.noteskin == 'pixel')
						currentTimingShown.x = FlxG.save.data.changedHitX + 210;
						else
						currentTimingShown.x = FlxG.save.data.changedHitX + 250;
						currentTimingShown.y = FlxG.save.data.changedHitY + 40;
						currentTimingShown.cameras = [camHUD];
					}
					else
						{
							currentTimingShown.x = comboSpr.x + 150;
			                currentTimingShown.y = rating.y + 50;
						}
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if (FlxG.save.data.antialiasing)
				{
					currentTimingShown.antialiasing = true;
				}
				else
					{
						currentTimingShown.antialiasing = false;
					}
			}
		if (FlxG.save.data.showratinggraphic) // the Sick!	
		add(rating);

		if (SONG.noteskin != 'pixel')
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			if (FlxG.save.data.antialiasing)
				{
					rating.antialiasing = false;
				}
				else
					{
						rating.antialiasing = true;
					}
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			if (FlxG.save.data.antialiasing)
				{
					comboSpr.antialiasing = true;
				}
				else
					{
						comboSpr.antialiasing = false;
					}
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			if (FlxG.save.data.antialiasing)
				{
					rating.antialiasing = false;
				}
				else
					{
						rating.antialiasing = true;
					}
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		if (FlxG.save.data.hittimings)
			{
				currentTimingShown.updateHitbox();
			}
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			if (FlxG.save.data.enablesickpositions)
				{
					numScore.x = rating.x + (43 * daLoop) - 50;
					numScore.y = rating.y + 100; //150
					numScore.cameras = [camHUD];
				}
				else
					{
						numScore.x = coolText.x + (43 * daLoop) - 90;
						numScore.y += 80;
					}

			if (SONG.noteskin != 'pixel')
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				{
					if (FlxG.save.data.combotext)
					add(comboSpr);
					if (FlxG.save.data.combonumber)
					add(numScore);
				}

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001,
			onUpdate: function(tween:FlxTween)
			{
				/*
				if (currentTimingShown != null)
					currentTimingShown.alpha -= 0.03;
				timeShown++;*/
			}
		});

		if (FlxG.save.data.hittimings)
			{
				if (currentTimingShown != null)
					{
						if (currentTimingShown.alpha != 1)
							currentTimingShown.alpha = 1;
						FlxTween.tween(currentTimingShown, {alpha: 0}, 0.8, {ease: FlxEase.quadInOut, startDelay: 0, onComplete: function(tween:FlxTween)
							{
								//currentTimingShown.destroy();
							},
						});
					}
			}


			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					/*
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}*/
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			


		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();
				/*
				if (currentTimingShown != null && timeShown >= 20)
				{
					remove(currentTimingShown);
					currentTimingShown = null;
				}*/
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		////hi kadedev :)
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if(FlxG.save.data.botplay) //i hate inputs when botplay is on
			{
				holdArray = [false, false, false, false];
				pressArray = [false, false, false, false];
				releaseArray = [false, false, false, false];
			} 

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}		
								if (!inIgnoreList && !FlxG.save.data.ghosttapping)
									badNoteCheck();
								updateAccuracy();
								rating();
								if (FlxG.save.data.pscyheenginescoretext)
								ratingPsyche();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				 
				 #if debug
				trace(daNote.noteData);
				#end
					
				
						/*switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
								    trace('ghost tapping');
							case 3:
								if (upP || rightP || downP || leftP)
									trace('ghost tapping');
							case 1:
								if (upP || rightP || downP || leftP)
									trace('ghost tapping');
							case 0:
								if (upP || rightP || downP || leftP)
									trace('ghost tapping');
						}

					//this is already done in noteCheck / goodNoteHit
					/*if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				 */
			}	
			else if (!FlxG.save.data.ghosttapping)
				{
					badNoteCheck();
				}
				else if (FlxG.save.data.oldinput)
					badNoteCheck();		
					
				notes.forEachAlive(function(daNote:Note)
					{
						if (FlxG.save.data.oldinput && daNote.canBeHit && daNote.mustPress && !daNote.wasGoodHit) //pressArray.contains(true)
							{
								if (pressArray.contains(true))
									{
										noteMiss(daNote.noteData, daNote);
									}
							}
							
					});
		}

		if ((up || right || down || left) && generatedMusic && !boyfriend.stunned) ///&& !boyfriend.stunned
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		notes.forEach(function(daNote:Note)
			{
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) && !onbeat && donotidleinbetweenclosenotes))
					{
						if (daNote.y >= strumLine.y && daNote.canBeHit && daNote.mustPress)
							{
							}
							else if (daNote.y <= strumLine.y + 500 && !daNote.canBeHit && !daNote.mustPress && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && (boyfriend.animation.curAnim.curFrame >= 10 || boyfriend.animation.curAnim.finished))
								{
									boyfriend.playAnim('idle');
								}
					}			
			});

			if (notes.length <= 0)
				{
					if (curBeat % 1 == 0 && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && (boyfriend.animation.curAnim.curFrame >= 10 || boyfriend.animation.curAnim.finished))
						{
							boyfriend.playAnim('idle');
						}		
				}

				if (dad.curCharacter.startsWith('bf') && dad.animation.curAnim.name.startsWith('sing') && !dad.animation.curAnim.name.endsWith('miss') && (dad.animation.curAnim.curFrame >= 10 || dad.animation.curAnim.finished))
					{
						dad.playAnim('idle');
					}	

			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && !up && !down && !right && !left && !donotidleinbetweenclosenotes && (boyfriend.animation.curAnim.curFrame >= 10 || boyfriend.animation.curAnim.finished))
				{
					boyfriend.playAnim('idle');
				}
				
				
					if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left && !FlxG.save.data.botplay && shouldidleafterrelease && !onbeat && !donotidleinbetweenclosenotes)
						{
							if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
							{
										{
											boyfriend.playAnim('idle');
										}
							}
						}

							

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						{
							if (FlxG.save.data.botplay)
								{
							        spr.animation.play('static');
								}
								else
									{
										spr.animation.play('pressed');
										if (FlxG.save.data.ghosttappinghitsoundsenabled && FlxG.save.data.hitsounds)
											{
												FlxG.sound.play(Paths.sound('hitSoundGhost'), 0 + FlxG.save.data.hitsoundvolume);
											}
									}
						}
						if (leftR)
							{
								spr.animation.play('static');
							}
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						{
							if (FlxG.save.data.botplay)
								{
							        spr.animation.play('static');
								}
								else
									{
										spr.animation.play('pressed');
										if (FlxG.save.data.ghosttappinghitsoundsenabled && FlxG.save.data.hitsounds)
											{
												FlxG.sound.play(Paths.sound('hitSoundGhost'), 0 + FlxG.save.data.hitsoundvolume);
											}
									}
						}
					if (downR)
						{
							spr.animation.play('static');
						}
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						{
							if (FlxG.save.data.botplay)
								{
							        spr.animation.play('static');
								}
								else
									{
										spr.animation.play('pressed');
										if (FlxG.save.data.ghosttappinghitsoundsenabled && FlxG.save.data.hitsounds)
											{
												FlxG.sound.play(Paths.sound('hitSoundGhost'), 0 + FlxG.save.data.hitsoundvolume);
											}
									}
						}
					if (upR)
						{
							spr.animation.play('static');
						}
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						{
							if (FlxG.save.data.botplay)
								{
							        spr.animation.play('static');
								}
								else
									{
										spr.animation.play('pressed');
										if (FlxG.save.data.ghosttappinghitsoundsenabled && FlxG.save.data.hitsounds)
											{
												FlxG.sound.play(Paths.sound('hitSoundGhost'), 0 + FlxG.save.data.hitsoundvolume);
											}
									}
						}
					if (rightR)
						{
							spr.animation.play('static');
						}
			}

			if (spr.animation.curAnim.name == 'confirm' && SONG.noteskin != 'pixel')
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			truecombo = 0;
			songScore -= 10;
			notesPassing += 1;
            if (FlxG.save.data.missnotes)
			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			misses +=1;
            if (FlxG.save.data.oldinput)
			boyfriend.stunned = true;

			// get stunned for 5 seconds
			if (FlxG.save.data.oldinput)
				{
					new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
						{
							boyfriend.stunned = false;
						});
				}

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss' + altAnim3, true);
				case 1:
					boyfriend.playAnim('singDOWNmiss' + altAnim3, true);
				case 2:
					boyfriend.playAnim('singUPmiss' + altAnim3, true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss' + altAnim3, true);
			}
			updateAccuracy();
			rating();
			if (FlxG.save.data.pscyheenginescoretext)
			ratingPsyche();
		}

	}

  
			function badNoteCheck()
				{
					// just double pasting this shit cuz fuk u
					// REDO THIS SYSTEM!
					/// week7 input be like
					/// well yn this but better
					var upP = controls.UP_P;
					var rightP = controls.RIGHT_P;
					var downP = controls.DOWN_P;
					var leftP = controls.LEFT_P;


							
								if (leftP && BOTPLAY)
									noteMiss(0, daNote);
								else
									trace('no input');	
								if (downP && BOTPLAY)
									noteMiss(1, daNote);
								else
									trace('no input');	
								if (upP && BOTPLAY)
									noteMiss(2, daNote);
								else
									trace('no input');	
								if (rightP && BOTPLAY)
									noteMiss(3, daNote);
								else
									trace('no input');	
							
					updateAccuracy();
					rating();
					if (FlxG.save.data.pscyheenginescoretext)
					ratingPsyche();
				}

				function updateAccuracy()
					{
						if (misses > 0)
							fc = false;
						else
							fc = true;
						totalPlayed += 1;
						accuracy = totalNotesHit / totalPlayed * 100;
						if (SFC && misses == 0)
						accuracy = 100;
						rating();
						if (FlxG.save.data.pscyheenginescoretext)
						ratingPsyche();
					}

					function rating()
						{
							if (accuracy <= 30)
								{
									songRating = 'F';
								}
							else if (accuracy <= 40)
								{
									songRating = 'E';
								}
							else if (accuracy <= 50)
								{
								   songRating = 'D';
								}
							else if (accuracy <= 70)
								{
								   songRating = 'C';
								}
							else if (accuracy <= 80)
								{
								   songRating = 'B';
								}
							else if (accuracy <= 90)
								{
								   songRating = 'A';
								}
							else if (accuracy <= 95)
								{
								   songRating = 'S';
								}
							else if (accuracy >= 96)
								{
								   songRating = 'S+';
								}
							else if (accuracy == 100)
								{
									songRating = 'S+';
								}
						}

						function ratingPsyche()
							{
								
								if (accuracy <= 20)
									{
										songRatingPsyche = 'You Suck!';
									}
								else if (accuracy <= 40)
									{
										songRatingPsyche = 'Shit';
									}
								else if (accuracy <= 50)
									{
										songRatingPsyche = 'Bad';
									}
								else if (accuracy <= 60)
									{
									    songRatingPsyche = 'Meh';
									}
								else if (accuracy <= 80)
									{
									    songRatingPsyche = 'Nice';
									}
								else if (accuracy <= 90)
									{
									    songRatingPsyche = 'Good';
									}
								else if (accuracy <= 95)
									{
									    songRatingPsyche = 'Great';
									}
								else if (accuracy <= 99)
									{
									    songRatingPsyche = 'Sick!';
									}
								else if (accuracy == 100)
									{
									    songRatingPsyche = 'Perfect!!';
									}
							}

						function generateRanking():String
							{
								var ranking:String = "N/A";
						
								if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
									ranking = "(MFC)";
								else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
									ranking = "(GFC)";
								else if (misses == 0) // Regular FC
									ranking = "(FC)";
								else if (misses < 10) // Single Digit Combo Breaks
									ranking = "(SDCB)";
								else
									ranking = "(Clear)";
						
								// WIFE TIME :)))) (based on Wife3)
						
								var wifeConditions:Array<Bool> = [
									accuracy >= 99.9935, // AAAAA
									accuracy >= 99.980, // AAAA:
									accuracy >= 99.970, // AAAA.
									accuracy >= 99.955, // AAAA
									accuracy >= 99.90, // AAA:
									accuracy >= 99.80, // AAA.
									accuracy >= 99.70, // AAA
									accuracy >= 99, // AA:
									accuracy >= 96.50, // AA.
									accuracy >= 93, // AA
									accuracy >= 90, // A:
									accuracy >= 85, // A.
									accuracy >= 80, // A
									accuracy >= 70, // B
									accuracy >= 60, // C
									accuracy < 60 // D
								];
						
								for(i in 0...wifeConditions.length)
								{
									var b = wifeConditions[i];
									if (b)
									{
										switch(i)
										{
											case 0:
												ranking += " AAAAA";
											case 1:
												ranking += " AAAA:";
											case 2:
												ranking += " AAAA.";
											case 3:
												ranking += " AAAA";
											case 4:
												ranking += " AAA:";
											case 5:
												ranking += " AAA.";
											case 6:
												ranking += " AAA";
											case 7:
												ranking += " AA:";
											case 8:
												ranking += " AA.";
											case 9:
												ranking += " AA";
											case 10:
												ranking += " A:";
											case 11:
												ranking += " A.";
											case 12:
												ranking += " A";
											case 13:
												ranking += " B";
											case 14:
												ranking += " C";
											case 15:
												ranking += " D";
										}
										break;
									}
								}
						
								if (accuracy == 0)
									ranking = "N/A";
						
								return ranking;
							}


	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			{
				goodNoteHit(note);
				
				if (FlxG.save.data.hitsounds)
					{
						FlxG.sound.play(Paths.sound('normal-hitnormal'), 0 + FlxG.save.data.hitsoundvolume);	
					}	
			}
	}

		

	function goodNoteHit(note:Note):Void
	{
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		
		
		if (!note.wasGoodHit)
		{
					if (!FlxG.save.data.playerstrumlights)
						{
							playerStrums.forEach(function(spr:FlxSprite)
								{
									spr.animation.play('static');
									spr.centerOffsets();
								});
						}
						
			if (!note.isSustainNote)
			notesHitArray.unshift(Date.now());

			if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (SONG.notes[Math.floor(curStep / 16)].altAnim2)
						altAnim2 = '-alt';
					else
						altAnim2 = '';
				}

				if (note.altNote)
					{
						altAnim2 = '-alt';
					}	
						
			updateAccuracy();
			rating();
			if (FlxG.save.data.pscyheenginescoretext)
			ratingPsyche();

			if (!note.isSustainNote)
			{
				notesPassing += 1;
				popUpScore(note);
				///popUpScore(note.strumTime);
				combo += 1;
				truecombo += 1;
				if (highestcombo <= truecombo)
				highestcombo = truecombo;
			}
			else
				totalNotesHit += 1;

			if (note.noteData >= 0)
				{
						health += 0.023;
				}
			else
				health += 0.004;

			if (FlxG.save.data.notesplashes && note.isSustainNote && FlxG.save.data.notesplashhold && Rating == 'sick')
				{
					var recycledNote = grpNoteSplashes.recycle(NoteSplash);
					if (FlxG.save.data.botplay)
					recycledNote.setupNoteSplash(note.x - 30, note.y - 30, note.noteData);
					else if (FlxG.save.data.downscroll)
					recycledNote.setupNoteSplash(note.x - 30, note.y + 70, note.noteData);
					else
					recycledNote.setupNoteSplash(note.x - 30, note.y - 70, note.noteData);
					grpNoteSplashes.add(recycledNote);
				}

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT' + altAnim2, true);
					if (!boyfriend.animation.curAnim.name.startsWith("sing") && !FlxG.save.data.playerstrumlights)
						{
							playerStrums.forEach(function(spr:FlxSprite)
								{
									spr.animation.play('static');
									spr.centerOffsets();
								});
						}
				case 1:
					boyfriend.playAnim('singDOWN' + altAnim2, true);
					if (!boyfriend.animation.curAnim.name.startsWith("sing") && !FlxG.save.data.playerstrumlights)
						{
							playerStrums.forEach(function(spr:FlxSprite)
								{
									spr.animation.play('static');
									spr.centerOffsets();
								});
						}
				case 2:
					boyfriend.playAnim('singUP' + altAnim2, true);
					if (!boyfriend.animation.curAnim.name.startsWith("sing") && !FlxG.save.data.playerstrumlights)
						{
							playerStrums.forEach(function(spr:FlxSprite)
								{
									spr.animation.play('static');
									spr.centerOffsets();
								});
						}
				case 3:
					boyfriend.playAnim('singRIGHT' + altAnim2, true);
					if (!boyfriend.animation.curAnim.name.startsWith("sing") && !FlxG.save.data.playerstrumlights)
						{
							playerStrums.forEach(function(spr:FlxSprite)
								{
									spr.animation.play('static');
									spr.centerOffsets();
								});
						}
			}
			
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (FlxG.save.data.botplay)
					{
							playerStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(note.noteData) == spr.ID)
										{
											if (FlxG.save.data.botplay)
												{
															if (!FlxG.save.data.playerstrumlights)
																{
																	spr.animation.play('static');
																	spr.centerOffsets();
																}
																else if (FlxG.save.data.playerstrumlights)
																{
																	spr.animation.play('confirm', true);
																}				
												}
												else
													{
														
																if (!FlxG.save.data.playerstrumlights)
																	{
																		spr.animation.play('static');
																		spr.centerOffsets();
																	}
																	else if (FlxG.save.data.playerstrumlights)
																		{
																			spr.animation.play('confirm', true);
																		}		
													}		
										}
										else
											{
												{
											
													spr.centerOffsets();
													if (spr.animation.finished)
														{
															spr.animation.play('static');
															spr.centerOffsets();
														}	
												}
											}

											{
												playerStrums.forEach(function(spr:FlxSprite)
												{
													if (spr.animation.finished)
													{
														if (FlxG.save.data.playerstrumlights)
															{
																spr.animation.play('static');
																spr.centerOffsets();
															}
													}
												});
											}
								});	
					}
					else
						{
							if (Math.abs(note.noteData) == spr.ID)
								{
									if(!FlxG.save.data.playerstrumlights)
										{
											spr.animation.play('static');
											spr.centerOffsets();
										}
										else
											{
												spr.animation.play('confirm', true);	
											}
								}
						}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}


	var fastCarCanDrive:Bool = true;

	function getsonginfo():Void
		{
			songwithoutdashes = StringTools.replace(PlayState.SONG.song, "-", " ").toLowerCase();
			//note to self: i should probably automate this procces somehow so people don't have to type out what song has what composers and whatnot...
			// i did it is in the json now
			// thank you
		}

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}


	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
		/*#if cpp
		if (FlxG.timeScale != 1)
			{
				if (FreeplayState.gamespeed > 1)
					{
						@:privateAccess
						{
							if (trainSound.playing)
								lime.media.openal.AL.sourcef(trainSound._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
							//sniper gaming looking for a way to pitch vocals without cpp
						}
						///trace("pitched inst and vocals to " + FlxG.timeScale);
					 
					}			
		

		if (FreeplayState.gamespeed < 1)
			{
				{
					@:privateAccess
					{
						if (trainSound.playing)
							lime.media.openal.AL.sourcef(trainSound._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, FreeplayState.gamespeed);
						//sniper gaming looking for a way to pitch vocals without cpp
					}
					///trace("pitched inst and vocals to " + gamespeed);
				}
			}
			}
		#end*/
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
       #if cpp
		if (FlxG.save.data.showratings && songStarted && !endingSong)
			{
				ratingsd = " | " + ratings.text;
			}
			else
				{
					ratingsd = "";	
				}
		#end		
		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].camerashake && curStep == SONG.notes[Math.floor(curStep / 16)].camerashaketrigger)
					{
						if (SONG.notes[Math.floor(curStep / 16)].shakegamecamera)
						FlxG.camera.shake(SONG.notes[Math.floor(curStep / 16)].camerashakeamount, SONG.notes[Math.floor(curStep / 16)].camerashakeduration);
						if (SONG.notes[Math.floor(curStep / 16)].shakeHUD)
							camHUD.shake(SONG.notes[Math.floor(curStep / 16)].camerashakeamount, SONG.notes[Math.floor(curStep / 16)].camerashakeduration);
					}
			}

			if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (SONG.notes[Math.floor(curStep / 16)].crossFade && !trailon)
						{
							if (!trail.alive)
							trail.revive();
							trail.visible = true;
							trailon = true;
							trail.x = dad.x + 50;
						}
					else if (trailon && !SONG.notes[Math.floor(curStep / 16)].crossFade)
						{
							trail.visible = false;
							trail.kill();
							trailon = false;
						}
				}
					

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		
		if (curStep == 937 && SONG.song.toLowerCase() == 'Eggnog' && !FlxG.save.data.usedeprecatedloading)
			{
				var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
					-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;
			
					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
			}

				#if cpp
				if (!ischeating)
					{
						if (startTimer.finished && !paused)
							DiscordClient.changePresence(detailsText + SONG.song + storyDifficultyText + botplayd + practicemodeon + ratingsd, " Rating: " + songRating + " (" + fullcombotext + ")" + " | Cur Acc: " + baseText2 + " | All Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
					}
				
				#end				

			// Song duration in a float, useful for the time left feature
				songLength = FlxG.sound.music.length;


			if (curSong.toLowerCase() == 'avidity' && curStep >= 737 && curStep < 768 && !SONG.notes[Math.floor(curStep / 16)].disablecamzooming)
				{
					if (FlxG.save.data.camzooming && FlxG.camera.zoom < 1.35 && curStep % 2 == 0)
						{
							FlxG.camera.zoom += 0.020;
							camHUD.zoom += 0.04;
						}
				}
				if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (!endingSong && songStarted)
							{
								if (curStep >= SONG.notes[Math.floor(curStep / 16)].camerazoomtrigger && curStep < SONG.notes[Math.floor(curStep / 16)].camerazoomtrigger2 && SONG.notes[Math.floor(curStep / 16)].camzooming && SONG.notes[Math.floor(curStep / 16)].curstepzooming)
									{
										if (FlxG.save.data.camzooming && FlxG.camera.zoom < 1.35 && curStep % SONG.notes[Math.floor(curStep / 16)].camerazoompercentinput == 0)
											{
												FlxG.camera.zoom += SONG.notes[Math.floor(curStep / 16)].flixelcamerazoom;
												camHUD.zoom += SONG.notes[Math.floor(curStep / 16)].flixelHUDzoom;
											}
									}
							}
					}
				if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (!endingSong && songStarted)
							{
								if (SONG.notes[Math.floor(curStep / 16)].curstepanim && SONG.notes[Math.floor(curStep / 16)].playanim)
									{
										if (curStep == SONG.notes[Math.floor(curStep / 16)].steppernumanim)
											{
												if (SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'dad')
													{
														dad.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced);	
													}
													else if (SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'boyfriend')
														{
															boyfriend.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced);	
														}
														else if (SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'gf')
															{
																gf.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced);	
															}
											}
									}
							}
					}

					if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (!endingSong && songStarted && SONG.notes[Math.floor(curStep / 16)].islooped && SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'dad' && SONG.notes[Math.floor(curStep / 16)].curstepanim)
								{
												{
														{
															dad.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced); // should play the anim for the entire section.
														}
												}				
								}
			
								if (!endingSong && songStarted && SONG.notes[Math.floor(curStep / 16)].islooped && SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'boyfriend' && SONG.notes[Math.floor(curStep / 16)].curstepanim)
								{
												{
														{
															boyfriend.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced); // should play the anim for the entire section.
														}
												}				
								}
			
								if (!endingSong && songStarted && SONG.notes[Math.floor(curStep / 16)].islooped && SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'gf' && SONG.notes[Math.floor(curStep / 16)].curstepanim)
									{
													{
															{
																gf.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced); // should play the anim for the entire section.
															}
													}			
									}
						}
					
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();
		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (!endingSong && songStarted && SONG.notes[Math.floor(curStep / 16)].gfspeed)
					{
					 gfSpeed = SONG.notes[Math.floor(curStep / 16)].sectiongfspeed;
					}
			}
		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (!endingSong && songStarted)
					{
						if (curBeat >= SONG.notes[Math.floor(curStep / 16)].camerazoomtrigger && curBeat < SONG.notes[Math.floor(curStep / 16)].camerazoomtrigger2 && SONG.notes[Math.floor(curStep / 16)].camzooming && SONG.notes[Math.floor(curStep / 16)].curbeatzooming)
							{
								if (FlxG.save.data.camzooming && FlxG.camera.zoom < 1.35 && curBeat % SONG.notes[Math.floor(curStep / 16)].camerazoompercentinput == 0)
									{
										FlxG.camera.zoom += SONG.notes[Math.floor(curStep / 16)].flixelcamerazoom;
										camHUD.zoom += SONG.notes[Math.floor(curStep / 16)].flixelHUDzoom;
									}
							}
					}
			}

			if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (!endingSong && songStarted)
						{
							if (SONG.notes[Math.floor(curStep / 16)].curbeatanim && SONG.notes[Math.floor(curStep / 16)].playanim)
								{
									if (curBeat == SONG.notes[Math.floor(curStep / 16)].steppernumanim)
										{
											if (SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'dad')
												{
													dad.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced);
												}
												else if (SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'boyfriend')
													{
														boyfriend.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced);	
													}
													else if (SONG.notes[Math.floor(curStep / 16)].charactertoplayon == 'gf')
														{
															gf.playAnim(SONG.notes[Math.floor(curStep / 16)].animtoplay, SONG.notes[Math.floor(curStep / 16)].isforced);
														}
										}
								}
						}
				}



		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}
		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (!endingSong && songStarted)
					{
						if (SONG.notes[Math.floor(curStep / 16)].camzoomonp1 && curBeat % 4 == 0) // depends on how long the section is?, temporary solution for now ig
							{
								triggeredcamera = true;
								FlxTween.tween(FlxG.camera, {zoom: SONG.notes[Math.floor(curStep / 16)].camzoomamountp1}, (Conductor.stepCrochet * SONG.notes[Math.floor(curStep / 16)].camzoomtime / 1000), {ease: FlxEase.quadInOut, onComplete: fixzoom});
							}
							else if (curBeat % 4 == 0 && triggeredcamera)
								{
									defaultstagezoom();
									triggeredcamera = false;
								}
					}
			}

			


		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes / play him anims for too long // yeah but will idle if its not his turn, therefore making him idle when the camera is not on him
			 if (dad.curCharacter == 'dad' && (SONG.notes[Math.floor(curStep / 16)].mustHitSection))
				{
					dad.dance();
				}
				else if ((SONG.notes[Math.floor(curStep / 16)].mustHitSection) && oldidlecode)
					{
						dad.dance();
					}
			///if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				///dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && FlxG.save.data.camzooming && FlxG.camera.zoom < 1.35 && !SONG.notes[Math.floor(curStep / 16)].disablecamzooming)
					{
						FlxG.camera.zoom += 0.015;
						camHUD.zoom += 0.03;
					}
			}

		if (!triggeredalready)
			{
				if (songStarted && !endingSong && FlxG.save.data.songinfo)
					{
						songinfobar();
				        triggeredalready = true;
					}
			}
			if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (FlxG.save.data.camzooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
						{
							if (!endingSong && songStarted && !SONG.notes[Math.floor(curStep / 16)].disablecamzooming)
								{
									FlxG.camera.zoom += 0.015;
									camHUD.zoom += 0.03;
								}
						}
				}

		if (!FlxG.save.data.hideHUD && addedhealthbarshit)
			{
				iconP1.setGraphicSize(Std.int(iconP1.width + 30));
				iconP2.setGraphicSize(Std.int(iconP2.width + 30));
				iconP1.updateHitbox();
		        iconP2.updateHitbox();
			}																					



		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.animation.curAnim.name != SONG.notes[Math.floor(curStep / 16)].animtoplay)
					{
						boyfriend.playAnim('idle');
					}
			}

			
			if (boyfriend.animation.curAnim.name == "hey" && curSong.toLowerCase() == 'bopeebo')
				{
				    if (curBeat % 2 == 0)
						{
							boyfriend.playAnim('idle');
						}
				}
			
			
			
			if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (dad.animation.curAnim.name.startsWith("sing") && dad.curCharacter != 'gf')
						{
							///idle has been canceled btw
						}
						else if (!dad.animation.curAnim.name.startsWith("sing") && dad.animation.curAnim.name != SONG.notes[Math.floor(curStep / 16)].animtoplay)
							{
								dad.dance();
							}
				}

			if (SONG.notes[Math.floor(curStep / 16)] != null && SONG.notes[Math.floor(curStep / 16)].gfsection)
				{

				}	
				// idle every second beat

		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left && !FlxG.save.data.botplay && onbeat)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
							{
								boyfriend.playAnim('idle');
							}
				}
			}
			

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			//boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				if (curSong.toLowerCase() == 'roses' || curSong.toLowerCase() == 'senpai')
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;
                if (!FlxG.save.data.optimizations)
					{
							if (curBeat % 4 == 0)
								{
									phillyCityLights.forEach(function(light:FlxSprite)
									{
										light.visible = false;
									});
				
									curLight = FlxG.random.int(0, phillyCityLights.length - 1);
				
									phillyCityLights.members[curLight].visible = true;
									// phillyCityLights.members[curLight].alpha = 1;
								}
					}
					
						
						

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	public static function speedchange():Void
	{
		if (FreeplayState.gamespeed >= 0) // going under 0 freezes ur game
			{
				FlxG.timeScale = FreeplayState.gamespeed;	
			}
			else
				{
					gamespeed = FreeplayState.gamespeed;
				}
		needstopitch = true;
		dontstopold = false;
	}
	
     function defaultstagezoom():Void
		{
			switch (SONG.song.toLowerCase()) // put the default cam zoom for ur stage here
				{
					case 'spookeez' | 'monster' | 'south': 
						{
						 defaultCamZoom = 1.05;
						}
					   case 'pico' | 'blammed' | 'philly': 
					   {
						 defaultCamZoom = 1.05;
					   }
					   case 'milf' | 'satin-panties' | 'high' | 'avidity':
					   {
						 defaultCamZoom = 0.90;
					   }
					   case 'cocoa' | 'eggnog':
					   {
						 defaultCamZoom = 0.80;
					   }
					   
					   case 'winter-horrorland':
					   {
						 defaultCamZoom = 1.05;
					   }
					   case 'senpai' | 'roses' | 'thorns':
					   {
						 defaultCamZoom = 1.05;
					   }
					   default:
					   {
						 defaultCamZoom = 0.9;
					   }// make it pull from the json you idiot.	   			
				}
		}

		function songinfobar():Void
			{
				FlxTween.tween(songInfo, {alpha: 1, y: 20}, 0.8, {ease: FlxEase.quartInOut, startDelay: 0.3});
				new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTween.tween(songInfo, {alpha: 0, y: -20}, 0.8, {ease: FlxEase.quartInOut, startDelay: 0.3});
					});
				FlxTween.tween(blackBorder, {alpha: 0.5}, 0.8, {ease: FlxEase.quartInOut, startDelay: 0.3});
				new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTween.tween(blackBorder, {alpha: 0, y: -20}, 0.8, {ease: FlxEase.quartInOut, startDelay: 0.3});
					});
				FlxTween.tween(songInfo2, {alpha: 1, y: 47}, 0.8, {ease: FlxEase.quartInOut, startDelay: 0.3});
				new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTween.tween(songInfo2, {alpha: 0, y: -20}, 0.8, {ease: FlxEase.quartInOut, startDelay: 0.3});
					});		
			}

			function fixzoom(tween:FlxTween):Void
				{
					if (SONG.notes[Math.floor(curStep / 16)].camzoomonp1)
						{
							defaultCamZoom = SONG.notes[Math.floor(curStep / 16)].camzoomamountp1;
						}
				}



	var curLight:Int = 0;
}
