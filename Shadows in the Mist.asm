# Name: █████████ █████
# Course: CSC_35
# Term & Year: ██████ ████
# Project: Final Project
#
# 1. Assemble	: as -o final.o Final.asm
# 2. Link		: ld -o a.out final.o csc35.o
# 3. Execute	: ./a.out
#
# Registors:
# rax: Lost / Special flag / Attack Damage		r8:  Health
# rbx: Block or Attack choice					r9:  Stamina
# rcx: MonsterDamage							r10: Sanity
# rdx: MonsterHealth							r11: Days till insane
# rsi: days to castle							r12: random1 / Delta Health
# rbp:--										r13: random2 / Delta Stamina
# rsp:--										r14: random3 / Delta Sanity / Sheild blocked
# r15: default choice / MonsterHealth
#
# color codes:
# 0. Black	4. Blue
# 1. Red	5. Magenta
# 2. Green	6. Cyan
# 3. Yellow	7. White
#
# NOTES:  
#		There are 4 ways to end the game: 1. Health = 0, 2. Sanity = 0, 3. Days to castle is > Days left until you go insane, 4. Days to Castle = 0
#		There are 8 entirely random events 1 conditional random event and 1 conditional event, for a total of 10 events in the game
#		4 Random combat events with 1 of those combat events containing 1 conditional event
#		2 Random rest events
#		2 Random Meditation Events
#		1 conditional radnom event where Health >= 81, Stamina >= 80, & Sanity >= 80 conditions must be met before event has chance of appearing
#
#		Game structure is broken up (as much as I was able to) into 3 main areas, 1. the MAIN (Line: 1136) area where most most the game functinality and check and order of operations are,
#		2. Text output Subroutines (Line: 1593, here is where anything that will be outputed to a screen will be called from. 3. Game Logic (Line: 2161), this is where any shuffling of registors or values happens

.intel_syntax noprefix
.data

# ***************************************************************** Game Start text prompts *************************************************************************
GameTitle:
	.ascii "\t\t\t\t\t\t╔═╗┬ ┬┌─┐┌┬┐┌─┐┬ ┬┌─┐  ┬┌┐┌  ┌┬┐┬ ┬┌─┐  ╔╦╗┬┌─┐┌┬┐\n"
	.ascii "\t\t\t\t\t\t╚═╗├─┤├─┤ │││ ││││└─┐  ││││   │ ├─┤├┤   ║║║│└─┐ │ \n"
	.ascii "\t\t\t\t\t\t╚═╝┴ ┴┴ ┴─┴┘└─┘└┴┘└─┘  ┴┘└┘   ┴ ┴ ┴└─┘  ╩ ╩┴└─┘ ┴ \n\n\0"
	
GameIntro1:
	.ascii "\tYou slowly open your eyes to find yourself lying on the ground in the middle of a forest that smells of dampness and decay. Your head\nthrobs with pain, "
	.ascii "and your vision is blurry. As you try to get up, you realize that your body is weak, and your movements are slow. You don't\nremember "
	.ascii "how you got here.\n\n\tAs you stand up, you feel a sense of dread wash over you as you realize where you are. The Howling Woods is known to be cursed,\n"
	.ascii "and its dark energy can cause people to lose their minds over time. The air is thick with a fog that seems to be alive, and the ground\nbeneath your feet "
	.ascii "is damp and slippery.\n\n\tYou take a few steps forward and begin to feel the effects of the curse. Your thoughts become cloudy, and you struggle to focus on your\n"
	.ascii "surroundings. You can feel The Howling Woods slowly but surely causing you to go lose your grip on reality.\n"
	.ascii "\n\tSuddenly, you hear a deafening roar, and before you can react, a Nightstalker leaps out from the shadows towards you. It's a grotesque\n"
	.ascii "creature with razor-sharp teeth, glowing red eyes, and a body coverd in matted fur. Its limbs are long and twissted, and its movements are\n"
	.ascii "erratic and unpredictable.\n\n\tAs the Nightstalker lunges at you, you can feel your heart pounding in your chest. You draw your weapon and prepare to fight.\n"
	.ascii "The Nightstalker is fast and agile, and its attacks are ferocious. You must manage your health, stamina, and sanity carefully if you want to survive.\n"
	.ascii "\n\tIn the heat of the battle, the Nightstalker lands a vicious blow, and you feel a searing pain as its claws tear through your flesh.\n"
	.ascii "You grit your teeth and fight back with all your might, unleashing a flurry of devastating attacks on the Nightstalker.\n\n\0"

GameIntro2:
	.ascii "\tBut as the fight continues, you begin to feel a dampness on your clothing. Looking down, you see blood seeping from a deep wound in your side\n"
	.ascii "where the Nightstalker's claws had penetrated your skin.\n"
	.ascii "\n\tThe longer this fight goes on the greater the chance this beast will kill you. With a final vicious strike, you sink your blade deep in\n"
	.ascii "the beasts chest. But before it dies, it lets out a death-pitched scream that makes your blood run cold. As its lifeless body twitches, the\n"
	.ascii "forest around you stirs uneasily, and you can feel the darkness of The Howling Woods closing in around you.\n"
	.ascii "\n\tYou breathe a sigh of relief and take a moment to catch your breath. But the wound the Nightstalker inflicted on you is severe, and\n"
	.ascii "you can feel your strength draining away.\n"
	.ascii "\n\tYou must find a way to heal yourself quickly if you want to survive the journey ahead. The path to the castle is treacherous, and\n"
	.ascii "you must navigate through The Howling Woods while being attacked by these monstrous creatures at every turn.\n"
	.ascii "\n\tYou take a deep breath and muster up all your courage. You will need to use all your skills and resources to make it back to the castle\n"
	.ascii "alive. Will you be able to manage your health, stamina, and sanity effectively, and fight off the madness and horrors that are slowly consuming you?\n"
	.ascii "The journey ahead will be challenging, but the rewards will be great. It's time to embark on this adventure and prove yourself as a hero.\n\n\0"

GameExplain1:
	.ascii "\n                                                           ╔═╗┌┐  ┬┌─┐┌─┐┌┬┐┬┬  ┬┌─┐"
	.ascii "\n                                                           ║ ║├┴┐ │├┤ │   │ │└┐┌┘├┤ "
	.ascii "\n***********************************************************╚═╝└─┘└┘└─┘└─┘ ┴ ┴ └┘ └─┘*******************************************************************\n\0"

GameExplain2:
	.ascii "\tSurvive The Howling Woods until you reach your kingdom before your sanity reaches 0 and you're lost to the forest. You know your kingdom\n"
	.ascii "lays west so that is the diretion you'll travel using the sun to guide you.\n"
	.ascii "\n\tAt the start of the game, the player's maximum health, stamina, and sanity values are set to 100. However, due to the wound inflicted by\n"
	.ascii "the Nightstalker, the player's initial health value is reduced to 80 to start.\n"
	.ascii "\n\tEach day you will be given 3-5 options. Your sanity will decrease by 10-20 points a day. You estimate that you have"
	.ascii " 120 days before you will go\ncompletely insane, regardless of your sanity levels; And you estimate that it will take 60 days of tavel to reach the castle.\n"
	.ascii "\n\tIf your sanity reaches 0, you will transform into a Shadow Beast, "
	.ascii "a feral, mindless creature consumed by the darkness of The Howling Woods.\nResting or Meditating won't take you closer to the castle, only Hunting will.\n\0"

JourneyStart:
	.ascii "\nAre you ready to escape the forest?\n\t1. Resist the Madness\n\t2. Submit to the Madness of The Howing Woods\n\0"
# ****************************************************************************** Game Prompts *************************************************************************

DaysLeftText:
	.ascii " are left until you go insane.\n\0"
	
DaysToCastleText:
	.ascii " days to castle.\n\0"

PromtPlayer:
	.ascii "What choice will you make?\n\0"
# ***************************************************************************** Players Decisions based on state of game **********************************************
GameOptions:
	.ascii "\t1. Hunt: Increase Health: 10-15 points, Decrease Stamina: 5-10 points, but risk risk becoming the hunted\n"
	.ascii "\t2. Rest: Increase Health: 25-35 Points, Increase Stamina: 30-50 points, but risk losing sanity due to the brutal nature of the forest\n"
	.ascii "\t3. Meditate: Increase Sanity: 25-45 points, Increase: Stamina by 10-15 points. Chance of Favorable/Unfavorable experience.\n\n\0"
	
CombatOptions:
	.ascii "\t1. Light Attack: Attack Creature for 10-30 points of damange.\n"
	.ascii "\t2. Heavy Attack: Attack for 30-40 points of damage *Comsume 10 Stamina; Stamina < 10, will preform Light Attack*\n"
	.ascii "\t3. Block: Defend from 10-35 points of damage; *10% chance to Sheild Bash for 5-25 points of damage*\n"
	.ascii "\t4. Counter Attack: Attempt to counter attack for 15-80 points of damage *50% chance Dodge; fail +15 damage, Comsume 15 Stamina*\n"
	.ascii "\t5. Flee: FLEE WITH EXTRA FLEE!!!!! *Consumes 20-40 Stamina, Add 2 days to journey*\n\0"
	
SpecialOptions:
	.ascii "\t 1. Look in into the Crytal Skulls Eyes and give into the insanity. * -50 Health, -50 Stamina, -50 Sanity, Shorten journey by 1 - 3 days*\n"
	.ascii "\t 2. Continue on your current path and leave this cursed place behind.\n\0"

# ******************************************************************************* Game Text ************************************************************************************

HuntText:
	.ascii "\nYou decide to go hunting.\n\0"

RestText:
	.ascii "\nYou decide to rest.\n\0"

MeditateText:
	.ascii "\nYou decided to meditate.\n\0"
	
CombatVictoryText:
	.ascii "You Defeated The Beast!\n\0"

HealthIncreased:
	.ascii "Health Increased by: \0"
	
HealthDecreased:
	.ascii "Health Decreased by: \0"

StaminaIncreased:
	.ascii "Stamina Increased by: \0"
	
StaminaDecreased:
	.ascii "Stamina Decreased by: \0"

SanityIncreased:
	.ascii "Sanity Increased by: \0"
	
SanityDecreased:
	.ascii "Sanity Decreased by: \0"
	
AttackText:
	.ascii "Attacked for: \0"
	
BlockedText:
	.ascii "Blocked for: \0"
	
FleeText:
	.ascii "You Flee from the beast, with extra FLEE!!! 1 Day added to Journey\n\0"
	
TryAgainText:												
	.ascii "Care to try again?\n"
	.ascii "\t1. You haven't bested me yet!\n"
	.ascii "\t2. The Howling Woods can have me. I'll become yet another Shadow in the Mist.\n\0"
	
DeathText:
	.ascii "\t\t\t╦ ╦┌─┐┬ ┬  ╔═╗┌─┐┬─┐┬┌─┐┬ ┬┌─┐┌┬┐  ┌┬┐┌─┐  ┌┬┐┬ ┬┌─┐  ╦ ╦┌─┐┬ ┬┬  ┬┌┐┌┌─┐  ╦ ╦┌─┐┌─┐┌┬┐┌─┐\n"
	.ascii "\t\t\t╚╦╝│ ││ │  ╠═╝├┤ ├┬┘│└─┐├─┤├┤  ││   │ │ │   │ ├─┤├┤   ╠═╣│ │││││  │││││ ┬  ║║║│ ││ │ ││└─┐\n"
	.ascii "\t\t\t ╩ └─┘└─┘  ╩  └─┘┴└─┴└─┘┴ ┴└─┘─┴┘   ┴ └─┘   ┴ ┴ ┴└─┘  ╩ ╩└─┘└┴┘┴─┘┴┘└┘└─┘  ╚╩╝└─┘└─┘─┴┘└─┘\n\0"
	
EscapeText:
	.ascii "\t\t\t\t\t\t\t   ╦ ╦┌─┐┬ ┬  ╔═╗┌─┐┌─┐┌─┐┌─┐┌─┐┌┬┐┬\n"
	.ascii "\t\t\t\t\t\t\t   ╚╦╝│ ││ │  ║╣ └─┐│  ├─┤├─┘├┤  │││\n"
	.ascii "\t\t\t\t\t\t\t    ╩ └─┘└─┘  ╚═╝└─┘└─┘┴ ┴┴  └─┘─┴┘o\n\0"
	
LostText:
	.ascii "\t\t\t\t\t\t╦  ┌─┐┌─┐┌┬┐  ┌┬┐┌─┐  ┌┬┐┬ ┬┌─┐  ╔═╗┌─┐┬─┐┌─┐┌─┐┌┬┐\n"
	.ascii "\t\t\t\t\t\t║  │ │└─┐ │    │ │ │   │ ├─┤├┤   ╠╣ │ │├┬┘├┤ └─┐ │ \n"
	.ascii "\t\t\t\t\t\t╩═╝└─┘└─┘ ┴    ┴ └─┘   ┴ ┴ ┴└─┘  ╚  └─┘┴└─└─┘└─┘ ┴ \n\0"
	
ShadowBeastPicText:
	.ascii "\t\t\t\t\t\t\t\t╔═╗┬ ┬┌─┐┌┬┐┌─┐┬ ┬  ╔╗ ┌─┐┌─┐┌─┐┌┬┐\n"
	.ascii "\t\t\t\t\t\t\t\t╚═╗├─┤├─┤ │││ ││││  ╠╩╗├┤ ├─┤└─┐ │ \n"
	.ascii "\t\t\t\t\t\t\t\t╚═╝┴ ┴┴ ┴─┴┘└─┘└┴┘  ╚═╝└─┘┴ ┴└─┘ ┴ \n\0"

