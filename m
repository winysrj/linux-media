Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1INcF6R012763
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 18:38:15 -0500
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1INc1sa013121
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 18:38:01 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: John Pilkington <J.Pilk@tesco.net>
In-Reply-To: <499C0E76.9000907@tesco.net>
References: <498C3AD4.1070907@tesco.net>
	<1233958764.2466.72.camel@pc10.localdom.local>
	<4990B315.8000309@tesco.net>
	<1234228256.3932.15.camel@pc10.localdom.local>
	<499C0E76.9000907@tesco.net>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 00:38:53 +0100
Message-Id: <1235000333.2486.35.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l_list <video4linux-list@redhat.com>
Subject: Re: Hauppauge HVR-1110 analog audio problem
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


Am Mittwoch, den 18.02.2009, 13:34 +0000 schrieb John Pilkington:
> < older stuff deleted>
> >> Many thanks for your speedy reply.  I still have no analog sound but 
> >> have a few more observations that make me think the problem lies in 
> >> misrouting of the audio rather than in the saa7134 setup.
> >>
> >> First the v4l drivers;  these are from ATrpms and were built from 
> >> mercurial recently. The patch is in there.
> >>
> >> Yes, I had been using the ATrpms alsa-driver and kmdl, but I saw/heard 
> >> no obvious change when I uninstalled them.
> >>
> >> The only indication I have yet seen of analog sound is in the display of 
> >> the PulseAudio volume control.  This shows SAA7134 - SAA7134 PCM as an 
> >> input device with a level indicator that is active and fairly well 
> >> correlated with the sound level on an independent receiver when mplayer 
> >> or tvtime are showing a picture.  Attempts to start kmix produce a 
> >> short-lived floating progress indicator but no kmix.
> >>
> >> Another Input Device is HDA Intel - STAC92xx Analog, which generates 
> >> whitish noise unless muted.
> > 
> > John, without looking closer. too late today.
> > 
> > Does the STAC92xx work for video sound playback on other clips/video you
> > have on disk/somewhere? 
> > 
> > That will use PCM. If this does not work, playback of saa7134-alsa sound
> > can't work either, but recordings are independent from it and should
> > play on another machine with proper sound card support.
> > 
> > In any case, try to avoid pulseaudio.
> > It is flaky and unstable from Fedora 8 to 10.
> > 
> > Best results are with -ao oss (mplayer) -A oss (xine) or with sox on
> > tvtime, which is "oss" by default. (alsa oss emulation layer)
> > 
> > Try to get rid of all off kernel alsa stuff
> > and rpm -ivh --force the old original Fedora kernel if needed.
> > 
> > Cheers,
> > Hermann
> > 
> >> At present I'm at a loss to understand all this. YMMV.
> >>
> >> Cheers,
> >>
> >> John P
> >
> 
> Hi again: I still haven't heard any sound from the analog side of this 
> card.  Since I last wrote there have been several sound-system updates 
> in fc10 and I have complicated matters by adding another apparently 
> quite similar capture card by Avermedia - more details below.  This went 
> smoothly on the dvb side but probably doesn't help diagnosis.
> 
> I don't want to send lots of dmesg stuff but  'dmseg | grep saa' looks 
> as if it might shed some light on things:
> 
> 
> > dmesg | grep saa      
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> > saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 21, latency: 32, mmio: 0x92005000
> > saa7133[0]: subsystem: 0070:6700, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
> > saa7133[0]: board init: gpio is 400000                                                               
> > saa7133[0]: i2c eeprom 00: 70 00 00 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92                           
> > saa7133[0]: i2c eeprom 10: ff ff ff 08 ff 20 ff ff ff ff ff ff ff ff ff ff                           
> > saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 a3 ff ff ff ff                           
> > saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                           
> > saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff                           
> > saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                           
> > saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                           
> > saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                           
> > saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00                           
> > saa7133[0]: i2c eeprom 90: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09                           
> > saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72                           
> > saa7133[0]: i2c eeprom b0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00                           
> > saa7133[0]: i2c eeprom c0: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00                           
> > saa7133[0]: i2c eeprom d0: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09                           
> > saa7133[0]: i2c eeprom e0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72                           
> > saa7133[0]: i2c eeprom f0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00                           
> > tuner' 1-004b: chip found @ 0x96 (saa7133[0])                                                        
> > saa7133[0]: hauppauge eeprom: model=67559                                                            
> > saa7133[0]: registered device video0 [v4l2]                                                          
> > saa7133[0]: registered device vbi0                                                                   
> > saa7133[0]: registered device radio0                                                                 
> > saa7134 0000:07:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22                                     
> > saa7133[1]: found at 0000:07:01.0, rev: 209, irq: 22, latency: 32, mmio: 0x92004800                  
> > saa7133[1]: subsystem: 1461:f01d, board: Avermedia Super 007 [card=117,autodetected]                 
> > saa7133[1]: board init: gpio is 40000                                                                
> > tuner' 2-004b: chip found @ 0x96 (saa7133[1])
> > saa7133[1]: i2c eeprom 00: 61 14 1d f0 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7133[1]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff 00 55 ff ff ff ff
> > saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 40: ff 21 00 c0 96 10 03 02 15 16 ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: registered device video1 [v4l2]
> > saa7133[1]: registered device vbi1
> > DVB: registering new adapter (saa7133[0])
> > DVB: registering new adapter (saa7133[1])
> 
> That was after a reboot. Then, as root, I did 'modprobe -r saa7134-alsa' 
> and 'modprobe saa7134-alsa'.  This added 3 lines to dmesg:
> 
> > saa7134 ALSA driver for DMA sound loaded
> > saa7133[0]/alsa: saa7133[0] at 0x92005000 irq 21 registered as card -1
> > saa7133[1]/alsa: saa7133[1] at 0x92004800 irq 22 registered as card -1
> 
> which looks as if something ( as well as me) is confused, but with the 
> prior modprobe -r the following modprobe shows no error.

