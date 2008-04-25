Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PNtXK6025576
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 19:55:33 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PNt4Ft001937
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 19:55:04 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: mkrufky@linuxtv.org
In-Reply-To: <1209160129.21096.11.camel@pc10.localdom.local>
References: <4811F391.1070207@linuxtv.org>
	<1209160129.21096.11.camel@pc10.localdom.local>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 01:41:06 +0200
Message-Id: <1209166866.9807.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, gert.vervoort@hccnet.nl,
	mchehab@infradead.org
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


Am Freitag, den 25.04.2008, 23:48 +0200 schrieb hermann pitton: 
> Hi,
> 
> Am Freitag, den 25.04.2008, 11:06 -0400 schrieb mkrufky@linuxtv.org:
> > Mauro Carvalho Chehab wrote:
> > > On Fri, 25 Apr 2008 10:40:14 -0400
> > > "Michael Krufky" <mkrufky@linuxtv.org> wrote:
> > >
> > >   
> > >> On Fri, Apr 25, 2008 at 9:56 AM, Mauro Carvalho Chehab
> > >> <mchehab@infradead.org> wrote:
> > >>     
> > >>> On Thu, 24 Apr 2008 05:55:28 +0200
> > >>>  hermann pitton <hermann-pitton@arcor.de> wrote:
> > >>>
> > >>>  > > > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the
> > drivers
> > >>>  > > > >>>> for   the Hauppauge WinTV appear to have suffered some
> > regression
> > >>>  > > > >>>> between the two kernel versions.

[snip] 
> > 
> > Lets get your fixes tested ASAP so we can fix 2.6.25-stable.
> > 
> > Regards,
> > 
> > Mike
> 
> I started already yesterday evening to test if the tuner eeprom
> detection will come back for one of the md7134 cards on saa7134 by
> reverting the above changeset.
> 
> To my surprise not. Only reloading the tuner stuff detects the right
> tuner.
> 
> Since it became too late then, I have now repeated it on a 2.6.25 and
> get the same. Can't say when it started, since no free slots for such
> cards during the last months.
> 
> Will try with Mauro's saa7134-cards.c patch later.
> 

With a new v4l-dvb copy and only Mauro's saa7134-cards.c patch applied,
it is the same as previously for now. Seems tuner-simple doesn't act on
it.

I had to replace the previous md7134 with tuner=38 with another one with
tuner=5. The first one has a second PCI bridge for ISDN and most
machines don't like that ;)

Logs attached including tuner reload.

Cheers,
Hermann


Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: setting pci latency timer to 64
saa7133[0]: found at 0000:01:07.0, rev: 208, irq: 19, latency: 64, mmio: 0xe8000000
saa7133[0]: subsystem: 1043:4857, board: Philips Tiger reference design [card=81,insmod option]
saa7133[0]: board init: gpio is 200000
saa7133[0]/core: hwinit1
tuner' 2-004b: tda829x detected
tuner' 2-004b: Setting mode_mask to 0x0e
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tuner' 2-004b: tuner 0x4b: Tuner type absent
tuner' 2-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x04, config=0x00
tuner' 2-004b: set addr for type -1
tuner' 2-004b: defining GPIO callback
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
tuner' 2-004b: type set to tda8290+75a
tuner' 2-004b: tv freq set to 400.00
tuner' 2-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e
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
tuner' 2-004b: Calling set_type_addr for type=54, addr=0x00, mode=0x0e, config=0x00
tuner' 2-004b: set addr for type 54
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
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input10
tuner' 3-004b: tda829x detected
tuner' 3-004b: Setting mode_mask to 0x0e
tuner' 3-004b: chip found @ 0x96 (saa7133[1])
tuner' 3-004b: tuner 0x4b: Tuner type absent
tuner' 3-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x04, config=0x00
tuner' 3-004b: set addr for type -1
tuner' 3-004b: defining GPIO callback
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
tuner' 3-004b: type set to tda8290+75a
tuner' 3-004b: tv freq set to 400.00
tuner' 3-004b: saa7133[1] tuner' I2C addr 0x96 with type 54 used for 0x0e
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
tuner' 3-004b: Calling set_type_addr for type=54, addr=0x00, mode=0x0e, config=0x00
tuner' 3-004b: set addr for type 54
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
tuner' 4-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x04, config=0x00
tuner' 4-004b: set addr for type -1
tuner' 4-004b: defining GPIO callback
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
tuner' 4-004b: type set to tda8290+75a
tuner' 4-004b: tv freq set to 400.00
tuner' 4-004b: saa7133[2] tuner' I2C addr 0x96 with type 54 used for 0x0e
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
tuner' 4-004b: Calling set_type_addr for type=54, addr=0x00, mode=0x0e, config=0x00
tuner' 4-004b: set addr for type 54
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
tuner' 5-0060: Calling set_type_addr for type=63, addr=0xff, mode=0x04, config=0x00
tuner' 5-0060: set addr for type -1
tuner' 5-0060: defining GPIO callback
tuner-simple 5-0060: creating new instance
tuner-simple 5-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner-simple 5-0060: tuner 0 atv rf input will be autoselected
tuner-simple 5-0060: tuner 0 dtv rf input will be autoselected
tuner' 5-0060: type set to Philips FMD1216ME M
tuner' 5-0060: tv freq set to 400.00
tuner-simple 5-0060: using tuner params #0 (pal)
tuner-simple 5-0060: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0060: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0060: saa7134[3] tuner' I2C addr 0xc0 with type 63 used for 0x0e
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
tuner' 5-0060: Calling set_type_addr for type=5, addr=0x00, mode=0x0e, config=0x00
tuner' 5-0060: set addr for type 63
saa7134[3]/core: hwinit2
tuner' 5-0060: switching to v4l2
tuner' 5-0060: tv freq set to 400.00
tuner-simple 5-0060: using tuner params #0 (pal)
tuner-simple 5-0060: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0060: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0060: tv freq set to 400.00
tuner-simple 5-0060: using tuner params #0 (pal)
tuner-simple 5-0060: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0060: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0060: tv 0x1b 0x6f 0x86 0x52
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
tuner-simple 5-0060: destroying instance
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
tuner' 3-004b: chip found @ 0x96 (saa7133[1])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
tuner' 4-004b: chip found @ 0x96 (saa7133[2])
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
All bytes are equal. It is not a TEA5767
tuner' 5-0060: chip found @ 0xc0 (saa7134[3])
tuner-simple 5-0060: creating new instance
tuner-simple 5-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