DreadClawText:
	.ascii "\tWhile tracking through the dense foliage of The Howling Woods, you spot what you think to be a Buck at first, but soon find you’re\n"
	.ascii "mistaken. The creature being tracked was no deer, but a twisted and darkly beautiful creature with gnarled antlers and shimmering black fur.\n"
	.ascii "Its eyes glinted with an otherworldly intelligence, and its hooves left next to no trace as it moved through the forest. It’s a miracle you\n"
	.ascii "were able to track it this far.\n\tYou slowly pull your bow from your back and draw and arrow from your quiver. From this distance you should be able to make a clean\n"
	.ascii "kill. You take a kneeling stance, take a breath, and draw your bow.\n"
	.ascii "\n\tJust as you are about to release your arrow when suddenly you hear a sound coming from above. Looking up, you catch a glimpse of a\n"
	.ascii "sleek and dangerous-looking beast with razor-sharp claws and gleaming yellow eyes perched on a high tree branch.\n"
	.ascii "\n\tWithout warning, the creature lunges at you, its deadly claws slashing through the air."
	.ascii " You attempt to adjust your aim with your bow,\nbut it happens too fast and you shoot wide. The creature barrels down on you, knocking you both to the ground. The Dreadclaw sinks its sharp\n"
	.ascii "teeth into your shoulder, causing you to cry out in pain. With adrenaline coursing through your veins, you muster all your strength and manage\n"
	.ascii "sto grab hold of the creature's neck, throwing it off of you with all you might. As the beast recoils, you take the opportunity to draw your\nsword and prepare for another attack.\n\0"

MinotaurText:
	.ascii "\tAs you made your way through the mist-shrouded forest, you hear a faint sound in the distance. It was the sound of something moving through\nthe underbrush, and it was getting closer.\n"
	.ascii "\n\tAs you turn a corner, you find yourself face to face with a creature unlike any you’ve ever seen. It has a humanoid figure, but its skin is\n"
	.ascii "covered in scales and its eyes glow an eerie green. It strikes you as a minotaur, or a version of one. A creature thought to be a myth. The creature\n"
	.ascii "is wielding a long double bladed axe, and it let out a guttural growl as it charged towards the hero. Your heart races as you realize this is no\n"
	.ascii "ordinary animal. You draw your weapon and prepare for the worst.\n"
	.ascii "\n\tYou dodge to the side, barely avoiding the deadly weapon. You swing your weapon at the creature, but it's quick and agile, easily avoiding\n"
	.ascii "your attack. You step back, trying to gain some distance and catch your breath. Before going on the offensive.\n\0"

NightStalkerText:
	.ascii "\tYou are quietly stalking through the Howling Woods, bow in hand, searching for prey. As you make your way through the dense undergrowth\n"
	.ascii "of the Howling Woods, you suddenly hear a rustling in the nearby bushes. You tense up, hand nocking an arrow to your bow, and slowly make your\n"
	.ascii "way towards the noise.\n"
	.ascii "\n\tOut of the shadows, the nightstalker emerges, its glowing eyes fixed on you. You draw your bow and prepare to fight, but the beast is\n"
	.ascii "too fast. With lightning speed, it lunges forward, knocking your bow out of your hand and sending it flying into the underbrush. With a growl,\n"
	.ascii "the nightstalker turns its attention back to you, ready to strike again. You draw your sword and wondering how many more nightmares there are\nin this cursed place.\n\0"

SpiderText:
	.ascii "\tAs you stalk through the thick undergrowth of the Howling Woods, your senses on high alert, you suddenly hear a faint clicking sound.\n"
	.ascii "You slow your breathing, trying to pinpoint the source of the noise. It gets louder and closer, until you spot movement among the leaves. A\n"
	.ascii "large, black spider-like creature scurries out of a nearby bush, its multiple legs skittering over the ground.\n"
	.ascii "\n\tYou freeze, watching as it raises its bulbous abdomen and hisses at you, revealing a set of a mouth full of sharp fangs, and four claw like\n"
	.ascii "horns coming out of it's face. It's unlike any spider you've ever seen before - its body is covered in spines, and it seems to be the size of a\n"
	.ascii "large dog. The creature continues to hiss and advance towards you, its eyes glinting in the dappled sunlight. You loose an arrow at it, striking it\n"
	.ascii "in the fleshy part of its abdomen. You draw your sword, praying that the smell that just entered your nose is coming from this viel creature and not\nyour own set of trousers.\n\0"

MindGame1Text:
	.ascii "\tAs you settle down to rest, your eyelids begin to droop and you feel the weariness of your journey take hold. But as you close your eyes,\n"
	.ascii "you start to see strange and unsettling visions. At first, it's just minor things like a tree branch that seems to move on its own, or a whisper\n"
	.ascii "that you can't quite make out. But as time passes, the hallucinations become more vivid and unnerving. You see twisted versions of the creatures\n"
	.ascii "you've encountered, and they speak to you in eerie, incomprehensible tongues.\n"
	.ascii "\n\tThe sounds of the forest become muddled and warped, and your thoughts start to blur together. You feel as though you're losing your grip\n"
	.ascii "on reality, and you can't tell what's real and what's not. You try to shake yourself awake, but the hallucinations persist. It's only after what\n"
	.ascii "feels like an eternity that the effects begin to subside, leaving you feeling drained and confused.\n\tAs you stand up, you wonder what other terrors this forest has in store for you. You lost 5 additional Sanity\n\0"

MindGame2Text:
	.ascii "\tAs you settle down to rest, you feel a sudden chill in the air. The mist around you thickens, and you begin to hear strange whispers\n"
	.ascii "and murmurs. You try to shrug it off and close your eyes, but the whispers become louder and more urgent. Suddenly, you feel something brush\n"
	.ascii "against your face, and you jolt awake.\n\n\tYou find yourself staring into the glowing eyes of a strange creature, its long fingers inches from your face. Its skin is slick and\n"
	.ascii "slimy, and it exudes a putrid odor that makes your stomach turn. You scramble to your feet and draw your weapon, but the creature simply\nvanishes into the mist.\n"
	.ascii "\n\tShaken, you realize that you cannot rest safely in this forest. You steel yourself and continue on, wary of what other terrors may\nlie ahead. You lost 5 additional Sanity\n\0"

EnlightenmentText:
	.ascii "\tYou sit down and begin to meditate, focusing your mind and breathing deeply. As you do, you feel your thoughts and worries begin to drift\naway, replaced by a sense of calm and clarity.\n"
	.ascii "\n\tAs you continue to meditate, you feel a deep sense of inner peace and stillness wash over you. You begin to feel as if you are floating,\nweightless and free.\n"
	.ascii "\n\tSuddenly, you become aware of a new path that you had not noticed before. It seems to be a shortcut that will take you directly to the\ncastle, bypassing many of the dangers and obstacles you had encountered before.\n"
	.ascii "\n\tYou feel a sense of enlightenment and understanding wash over you, as if you have been given a glimpse into the true nature of things.\n"
	.ascii "You stand up, feeling refreshed and renewed, ready to face whatever challenges lie ahead on your journey to the castle.\n"
	.ascii "\n\t Minus 2 days off your journey to the castle\n\0"
	
TerrorText:
	.ascii "\tAs you close your eyes and try to focus on your breath, the mist around you seems to grow thicker and closer. The peaceful sound of the\n"
	.ascii "forest fades away, replaced by a constant low hum that seems to come from all directions. Your mind begins to race, and your thoughts become\njumbled and disjointed.\n"
	.ascii "\n\tYou try to push through the confusion, but it only gets worse. Suddenly, the mist takes on a life of its own, forming into twisted,\n"
	.ascii "grotesque shapes that slither and crawl towards you. You feel a sense of dread wash over you as they get closer, their haunting whispers filling\nyour ears.\n"
	.ascii "\n\tYour heart races as you try to fend off the visions, but they continue to assault you relentlessly. You feel as though you're losing\n"
	.ascii "your grip on reality, and the line between what's real and what's not begins to blur. Your body begins to shake uncontrollably, and you struggle\nto maintain control over your own mind.\n"
	.ascii "\n\tFinally, after what seems like an eternity, the mist begins to clear, and the shapes and whispers recede into nothingness. You're left\n"
	.ascii "trembling, sweat-soaked, and utterly exhausted. You realize that the mist in the forest seems to be playing tricks on your mind, and you're not\nsure how much more you can take.\n"
	.ascii "\n\t You lost 10 Health, 15 Stamina, 10 Sanity, 2 Days added to journey\n\0"
	
ExhaustedText:
	.ascii "\tYou've been pushing your body beyond its limits in order to navigate the treacherous forest, and it finally catches up with you. As you're\nrunning through the woods, your legs"
	.ascii "suddenly give out, and you collapse to the ground. Everything begins to go black, and you feel yourself slipping\naway into unconsciousness.\n"
	.ascii "\n\tJust before you completely lose consciousness, you see an eerie cat with needle like teeth giving you an unsettling grin. It seems to be\nbeckoning you with its eyes, and you feel yourself being "
	.ascii "pulled towards it. You try to resist, but the cat's gaze is too strong, and you pass out.\n"
	.ascii "\n\tWhen you wake up, you find yourself in a different part of the forest. You're disoriented and confused, but you can't shake the feeling\nthat something strange has happened to you.\n"
	.ascii "\n\t Health, Stamina, and Sanity reset to 100, 3 days added to journey\n\0"

ShadowBeastText:
	.ascii "\tAs you frantically try to make your way out of the dense forest, the creeping mist and constant danger begin to take their toll on your\nmind. Suddenly, your sanity drops to zero "
	.ascii "and you feel a dark presence take hold of you. You collapse to the ground, writhing in agony as your body\ncontorts and transforms into a shadowy beast. Your mind becomes consumed"
	.ascii " by a feral instinct that only knows to hunt and kill, and you know deep\ndown that there's no escaping the forest as long as you remain in this cursed form.\n\0"
	
CastleText:
	.ascii "\tAfter many days of struggling through the treacherous forest, you finally emerge to see your home, a massive castle off in the distance,\n"
	.ascii "gleaming in the sunlight. You can't help but breathe a sigh of relief at the sight of it.\n"
	.ascii "\n\tThe horrors that you have survived and endured during your time in the forest weigh heavily on your mind. The constant battles with\n"
	.ascii "terrifying beasts and the unending mist that seems to play tricks on your mind have left you mentally and physically exhausted.\n"
	.ascii "\n\tAs you make your way towards the castle, you can't help but wonder if you will ever fully recover from the traumas you have experienced\n"
	.ascii "in the forest. But for now, you are just grateful to be alive and have made it to safety out of the Howling Woods.\n\0"
	
OutOfTime:
	.ascii "\tAs you venture through the thick underbrush of the howling forest, you feel your body growing weaker and weaker with each passing moment.\nThe wounds from the countless battles with the forest's "
	.ascii "beasts have taken their toll on you, and you know deep down that your time is running out.\n"
	.ascii "\n\tLooking up at the darkening sky, you feel a strange sense of peace wash over you. The stars twinkle above you, casting their gentle\nlight down upon the forest below. You close your eyes, taking "
	.ascii "in a deep breath of the cool night air, and for a brief moment, you forget the\nhorrors that you have survived and endured.\n"
	.ascii "\n\tWith a calm resolve, you accept your fate. You know that even if you were to continue on, you would not be able to escape this forest\nalive. And so, you choose to embrace the final moments of "
	.ascii "your life with dignity and grace.\n"
	.ascii "\n\tAs you lie there, staring up at the night sky, you feel a deep sense of gratitude for the experiences that have brought you to this\nmoment. The thrill of the hunt, the thrill of survival, the "
	.ascii "thrill of knowing that you have lived your life to the fullest.\n"
	.ascii "\n\tWith your last breath, you whisper a final farewell to the forest, the beasts, and the life that you have known. And as your eyes close\nfor the final time, you know that you will forever be "
	.ascii "remembered as a hunter, a survivor, and a champion of the wild.\n\0"

SpecialEventText:
	.ascii "\tAs you continue to venture through the forest, you come across a mysterious temple that seems to have been hidden away for centuries.\nInside, you find a crystal skull that seems to be glowing "
	.ascii "with an otherworldly energy. As you gaze into its eyes, you feel a powerful force pulling\nat your mind, urging you to make a choice.\n"
	.ascii "\n\tYou realize that the skull is offering you a portal that will take you closer to the castle, but at a cost. The portal will require you to\ngive in to the insanity that has been haunting you "
	.ascii "throughout your journey. It promises a quicker route to the castle, but at the risk of losing\nyourself entirely.\n"
	.ascii "\n\tAs you weigh the decision, you can feel the pull of the portal growing stronger, and you know that time is running out. You must make a\nchoice and quickly, for the forest is unforgiving and "
	.ascii "the castle is your only hope of survival.\n\0"
	
AcceptSpecialEventText:
	.ascii "\tYou gaze into the crystal skull's eyes, and feel a strange sensation coursing through your body. Suddenly, you are enveloped in a blinding\nflash of light, and the world around you begins to warp and twist.\n"
	.ascii "\n\tIt feels as though every atom in your body is being pulled apart and put back together again. The pain is excruciating, as if your very\nbeing is being torn apart at the seams. You scream, but the sound is lost in the chaos to the void.\n"
	.ascii "\n\tJust as quickly as it started, the sensation fades away. You find yourself standing in a new location, closer to the castle than you were\nbefore. At least you hope you are. But the memory of the experience lingers, and you know you would "
	.ascii "never want to go through it again.\n"
	.ascii "\n\tYour body aches and you feel disoriented, but you know you must press on if you hope to make it to the castle. The path ahead may be\ntreacherous, but you have come too far to turn back now.\n\0"

MapFoundText:
	.ascii "\tAs you finish off the minotaur and catch your breath and examine the creature's body, you notice a piece of parchment sticking out of its\npocket. You carefully remove it and realize it's a partial map of the surrounding area."
	.ascii "\n\n\tThe map appears to be torn and incomplete, but you can make out some familiar landmarks and a few new ones. You notice a marking that\nappears to indicate a shortcut through the forest, which could potentially save you "
	.ascii "several days of travel."
	.ascii "\n\n\tDespite the map's incomplete nature, you feel a sense of relief and gratitude. Without this discovery, you might have been lost in the\nHowling Woods forever. You carefully fold the map and tuck it into your own pocket, "
	.ascii "determined to use it to its fullest potential.\n"
	.ascii "\t -2 Day on Journey to castle\n\0"

# ****************************************************************************** Player Stats Values *********************************************************************
													# stored in r11
DaysLeft:										    # Days left till player goes insane
	.quad 120
	
													# Health stored in r8
HealthText:
	.ascii "Health: \0"
Health:
	.quad 80
	
													# Stamina stored in r9