John, that is normal output of saa7134-alsa.

It just indicates that it uses the next free minor for /dev/dsp
and /dev/mixer talking about "sox" and the alsa OSS emulation layer.

you can force the dev numbers with the "index" option, but you sound
card might have taken already the first ones.

you can use "dump-mixers" from xawtv and many other tools.

For me on this machine.

dump-mixers
/dev/mixer = HDA-Intel (Realtek ALC888)
  vol        ( 0) :  mono          71
  line       ( 6) :  stereo        97/0
  mic        ( 7) :  stereo        0/0
  pcm2       (10) :  stereo        100/100
  igain      (12) :  stereo        0/0
  dig1       (17) :  mono          0
  phout      (21) :  stereo        100/100
/dev/mixer1 = SAA7134 (SAA7134 Mixer)
  video      (22) :  stereo  rec   0/0
/dev/mixer2 = SAA7134 (SAA7134 Mixer)
  video      (22) :  stereo  rec   0/0
/dev/mixer3 = SAA7134 (SAA7134 Mixer)
  video      (22) :  stereo  rec   0/0

If you did load saa7134-alsa with debug=1 and
"echo 1 > /sys/module/saa7134/parameters/audio_debug"

and start "tvtime" with -v --device=/dev/video0 on the saa7133/35/31e
you should see something for PAL-I, first pilot detction for Mono and
finally NICAM not muted, like I have for PAL-BG dual FM.

tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7133[0]/dvb: setting GPIO21 to 0 (TV antenna?)
saa7133[2]/audio: tvaudio thread scan start [2]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [3]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [4]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [5]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread status: 0x1002a4 [B/G A2,stereo]
saa7133[2]/audio: detailed status:  A2/EIAJ pilot tone ## A2/EIAJ stereo ########### init done
saa7133[2]/audio: tvaudio thread scan start [6]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [7]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [8]
saa7133[2]/audio: scanning: D/K
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread scan start [9]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [10]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread scan start [11]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [12]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [13]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread scan start [14]
saa7133[2]/audio: scanning: D/K
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread scan start [15]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [16]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread scan start [17]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [18]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [19]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread scan start [20]
saa7133[2]/audio: scanning: D/K
saa7133[2]/audio: tvaudio thread scan start [21]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [22]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [23]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [24]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [25]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [26]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [27]
saa7133[2]/audio: scanning: I
saa7133[2]/audio: tvaudio thread scan start [28]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread status: 0x14000b [I NICAM]
saa7133[2]/audio: detailed status: ########### NICAM muted ## init done
saa7133[2]/audio: tvaudio thread scan start [29]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [30]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [31]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [32]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [33]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [34]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [35]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread scan start [36]
saa7133[2]/audio: scanning: B/G D/K I
saa7133[2]/audio: tvaudio thread status: 0x1002a4 [B/G A2,stereo]
saa7133[2]/audio: detailed status:  A2/EIAJ pilot tone ## A2/EIAJ stereo ########### init done

I did force PAL-DK and PAL-I from tvtime, but have no such broadcast.

tvtime -v --device=/dev/video2 and then
"sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp3 -t ossdsp -w -r 32000 /dev/dsp"

produces this

