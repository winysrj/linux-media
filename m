Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78J2w6G028641
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 15:02:58 -0400
Received: from smtp-out3.blueyonder.co.uk (smtp-out3.blueyonder.co.uk
	[195.188.213.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78J2c6Z020180
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 15:02:39 -0400
Message-ID: <489C984E.70300@blueyonder.co.uk>
Date: Fri, 08 Aug 2008 20:02:38 +0100
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <488C9266.7010108@blueyonder.co.uk>	
	<1217364178.2699.17.camel@pc10.localdom.local>	
	<4890BBE8.8000901@blueyonder.co.uk>	
	<1217457895.4433.52.camel@pc10.localdom.local>	
	<48921FF9.8040504@blueyonder.co.uk>	
	<1217542190.3272.106.camel@pc10.localdom.local>	
	<48942E42.5040207@blueyonder.co.uk>	
	<1217679767.3304.30.camel@pc10.localdom.local>	
	<4895D741.1020906@blueyonder.co.uk>	
	<1217798899.2676.148.camel@pc10.localdom.local>	
	<4898C258.4040004@blueyonder.co.uk>
	<489A0B01.8020901@blueyonder.co.uk>	
	<1218059636.4157.21.camel@pc10.localdom.local>	
	<489B6E1B.301@blueyonder.co.uk>
	<1218153337.8481.30.camel@pc10.localdom.local>
In-Reply-To: <1218153337.8481.30.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
Reply-To: id012c3076@blueyonder.co.uk
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Hermann,

I got errors in the 'make' (see below).  Presumably, there is something 
else I need to install/download?

Ian

[Ian@localhost ~]$ cd v4l-dvb/
[Ian@localhost v4l-dvb]$ make
make -C /home/Ian/v4l-dvb/v4l
make[1]: Entering directory `/home/Ian/v4l-dvb/v4l'
No version yet, using 2.6.25.11-97.fc9.i686
make[1]: Leaving directory `/home/Ian/v4l-dvb/v4l'
make[1]: Entering directory `/home/Ian/v4l-dvb/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.25
File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at 
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: Leaving directory `/home/Ian/v4l-dvb/v4l'
make[1]: Entering directory `/home/Ian/v4l-dvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.25
File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at 
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** No rule to make target `.myconfig', needed by 
`config-compat.h'.  Stop.
make[1]: Leaving directory `/home/Ian/v4l-dvb/v4l'
make: *** [all] Error 2
[Ian@localhost v4l-dvb]$

hermann pitton wrote:
> Hi Ian,
>
> Am Donnerstag, den 07.08.2008, 22:50 +0100 schrieb Ian Davidson:
>   
>> Hi Hermann,
>>
>> I am sorry for being slow - but I have some questions.
>>     
>
> no problem, but it is unfortunately time we have to waste all and
> sometimes it is better someone more used to test some new cards tries to
> give the status under current conditions, but who can buy all the new
> cards, only to shuffle them to a pile, since already no free PCI slots
> since long.
>
> That stuff is still under full production, but might vanish soon in the
> future at all, since PCI is outdated and on new machines you hardly find
> a slot left.
>
>   
>> 1) When you say "you need firmware ...for DVB-T", would that only be if 
>> I want to use the tuner?
>>     
>
> It even means you need firmware only, if you want the frontend being
> usable for DVB-T. You don't need it for analog TV tuning.
>
>   
>> 2) I have the mercurial and I can see the details in saa7134-cards.c and 
>> I have seen the entry for the 'close match'.  I appreciate that, since 
>> it was not auto-detected, the match may not be close enough.  I can see 
>> the vmux entry there.  Presumably, 'vmux' is 'Video Multiplex' and 
>> 'amux' is 'Audio Multiplex' (or something similar) - but what would I 
>> change to try different values.  Currently, the file saa7134-cards.c is 
>> in the folder I downloaded to - would linux know that it was supposed to 
>> look there?  Do I need to put the settings somewhere else (such as the 
>> modeprobe.conf?)
>>     
>
> Yes, that is exactly latest linux in this case.
>
> Changing the code is still prior to modprobe options,
> but we discussed once to get the complete cards configurations into
> userspace and almost all agreed.
>
> On top of v4l-dvb try
> "make"
> become root
> "make rmmod"
> "make rminstall"
> "make install"
> "modprobe -v saa7134"
>
> If you still have black and white only on the composite input,
> you now change the code and save it, simplest is to add all 5 possible
> composite inputs from vmux=0 to four to the card's entry.
>
> Now you just do the same for
> "make"
> "make rmmod"
> "make install"
> "modprobe -v saa7134"
>
> That is still some major part of what it is all about.
> Change the code if needed.
>
>   
>> 3) Incidentally, I happened to notice that just after boot, I get some 
>> messages that there is a problem with modprobe. The messages were wiped 
>> off the screen before I could record them reliably.  Is there some way 
>> of seeing what those messages were, once linux is up and running.
>>     
>
> Such modprobe related messages you always find later with "dmesg",
> since they come fairly late and all logging and udev is already up.
>
> Happy hacking,
>
> Hermann
>
>   
>> Ian
>>
>> hermann pitton wrote:
>>     
>>> Hi Ian,
>>>
>>> Am Mittwoch, den 06.08.2008, 21:35 +0100 schrieb Ian Davidson:
>>>   
>>>       
>>>> I do have the (Windows) driver disk.
>>>>
>>>> Is there any information on that that could assist with making the card 
>>>> card work under linux?
>>>>
>>>> Ian
>>>>     
>>>>         
>>> seems nobody else has this revision of the new Kworld 210SE yet.
>>>
>>> You need firmware for the tda10046a in lib firmware for DVB-T.
>>>
>>> You can find some long winded thread with timf on the linux-dvb ML,
>>> where we tried to settle some issues for firmware loading and AGC
>>> switching on the prior 210RF, but without full success yet. (June 2008)
>>>
>>> Hopefully it does not hit you too.
>>>
>>> For the composite input, you are mostly interested, the .inf files might
>>> have some hints, but usually manufacturers keep what they previously
>>> had.
>>>
>>> If you get the v4l-dvb source from mercurial at linuxtv.org installed,
>>> the composite input in saa7134-cards.c can be on vmux 0,1,2,3 or 4.
>>>
>>> You can just add that much composite sections in the card's entry and
>>> try them, or look for other cards offering them.
>>>
>>> On a PAL card it was not seen yet, that none of them works, only NTSC
>>> cards are know to might have a video enhancer to transform the signal to
>>> s-video, which is at the higher vmuxes you see in saa7134-cards.c then.
>>>
>>> The amux is either the LINE1 or the LINE2 pair, if not blocked by an
>>> external gpio switched mux in between.
>>>
>>> If you don't have analog audio out to the sound card, you depend on
>>> saa7134-alsa and should read about it on the v4l wiki at linuxtv.org.
>>>
>>> Good Luck,
>>> Hermann
>>>
>>>
>>>   
>>>       
>>>> Ian Davidson wrote:
>>>>     
>>>>         
>>>>> I have a KWorld DVB-T 210SE card which is not autodetected.  I want to 
>>>>> use this card simply to capture video from the Composite input - the 
>>>>> tuner is redundant.  With help from Hermann, I now am able to capture 
>>>>> video - but the video is always Black and White.  I would much prefer 
>>>>> it to be colour.
>>>>>
>>>>> I would appreciate suggestions as to what to try next.
>>>>>
>>>>> Ian
>>>>>
>>>>>
>>>>> hermann pitton wrote:
>>>>>       
>>>>>           
>>>>>> Hi Ian,
>>>>>>
>>>>>> Am Sonntag, den 03.08.2008, 17:05 +0100 schrieb Ian Davidson:
>>>>>>  
>>>>>>         
>>>>>>             
>>>>>>> Hi Hermann,
>>>>>>>
>>>>>>> 1) I have changed my email "Reply-To" as emails were getting lost in
>>>>>>> the system.
>>>>>>>
>>>>>>> 2) I searched for modprobe.conf and found one (only)
>>>>>>> in /usr/share/logwatch/default.conf/services.  I opened it and saw
>>>>>>> that it was empty (apart from comments) and added the options line.  I
>>>>>>> then saved it and copied it to /etc and ran depmod.  After rebooting,
>>>>>>> this is what I get in dmesg (extract)
>>>>>>>
>>>>>>> iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
>>>>>>> ppdev: user-space parallel port driver
>>>>>>> Linux video capture interface: v2.00
>>>>>>> saa7130/34: v4l2 driver version 0.2.14 loaded
>>>>>>> ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
>>>>>>> saa7133[0]: setting pci latency timer to 64
>>>>>>> saa7133[0]: found at 0000:04:02.0, rev: 209, irq: 18, latency: 64,
>>>>>>> mmio: 0xfebff800
>>>>>>> saa7133[0]: subsystem: 17de:7253, board: KWorld DVB-T 210
>>>>>>> [card=114,insmod option]
>>>>>>> saa7133[0]: board init: gpio is 100
>>>>>>> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
>>>>>>> PCI: Setting latency timer of device 0000:00:1b.0 to 64
>>>>>>> ALSA sound/pci/hda/hda_intel.c:1810: chipset global capabilities =
>>>>>>> 0x4401
>>>>>>> saa7133[0]: i2c eeprom 00: de 17 53 72 ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>>>> ff ff
>>>>>>> saa7133[0]: i2c scan: found device @ 0x10  [???]
>>>>>>> ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0x1
>>>>>>> hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
>>>>>>> ALSA sound/pci/hda/hda_codec.c:2857: autoconfig: line_outs=4
>>>>>>> (0x14/0x15/0x16/0x17/0x0)
>>>>>>> ALSA sound/pci/hda/hda_codec.c:2861:    speaker_outs=0
>>>>>>> (0x0/0x0/0x0/0x0/0x0)
>>>>>>> ALSA sound/pci/hda/hda_codec.c:2865:    hp_outs=1
>>>>>>> (0x1b/0x0/0x0/0x0/0x0)
>>>>>>> ALSA sound/pci/hda/hda_codec.c:2866:    mono: mono_out=0x0
>>>>>>> ALSA sound/pci/hda/hda_codec.c:2874:    inputs: mic=0x18, fmic=0x19,
>>>>>>> line=0x1a, fline=0x0, cd=0x0, aux=0x0
>>>>>>> saa7133[0]: i2c scan: found device @ 0x96  [???]
>>>>>>> saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
>>>>>>> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Headphone
>>>>>>> Playback Volume, skipped
>>>>>>> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker
>>>>>>> Playback Volume, skipped
>>>>>>> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback
>>>>>>> Volume, skipped
>>>>>>> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Line-Out
>>>>>>> Playback Volume, skipped
>>>>>>> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker
>>>>>>> Playback Switch, skipped
>>>>>>> ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback
>>>>>>> Switch, skipped
>>>>>>> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
>>>>>>> tda8290 1-004b: setting tuner address to 61
>>>>>>> tda8290 1-004b: type set to tda8290+75a
>>>>>>> saa7133[0]: registered device video0 [v4l2]
>>>>>>> saa7133[0]: registered device vbi0
>>>>>>> saa7133[0]: registered device radio0
>>>>>>> DVB: registering new adapter (saa7133[0])
>>>>>>> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>>>>>>> tda1004x: setting up plls for 48MHz sampling clock
>>>>>>> SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
>>>>>>> NET: Registered protocol family 10
>>>>>>> lo: Disabled Privacy Extensions
>>>>>>> mtrr: base(0xd0000000) is not aligned on a size(0xff00000) boundary
>>>>>>> tda1004x: timeout waiting for DSP ready
>>>>>>> tda1004x: found firmware revision 0 -- invalid
>>>>>>> tda1004x: trying to boot from eeprom
>>>>>>> tda1004x: timeout waiting for DSP ready
>>>>>>> device-mapper: multipath: version 1.0.5 loaded
>>>>>>> tda1004x: found firmware revision 0 -- invalid
>>>>>>> tda1004x: waiting for firmware upload...
>>>>>>> tda1004x: no firmware upload (timeout or file not found?)
>>>>>>> tda1004x: firmware upload failed
>>>>>>> loop: module loaded
>>>>>>> EXT3 FS on dm-0, internal journal
>>>>>>> kjournald starting.  Commit interval 5 seconds
>>>>>>>
>>>>>>> And, when I run xawtv I got this.
>>>>>>>
>>>>>>> [Ian@localhost ~]$ xawtv -hwscan
>>>>>>> This is xawtv-3.95, running on Linux/i686 (2.6.25.11-97.fc9.i686)
>>>>>>> looking for available devices
>>>>>>> /dev/video0: OK                         [ -device /dev/video0 ]
>>>>>>>     type : v4l2
>>>>>>>     name : KWorld DVB-T 210
>>>>>>>     flags: overlay capture tuner
>>>>>>> [Ian@localhost ~]$
>>>>>>> SO I ran xawtv again (with -remote -nodga) and saw that I could select
>>>>>>> Composite1 an a source.  Then I ran streamer, specifying Composite1
>>>>>>> and I captured an AVI file.  However, as you predicted, the images
>>>>>>> captured are all Black and White.  (We went through all the camera
>>>>>>> options to make sure it wasn't the camera set to BW!)
>>>>>>>
>>>>>>> Definitely a long way forward.
>>>>>>>
>>>>>>> Ian
>>>>>>>
>>>>>>> PS - last time I tried, I am able to record audio through the mobo
>>>>>>> sound system.  I did not seemto be able to tune in the tuner yet.
>>>>>>>
>>>>>>>
>>>>>>> hermann pitton wrote:    
>>>>>>>           
>>>>>>>               
>>>>>>>> Hi Ian,
>>>>>>>>
>>>>>>>> become root !
>>>>>>>>
>>>>>>>>       
>>>>>>>>             
>>>>>>>>                 
>>>>>> definitely a long way, not to talk about lost mails, but on module stuff
>>>>>> you must be root.
>>>>>>
>>>>>> That is nothing new at all :) and took much too long.
>>>>>>
>>>>>> Since I don't have neither the prior card nor the actual one,
>>>>>> it is time to go back to lists, others might be helpful as well.
>>>>>>
>>>>>> Cheers,
>>>>>> Hermann
>>>>>>         
>>>>>>             
>
>
>
>  
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>   

-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