StaminaText:
	.ascii "Stamina: \0"
Stamina:
	.quad 100
	
													# Sanity stored in r10
SanityText:
	.ascii "Sanity: \0"
Sanity:
	.quad 100
	
													# Days left to castle stored in rsi
Castle:												# Days to Castle Game value set to 60
	.quad 50

# ********************************************************************************** Misc. *****************************************************************************
													# New Line on it's own
NL:
	.ascii "\n\0"

# ***************************************************************************** Game ascii images ***********************************************************************

NightStalker1:
	.ascii "                                                                                     ,--,  ,.-.\n"
	.ascii "                                                       ,                   \\,       '-,-`,'-.' | ._\n"
	.ascii "                                                      /|           \\    ,   |\\         }  )/  / `-,',\n"
	.ascii "                                                      [ ,          |\\  /|   | |        /  \\|  |/`  ,`\n"
	.ascii "                                                      | |       ,.`  `,` `, | |  _,...(   (      .',\n"
	.ascii "                                                      \\  \\  __ ,-` `  ,  , `/ |,'      Y     (   /_L\\\n"
	.ascii "                                                       \\  \\_\\,``,   ` , ,  /  |         )         _,/\n"
	.ascii "                                                        \\  '  `  ,_ _`_,-,<._.<        /         /\n"
	.ascii "                                                         ', `>.,`  `  `   ,., |_      |         /\n"
	.ascii "                                                           \\/`  `,   `   ,`  | /__,.-`    _,   `\\\n"
	.ascii "                                                       -,-..\\  _  \\  `  /  ,  / `._) _,-\\`       \\\n"
	.ascii "                                                        \\_,,.) /\\    ` /  / ) (-,, ``    ,        |\n"
	.ascii "                                                       ,` )  | \\_\\       '-`  |  `(               \\\n"
	.ascii "                                                      /  /```(   , --, ,' \\   |`<`    ,            |\n"
	.ascii "                                                     /  /_,--`\\   <\\  V /> ,` )<_/)  | \\      _____)\n"
	.ascii "                                               ,-, ,`   `   (_,\\ \    |   /) / __/  /   `----`\n"
	.ascii "                                              (-, \\           ) \\ ('_.-._)/ /,`    /\n"
	.ascii "                                              | /  `          `/ \\\\ V   V, /`     /\n"
	.ascii "                                           ,--\\(        ,     <_/`\\\\     ||      /\n"
	.ascii "                                          (   ,``-     \/|         \\\\-A.A-`|     /\n"
	.ascii "                                         ,>,_ )_,..(    )\\          -,,_-`  _--`\n"
	.ascii "                                        (_ \\|`   _,/_  /  \\_            ,--`\n"
	.ascii "                                         \\( `   <.,../`     `-.._   _,-`\n\0"

DreadClaw1:
	.ascii "                                              ^             \n"
	.ascii "                                             / \\           ^\n"
	.ascii "                       _,-~~~--~~~--._      (   \\         / \\\n"
	.ascii "                   _,-'               `.__  (    \\_.---._/   )\n"
	.ascii "                 ,'                       `-(_` -'       `-. )   \n"
	.ascii "                /       \"--..                \.'           ` /  \n"
	.ascii "               ,             `-.              :  _  .-.  _ : \n"
	.ascii "              /                 ;             : (0).oYo.(0);\n"
	.ascii "            /                    `             \.-'V'\"'V'-./\n"
	.ascii "           /                     '              \\^     ^//\n"
	.ascii "  /\\      /                      '     :    : .-'\\^   ^//\n"
	.ascii " ;  \\    ;   /                  ,'  _.-`.    `. : \\^_^//\n"
	.ascii " ;   \\   ;  ;`.               ,'~~-'     `.    `.`.`-.-'\n"
	.ascii "  \\   |_/   ;  `.        /-'/___.---.      `-.   `.`---.\n"
	.ascii "   \\       /     |      /____.---.)))         `-. `---.\\\n"
	.ascii "    \\_____/      (____________))))\\\\\\            `-.\\\\\\\\\n"
	.ascii "                               \\\\\\\\\n\0"

Minotaur1:
	.ascii "\t\t\t\t\t\t          ,     .\n"
	.ascii "\t\t\t\t\t\t         /(     )\\               A\n"
	.ascii "\t\t\t\t\t\t    .--.( `.___.' ).--.         /_\\\n"
	.ascii "\t\t\t\t\t\t    `._ `%_&%#%$_ ' _.'     /| <___> |\\\n"
	.ascii "\t\t\t\t\t\t       `|(@\\*%%/@)|'       / (  |L|  ) \\\n"
	.ascii "\t\t\t\t\t\t        |  |%%#|  |       J d8bo|=|od8b L\n"
	.ascii "\t\t\t\t\t\t         \\ \\$#%/ /        | 8888|=|8888 |\n"
	.ascii "\t\t\t\t\t\t         |\\|%%#|/|        J Y8P\"|=|\"Y8P F\n"
	.ascii "\t\t\t\t\t\t         | (.\".)%|         \\ (  |L|  ) /\n"
	.ascii "\t\t\t\t\t\t     ___.'  `-'  `.___      \\|  |L|  |/\n"
	.ascii "\t\t\t\t\t\t   .'#*#`-       -'$#*`.       / )|\n"
	.ascii "\t\t\t\t\t\t  /#%^#%*_ *%^%_  #  %$%\\    .J (__)\n"
	.ascii "\t\t\t\t\t\t  #&  . %%%#% ###%*.   *%\\.-'&# (__)\n"
	.ascii "\t\t\t\t\t\t  %*  J %.%#_|_#$.\\J* \\ %'#%*^  (__)\n"
	.ascii "\t\t\t\t\t\t  *#% J %$%%#|#$#$ J\\%   *   .--|(_)\n"
	.ascii "\t\t\t\t\t\t  |%  J\\ `%%#|#%%' / `.   _.'   |L|\n"
	.ascii "\t\t\t\t\t\t  |#$%||` %%%$### '|   `-'      |L|\n"
	.ascii "\t\t\t\t\t\t  (#%%||` #$#$%%% '|            |L|\n\0"


Spider1:
	.ascii "\t\t\t\t\t\t                            ,-.                               \n"
	.ascii "\t\t\t\t\t\t       ___,---.__          /'|`\\          __,---,___          \n"
	.ascii "\t\t\t\t\t\t    ,-'    \`    `-.____,-'  |  `-.____,-'    //    `-.       \n"
	.ascii "\t\t\t\t\t\t  ,'        |           ~'\     /`~           |        `.      \n"
	.ascii "\t\t\t\t\t\t /      ___//              `. ,'          ,  , \___      \\    \n"
	.ascii "\t\t\t\t\t\t|    ,-'   `-.__   _         |        ,    __,-'   `-.    |    \n"
	.ascii "\t\t\t\t\t\t|   /          /\\_  `   .    |    ,      _/\\          \\   |   \n"
	.ascii "\t\t\t\t\t\t\\  |           \\ \\`-.___ \\   |   / ___,-'/ /           |  /  \n"
	.ascii "\t\t\t\t\t\t \\  \\           | `._   `\\\\  |  //'   _,' |           /  /      \n"
	.ascii "\t\t\t\t\t\t  `-.\\         /'  _ `---'' , . ``---' _  `\\         /,-'     \n"
	.ascii "\t\t\t\t\t\t     ``       /     \\    ,='/ \\`=.    /     \\       ''          \n"
	.ascii "\t\t\t\t\t\t             |__   /|\\_,--.,-.--,--._/|\\   __|                  \n"
	.ascii "\t\t\t\t\t\t             /  `./  \\\\`\\ |  |  | /,//' \\,'  \\                  \n"
	.ascii "\t\t\t\t\t\t            /   /     ||--+--|--+-/-|     \\   \\                 \n"
	.ascii "\t\t\t\t\t\t           |   |     /'\\_\\_\\ | /_/_/`\\     |   |                \n"
	.ascii "\t\t\t\t\t\t            \\   \\__, \\_     `~'     _/ .__/   /            \n"
	.ascii "\t\t\t\t\t\t             `-._,-'   `-._______,-'   `-._,-\n\0"

MindGameImage1:
	.ascii "\t\t\t\t\t\t            _.------.                        .----.__\n"
	.ascii "\t\t\t\t\t\t           /         \\_.       ._           /---.__  \\\n"
	.ascii "\t\t\t\t\t\t          |  O    O   |\\\\___  //|          /       `\\ |\n"
	.ascii "\t\t\t\t\t\t          |  .vvvvv.  | )   `(/ |         | o     o  \\|\n"
	.ascii "\t\t\t\t\t\t          /  |     |  |/      \\ |  /|   ./| .vvvvv.  |\\\n"
	.ascii "\t\t\t\t\t\t         /   `^^^^^'  / _   _  `|_ ||  / /| |     |  | \\\n"
	.ascii "\t\t\t\t\t\t       ./  /|         | O)  O   ) \\|| //' | `^vvvv'  |/\\\\\n"
	.ascii "\t\t\t\t\t\t      /   / |         \\        /  | | ~   \\          |  \\\\\n"
	.ascii "\t\t\t\t\t\t      \\  /  |        / \\ Y   /'   | \\     |          |   ~\n"
	.ascii "\t\t\t\t\t\t       `'   |  _     |  `._/' |   |  \\     7        /\n"
	.ascii "\t\t\t\t\t\t         _.-'-' `-'-'|  |`-._/   /    \\ _ /    .    |\n"
	.ascii "\t\t\t\t\t\t    __.-'            \\  \\   .   / \\_.  \\ -|_/\\/ `--.|_\n"
	.ascii "\t\t\t\t\t\t --'                  \\  \\ |   /    |  |              `-\n"
	.ascii "\t\t\t\t\t\t                       \\uU \\UU/     |  /   \n\0"

MindGameImage2:
	.ascii "\t\t\t\t\t\t       -. -. `.  / .-' _.'  _\n"
	.ascii "\t\t\t\t\t\t      .--`. `. `| / __.-- _' `\n"
	.ascii "\t\t\t\t\t\t     '.-.  \\  \\ |  /   _.' `_\n"
	.ascii "\t\t\t\t\t\t     .-. \\  `  || |  .' _.-' `.\n"
	.ascii "\t\t\t\t\t\t   .' _ \\ '  -    -'  - ` _.-.\n"
	.ascii "\t\t\t\t\t\t    .' `. %%%%%   | %%%%% _.-.`-\n"
	.ascii "\t\t\t\t\t\t  .' .-. ><(@)> ) ( <(@)>< .-.`.\n"
	.ascii "\t\t\t\t\t\t    ((\"`(   -   | |   -   )'\"))\n"
	.ascii "\t\t\t\t\t\t   / \\\\#)\\    (.(_).)    /(#//\\\n"
	.ascii "\t\t\t\t\t\t  ' / ) ((  /   | |   \\  )) (`.`.\n"
	.ascii "\t\t\t\t\t\t  .'  (.) \\ .md88o88bm. / (.) \\)\n"
	.ascii "\t\t\t\t\t\t    / /| / \\ `Y88888Y' / \\ | \\ \\\n"
	.ascii "\t\t\t\t\t\t  .' / O  / `.   -   .' \\  O \\ \\\\\n"
	.ascii "\t\t\t\t\t\t   / /(O)/ /| `.___.' | \\\\(O) \\\n"
	.ascii "\t\t\t\t\t\t    / / / / |  |   |  |\\  \\  \\ \\\n"
	.ascii "\t\t\t\t\t\t    / / // /|  |   |  |  \\  \\ \\  \n"
	.ascii "\t\t\t\t\t\t  _.--/--/'( ) ) ( ) ) )`\\-\\-\\-._\n"
	.ascii "\t\t\t\t\t\t ( ( ( ) ( ) ) ( ) ) ( ) ) ) ( ) ) \n\0"

EnlightenmentPicture:
	.ascii "\t\t\t\t\t\t         _    .  ,   .           .\n"
	.ascii "\t\t\t\t\t\t    *  / \\_ *  / \\_      _  *        *   /\\'__        *\n"
	.ascii "\t\t\t\t\t\t      /    \\  /    \\,   ((        .    _/  /  \\  *'.\n"
	.ascii "\t\t\t\t\t\t .   /\\/\\  /\\/ :' __ \\_  `          _^/  ^/    `--.\n"
	.ascii "\t\t\t\t\t\t    /    \\/  \\  _/  \\-'\\      *    /.' ^_   \\_   .'\\  *\n"
	.ascii "\t\t\t\t\t\t  /\\  .-   `. \\/     \\ /==~=-=~=-=-;.  _/ \\ -. `_/   \\\n"
	.ascii "\t\t\t\t\t\t /  `-.__ ^   / .-'.--\\ =-=~_=-=~=^/  _ `--./ .-'  `-\n"
	.ascii "\t\t\t\t\t\t/        `.  / /       `.~-^=-=~=^=.-'      '-._ `._\n\0"

TerrorPicture:
	.ascii "\t\t\t\t\t\t          ,   ,\n"
	.ascii "\t\t\t\t\t\t         ,-`{-`/\n"
	.ascii "\t\t\t\t\t\t      ,-~ , \\ {-~~-,\n"
	.ascii "\t\t\t\t\t\t    ,~  ,   ,`,-~~-,`,\n"
	.ascii "\t\t\t\t\t\t  ,`   ,   { {      } }                                             }/\n"
	.ascii "\t\t\t\t\t\t ;     ,--/`\\ \\    / /                                     }/      /,/\n"
	.ascii "\t\t\t\t\t\t;  ,-./      \\ \\  { {  (                                  /,;    ,/ ,/\n"
	.ascii "\t\t\t\t\t\t; /   `       } } `, `-`-.___                            / `,  ,/  `,/\n"
	.ascii "\t\t\t\t\t\t \\|         ,`,`    `~.___,---}                         / ,`,,/  ,`,;\n"
	.ascii "\t\t\t\t\t\t  `        { {                                     __  /  ,`/   ,`,;\n"
	.ascii "\t\t\t\t\t\t        /   \\ \\                                 _,`, `{  `,{   `,`;`\n"
	.ascii "\t\t\t\t\t\t       {     } }       /~\\         .-:::-.     (--,   ;\\ `,}  `,`;\n"
	.ascii "\t\t\t\t\t\t       \\\\._./ /      /` , \\      ,:::::::::,     `~;   \\},/  `,`;     ,-=-\n"
	.ascii "\t\t\t\t\t\t        `-..-`      /. `  .\\_   ;:::::::::::;  __,{     `/  `,`;     {\n"
	.ascii "\t\t\t\t\t\t                   / , ~ . ^ `~`\\:::::::::::<<~>-,,`,    `-,  ``,_    }\n"
	.ascii "\t\t\t\t\t\t                /~~ . `  . ~  , .`~~\\:::::::;    _-~  ;__,        `,-`\n"
	.ascii "\t\t\t\t\t\t       /`\\    /~,  . ~ , '  `  ,  .` \\::::;`   <<<~```   ``-,,__   ;\n"
	.ascii "\t\t\t\t\t\t      /` .`\\ /` .  ^  ,  ~  ,  . ` . ~\\~                       \\\\, `,__\n"
	.ascii "\t\t\t\t\t\t     / ` , ,`\\.  ` ~  ,  ^ ,  `  ~ . . ``~~~`,                   `-`--, \\\n\0"

