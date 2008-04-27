Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3RKGsEn011319
	for <video4linux-list@redhat.com>; Sun, 27 Apr 2008 16:16:54 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3RKGefZ009037
	for <video4linux-list@redhat.com>; Sun, 27 Apr 2008 16:16:41 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080426201940.1507fb82@gaivota>
References: <20080425114526.434311ea@gaivota> <4811F391.1070207@linuxtv.org>
	<20080426085918.09e8bdc0@gaivota> <481326E4.2070909@pickworth.me.uk>
	<20080426110659.39fa836f@gaivota>
	<1209247821.15689.12.camel@pc10.localdom.local>
	<20080426201940.1507fb82@gaivota>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 22:15:22 +0200
Message-Id: <1209327322.2661.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mkrufky@linuxtv.org, gert.vervoort@hccnet.nl,
	linux-dvb@linuxtv.org
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

Hi,

Am Samstag, den 26.04.2008, 20:19 -0300 schrieb Mauro Carvalho Chehab:
> On Sun, 27 Apr 2008 00:10:21 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> > Cool stuff!
> > 
> > Works immediately for all tuners again. Analog TV, radio and DVB-T on
> > that machine is tested.
> > 
> > Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> 
> Thanks. I'll add it to the patch.
> 
> > Maybe Hartmut can help too, but I will test also on the triple stuff and
> > the FMD1216ME/I MK3 hybrid tomorrow.
> 
> Thanks.
> 
> It would be helpful if tda9887 conf could also be validated. I didn't touch at
> the logic, but I saw some weird things:
> 
> For example, SAA7134_BOARD_PHILIPS_EUROPA defines this:
> 	.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE
> 
> And SAA7134_BOARD_PHILIPS_SNAKE keep the default values.
> 
> However, there's an autodetection code that changes from EUROPA to SNAKE,
> without cleaning tda9887_conf:
> 
>         case SAA7134_BOARD_PHILIPS_EUROPA:
>                 if (dev->autodetected && (dev->eedata[0x41] == 0x1c)) {
>                         /* Reconfigure board as Snake reference design */
>                         dev->board = SAA7134_BOARD_PHILIPS_SNAKE;
>                         dev->tuner_type = saa7134_boards[dev->board].tuner_type;
>                         printk(KERN_INFO "%s: Reconfigured board as %s\n",
>                                 dev->name, saa7134_boards[dev->board].name);
>                         break;
> 
> I'm not sure if .tda9887_conf is missing at SNAKE board entry, or if the above
> code should be doing, instead:
> 
> 	dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
> 
> If the right thing to do is to initialize SNAKE with the same tda9887
> parameters as EUROPE, the better would be to add the .tda9887_conf to SNAKE
> entry.
> 
> Cheers,
> Mauro

Hartmut has the board and knows better, but it looks like it only has
DVB-S and external analog video inputs. There is TUNER_ABSENT set, no
analog tuner, no tda9887 and also no DVB-T, but it unfortunately shares
the subsystem with the Philips Europa.

I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
boards.

Unchanged is that the tda9887 is not up for analog after boot.
Previously one did reload "tuner" just once and was done.

Now, modprobe vr tuner and modprobe -v tuner results in

tuner' 2-004b: tda829x detected
tuner' 2-004b: Setting mode_mask to 0x0e
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tuner' 2-004b: tuner 0x4b: Tuner type absent
tuner' 3-004b: tda829x detected
tuner' 3-004b: Setting mode_mask to 0x0e
tuner' 3-004b: chip found @ 0x96 (saa7133[1])
tuner' 3-004b: tuner 0x4b: Tuner type absent
tuner' 4-004b: tda829x detected
tuner' 4-004b: Setting mode_mask to 0x0e
tuner' 4-004b: chip found @ 0x96 (saa7133[2])
tuner' 4-004b: tuner 0x4b: Tuner type absent
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
tuner' 5-0043: type set to tda9887
tuner' 5-0043: tv freq set to 0.00
tuner' 5-0043: TV freq (0.00) out of range (44-958)
tuner' 5-0043: saa7134[3] tuner' I2C addr 0x86 with type 74 used for
0x0e
tuner' 5-0061: Setting mode_mask to 0x0e
tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
tuner' 5-0061: tuner 0x61: Tuner type absent

So tests were not complete and it is not finished yet ;)

DVB-T still works, but analog of course not.

A "modprobe -vr saa7134-dvb" and then "modprobe -v saa7134" brings them
all back, including enabling analog TV on the FMD1216ME and tda9887.

Cheers,
Hermann


Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: setting pci latency timer to 64
saa7133[0]: found at 0000:01:07.0, rev: 208, irq: 19, latency: 64, mmio: 0xe8000000
saa7133[0]: subsystem: 1043:4857, board: Philips Tiger reference design [card=81,insmod option]
saa7133[0]: board init: gpio is 0
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
tuner' 2-004b: tda829x detected
tuner' 2-004b: Setting mode_mask to 0x0e
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tuner' 2-004b: tuner 0x4b: Tuner type absent
tuner' 2-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
tuner' 2-004b: defining GPIO callback
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
tuner' 2-004b: type set to tda8290+75a
tuner' 2-004b: tv freq set to 400.00
tuner' 2-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e
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
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input7
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
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
tuner' 5-0043: type set to tda9887
tuner' 5-0043: tv freq set to 0.00
tuner' 5-0043: TV freq (0.00) out of range (44-958)
tuner' 5-0043: saa7134[3] tuner' I2C addr 0x86 with type 74 used for 0x0e
tuner' 5-0061: Setting mode_mask to 0x0e
tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
tuner' 5-0061: tuner 0x61: Tuner type absent
saa7134[3]: i2c eeprom 00: be 16 03 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 1f 02 51 96 2b
saa7134[3]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7134[3]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00
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
saa7134[3] Board has DVB-T
saa7134[3] Tuner type is 63
tuner' 5-0043: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 5-0043: set addr discarded for type 74, mask e. Asked to change tuner at addr 0xff, with mask e
tuner' 5-0061: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 5-0061: defining GPIO callback
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner-simple 5-0061: tuner 0 atv rf input will be autoselected
tuner-simple 5-0061: tuner 0 dtv rf input will be autoselected
tuner' 5-0061: type set to Philips FMD1216ME M
tuner' 5-0061: tv freq set to 400.00
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0061: saa7134[3] tuner' I2C addr 0xc2 with type 63 used for 0x0e
tuner' 5-0043: switching to v4l2
tuner' 5-0061: switching to v4l2
tuner' 5-0061: tv freq set to 400.00
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0061: tv freq set to 400.00
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
tuner' 5-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
tuner' 5-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[2])
DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
tuner-simple 5-0061: attaching existing instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner-simple 5-0061: tuner 0 atv rf input will be autoselected
tuner-simple 5-0061: tuner 0 dtv rf input will be autoselected
DVB: registering new adapter (saa7134[3])
DVB: registering frontend 3 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok








 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
