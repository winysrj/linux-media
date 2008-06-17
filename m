Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HCSHM4023677
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 08:28:17 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5HCS3Yo019372
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 08:28:03 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans-Peter Diettrich <DrDiettrich1@aol.com>
In-Reply-To: <4855BC3F.4010806@aol.com>
References: <485273BB.6040608@aol.com>
	<1213387999.2758.65.camel@pc10.localdom.local>
	<48540B1E.3020908@aol.com>
	<1213555148.2683.61.camel@pc10.localdom.local>
	<4855BC3F.4010806@aol.com>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 14:26:03 +0200
Message-Id: <1213705563.2621.50.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Medion problem
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

Hi,

Am Montag, den 16.06.2008, 03:05 +0200 schrieb Hans-Peter Diettrich: 
> hermann pitton schrieb:
> 
> >> Close, but here's what really works so far:
> >>
> >> dodi@noname:~> xawtv -nodga -remote -c /dev/video1
> >> This is xawtv-3.95, running on Linux/x86_64 (2.6.22.17-0.1-default)
> >> xinerama 0: 1280x1024+1680+0
> >> xinerama 1: 1680x1050+0+0
> > 
> > it is because the 16be:0005 device is detected at first now on the PCI
> > bus and thus 16be:0003 becomes /dev/video1.
> 
> I wonder why xawtv uses /dev/video0 by default, and not the link /dev/video.

there is a hint in the source.

It changed to that, because Redhat once switched over to start
with /dev/video0 and forgot the link to it from old /dev/video.
Is fixed these days.

> >> Only the sound is missing :-(
> >> Even modprobe (tuner and saa7134) didn't help.
> > 
> > The card has usually also internally a red MPC2 style analog audio out
> > connector. Since about the md8383 this is not connected anymore to AUX
> > or CD-in of the soundchip of the board. You can use a cdrom audio cable
> > for that.
> 
> This wouldn't help in video recording, I suppose?

For sound without saa7134-alsa it would help also for analog recording.

For mencoder with saa7134-alsa something like that.

/usr/bin/mencoder -v tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:chanlist=europe-west:alsa:adevice=hw.1,0:audiorate=32000:amode=1:forceaudio:volume=95:immediatemode=0:norm=PAL -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=3600 -vf pp=lb -oac mp3lame -lameopts cbr:br=128:mode=0 -o mytest.avi

For mplayer without analog audio out connected.

/usr/bin/mplayer -v tv:// -vf pp=lb -tv driver=v4l2:norm=PAL:input=0:alsa:adevice=hw.1,0:forceaudio:immediatemode=0:audiorate=32000:amode=1:width=640:height=480:outfmt=yuy2:device=/dev/video0:chanlist=europe-west:channel=E6

One would prefer "tvtime" with the good deinterlacers from DScaler and
no fumbling on the command line,
but you need some helper application like "sox" for the sound then or
add the analog audio connection. Kaffeine is fine for DVB-S.

BTW, the driver supports HDTV if it is not S2 and not encrypted, like
BBC HD 1080i.
The x264 decoder has at least some remaining troubles on x86_64 systems
and multithreading on amd64 quad core CPUs, but on x86 32bit and Nvidia
you might be already fine with yours.

> > The other option is to load saa7134-alsa for dma sound.
> > Have a look at the v4l wiki at linuxtv.org for usage hints.
> > 
> > A quick start is:
> > "sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 32000 /dev/dsp"
> 
> Thanks, I'll give it a try :-)
> 
> 
> >> saa7134[1]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
> >> saa7134[1]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[1]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[1] Tuner type is 38
> >> saa7134[1]: registered device video1 [v4l2]
> >> saa7134[1]: registered device vbi1
> >> saa7134[1]: registered device radio0
> >> saa7134[1]/dvb: frontend initialization failed
> >>
> > 
> > Thanks, this did confuse me a little last night,
> > but on a second look it really might mean that you have a new and
> > undocumented card type/revision under 16be:0003 and I start some
> > guessing.
> 
> If I can assist...
> 
> > It is all about if you really have the detected, but not loaded analog
> > only tuner=38 (FM1216ME/I H-3) or the hybrid with analog and DVB-T
> > support tuner=63 (FMD1216ME/I H-3).
> > 
> > It seems it is the analog only tuner.
> > The hybrid one comes also with an external Philips tda10046 channel
> > decoder chip.
> > If you would enable "i2c_scan=1" on loading the saa7134 it should be
> > found at i2c address 0x10 in dmesg, but frontend attach fails already
> > and the tda10046 is also not present in the eeprom.
> 
> You mean modprobe -vr and -v?

Yes.

> > Is DVB-T announced at all? Best would be to take the card out, look at
> > the CTX???_V? type and revision, read the tuner label and report if the
> > tda10046 is there.
> 
> Okay, but it will take some time. I'm handicapped and need assistance to
> get the card out.

If you "modprobe -v saa7134 i2c_scan=1" and the tda10046 DBT-T
channel-decoder at address 0x10 is not there, we should have a new
device type without DVB-T support.

> > If it has the FM1216ME/I H-3 analog only, some pictures would be welcome
> > as well, since not yet documented.
> > The version of the ISL chip for the 12Volt supply of the LNB would also
> > be interesting. On the known one it is isl6405er.
> > In case you send pics, please off list or load them up somewhere.
> 
> I have a camera, and some unused webspace :-)