ReaperPicture:
	.ascii "\t\t\t\t                                         .\"\"--..__\n"
	.ascii "\t\t\t\t                     _                     []       ``-.._\n"
	.ascii "\t\t\t\t                  .'` `'.                  ||__           `-._\n"
	.ascii "\t\t\t\t                 /    ,-.\\                 ||_ ```---..__     `-.\n"
	.ascii "\t\t\t\t                /    /:::\\\\               /|//}          ``--._  `.\n"
	.ascii "\t\t\t\t                |    |:::||              |////}                `-. \\\n"
	.ascii "\t\t\t\t                |    |:::||             //'///                    `.\\\n"
	.ascii "\t\t\t\t                |    |:::||            //  ||'                      `|\n"
	.ascii "\t\t\t\t                /    |:::|/        _,-//\\  ||\n"
	.ascii "\t\t\t\t               /`    |:::|`-,__,-'`  |/  \\ ||\n"
	.ascii "\t\t\t\t             /`  |   |'' ||           \\   |||\n"
	.ascii "\t\t\t\t           /`    \\   |   ||            |  /||\n"
	.ascii "\t\t\t\t         |`       |  |   |)            \\ | ||\n"
	.ascii "\t\t\t\t        |          \\ |   /      ,.__    \\| ||\n"
	.ascii "\t\t\t\t        /           `         /`    `\\   | ||\n"
	.ascii "\t\t\t\t       |                     /        \\  / ||\n"
	.ascii "\t\t\t\t       |                     |        | /  ||\n"
	.ascii "\t\t\t\t       /         /           |        `(   ||\n\0"

CatPicture:
	.ascii "\t\t\t	-  -   -     -   -   --   -    -     - -   -  _  -    -  -      -  - -  -  -  -\n"
	.ascii "\t\t\t=-   - =- = - =  -  =- =   _.----~~~~~~-----..__ =   =-   -=-  - = =  -=--  = -\n"
	.ascii "\t\t\t=#-=  =-# - == ##= -__..------~~~~-     .._     ~~-. #== -#- = =-  ##=-= =#- -\n"
	.ascii "\t\t\t#===#==___.--.--~~~~     --~~~~---~ __  ~~----.__   ~~~~~~~---...._____#== =##=\n"
	.ascii "\t\t\t##(~~~~_..----~       ~~--=< O >- .----. -< O >=--~~             ..   .)#=#=##=\n"
	.ascii "\t\t\t###~-..__..--         ..  ___-----_...__-----___        _.  ~-=___..-~#########\n"
	.ascii "\t\t\t##==#===#==`   _    ..   (     \" :_.}{._; \" \"   )      _-     '==#=##=====#=#==\n"
	.ascii "\t\t\t=#-==-== =# \\   ~~-      `   \" \" __###__  \"\"    '    -~     .'==-=#===#- -=- #=\n"
	.ascii "\t\t\t-= == -=  -= `-._  ~-.    _`--~~~VvvvvVV~~---'_     ~..    _. #= =  =  ==# - ==\n"
	.ascii "\t\t\t = -==  - = - == -.     `~##\\(            )/###~' .     _.~    -=- = -= -=- -\n"
	.ascii "\t\t\t= -  -= -   - -    -    `.###\\#    {     #/####.'    _-~  - =  - - -  -    = -\n"
	.ascii "\t\t\t -    -       -  -  -_    -####    !     #####-  ..    -    -       -   -   - -\n"
	.ascii "\t\t\t                      -._  ~.###   }     ###-~ ___.-~\n"
	.ascii "\t\t\t                         ~-  \\##  / \"   ##.~ /~                      \n"
	.ascii "\t\t\t                           \\ |###  \"   ###' /   \n"
	.ascii "\t\t\t                            \\`/\\#######/\\' ;                               \n"
	.ascii "\t\t\t                             ~-.^^^^^^^ .-~                                    \n"
	.ascii "\t\t\t                                ~~~~~~~~\n\0"

ShadowBeastPic:
	.ascii "\t\t\t\t\t\t         __.,,------.._\n"
	.ascii "\t\t\t\t\t\t      ,'\"   _      _   \"`.\n"
	.ascii "\t\t\t\t\t\t     /.__, ._  -=- _\"`    Y\n"
	.ascii "\t\t\t\t\t\t    (.____.-.`      \"\"`   j\n"
	.ascii "\t\t\t\t\t\t     VvvvvvV`.Y,.    _.,-'       ,     ,     ,\n"
	.ascii "\t\t\t\t\t\t        Y    ||,   '\"\\         ,/    ,/    ./\n"
	.ascii "\t\t\t\t\t\t        |   ,'  ,     `-..,'_,'/___,'/   ,'/   ,\n"
	.ascii "\t\t\t\t\t\t   ..  ,;,,',-'\"\\,'  ,  .     '     ' \"\"' '--,/    .. ..\n"
 	.ascii "\t\t\t\t\t\t,'. `.`---'     `, /  , Y -=-    ,'   ,   ,. .`-..||_|| ..\n"
	.ascii "\t\t\t\t\t\tff\\\\`. `._        /f ,'j j , ,' ,   , f ,  \\=\\ Y   || ||`||_..\n"
	.ascii "\t\t\t\t\t\tl` \\` `.`.\"`-..,-' j  /./ /, , / , / /l \\   \\=\\l   || `' || ||...\n"
	.ascii "\t\t\t\t\t\t `  `   `-._ `-.,-/ ,' /`\"/-/-/-/-\"'''\"`.`.  `'.\\--`'--..`'_`' || ,\n"
	.ascii "\t\t\t\t\t\t            \"`-_,',  ,'  f    ,   /      `._    ``._     ,  `-.`'//         ,\n"
	.ascii "\t\t\t\t\t\t          ,-\"'' _.,-'    l_,-'_,,'          \"`-._ . \"`. /|     `.'\\ ,       |\n"
	.ascii "\t\t\t\t\t\t        ,',.,-'\"          \\=) ,`-.         ,    `-'._`.V |       \\ // .. . /j\n"
	.ascii "\t\t\t\t\t\t        |f\\\\               `._ )-.\"`.     /|         `.| |        `.`-||-\\\\/\n"
	.ascii "\t\t\t\t\t\t        l` \\`                 \"`._   \"`--' j          j' j          `-`---'\n"
	.ascii "\t\t\t\t\t\t         `  `                     \"`,-  ,'/       ,-'\"  /\n"
	.ascii "\t\t\t\t\t\t                                 ,'\",__,-'       /,, ,-'\n"
	.ascii "\t\t\t\t\t\t                                 Vvv'            VVv'\n\0"

CastlePicture:
	.ascii "\t\t\t\t\t\t                   (   .                   _ _ _ _ _\n"
	.ascii "\t\t\t\t\t\t    (   .     .  .=##                      ]-I-I-I-[                    /\n"
	.ascii "\t\t\t\t\t\t  .=##   .  (      ( .                     \\ `  ' /        \\\\\\' ,      / //\n"
	.ascii "\t\t\t\t\t\t    ( .   .=##  .       .                   |'  []          \\\\\\//    _/ //'\n"
	.ascii "\t\t\t\t\t\t  .     .   ( .    .        _----|          |.  '|           \\_-//' /  //<'\n"
	.ascii "\t\t\t\t\t\t                             ----|_----|    | ' .|             \\ ///  >   \\\\\\`\n"
	.ascii "\t\t\t\t\t\t    ]-I-I-I-I-[       ----|      |     |    |. ` |            /,)-^>>  _\\`\n"
	.ascii "\t\t\t\t\t\t     \\ `   '_/            |     / \\    |    | /^\\|            (/   \\\\ / \\\\\\\n"
	.ascii "\t\t\t\t\t\t      []  `__|            ^    / ^ \\   ^    | |*||                  //  //\\\\\\\n"
	.ascii "\t\t\t\t\t\t      |__   ,|           / \\  / ^ ^`\\ / \\   | ===|                 ((`\n"
	.ascii "\t\t\t\t\t\t   ___| ___ ,|__        / ^  /=_=_=_=\\ ^ \\  |, `_|\n"
	.ascii "\t\t\t\t\t\t   I_I__I_I__I_I       (====(_________)_^___|____|____                 \n"
	.ascii "\t\t\t\t\t\t   \\-\\--|-|--/-/       |     I  [ ]__I I_I__|____I_I_|                     \n"
	.ascii "\t\t\t\t\t\t    |[] `    '|__   _  |_   _|`__  ._[  _-\\--|-|--/-/                      \n"
	.ascii "\t\t\t\t\t\t   / \\  [] ` .|  |-| |-| |-| |_| |_| |_| | []   [] |                \n"
	.ascii "\t\t\t\t\t\t  <===>    `  |.            .      .     |    '    |\n"
	.ascii "\t\t\t\t\t\t  ] []|  `    |   []    --   []      `   |   [] '  |\n"
	.ascii "\t\t\t\t\t\t  <===>.  `   |  .   '  .       '  .[]   | '       |             \n"
	.ascii "\t\t\t\t\t\t   \\_/    .   |       .       '          |   `  [] |           \n"
	.ascii "\t\t\t\t\t\t    | []    . |   .  .           ,  .    | ,    .  |                   \n"
	.ascii "\t\t\t\t\t\t    |    . '  |       . []  '            |    []'  |\n"
	.ascii "\t\t\t\t\t\t   / \\   ..   |  `      .    .     `[]   | -   `   |                     \n"
	.ascii "\t\t\t\t\t\t  <===>      .|=-=-=-=-=-=-=-=-=-=-=-=-=-|    .   / \\                   \n"
	.ascii "\t\t\t\t\t\t  ] []|` ` [] |`  .  .   _________   .   |-      <===>            \n"
	.ascii "\t\t\t\t\t\t  <===>  `  ' | '   |||  |       |  |||  |  []   <===>                      \n"
	.ascii "\t\t\t\t\t\t   \\_/     -- |   . |||  |       |  |||  | .  '   \\_/                     \n"
	.ascii "\t\t\t\t\t\t  ./|' . . . .|. . .||||/|_______|\\|||| /|. . . . .|\\_\n\0"
	
LostPicture:
	.ascii "\t\t\t\t  ` : | | | |:  ||  :     `  :  |  |+|: | : : :|   .        `              .\n"
	.ascii "\t\t\t\t      ` : | :|  ||  |:  :    `  |  | :| : | : |:   |  .                    :\n"
	.ascii "\t\t\t\t         .' ':  ||  |:  |  '       ` || | : | |: : |   .  `           .   :.\n"
	.ascii "\t\t\t\t                `'  ||  |  ' |   *    ` : | | :| |*|  :   :               :|\n"
	.ascii "\t\t\t\t        *    *       `  |  : :  |  .      ` ' :| | :| . : :         *   :.||\n"
	.ascii "\t\t\t\t             .`            | |  |  : .:|       ` | || | : |: |          | ||\n"
	.ascii "\t\t\t\t      '          .         + `  |  :  .: .         '| | : :| :    .   |:| ||\n"
	.ascii "\t\t\t\t         .                 .    ` *|  || :       `    | | :| | :      |:| |\n"
	.ascii "\t\t\t\t .                .          .        || |.: *          | || : :     :|||\n"
	.ascii "\t\t\t\t        .            .   . *    .   .  ` |||.  +        + '| |||  .  ||`\n"
	.ascii "\t\t\t\t     .             *              .     +:`|!             . ||||  :.||`\n"
	.ascii "\t\t\t\t +                      .                ..!|*          . | :`||+ |||`\n"
	.ascii "\t\t\t\t     .                         +      : |||`        .| :| | | |.| ||`     .\n"
	.ascii "\t\t\t\t       *     +   '               +  :|| |`     :.+. || || | |:`|| `\n"
	.ascii "\t\t\t\t                            .      .||` .    ..|| | |: '` `| | |`  +\n"
	.ascii "\t\t\t\t  .       +++                      ||        !|!: `       :| |\n"
	.ascii "\t\t\t\t              +         .      .    | .      `|||.:      .||    .      .    `\n"
	.ascii "\t\t\t\t          '                           `|.   .  `:|||   + ||'     `\n"
	.ascii "\t\t\t\t  __    +      *                         `'       `'|.    `:\n"
	.ascii "\t\t\t\t\"'  `---\"\"\"----....____,..^---`^``----.,.___          `.    `.  .    ____,.,-\n"
	.ascii "\t\t\t\t    ___,--'\"\"`---\"'   ^  ^ ^        ^       \"\"\"'---,..___ __,..---\"\"'\n"
	.ascii "\t\t\t\t--\"'                                 ^                         ``--..,__\n\0"
	
