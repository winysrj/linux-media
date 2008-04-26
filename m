Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QMBc0e019115
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 18:11:38 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QMBPPX017132
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 18:11:26 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <20080426110659.39fa836f@gaivota>
References: <20080425114526.434311ea@gaivota> <4811F391.1070207@linuxtv.org>
	<20080426085918.09e8bdc0@gaivota> <481326E4.2070909@pickworth.me.uk>
	<20080426110659.39fa836f@gaivota>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 00:10:21 +0200
Message-Id: <1209247821.15689.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: mkrufky@linuxtv.org, video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	gert.vervoort@hccnet.nl
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
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


Am Samstag, den 26.04.2008, 11:06 -0300 schrieb Mauro Carvalho Chehab:
> On Sat, 26 Apr 2008 13:58:12 +0100
> Ian Pickworth <ian@pickworth.me.uk> wrote:
> 
> > Mauro Carvalho Chehab wrote:
> > > 
> > > The issue is that set_type_addr were called at the wrong place.
> > > 
> > > Anyway, I've just committed a patch that should fix this for cx88. I'll soon
> > > use the same logic to fix also saa7134.
> > > 
> > > I've also added a patch for tuner-core, to improve debug (of course, this
> > > doesn't need to go to -stable). This helps to see the bug, if tuner debug is
> > > enabled.
> > > 
> > > Cheers,
> > > Mauro
> > Hi Mauro,
> > I have pulled the latest Mercurial source (at about 13:30 BST), compiled 
> > and installed. I also removed the "tuner=38" workaround from my 
> > modprobe.conf file. On reboot the WinTV cx88 card was detected correctly 
> >   - thus curing the original problem in the standard 2.6.25 drivers. 
> > Also, tvtime works OK with created devices - tuning to all 5 channels OK.
> > The dmesg trace is below.
> 
> Thanks for your tests. Please try also to load first tuner, and then cx88.
> > 
> > About how long would it take for a fix like this to reach the kernel 
> > tree - any chance for 2.6.25?
> I'll wait for one or two days for more people to test. Then, I'll send to
> mainstream, together with saa7134 fix for the same issue.
> 
> After mainstream merge, we'll send for 2.6.25. I think this should also be sent
> to 2.6.24, since the same bug is present on older versions, if tuner is loaded
> before cx88 or saa7134.
> 
> Btw, I've just added the corresponding saa7134 patch.
> 
> Hermann,
> 
> Could you test it please?
> 
> Cheers,
> Mauro


Hi,

Mauro, just came back.

Cool stuff!

Works immediately for all tuners again. Analog TV, radio and DVB-T on
that machine is tested.

Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

Maybe Hartmut can help too, but I will test also on the triple stuff and
the FMD1216ME/I MK3 hybrid tomorrow.

Thanks and cheers,
Hermann


