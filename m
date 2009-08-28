Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:60107 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbZH1BRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 21:17:43 -0400
Subject: Re: Pinnacle PCTV 310i active antenna
From: hermann pitton <hermann-pitton@arcor.de>
To: Martin Konopka <martin.konopka@mknetz.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1248754507.3246.13.camel@pc07.localdom.local>
References: <200907011701.43079.martin.konopka@mknetz.de>
	 <1246753081.822.16.camel@pc07.localdom.local>
	 <200907272136.19668.martin.konopka@mknetz.de>
	 <1248754507.3246.13.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 03:08:27 +0200
Message-Id: <1251421707.3674.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

Am Dienstag, den 28.07.2009, 06:15 +0200 schrieb hermann pitton:
> Hi Martin,
> 
> Am Montag, den 27.07.2009, 21:36 +0200 schrieb Martin Konopka:
> > Hi Hermann,
> > 
> > I'm using kernel 2.6.28-11 on a mythbuntu distribution.  I tried to load the 
> > drivers with the card=50 option and antenna_pwr=1.
> > 
> > [ 8745.007384] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 300i 
> > DVB-T + PAL [card=50,insmod option]
> > [ 8745.007628] saa7133[0]: board init: gpio is 600c000
> > [ 8745.007641] saa7133[0]: gpio: mode=0x0008000 in=0x6004000 out=0x0008000 
> > [pre-init]
> > [ 8745.148374] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> > 
> > [..]
> > 
> > [ 8802.196576] dvb_init() allocating 1 frontend
> > [ 8802.196583] saa7133[0]/dvb: pinnacle 300i dvb setup
> > [ 8802.196845] mt352_read_register: readreg error (reg=127, ret==-5)
> > [ 8802.196953] saa7133[0]/dvb: frontend initialization failed
> > 
> > The antenna power is not activated. I then installed microsoft stuff. To my 
> > horror it turned out that the active antenna switch is greyed out in 
> > Pinnacle's TV application. 
> > 
> > So the card obviously does not have an active antenna, although the manual 
> > mentions it. Probably copy and paste from the 300i manual.
> > 
> > Regards,
> > 
> > Martin
> 
> thanks a lot for reporting and for going to all that testing stuff.
> 
> Since neither Hartmut nor me ever had such a card, Hartmut would be much
> better than me on such, we should be able to exclude active voltage to
> support the antenna on it now.
> 
> For the other issues since 2.6.26 I don't have new ideas and such cards
> seem not to be available on some e/xbay currently.
> 
> The Hauppauge/Pinnacle US guys can't help much either currently and
> there is no reason to blame them for something they don't know. (yet)
> 
> So it is only what is posted so far.
> 
> Thanks,
> Hermann
> 

also for the record.

The early variant of the 310i I have now has clearly support for 5 Volt
antenna output. Easy to measure.

I can install currently three different driver versions under vista, all
with different gpio configuration. The one for testing the 5 Volt switch
for now is with the original driver CD from 2005.

Unfortunately, it has also these always changing gpios, like the TS
interface is always on, but the voltage switch is no problem on vista
with that old XP driver. Other stuff is ...

dmesg from mine.

saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:04:03.0, rev: 208, irq: 21, latency: 64, mmio: 0xfebfe800
saa7133[2]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,insmod option]
saa7133[2]: board init: gpio is 600e000
IRQ 21/saa7133[2]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[2]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2c b0 22 ff ff
saa7133[2]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a5 ff 21 00 c2
saa7133[2]: i2c eeprom 30: 96 10 03 32 15 20 ff ff 0c 22 17 88 03 44 31 f9
saa7133[2]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
input: i2c IR (Pinnacle PCTV) as /class/input/input6
ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-3/3-0047/ir0 [saa7133[2]]
tuner 3-004b: chip found @ 0x96 (saa7133[2])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
saa7133[2]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10086 DVB-S)...
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[1])
DVB: registering adapter 1 frontend 0 (Philips TDA10086 DVB-S)...
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[2])
DVB: registering adapter 2 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok

board init: gpio is 600e000 can also change to 0x600c000.

BTW, not totally unrelated, the recent NXP Creatix driver for the Medion
Quad (CTX944) does support also 13 Volt on the second DVB-S device now.

Another problem we still have to resolve.

Cheers,
Hermann

> > 
> > Am Sonntag, 5. Juli 2009 02:18:01 schrieben Sie:
> > > Hi Martin,
> > >
> > > Am Mittwoch, den 01.07.2009, 17:01 +0200 schrieb Martin Konopka:
> > > > Hi all,
> > > >
> > > > my Pinnacle 310i is working well with linux, except for the active
> > > > antenna that is attached to it. I need it in order to watch some weaker
> > > > channels. Is there any way to activate the antenna power of this card
> > > > with recent drivers? The Windows software has an option to do that.
> > >
> > > on which kernel you are currently?
> > >
> > > We have some reports, that what was assumed to be support for an
> > > additional LNA on it is broken on 2.6.26 and onwards, IIRC.
> > >
> > > There are no previous reports for such an active antenna switch for the
> > > 310i I do believe, but Gerd had such an option for the earlier 300i.
> > > (card=50)
> > >
> > > If you don't have any further details, like gpio settings reported from
> > > DScaler's regspy, you might try to force the use of that card, nothing
> > > won't work, but eventually you get voltage to the antenna. ("modinfo
> > > saa7134-dvb")
> > >
> > > Cheers,
> > > Hermann
> > 
> > 