SpecialEventPicture:
	.ascii "\t\t\t\t\t     _                      _______                      _\n"
	.ascii "\t\t\t\t\t  _dMMMb._              .adOOOOOOOOOba.              _,dMMMb_\n"
	.ascii "\t\t\t\t\t dP'  ~YMMb            dOOOOOOOOOOOOOOOb            aMMP~  `Yb\n"
	.ascii "\t\t\t\t\t V      ~\"Mb          dOOOOOOOOOOOOOOOOOb          dM\"~      V\n"
	.ascii "\t\t\t\t\t          `Mb.       dOOOOOOOOOOOOOOOOOOOb       ,dM'\n"
	.ascii "\t\t\t\t\t           `YMb._   |OOOOOOOOOOOOOOOOOOOOO|   _,dMP'\n"
	.ascii "\t\t\t\t\t      __     `YMMM| OP'~\"YOOOOOOOOOOOP\"~`YO |MMMP'     __\n"
	.ascii "\t\t\t\t\t    ,dMMMb.     ~~' OO     `YOOOOOP'     OO `~~     ,dMMMb.\n"
	.ascii "\t\t\t\t\t _,dP~  `YMba_      OOb      `OOO'      dOO      _aMMP'  ~Yb._\n"
	.ascii "\t\t\t\t\t             `YMMMM\\`OOo     OOO      oOO'/MMMMP'\n"
	.ascii "\t\t\t\t\t     ,aa.     `~YMMb `OOOb._,dOOOb._,dOOO'dMMP~'       ,aa.\n"
	.ascii "\t\t\t\t\t   ,dMYYMba._         `OOOOOOOOOOOOOOOOO'          _,adMYYMb.\n"
	.ascii "\t\t\t\t\t  ,MP'   `YMMba._      OOOOOOOOOOOOOOOOO       _,adMMP'   `YM.\n"
	.ascii "\t\t\t\t\t  MP'        ~YMMMba._ YOOOOPVVVVVYOOOOP  _,adMMMMP~       `YM\n"
	.ascii "\t\t\t\t\t  YMb           ~YMMMM\\'OOOOI`````IOOOOO'/MMMMP~           dMP\n"
	.ascii "\t\t\t\t\t   `Mb.           `YMMMb`OOOI,,,,,IOOOO'dMMMP'           ,dM'\n"
	.ascii "\t\t\t\t\t     `'                  `OObNNNNNdOO'                   `'\n"
	.ascii "\t\t\t\t\t                           `~OOOOO~'   \n\0"
	
AcceptSpecialEventPicture:
	.ascii "\t\t\t\t\t}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}\n"
	.ascii "\t\t\t\t\t{{            +             +                  +   @          {{\n"
	.ascii "\t\t\t\t\t}}   |                *           o     +                .    }}\n"
	.ascii "\t\t\t\t\t{{  -O-    o               .               .          +       {{\n"
	.ascii "\t\t\t\t\t}}   |                    _,.-----.,_         o    |          }}\n"
	.ascii "\t\t\t\t\t{{           +    *    .-'.         .'-.          -O-         {{\n"
	.ascii "\t\t\t\t\t}}      *            .'.-'   .---.   `'.'.         |     *    }}\n"
	.ascii "\t\t\t\t\t{{ .                /_.-'   /     \\   .'-.\\                   {{\n"
	.ascii "\t\t\t\t\t}}         ' -=*<  |-._.-  |   @   |   '-._|  >*=-    .     + }}\n"
	.ascii "\t\t\t\t\t{{ -- )--           \\`-.    \\     /    .-'/                   {{\n"
	.ascii "\t\t\t\t\t}}       *     +     `.'.    '---'    .'.'    +       o       }}\n"
	.ascii "\t\t\t\t\t{{                  .  '-._         _.-'  .                   {{\n"
	.ascii "\t\t\t\t\t}}         |               `~~~~~~~`       - --===D       @   }}\n"
	.ascii "\t\t\t\t\t{{   o    -O-      *   .                  *        +          {{\n"
	.ascii "\t\t\t\t\t}}         |                      +         .            +    }}\n"
	.ascii "\t\t\t\t\t{{ jgs          .     @      o                        *       {{\n"
	.ascii "\t\t\t\t\t}}       o                          *          o           .  }}\n"
	.ascii "\t\t\t\t\t{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{\n\0"

FoundMap:
	.ascii "\t\t\t\t\t\t   _______________________________\n"
	.ascii "\t\t\t\t\t\t / \\                P		   \\.\n"
	.ascii "\t\t\t\t\t\t|   |            P /\\              |.\n"
	.ascii "\t\t\t\t\t\t \\_ |           /\\|  |/\\           |.\n"
	.ascii "\t\t\t\t\t\t    |        [] ||_/\\_|| []        |.\n"
	.ascii "\t\t\t\t\t\t    |        ||_||____||_||        |.\n"
	.ascii "\t\t\t\t\t\t    |        ||____[]____||        |.\n"
	.ascii "\t\t\t\t\t\t    |       {::     \\__    }       |.\n"
	.ascii "\t\t\t\t\t\t    |   ___  \\v:    .'\"  _V ___    |.\n"
	.ascii "\t\t\t\t\t\t    |   (      \\_      __/  --  )  |.\n"
	.ascii "\t\t\t\t\t\t    |  (__---    |::\\ :/  ---     )|.\n"
	.ascii "\t\t\t\t\t\t    |     (       \\::\\/  ----- ___)|.\n"
	.ascii "\t\t\t\t\t\t    |      (______  \\/ ________)   |.\n"
	.ascii "\t\t\t\t\t\t    |   ___________________________|___\n"
	.ascii "\t\t\t\t\t\t    |  /         		      /.\n"
	.ascii "\t\t\t\t\t\t    \\_/______________________________/.\n\0"

	
UIBoarder:
	.ascii "===================================================================================================================================================\n\0"
	

# *************************************************** Health UI **********************************************************************
PlayerHealth100:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"  

PlayerHealth95:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth90:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth85:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth80:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth75:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth70:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth65:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth60:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  \n\0" 

PlayerHealth55:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth50:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  \n\0" 

PlayerHealth45:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  +__+  \n\0"

PlayerHealth40:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  \n\0" 

PlayerHealth35:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  +__+  \n\0"

PlayerHealth30:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  \n\0" 

PlayerHealth25:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  +__+  \n\0"

PlayerHealth20:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  +--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  |  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  \n\0"

 PlayerHealth15:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+        \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  +--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  +__+  \n\0"

PlayerHealth10:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t+--+  \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t|  |  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  \n\0" 

PlayerHealth5:
	.ascii " ╦ ╦┌─┐┌─┐┬ ┌┬┐┬ ┬\t      \n"
	.ascii " ╠═╣├┤ ├─┤│  │ ├─┤\t+--+  \n"
	.ascii " ╩ ╩└─┘┴ ┴┴─┘┴ ┴ ┴\t+__+  \n\0"

# *************************************************** Stamina UI **********************************************************************

PlayerStamina100:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"  

PlayerStamina95:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina90:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina85:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina80:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina75:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina70:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina65:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina60:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  \n\0" 

PlayerStamina55:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina50:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  \n\0" 

PlayerStamina45:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  +__+  \n\0"

PlayerStamina40:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  \n\0" 

PlayerStamina35:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  +__+  \n\0"

PlayerStamina30:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  \n\0" 

PlayerStamina25:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  +__+  \n\0"

PlayerStamina20:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+  +--+  \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  |  |  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  \n\0"

 PlayerStamina15:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+        \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |  +--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  +__+  \n\0"

PlayerStamina10:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t+--+     \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t|  |\n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  \n\0" 

PlayerStamina5:
	.ascii " ╔═╗┌┬┐┌─┐┌┬┐┬┌┐┌┌─┐\t      \n"
	.ascii " ╚═╗ │ ├─┤│││││││├─┤\t+--+  \n"
	.ascii " ╚═╝ ┴ ┴ ┴┴ ┴┴┘└┘┴ ┴\t+__+  \n\0"

# *************************************************** Sanity UI **********************************************************************

PlayerSanity100:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"  

PlayerSanity95:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity90:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity85:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity80:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity75:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity70:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity65:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity60:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  \n\0" 

PlayerSanity55:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity50:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  \n\0" 

PlayerSanity45:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  +__+  \n\0"

PlayerSanity40:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  \n\0" 

PlayerSanity35:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  +__+  \n\0"

PlayerSanity30:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  \n\0" 

PlayerSanity25:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  +__+  \n\0"

PlayerSanity20:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+  +--+  \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  |  |  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  \n\0"

 PlayerSanity15:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+        \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |  +--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  +__+  \n\0"

PlayerSanity10:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t+--+     \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t|  |\n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  \n\0" 

PlayerSanity5:
	.ascii " ╔═╗┌─┐┌┐┌┬┌┬┐┬ ┬\t      \n"
	.ascii " ╚═╗├─┤││││ │ └┬┘\t+--+  \n"
	.ascii " ╚═╝┴ ┴┘└┘┴ ┴  ┴ \t+__+  \n\0"

# *************************************************** Monster Health **********************************************************************

MonsterHealth150:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"  

MonsterHealth145:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth140:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth135:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth130:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth125:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth120:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth115:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth110:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth105:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth100:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"  

MonsterHealth95:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth90:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth85:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth80:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth75:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth70:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth65:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth60:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  \n\0" 

MonsterHealth55:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth50:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth45:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  +__+  \n\0"

MonsterHealth40:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  \n\0" 

MonsterHealth35:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  +__+  \n\0"

MonsterHealth30:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  \n\0" 

MonsterHealth25:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  +__+  \n\0"

MonsterHealth20:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  +--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  |  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  \n\0"

 MonsterHealth15:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+        \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  +--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  +__+  \n\0"

MonsterHealth10:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t+--+  \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t|  |  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  \n\0" 

MonsterHealth5:
	.ascii " ╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐\t      \n"
	.ascii " ║║║│ ││││└─┐ │ ├┤ ├┬┘\t+--+  \n"
	.ascii " ╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─\t+__+  \n\0"
.text
.global _start

###################################################################################### MAIN ######################################################################################
_start:
	call Intro									# jumps to Intro subroutine to give all info and prologue for game

Journey:
# ************************************************** Start of game ************************************************		
	mov r8, Health								# assign player resources to registers
	mov r9, Stamina
	mov r10, Sanity
	mov r11, DaysLeft
	mov r15, 0
	mov rax, 0									# flag to determining if player jumps to GameOverLost 0 = countinue
	mov rsi, Castle	
	lea rdi, JourneyStart
	call WriteString
	call ReadInt								# jump if 1 or 2, for end or continue.
	cmp rdi, 1
	je FirstPrompt
	cmp rdi, 2
	je Surrender	
	jmp Journey

Surrender:
	mov rdi, 7
	call SetForeColor
	call Exit

# ********************************************* Main game loop here ***********************************************
FirstPrompt:
	call ClearScreen
	call GetUI
	jmp prompt
	
ResetPrompt:
	mov r15, rdi								# set player desition from comabt to decistion prompt
	call ClearScreen
	call GetUI

Begin:
	call CheckInsanityVsCastle					# check to see how great a difference between days to castle and going insane is
	call CheckCastleDays						# check if days to castle = 0
	call CheckDaysTillInsane					# sets sanity to 0 if time to insane days have gone to 0
	call CheckSpecialEvent
	call CheckHealth							# Check Players stats and jmp to labels if 	 any = 0
	call CheckStamina
	call CheckSanity
	
	cmp rax, 1
	je GameOverLost
	cmp rax, 2									# special event flag is = 2
	je SpecialEventChance
	cmp r8, 0
	jle GameOverHealth
	cmp r9, 0
	jle GameOverStamina
	cmp r10, 0
	jle GameOverSanity
	cmp rsi, 0
	jle GameOverEscape							# End Adventure

MainOptions:
	cmp r15, 1									# determine what option to jmp to
	je opt1
	cmp r15, 2
	je opt2
	cmp r15, 3
	je opt3
	jmp prompt

opt1:	
	call DecreaseInsanityDay
	call DecreaseDaysToCastle
	call ResetRandomHSS
	call DailyDecreaseSanity

	call RandomEvent							# Random Hunt Event Check 1 in 4 chance
	cmp r15, 25									# if the random number =< 25 jmp to Hunted Event	
	jle Hunted
	
	call HuntLogic
	call HuntingText1
	lea rdi, NL
	call WriteString
	jmp prompt

opt2:
	call DecreaseInsanityDay
	call ResetRandomHSS
	call DailyDecreaseSanity
	call RestLogic

	call RandomEvent							# Random Hunt Event Check 1 in 4 chance
	cmp r15, 25									# if the random number =< 25 jmp to MindGame Event
	jle MindGames

	call RestingText
	lea rdi, NL
	call WriteString
	jmp prompt
opt3:
	call DecreaseInsanityDay
	call ResetRandomHSS
	
	call RandomEvent							# Random Meditation Event Check 1 int 4 chance
	cmp r15, 20									# if the random number =< 20 jmp to Hunted Event
	jle MeditationEvents
	
	call MeditateLogic
	call MeditatingText
	jmp prompt

FleePrompt:
	mov rax, 0									# reset ForestFlag	 
	mov r15, 0									# reset decition prompt
	call CheckInsanityVsCastle					# check to see how great a difference between days to castle and going insane is
	call CheckCastleDays						# check if days to castle = 0
	call CheckDaysTillInsane					# sets sanity to 0 if time to insane days have gone to 0
	call CheckSpecialEvent
	call CheckHealth							# Check Players stats and jmp to labels if any = 0
	call CheckStamina
	call CheckSanity
	
	cmp rax, 1
	je GameOverLost
	cmp rax, 2									# special event flag is = 2
	je SpecialEventChance
	cmp r8, 0
	jle GameOverHealth
	cmp r9, 0
	jle GameOverStamina
	cmp r10, 0
	jle GameOverSanity
	cmp rsi, 0
	jle GameOverEscape							# End Adventure
	
	call ClearScreen							# clears screen to format for game play
	call GetUI									# Interface for players game
	lea rdi, FleeText
	call WriteString
	call PlayerPrompt 
	call DefaultOptions
	call ReadInt
	jmp ResetPrompt								# reset inital game state
	