tuner-simple 5-0060: destroying instance
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: setting pci latency timer to 64
saa7133[0]: found at 0000:01:07.0, rev: 208, irq: 19, latency: 64, mmio: 0xe8000000
saa7133[0]: subsystem: 1043:4857, board: Philips Tiger reference design [card=81,insmod option]
saa7133[0]: board init: gpio is 0
saa7133[0]/core: hwinit1
tuner' 2-004b: tda829x detected
tuner' 2-004b: Setting mode_mask to 0x0e
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tuner' 2-004b: tuner 0x4b: Tuner type absent
saa7133[0]: i2c eeprom 00: 43 10 57 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 cb ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 2-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
tuner' 2-004b: defining GPIO callback
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
tuner' 2-004b: type set to tda8290+75a
tuner' 2-004b: tv freq set to 400.00
tuner' 2-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e
saa7133[0]/core: hwinit2
tuner' 2-004b: switching to v4l2
tuner' 2-004b: tv freq set to 400.00
tuner' 2-004b: tv freq set to 400.00
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
tuner' 2-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
saa7133[1]: setting pci latency timer to 64
saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 18, latency: 64, mmio: 0xe8001000
saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual [card=78,autodetected]
saa7133[1]: board init: gpio is 0
saa7133[1]/core: hwinit1
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input6
tuner' 3-004b: tda829x detected
tuner' 3-004b: Setting mode_mask to 0x0e
tuner' 3-004b: chip found @ 0x96 (saa7133[1])
tuner' 3-004b: tuner 0x4b: Tuner type absent
saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff ff
saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 3-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
tuner' 3-004b: defining GPIO callback
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
tuner' 3-004b: type set to tda8290+75a
tuner' 3-004b: tv freq set to 400.00
tuner' 3-004b: saa7133[1] tuner' I2C addr 0x96 with type 54 used for 0x0e
saa7133[1]/core: hwinit2
tuner' 3-004b: switching to v4l2
tuner' 3-004b: tv freq set to 400.00
tuner' 3-004b: tv freq set to 400.00
saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[1]: registered device radio1
tuner' 3-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 64, mmio: 0xe8002000
saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid [card=134,autodetected]
saa7133[2]: board init: gpio is 0
saa7133[2]/core: hwinit1
tuner' 4-004b: tda829x detected
tuner' 4-004b: Setting mode_mask to 0x0e
tuner' 4-004b: chip found @ 0x96 (saa7133[2])
tuner' 4-004b: tuner 0x4b: Tuner type absent
saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2b
saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8f
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 4-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
tuner' 4-004b: defining GPIO callback
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
tuner' 4-004b: type set to tda8290+75a
tuner' 4-004b: tv freq set to 400.00
tuner' 4-004b: saa7133[2] tuner' I2C addr 0x96 with type 54 used for 0x0e
saa7133[2]/core: hwinit2
tuner' 4-004b: switching to v4l2
tuner' 4-004b: tv freq set to 400.00
tuner' 4-004b: tv freq set to 400.00
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
tuner' 4-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
saa7134[3]: board init: gpio is 0
saa7134[3]/core: hwinit1
All bytes are equal. It is not a TEA5767
tuner' 5-0060: Setting mode_mask to 0x0e
tuner' 5-0060: chip found @ 0xc0 (saa7134[3])
tuner' 5-0060: tuner 0x60: Tuner type absent
saa7134[3]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
saa7134[3]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 03 c0 08 00 00 00 00 00
saa7134[3]: i2c eeprom 20: 00 00 00 da ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3] Tuner type is 5
tuner' 5-0060: Calling set_type_addr for type=5, addr=0xff, mode=0x0e, config=0x00
tuner' 5-0060: defining GPIO callback
tuner-simple 5-0060: creating new instance
tuner-simple 5-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
tuner-simple 5-0060: tuner 0 atv rf input will be autoselected
tuner-simple 5-0060: tuner 0 dtv rf input will be autoselected
tuner' 5-0060: type set to Philips PAL_BG (FI1
tuner' 5-0060: tv freq set to 400.00
tuner-simple 5-0060: using tuner params #0 (pal)
tuner-simple 5-0060: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x90
tuner-simple 5-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0060: tv 0x1b 0x6f 0x8e 0x90
tuner' 5-0060: saa7134[3] tuner' I2C addr 0xc0 with type 5 used for 0x0e
saa7134[3]/core: hwinit2
tuner' 5-0060: switching to v4l2
tuner' 5-0060: tv freq set to 400.00
tuner-simple 5-0060: using tuner params #0 (pal)
tuner-simple 5-0060: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x90
tuner-simple 5-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0060: tv 0x1b 0x6f 0x8e 0x90
tuner' 5-0060: tv freq set to 400.00
tuner-simple 5-0060: using tuner params #0 (pal)
tuner-simple 5-0060: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x90
tuner-simple 5-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0060: tv 0x1b 0x6f 0x8e 0x90
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
tuner' 5-0060: Cmd TUNER_SET_STANDBY accepted for analog TV
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7133[0]/core: setting GPIO21 to static 1
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7133[1]/core: setting GPIO21 to static 0
DVB: registering new adapter (saa7133[2])
DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
saa7134[3]/dvb: frontend initialization failed





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