Without it's only best guess.

> > The likely correct tuner=38 would be set again with current v4l-dvb.
> > There was a regression in the eeprom tuner detection, which is fixed
> > now. Both tuners are not fully compatible for analog. With a wrong one
> > set, you lose some channels and on low VHF they might be noisy/snowy.
> 
> Does it mean that I must get the current head revision from the repository?

No, only if you like to start to experiment with DVB-S on the 16be:0005
device and have SAT equipment. Else the modprobe options below should
help you out so far.

> > To escape the broken eeprom detected tuner setup, you can use the
> > compatible card=5 and force the tuner type there for the 16be:0003
> > section.
> > "modprobe -v saa7134 card=93,5 tuner=4,38 latency=64 gbuffers=32"
> > something. The -v is important to see if there is something from YAST
> > overriding your command line.
> 
> The log ends with:
> 
> insmod 
> /lib/modules/2.6.22.17-0.1-default/kernel/drivers/media/video/saa7134/saa7134.ko 
> card=93,5 tuner=4,38 latency=64 gbuffers=32
> 
> Nonetheless no sound :-(

Without the audio cable or proper use of saa7134-alsa it is expected
to stay so.

> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7134[0]: setting pci latency timer to 64
> saa7134[0]: found at 0000:02:00.0, rev: 1, irq: 16, latency: 64, mmio: 
> 0xfddff000
> saa7134[0]: subsystem: 16be:0005, board: Medion 7134 Bridge #2 
> [card=93,insmod option]
> saa7134[0]: board init: gpio is 0
> saa7134[0]: Medion 7134 Bridge #2: dual saa713x broadcast decoders
> saa7134[0]: Sorry, none of the inputs to this chip are supported yet.
> saa7134[0]: Dual decoder functionality is disabled for now, use the 
> other chip.
> saa7134[0]: i2c eeprom 00: be 16 05 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
> saa7134[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 21 02 51 96 2b
> saa7134[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
> saa7134[0]: i2c eeprom 40: ff 24 00 c0 ff 1c 00 ff ff ff fd 79 44 9f c2 8f
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> saa7134[1]: setting pci latency timer to 64
> saa7134[1]: found at 0000:02:01.0, rev: 1, irq: 17, latency: 64, mmio: 
> 0xfddfe000
> saa7134[1]: subsystem: 16be:0003, board: SKNet Monster TV [card=5,insmod 
> option]
> saa7134[1]: board init: gpio is 0
> saa7134[1]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> saa7134[1]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
> saa7134[1]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner 2-0043: chip found @ 0x86 (saa7134[1])
> tda9887 2-0043: tda988[5/6/7] found @ 0x43 (tuner)
> tuner 2-0060: All bytes are equal. It is not a TEA5767
> tuner 2-0060: chip found @ 0xc0 (saa7134[1])
> tuner 2-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> tuner 2-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> saa7134[1]: registered device video1 [v4l2]
> saa7134[1]: registered device vbi1
> saa7134[1]: registered device radio0

No more error on the attempt to attach a likely not present
DVB-T frontend.

> > Please keep the list in reply.
> 
> I already noticed that I had forgotten to "reply all" :-(
> 
> DoDi

It happens to all, don't worry.

If there are no further surprises, you should be able to have TV sound
on a next step.

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