prompt:
	call CheckInsanityVsCastle					# check to see how great a difference between days to castle and going insane is
	call CheckCastleDays						# check if days to castle = 0
	call CheckDaysTillInsane					# sets sanity to 0 if time to insane days have gone to 0
	call CheckSpecialEvent
	call CheckHealth							# Check Players stats and jmp to labels if any = 0
	call CheckStamina
	call CheckSanity
	
	cmp rax, 1
	je GameOverLost
	cmp rax, 2									# special event flag is = 2
	je SpecialEventChance
	cmp r8, 0
	jle GameOverHealth
	cmp r9, 0
	jle GameOverStamina
	cmp r10, 0
	jle GameOverSanity
	cmp rsi, 0
	jle GameOverEscape							# End Adventure
	
	call PlayerPrompt 
	call DefaultOptions
	call ReadInt
	mov r15, rdi								# move user input into r15
	jmp Begin
	
VictoryPrompt:
	mov rax, 0									# reset ForestFlag
	mov r15, 0									# reset decision prompt
	call ResetRandomHSS
	call CheckInsanityVsCastle					# check to see how great a difference between days to castle and going insane is
	call CheckCastleDays						# check if days to castle = 0
	call CheckDaysTillInsane					# sets sanity to 0 if time to insane days have gone to 0
	call CheckSpecialEvent
	call CheckHealth							# Check Players stats and jmp to labels if any = 0
	call CheckStamina
	call CheckSanity	
	
	cmp rax, 1
	je GameOverLost
	cmp rax, 2									# special event flag is = 2
	je SpecialEventChance
	cmp r8, 0
	jle GameOverHealth
	cmp r9, 0
	jle GameOverStamina
	cmp r10, 0
	jle GameOverSanity
	cmp rsi, 0
	jle GameOverEscape							# End Adventure
	
	call HuntHealthIncrease						# call raise health subroutine for hunting
	call CombatVictory
	call IncreaseHealthBy
	lea rdi, NL
	call WriteString
	call PlayerPrompt
	call DefaultOptions
	call ReadInt
	jmp ResetPrompt								# reset game to initial state

# ********************************************** Option 1 logic Hunted *****************************************************************************

Hunted:
	call ResetRandomHSS
	call RandomFour								# Random Hunt Event Check 1 int 4 chance
												# Determine how much health the moster will have												
	cmp r15, 1		
	je MonsterHealth1
	cmp r15, 2		
	je MonsterHealth2
	cmp r15, 3		
	je MonsterHealth3

MonsterHealth4:
	mov rdx, 80
	jmp HuntedLoop
MonsterHealth3:
	mov rdx, 150
	jmp HuntedLoop
MonsterHealth2:
	mov rdx, 100
	jmp HuntedLoop
MonsterHealth1:
	mov rdx, 120

HuntedLoop:
	call CheckHealth							# Check Players stats and jmp to labels if any = 0
	call CheckStamina
	call CheckSanity
	cmp r8, 0
	jle GameOverHealth
	cmp r9, 0
	jle GameOverStamina
	cmp r9, 0
	jle GameOverSanity
	
	call CheckMonsterHealth
	cmp rdx, 0									# Kill Monster	
	jle CheckMinotaurEvent						# jump to check for Minotaur if health 0 for map event
	
	cmp r15, 1		
	je Hunted1
	cmp r15, 2		
	je Hunted2
	cmp r15, 3		
	je Hunted3
	cmp r15, 5									# Flee combat
	je FleePrompt


Hunted4:
	call DreadClawHunt
	jmp HuntedOptionDread
Hunted3:
	call MinotaurHunt
	jmp HuntedOptionsMinotaur
Hunted2:
	call NightStalkerHunt
	jmp HuntedOptionsStalker
Hunted1:
	call SpiderHunt
	jmp HuntedOptionsSpider

HuntedOptionDread:
HuntedOptionsMinotaur:
HuntedOptionsStalker:
HuntedOptionsSpider:
	
	call CombatPrompt
	call ReadInt
	mov rbx, rdi

	cmp rbx, 1
	je CombatOpt1
	cmp rbx, 2
	je CombatOpt2
	cmp rbx, 3
	je CombatOpt3
	cmp rbx, 4
	je CombatOpt4
	cmp rbx, 5
	je CombatOpt5
	jmp HuntedLoop								# input validation	

CombatOpt1:
	call MonsterAttack
	call Combat1
	jmp HuntedLoop
CombatOpt2:
	call MonsterAttack
	call Combat2
	jmp HuntedLoop
CombatOpt3:
	call MonsterAttack
	call Combat3
	jmp HuntedLoop
CombatOpt4:
	call MonsterAttack
	call Combat4
	jmp HuntedLoop
CombatOpt5:
	call MonsterAttack
	call Combat5
	jmp HuntedLoop
	
CheckMinotaurEvent:
	cmp r15, 3
	je MapEvent
	jmp VictoryPrompt

MapEvent:
	call DecreaseDaysToCastle
	call DecreaseDaysToCastle
	call FoundMapEvent
	call PlayerPrompt
	call DefaultOptions
	call ReadInt
	jmp ResetPrompt
	
# *************************************** Option 2 random events Logic Rest ***********************************************************
MindGames:

	call RandomFour
	cmp r15, 2									# 50% chance of either encounter
	jle MindGame2

MindGame1:
	call MindGameWispers
	jmp prompt
	
MindGame2:
	call MindGameMistMan
	jmp prompt
	
# **************************************** Option 3 random events Logic Meditation *********************************************************

MeditationEvents:
	call RandomEvent
	cmp r15, 35									# 35% chance of getting Enlightened event
	jle opt3Good
	
	call TerrorEvent
	jmp prompt
	
opt3Good:
	call MeditateLogic
	call EnlightedEvent
	jmp prompt
	
# ************************************************* Game Over Logic *******************************************************************
GameOverHealth:
	call DeathPrompt
	lea rdi, TryAgainText
	call ReadInt
	cmp rdi, 1
	je goAgain
	call Exit									# Exits game if the player decides not to continue anymore
goAgain:										# Reset the players stats to initial state
	mov r8, Health								# assign player resources to registers
	mov r9, Stamina
	mov r10, Sanity
	mov r11, DaysLeft
	mov r15, 0
	mov rsi, Castle
	mov rax, 0									# reset Lost flag indicator
	call ResetRandomHSS
	jmp FirstPrompt
	
GameOverStamina:
	call ExhaustionPrompt
	jmp prompt

GameOverSanity:
	call InsanityPrompt
	lea rdi, TryAgainText
	call WriteString
	call ReadInt
	cmp rdi, 1
	je goAgain
	call Exit 									# Exits game if the player decides not to continue anymore
	
GameOverEscape:
	call EscapeForest
	call GetUiBoarder
	lea rdi, TryAgainText
	call WriteString
	call ReadInt
	cmp rdi, 1
	je goAgain
	call Exit 									# Exits game if the player decides not to continue anymore

GameOverLost:
	call LostToForest
	call GetUiBoarder
	lea rdi, TryAgainText
	call WriteString
	call ReadInt
	cmp rdi, 1
	je goAgain
	call Exit
	
# ************************************************* Special Event 90%  on 3x stats to call, then 10% chance (VERY RARE) **************************************************************
SpecialEventChance:
	
	mov rdi, 101
	call Random
	cmp rdi, 10
	jle SpecialEventChoice
	
	mov rax, 0									# reset rax flag
	call PlayerPrompt 							# if the change to get event fails continue back to main prompt, but in a odd way do to checks and balances of game
	call DefaultOptions
	call ReadInt
	mov r15, rdi								# move user input into r15
	
	jmp MainOptions

SpecialEventChoice:
	call ClearScreen
	call SpecialEvent
	call ReadInt
	
	cmp rdi, 1
	je AcceptSpecialEvent
	cmp rdi, 2
	je RegectSpecialEvent
	jmp SpecialEventChance
	
AcceptSpecialEvent:
	call AcceptSpecialEventLogic
	call ClearScreen
	call GetUI
	lea rdi, NL
	call WriteString
	call DecreaseHealthBy
	call DecreaseStaminaBy
	call DecreaseSanityBy
	lea rdi, NL
	call WriteString
	call AcceptSpecialEventImage
	call GetUiBoarder
	lea rdi, AcceptSpecialEventText
	call WriteString
	call GetUiBoarder
	mov rax, 0									# reset rax flag
	call prompt

RegectSpecialEvent:
	mov rax, 0									# reset rax flag
	jmp ResetPrompt
	
###################################################################################### Text output Subroutines ######################################################################################

FoundMapEvent:
	call ClearScreen
	call GetUI
	call MapImage
	call GetUiBoarder
	lea rdi, MapFoundText
	call WriteString
	call GetUiBoarder
	ret

SpecialEvent:
	call ClearScreen
	call GetUI 
	call SpecialEventImage
	call GetUiBoarder
	lea rdi, SpecialEventText
	call WriteString
	call GetUiBoarder
	call PlayerPrompt
	lea rdi, SpecialOptions
	call WriteString
	ret
	
LostToForest:
	call ClearScreen
	mov rdi, 2
	call SetForeColor
	lea rdi, GameTitle
	call WriteString
	mov rdi, 7
	call SetForeColor
	call GetUiBoarder
	call LostImage
	call GetUiBoarder
	lea rdi, OutOfTime
	call WriteString
	ret
	
EscapeForest:
	call ClearScreen
	mov rdi, 2
	call SetForeColor
	lea rdi, GameTitle
	call WriteString
	mov rdi, 7
	call SetForeColor
	call GetUiBoarder
	call CastleImage
	call GetUiBoarder
	lea rdi, CastleText
	call WriteString
	ret

InsanityPrompt:
	call ClearScreen
	mov rdi, 2
	call SetForeColor
	lea rdi, GameTitle
	call WriteString
	mov rdi, 7
	call SetForeColor
	call GetUiBoarder
	call ShadowBeast
	call GetUiBoarder
	lea rdi, ShadowBeastText
	call WriteString
	call GetUiBoarder
	ret

ExhaustionPrompt:								# is called if the players health = 0
	mov r8, 100									# assign player resources to registers
	mov r9, Stamina
	mov r10, Sanity
	call DecreaseInsanityDay					# decrease # days till insane
	mov r15, 0
	add rsi, 3									# add 3 days to journey
	call ResetRandomHSS
	call ClearScreen
	call GetUI
	call GetUiBoarder
	call Cat
	call GetUiBoarder
	lea rdi, ExhaustedText
	call WriteString
	call GetUiBoarder
	ret

DeathPrompt: 									# Is called if players health = 0
	call ClearScreen
	mov rdi, 2
	call SetForeColor
	lea rdi, GameTitle
	call WriteString
	mov rdi, 7
	call SetForeColor
	call GetUiBoarder
	call Death
	call GetUiBoarder
	lea rdi, TryAgainText
	call WriteString
	ret

TerrorEvent:
	call ClearScreen
	sub r8, 10									# reduce Health by 10
	sub r9, 15									# reduce Stamina by 15
	sub r10, 5									# reduce Sanity by an aditional 10 points
	mov r12, 10									# Change delta Health value
	mov r13, 15									# Change delta Stamina value
	mov r14, 5									# Change delta Sanity value
	add rsi, 2									# add 2 more days to castle
	call CheckHealth
	call CheckStamina
	call CheckSanity
	call GetUI
	call DecreaseHealthBy
	call DecreaseStaminaBy
	call DecreaseSanityBy
	call Terror
	call GetUiBoarder
	lea rdi, TerrorText
	call WriteString
	call GetUiBoarder
	ret

EnlightedEvent:
	call ClearScreen
	sub rsi, 2									# take 2 days off, of distance left to go to castle
	call GetUI
	call IncreaseStaminaBy
	call IncreaseSanityBy
	call Enlightenment
	call GetUiBoarder
	lea rdi, EnlightenmentText
	call WriteString
	call GetUiBoarder
	ret

Blocked:
	lea rdi, BlockedText
	call WriteString
	mov rdi, r14								# block num = 0 as the attack command was selected
	call WriteInt
	lea rdi, NL
	call WriteString
	ret

DamageDealt:
	lea rdi, AttackText
	call WriteString
	mov rdi, rax								# Attack num = 0 as the Block command was selected
	call WriteInt
	lea rdi, NL
	call WriteString
	ret 

CombatPrompt:
	call PlayerPrompt
	lea rdi, CombatOptions
	call WriteString
	ret

Intro:
	mov rdi, 2
	call SetForeColor
	lea rdi, GameTitle
	call WriteString

	lea rdi, GameIntro1
	call WriteString
	lea rdi, GameIntro2
	call WriteString

	call GameExplain							# suroutine to explain rules of game
	ret

GameExplain:
	mov rdi, 2
	call SetForeColor
	lea rdi, GameExplain1
	call WriteString
	lea rdi, GameExplain2
	call WriteString
	ret
	
DefaultOptions:
	lea rdi, GameOptions
	call WriteString
	ret

PlayerPrompt:
	lea rdi, PromtPlayer
	call WriteString
	ret
												# Gets the UI the player will use to see how they are managing their resources
GetUI:
	
	mov rdi, 2
	call SetForeColor
	lea rdi, GameTitle
	call WriteString
	call GetUiBoarder
	call GetHealth
	call GetStamina
	call GetSanity
	call GetUiBoarder
	call PlayerStatus
	ret
												# Creates the ====== boarder bar for the UI
GetUiBoarder:
	mov rdi, 7
	call SetForeColor
	lea rdi, UIBoarder
	call WriteString
	ret

DaysLeftPrompt:
	mov rdi, r11
	call WriteInt
	lea rdi, DaysLeftText
	call WriteString
	ret

DaysToCastlePrompt:
	mov rdi, rsi
	call WriteInt
	lea rdi, DaysToCastleText
	call WriteString
	ret

HealthPrompt:
	lea rdi, HealthText
	call WriteString
	mov rdi, r8
	call WriteInt
	lea rdi, NL
	call WriteString
	ret

StaminaPrompt:
	lea rdi, StaminaText
	call WriteString
	mov rdi, r9
	call WriteInt
	lea rdi, NL
	call WriteString
	ret

SanityPrompt:
	lea rdi, SanityText
	call WriteString
	mov rdi, r10
	call WriteInt
	lea rdi, NL
	call WriteString
	ret

PlayerStatus:
	call DaysLeftPrompt
	call DaysToCastlePrompt
	call HealthPrompt
	call StaminaPrompt
	call SanityPrompt
	ret