Input File     : '/dev/dsp3' (ossdsp)
Sample Size    : 16-bit (2 bytes)
Sample Encoding: signed (2's complement)
Channels       : 2
Sample Rate    : 32000

and a status line about elapsed time and processed buffers.
Time: 02:00.70 [00:00.00] of 00:00.00 (  0.0%) Output Buffer:   3.86M

And of course sound on PCM with the mixer slider up and that not muted.

As said before, we fixed the HVR1110 for all analog inputs since 2.6.28.

The analog setup for the Avermedia Super007 is not complete and has a
FIXME sticker for analog TV.

	[SAA7134_BOARD_AVERMEDIA_SUPER_007] = {
		.name           = "Avermedia Super 007",
		.audio_clock    = 0x00187de7,
		.tuner_type     = TUNER_PHILIPS_TDA8290,
		.radio_type     = UNSET,
		.tuner_addr     = ADDR_UNSET,
		.radio_addr     = ADDR_UNSET,
		.tuner_config   = 0,
		.mpeg           = SAA7134_MPEG_DVB,
		.inputs = {{
			.name   = name_tv, /* FIXME: analog tv untested */
			.vmux   = 1,
			.amux   = TV,
			.tv     = 1,
		}},
	},
	[SAA7134_BOARD_AVERMEDIA_M135A] = {

I could avoid to let it in with a fictional LNA configuration,
but not with that untested analog stuff. Likely it works or in worst
case needs one of the usual gpio21 configurations.

> In addition KDE keeps popping up this window:
> 
> > KDE detected that one or more internal sound devices were removed.
> > Do you want KDE to permanently forget about these devices?
> > This is the list of devices KDE thinks can be removed:
> > Capture: saa7133[0] (SAA7134 PCM)
> > Capture: saa7133[1] (SAA7134 PCM)
> 
> As before, I get good pictures from mplayer and tvtime, antenna and 
> composite, but the diagnostics say 'no sound'.  The only sign I have 
> seen that something might be there is in the level meter of the one of 
> the two PulseAudio input devices labelled 'SAA7134 - SAA7134 PCM'.
> 
> The other PulseAudio input device is called  'HDA Intel DTAC92xx 
> Analog'.  If unmuted it just produces whitish noise.
> 
> In the KDE (now 4.2) System > System Settings > Multimedia > Audio 
> Output > Music window the Output Devices shown are Pulse Audio, HDA 
> Intel (STAC92xx Analog), Default, Pulse Audio Sound Server, and HDA 
> Intel (STAC92xx Digital).  All except the last now play for the 'Test' 
> button. I don't have digital audio hardware.
> 
> Finally, another sample from dmesg, this time with no grepping.  The 
> 'ALSA sound' stuff is new.
> 
> > Linux video capture interface: v2.00
> > firewire_core: created device fw0: GUID 0090270001c0db68, S400
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> > saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 21, latency: 32, mmio: 0x92005000
> > saa7133[0]: subsystem: 0070:6700, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
> > saa7133[0]: board init: gpio is 400000
> > HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> > HDA Intel 0000:00:1b.0: setting latency timer to 64
> > ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=3 (0xd/0xf/0x10/0x0/0x0)
> > ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> > ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
> > ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
> > ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0xe, fmic=0xb, line=0xc, fline=0x0, cd=0x0, aux=0x0
> > ALSA sound/pci/hda/patch_sigmatel.c:2416: dac_nids=4 (0x2/0x5/0x4/0x3/0x0)
> > saa7133[0]: i2c eeprom 00: 70 00 00 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7133[0]: i2c eeprom 10: ff ff ff 08 ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 a3 ff ff ff ff
> > saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00
> > saa7133[0]: i2c eeprom 90: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09
> > saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
> > saa7133[0]: i2c eeprom b0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00
> > saa7133[0]: i2c eeprom c0: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00
> > saa7133[0]: i2c eeprom d0: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09
> > saa7133[0]: i2c eeprom e0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
> > saa7133[0]: i2c eeprom f0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00
> > nvidia: module license 'NVIDIA' taints kernel.
> > tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> > tveeprom 1-0050: Hauppauge model 67559, rev B1B4, serial# 1539545
> > tveeprom 1-0050: MAC address is 00-0D-FE-17-7D-D9
> > tveeprom 1-0050: tuner model is Philips 8275A (idx 114, type 4)
> > tveeprom 1-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> > tveeprom 1-0050: audio processor is SAA7131 (idx 41)
> > tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
> > tveeprom 1-0050: has radio
> > saa7133[0]: hauppauge eeprom: model=67559
> > tda829x 1-004b: setting tuner address to 61
> > tda829x 1-004b: type set to tda8290+75a
> > saa7133[0]: registered device video0 [v4l2]
> > saa7133[0]: registered device vbi0
> > saa7133[0]: registered device radio0
> > saa7134 0000:07:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> > saa7133[1]: found at 0000:07:01.0, rev: 209, irq: 22, latency: 32, mmio: 0x92004800
> > saa7133[1]: subsystem: 1461:f01d, board: Avermedia Super 007 [card=117,autodetected]
> > saa7133[1]: board init: gpio is 40000
> > tuner' 2-004b: chip found @ 0x96 (saa7133[1])
> > saa7133[1]: i2c eeprom 00: 61 14 1d f0 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7133[1]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff 00 55 ff ff ff ff
> > saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 40: ff 21 00 c0 96 10 03 02 15 16 ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > tda829x 2-004b: setting tuner address to 60
> > tda829x 2-004b: type set to tda8290+75a
> > usb-storage: device scan complete
> 
> ==================
> 
> Any suggestions appreciated. It's not clear to me which bits of the 
> system are broken but it would be nice to get it working!

Try to get PAL-I NICAM not muted on the HVR1110 with saa7134
audio_debug=1.

> John P
> 

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