HuntingText1:
	call ClearScreen
	call GetUI
	lea  rdi, HuntText
	call WriteString
	call IncreaseHealthBy
	call DecreaseStaminaBy
	call DecreaseSanityBy
	call ResetRandomHSS
	ret

RestingText:
	call ClearScreen
	call GetUI
	lea rdi, RestText
	call WriteString
	call IncreaseHealthBy
	call IncreaseStaminaBy
	call DecreaseSanityBy
	call ResetRandomHSS
	ret

MeditatingText:
	call ClearScreen
	call GetUI
	lea rdi, MeditateText
	call WriteString
	call IncreaseHealthBy
	call IncreaseStaminaBy
	call IncreaseSanityBy
	call ResetRandomHSS
	ret
	
CombatVictory:
	call ClearScreen
	call GetUI
	lea rdi, NL
	call WriteString
	lea rdi, CombatVictoryText
	call WriteString
	ret

DreadClawHunt:	

	call ClearScreen
	call GetUI
	call DecreaseHealthBy
	call DecreaseStaminaBy
	call DamageDealt
	call Blocked
	call DreadClaw
	call GetMonsterHealth
	call GetUiBoarder
	lea rdi, DreadClawText
	call WriteString
	call GetUiBoarder
	call ResetRandomHSS
	mov rax, 0									# reset Block values
	mov r14, 0									# reset Attack values
	ret

MinotaurHunt:
	call ClearScreen
	call GetUI
	call DecreaseHealthBy
	call DecreaseStaminaBy
	call DamageDealt
	call Blocked
	call Minotaur
	call GetMonsterHealth
	call GetUiBoarder
	lea rdi, MinotaurText
	call WriteString
	call GetUiBoarder
	call ResetRandomHSS
	mov rax, 0									# reset Block values
	mov r14, 0									# reset Attack values
	ret

NightStalkerHunt:
	call ClearScreen
	call GetUI
	call DecreaseHealthBy
	call DecreaseStaminaBy
	call DamageDealt	
	call Blocked
	call NightStalker
	call GetMonsterHealth
	call GetUiBoarder
	lea rdi, NightStalkerText
	call WriteString
	call GetUiBoarder
	call ResetRandomHSS
	mov rax, 0									# reset Block values
	mov r14, 0									# reset Attack values
	ret

SpiderHunt:
	call ClearScreen
	call GetUI
	call DecreaseHealthBy
	call DecreaseStaminaBy
	call DamageDealt
	call Blocked
	call Spider
	call GetMonsterHealth
	call GetUiBoarder
	lea rdi, SpiderText
	call WriteString
	call GetUiBoarder
	call ResetRandomHSS
	mov rax, 0									# reset Block values
	mov r14, 0									# reset Attack values
	ret

MindGameWispers:
	call ClearScreen
	
	sub r10, 5									# subtract from sanity
	call CheckSanity
	add r14, 5									# add difference to change in sanity

	call GetUI
	call DecreaseSanityBy	
	call MindGamePic1
	call GetUiBoarder
	lea rdi, MindGame1Text
	call WriteString
	call GetUiBoarder
	ret

MindGameMistMan:
	call ClearScreen

	sub r10, 10									# subtract from sanity
	call CheckSanity
	add r14, 10									# add difference to change in sanity	

	call GetUI
	call DecreaseSanityBy	
	call MindGamePic2
	call GetUiBoarder
	lea rdi, MindGame2Text
	call WriteString
	call GetUiBoarder
	ret		

# ******************************************************** Ascii Art display ***********************************************

NightStalker:
	mov rdi, 2
	call SetForeColor
	lea rdi, NightStalker1
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret

DreadClaw:
	mov rdi, 3
	call SetForeColor
	lea rdi, DreadClaw1
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret

Minotaur:
	mov rdi, 6
	call SetForeColor
	lea rdi, Minotaur1
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret

Spider:
	mov rdi, 5
	call SetForeColor
	lea rdi, Spider1
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret	

MindGamePic1:
	mov rdi, 5
	call SetForeColor
	lea rdi, MindGameImage1
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret

MindGamePic2:
	mov rdi, 3
	call SetForeColor
	lea rdi, MindGameImage2
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
Enlightenment:
	mov rdi, 6
	call SetForeColor
	lea rdi, EnlightenmentPicture
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
Terror:
	mov rdi, 1
	call SetForeColor
	lea rdi, TerrorPicture
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
Death:
	mov rdi, 1
	call SetForeColor
	lea rdi, ReaperPicture
	call WriteString
	lea rdi, DeathText
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret	
	
Cat:
	mov rdi, 5
	call SetForeColor
	lea rdi, CatPicture
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret		
	
ShadowBeast:
	mov rdi, 6
	call SetForeColor
	lea rdi, ShadowBeastPic
	call WriteString
	lea rdi, ShadowBeastPicText
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
CastleImage:
	mov rdi, 3
	call SetForeColor
	lea rdi, CastlePicture
	call WriteString
	lea rdi, EscapeText
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
LostImage:
	mov rdi, 2
	call SetForeColor
	lea rdi, LostPicture
	call WriteString
	lea rdi, LostText
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
SpecialEventImage:
	mov rdi, 5
	call SetForeColor
	lea rdi, SpecialEventPicture
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret
	
AcceptSpecialEventImage:
	mov rdi, 1
	call SetForeColor
	lea rdi, AcceptSpecialEventPicture
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret	
	
MapImage:
	mov rdi, 3
	call SetForeColor
	lea rdi, FoundMap
	call WriteString
	mov rdi, 7
	call SetForeColor
	ret	
	
###################################################################################### Game Logic ######################################################################################


CheckSpecialEvent:								# if Health, Stamina, Saity all at 80 offer a speial Event and even then there is only a 10% chance 
	cmp r8, 81									# set to 81 so that it doesn't trigger on the first cycle
	jge SpecialStaminaCheck
	ret

SpecialStaminaCheck:
	cmp r9, 80
	jge SpecialSanityCheck
	ret
	
SpecialSanityCheck:
	cmp r10, 80
	jge SpecialEventFlag
	ret
	
SpecialEventFlag:
	mov rax, 2									# set rax to flag the special event
	ret
	
AcceptSpecialEventLogic:
	call ResetRandomHSS
	sub r8, 50									# sub 50 Health
	sub r9, 50									# sub 50 Stamina
	sub r10, 50									# sub 50 Sanity

PortalRandomDays:
	mov rdi, 4									# radnom num of days to take off of journey
	call Random
	cmp rdi, 0
	je PortalRandomDays							# check that the days subtracted isn't 0											
	sub rsi, rdi
	
	mov r12, 50									# set delta Health
	mov r13, 50									# set delta Stamina
	mov r14, 50									# set delta Sanity
	ret
	

CheckInsanityVsCastle:							# Checks days to insane vs days to castle and if they are too greatly appart go insane
	mov r12, rsi								# create temp value for days to castle
	mov r13, r11								# create temp value for days till insane
	
	cmp r13, r12 								# if the difference is greater that -5, hero becomes lost this indicates that the insanity timer runs out before escape counter	
	jl ForestFlag
	ret
	
ForestFlag:									
	mov rax, 1									# rax is the flag indicator to check for lost prompt 1 = end
	ret

DecreaseDaysToCastle:
	sub rsi, 1
	call CheckCastleDays
	ret
	
CheckCastleDays:
	cmp rsi, 0
	jle CastleZero
	ret

CastleZero:
	mov rsi, 0									# sets days to get to castle = 0
	ret

CheckMonsterHealth:								# checks if monster health 0, if below will set to 0
	cmp rdx, 0
	jle SetMonster0
	ret
	
SetMonster0:
	mov rdx, 0
	ret

MonsterAttack:
												# checks what monster the player is fighting and attacks accordingly
	cmp r15, 1		
	je SpiderAttack
	cmp r15, 2		
	je StalkerAttack
	cmp r15, 3		
	je MinoataurAttack

DreadClawAttack:
	mov rdi, 11									# does 5-15 points of damage per hit
	call Random
	add rdi, 5
	mov rcx, rdi								# move Monster temp attack int rcx
	mov r12, rcx								# health changed by
	ret

MinoataurAttack:
	mov rdi, 26									# does 5-30 points of damage per hit
	call Random
	add rdi, 5
	mov rcx, rdi								# move Monster temp attack int rcx
	mov r12, rcx								# health changed by
	ret

StalkerAttack:
	mov rdi, 15									# does 5-20 points of damage per hit
	call Random
	add rdi, 5
	mov rcx, rdi								# move Monster temp attack int rcx
	mov r12, rcx								# health changed by
	ret

SpiderAttack:
	mov rdi, 21									# does 5-25 points of damage per hit
	call Random
	add rdi, 5
	mov rcx, rdi								# move Monster temp attack int rcx
	mov r12, rcx								# health changed by
	ret
												# call combat options are called after MonsterAttack so attack power is stored in rcx
Combat1:
	mov rdi, 21									# light attack for 10-30
	call Random
	add rdi, 10
	mov rax, rdi								# atttack damage delt to monster
	sub rdx, rdi								# sub monsters health
	call CheckMonsterHealth
	sub r8, rcx									# sub monsters attack from health
	ret
	
Combat2:
	mov rdi, 11
	call Random									# Heavy attack for 30 - 40
	add rdi, 30

	mov rax, rdi								# atttack damage delt to monster
	sub rdx, rdi								# sub monsters health
	call CheckMonsterHealth	
	sub r8, rcx									# sub monsters attack from health

	cmp r9, 10									# make sure player has block
	jg AttemptHeavyAttack
	jmp Combat1									# jump to light attack if stamina below 10

AttemptHeavyAttack:	
	sub r9, 10									# sub 10 points from stamina
	mov r13, 10									# display change in stamina
	ret
	
Combat3:										# Block Option
	mov rdi, 101								# Sheild Bash chance 10% for 10-25 points of damage
	call Random
	cmp rdi, 10
	jle SheildBash
	jmp FailBash

SheildBash:
	mov rdi, 21									# sheild bash for 5-25 points of damage	
	call Random
	add rdi, 5
	mov rax, rdi								
	sub rdx, rdi								# sub Monsters health from sheild bash damage

FailBash:
	mov rdi, 26									# block 10-35 points of damage
	call Random
	add rdi, 10
	
	cmp rcx, rdi								# compare rdi (block) to rcx (monster Attack)
	jle BlockSuccess

BlockFail:				
	sub rcx, rdi								# block fails and difference is subtracted from health
	mov r14, rdi								# Blocked damage delt by monster
	mov r12, rcx								# health changed by
	cmp rcx, 0
	sub r8, rcx
	ret
BlockSuccess:
	mov r14, rdi
	ret

Combat4:
												# Counter attack for 15-80 points of damage
	mov rdi, 66
	call Random
	add rdi, 15			
	sub rdx, rdi								# sub attack from monster health
	mov rax, rdi								# atttack damage delt to monster
	sub r9, 15									# sub 15 points from stamina
	mov r13, 15									# display change in stamina	
	
	mov rdi, 2									# determine Dodge
	call Random
	cmp rdi, 0									# dodge failed
	je DodgeFail

DodgeSuccess:
	mov r12, 0									# display 0 damage taken
	ret
DodgeFail:
	
	add rcx, 15									# add 15 damage to attack 	
	mov rdi, rcx								# move Monster temp attack int rcx
	mov r12, rcx								# health changed by
	call CheckMonsterHealth
	
	sub r8, rdi									# sub health
	ret

Combat5:
	mov rdi, 21									# Flee for 20-40 points of stamina
	call Random
	add rdi, 20
	sub r9, rdi									# sub stamina
	call CheckStamina
	mov r15, 5									# set to escape condition
	add rsi, 2									# add 2 days to journey
	ret

ResetRandomHSS:
	mov r12, 0
	mov r13, 0
	mov r14, 0
	ret

DecreaseHealthBy:
	lea rdi, HealthDecreased	
	call WriteString
	mov rdi, r12
	call WriteInt
	lea rdi, NL
	call WriteString
	mov r12, 0									# reset random value increase/decrease
	ret

IncreaseHealthBy:
	lea rdi, HealthIncreased	
	call WriteString
	mov rdi, r12
	call WriteInt
	lea rdi, NL
	call WriteString
	mov r12, 0									# reset random value increase/decrease
	ret

IncreaseStaminaBy:
	lea rdi, StaminaIncreased	
	call WriteString
	mov rdi, r13
	call WriteInt
	lea rdi, NL
	call WriteString
	mov r13, 0									# reset random value increase/decrease
	ret

DecreaseStaminaBy:
	lea rdi, StaminaDecreased	
	call WriteString
	mov rdi, r13
	call WriteInt
	lea rdi, NL
	call WriteString
	mov r13, 0									# reset random value increase/decrease
	ret
IncreaseSanityBy:
	lea rdi, SanityIncreased	
	call WriteString
	mov rdi, r14
	call WriteInt
	lea rdi, NL
	call WriteString
	lea rdi, NL
	call WriteString
	mov r14, 0									# reset random value increase/decrease
	ret

DecreaseSanityBy:
	lea rdi, SanityDecreased	
	call WriteString
	mov rdi, r14
	call WriteInt
	lea rdi, NL
	call WriteString
	mov r14, 0									# reset random value increase/decrease
	ret

RandomEvent:
	mov rdi, 101								# 1 in 4 change of random hunting event
	call Random
	mov r15, rdi
	cmp r15, 0
	je HuntZero
	ret

RandomFour:
	mov rdi, 5
	call Random
	mov r15, rdi
	cmp r15, 0
	je HuntZero
	ret

HuntZero:
	jmp RandomFour								# if rdi = 0 jump back to RandomFour to not add another call to the stack
	
HuntHealthIncrease:
	mov rdi, 6									# Increase Health by 10-15 points
	call Random
	add rdi, 10
	mov r12, rdi
	add r8, rdi									# add radom number to health
	ret
	
HuntLogic:
	call HuntHealthIncrease
	call CheckHealth							# check that health doesn't go over 100 or below 0

	mov rdi, 6									# Decrease Stamina by 5-10 points
	call Random
	add rdi, 5
	mov r13, rdi
	sub r9, rdi									# subtract random number from stamina
	
	call CheckStamina							# check that Stamina doesn't go over or below 0
	ret

RestLogic:
	mov rdi, 11									# increase health by 25-35
	call Random
	add rdi, 25
	mov r12, rdi
	add r8, rdi									# add health to player

	call CheckHealth
	
	mov rdi, 21									# Increase Stamina by 30-50 points
	call Random
	add rdi, 30
	mov r13, rdi
	add r9, rdi									# add stamina to player	

	call CheckStamina
	ret

MeditateLogic:
	mov rdi, 21									# increase Sanity by 25-45
	call Random
	add rdi, 25
	mov r14, rdi
	add r10, rdi								# add sanity to player
	
	call CheckSanity

	mov rdi, 6									# Increase Stamina by 10-15 points
	call Random
	add rdi, 10
	mov r13, rdi
	add r9, rdi									# add stamina to player	

	call CheckStamina
	ret

CheckHealth:
	cmp r8, 100
	jge SetHealth100
	cmp r8, 0
	jle SetHealth0
	ret

SetHealth100:
	mov r8, 100
	ret
SetHealth0:
	mov r8, 0
	ret

CheckStamina:
	cmp r9, 100
	jge SetStamina100
	cmp r9, 0
	jle SetStamina0
	ret

SetStamina100:
	mov r9, 100
	ret
SetStamina0:
	mov r9, 0
	ret

CheckSanity:
	cmp r10, 100
	jge SetSanity100
	cmp r10, 0
	jle SetSanity0
	ret

SetSanity100:
	mov r10, 100
	ret
SetSanity0:
	mov r10, 0
	ret
												# decrease sanity by 10-20 points per day
DailyDecreaseSanity:
	mov rdi, 11
	call Random
	add rdi, 10									# generate a random number from 10-20
	mov r14, rdi
	sub r10, rdi								# subtract it from sanity
	call CheckSanity							# check that Sanity doesn't go over or below 0
	ret
												
DecreaseInsanityDay:							# takes 1 day off for every desicition made/day gone by using register r11 to do the subtraction 
	sub r11, 1
	ret
	
CheckDaysTillInsane:							# if insanity days = 0 then set Sanity meter to 0
	cmp r11, 0
	je SetSanity0
	ret
	
GetHealth:										# Subroutine gets players current Health using redister r8 to hold the value
	mov rdi, 1
	call SetForeColor

	cmp r8, 100
	jge Health100
	cmp r8, 95
	jge Health95
	cmp r8, 90
	jge Health90
	cmp r8, 85
	jge Health85
	cmp r8, 80
	jge Health80
	cmp r8, 75
	jge Health75
	cmp r8, 70
	jge Health70
	cmp r8, 65
	jge Health65
	cmp r8, 60
	jge Health60
	cmp r8, 55
	jge Health55
	cmp r8, 50
	jge Health50
	cmp r8, 45
	jge Health45
	cmp r8, 40
	jge Health40
	cmp r8, 35
	jge Health35
	cmp r8, 30
	jge Health30
	cmp r8, 25
	jge Health25
	cmp r8, 20
	jge Health20
	cmp r8, 15
	jge Health15
	cmp r8, 10
	jge Health10
	cmp r8, 5
	jmp Health5

Health100:
	lea rdi, PlayerHealth100
	call WriteString
	ret
Health95:
	lea rdi, PlayerHealth95
	call WriteString
	ret
Health90:
	lea rdi, PlayerHealth90
	call WriteString
	ret
Health85:
	lea rdi, PlayerHealth85
	call WriteString
	ret
Health80:
	lea rdi, PlayerHealth80
	call WriteString
	ret
Health75:
	lea rdi, PlayerHealth75
	call WriteString
	ret
Health70:
	lea rdi, PlayerHealth70
	call WriteString
	ret
Health65:
	lea rdi, PlayerHealth65
	call WriteString
	ret
Health60:
	lea rdi, PlayerHealth60
	call WriteString
	ret
Health55:
	lea rdi, PlayerHealth55
	call WriteString
	ret
Health50:
	lea rdi, PlayerHealth50
	call WriteString
	ret
Health45:
	lea rdi, PlayerHealth45
	call WriteString
	ret
Health40:
	lea rdi, PlayerHealth40
	call WriteString
	ret
Health35:
	lea rdi, PlayerHealth35
	call WriteString
	ret
Health30:
	lea rdi, PlayerHealth30
	call WriteString
	ret
Health25:
	lea rdi, PlayerHealth25
	call WriteString
	ret
Health20:
	lea rdi, PlayerHealth20
	call WriteString
	ret
Health15:
	lea rdi, PlayerHealth15
	call WriteString
	ret
Health10:
	lea rdi, PlayerHealth10
	call WriteString
	ret
Health5:
	lea rdi, PlayerHealth5
	call WriteString
Health0:
	ret

GetStamina:										# Subroutine gets players current Stamina using redister r9 to hold the value
	mov rdi, 2
	call SetForeColor

	cmp r9, 100
	jge Stamina100
	cmp r9, 95
	jge Stamina95
	cmp r9, 90
	jge Stamina90
	cmp r9, 85
	jge Stamina85
	cmp r9, 80
	jge Stamina80
	cmp r9, 75
	jge Stamina75
	cmp r9, 70
	jge Stamina70
	cmp r9, 65
	jge Stamina65
	cmp r9, 60
	jge Stamina60
	cmp r9, 55
	jge Stamina55
	cmp r9, 50
	jge Stamina50
	cmp r9, 45
	jge Stamina45
	cmp r9, 40
	jge Stamina40
	cmp r9, 35
	jge Stamina35
	cmp r9, 30
	jge Stamina30
	cmp r9, 25
	jge Stamina25
	cmp r9, 20
	jge Stamina20
	cmp r9, 15
	jge Stamina15
	cmp r9, 10
	jge Stamina10
	cmp r9, 5
	jmp Stamina5

Stamina100:
	lea rdi, PlayerStamina100
	call WriteString
	ret
Stamina95:
	lea rdi, PlayerStamina95
	call WriteString
	ret
Stamina90:
	lea rdi, PlayerStamina90
	call WriteString
	ret
Stamina85:
	lea rdi, PlayerStamina85
	call WriteString
	ret
Stamina80:
	lea rdi, PlayerStamina80
	call WriteString
	ret
Stamina75:
	lea rdi, PlayerStamina75
	call WriteString
	ret
Stamina70:
	lea rdi, PlayerStamina70
	call WriteString
	ret
Stamina65:
	lea rdi, PlayerStamina65
	call WriteString
	ret
Stamina60:
	lea rdi, PlayerStamina60
	call WriteString
	ret
Stamina55:
	lea rdi, PlayerStamina55
	call WriteString
	ret
Stamina50:
	lea rdi, PlayerStamina50
	call WriteString
	ret
Stamina45:
	lea rdi, PlayerStamina45
	call WriteString
	ret
Stamina40:
	lea rdi, PlayerStamina40
	call WriteString
	ret
Stamina35:
	lea rdi, PlayerStamina35
	call WriteString
	ret
Stamina30:
	lea rdi, PlayerStamina30
	call WriteString
	ret
Stamina25:
	lea rdi, PlayerStamina25
	call WriteString
	ret
Stamina20:
	lea rdi, PlayerStamina20
	call WriteString
	ret
Stamina15:
	lea rdi, PlayerStamina15
	call WriteString
	ret
Stamina10:
	lea rdi, PlayerStamina10
	call WriteString
	ret
Stamina5:
	lea rdi, PlayerStamina5
	call WriteString
Stamina0:
	ret

GetSanity:										# Subroutine gets players current Sanity using redister r10 to hold the value
	mov rdi, 5
	call SetForeColor

	cmp r10, 100
	jge Sanity100
	cmp r10, 95
	jge Sanity95
	cmp r10, 90
	jge Sanity90
	cmp r10, 85
	jge Sanity85
	cmp r10, 80
	jge Sanity80
	cmp r10, 75
	jge Sanity75
	cmp r10, 70
	jge Sanity70
	cmp r10, 65
	jge Sanity65
	cmp r10, 60
	jge Sanity60
	cmp r10, 55
	jge Sanity55
	cmp r10, 50
	jge Sanity50
	cmp r10, 45
	jge Sanity45
	cmp r10, 40
	jge Sanity40
	cmp r10, 35
	jge Sanity35
	cmp r10, 30
	jge Sanity30
	cmp r10, 25
	jge Sanity25
	cmp r10, 20
	jge Sanity20
	cmp r10, 15
	jge Sanity15
	cmp r10, 10
	jge Sanity10
	cmp r10, 5
	jmp Sanity5

Sanity100:
	lea rdi, PlayerSanity100
	call WriteString
	ret
Sanity95:
	lea rdi, PlayerSanity95
	call WriteString
	ret
Sanity90:
	lea rdi, PlayerSanity90
	call WriteString
	ret
Sanity85:
	lea rdi, PlayerSanity85
	call WriteString
	ret
Sanity80:
	lea rdi, PlayerSanity80
	call WriteString
	ret
Sanity75:
	lea rdi, PlayerSanity75
	call WriteString
	ret
Sanity70:
	lea rdi, PlayerSanity70
	call WriteString
	ret
Sanity65:
	lea rdi, PlayerSanity65
	call WriteString
	ret
Sanity60:
	lea rdi, PlayerSanity60
	call WriteString
	ret
Sanity55:
	lea rdi, PlayerSanity55
	call WriteString
	ret
Sanity50:
	lea rdi, PlayerSanity50
	call WriteString
	ret
Sanity45:
	lea rdi, PlayerSanity45
	call WriteString
	ret
Sanity40:
	lea rdi, PlayerSanity40
	call WriteString
	ret
Sanity35:
	lea rdi, PlayerSanity35
	call WriteString
	ret
Sanity30:
	lea rdi, PlayerSanity30
	call WriteString
	ret
Sanity25:
	lea rdi, PlayerSanity25
	call WriteString
	ret
Sanity20:
	lea rdi, PlayerSanity20
	call WriteString
	ret
Sanity15:
	lea rdi, PlayerSanity15
	call WriteString
	ret
Sanity10:
	lea rdi, PlayerSanity10
	call WriteString
	ret
Sanity5:
	lea rdi, PlayerSanity5
	call WriteString
Sanity0:
	ret

GetMonsterHealth:								# Monsters Dynamic Health Bar
	mov rdi, 1
	call SetForeColor

	cmp rdx, 150
	jge Monster150
	cmp rdx, 145
	jge Monster145
	cmp rdx, 140
	jge Monster140
	cmp rdx, 135
	jge Monster135
	cmp rdx, 130
	jge Monster130
	cmp rdx, 125
	jge Monster125
	cmp rdx, 120
	jge Monster120
	cmp rdx, 115
	jge Monster115
	cmp rdx, 110
	jge Monster110
	cmp rdx, 105
	jge Monster105
	cmp rdx, 100
	jge Monster100
	cmp rdx, 95
	jge Monster95
	cmp rdx, 90
	jge Monster90
	cmp rdx, 85
	jge Monster85
	cmp rdx, 80
	jge Monster80
	cmp rdx, 75
	jge Monster75
	cmp rdx, 70
	jge Monster70
	cmp rdx, 65
	jge Monster65
	cmp rdx, 60
	jge Monster60
	cmp rdx, 55
	jge Monster55
	cmp rdx, 50
	jge Monster50
	cmp rdx, 45
	jge Monster45
	cmp rdx, 40
	jge Monster40
	cmp rdx, 35
	jge Monster35
	cmp rdx, 30
	jge Monster30
	cmp rdx, 25
	jge Monster25
	cmp rdx, 20
	jge Monster20
	cmp rdx, 15
	jge Monster15
	cmp rdx, 10
	jge Monster10
	cmp rdx, 5
	jge Monster5
	cmp rdx, 0
	jg Monster5
	cmp rdx, 0
	jle Monster0

Monster150:
	lea rdi, MonsterHealth150
	call WriteString
	ret
Monster145:
	lea rdi, MonsterHealth145
	call WriteString
	ret
Monster140:
	lea rdi, MonsterHealth140
	call WriteString
	ret
Monster135:
	lea rdi, MonsterHealth135
	call WriteString
	ret
Monster130:
	lea rdi, MonsterHealth130
	call WriteString
	ret
Monster125:
	lea rdi, MonsterHealth125
	call WriteString
	ret
Monster120:
	lea rdi, MonsterHealth120
	call WriteString
	ret
Monster115:
	lea rdi, MonsterHealth115
	call WriteString
	ret
Monster110:
	lea rdi, MonsterHealth110
	call WriteString
	ret
Monster105:
	lea rdi, MonsterHealth105
	call WriteString
	ret
Monster100:
	lea rdi, MonsterHealth100
	call WriteString
	ret
Monster95:
	lea rdi, MonsterHealth95
	call WriteString
	ret
Monster90:
	lea rdi, MonsterHealth90
	call WriteString
	ret
Monster85:
	lea rdi, MonsterHealth85
	call WriteString
	ret
Monster80:
	lea rdi, MonsterHealth80
	call WriteString
	ret
Monster75:
	lea rdi, MonsterHealth75
	call WriteString
	ret
Monster70:
	lea rdi, MonsterHealth70
	call WriteString
	ret
Monster65:
	lea rdi, MonsterHealth65
	call WriteString
	ret
Monster60:
	lea rdi, MonsterHealth60
	call WriteString
	ret
Monster55:
	lea rdi, MonsterHealth55
	call WriteString
	ret
Monster50:
	lea rdi, MonsterHealth50
	call WriteString
	ret
Monster45:
	lea rdi, MonsterHealth45
	call WriteString
	ret
Monster40:
	lea rdi, MonsterHealth40
	call WriteString
	ret
Monster35:
	lea rdi, MonsterHealth35
	call WriteString
	ret
Monster30:
	lea rdi, MonsterHealth30
	call WriteString
	ret
Monster25:
	lea rdi, MonsterHealth25
	call WriteString
	ret
Monster20:
	lea rdi, MonsterHealth20
	call WriteString
	ret
Monster15:
	lea rdi, MonsterHealth15
	call WriteString
	ret
Monster10:
	lea rdi, MonsterHealth10
	call WriteString
	ret
Monster5:
	lea rdi, MonsterHealth5
	call WriteString
	ret
Monster0:							
	ret
