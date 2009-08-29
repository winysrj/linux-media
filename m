Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:47503 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbZH2XvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 19:51:13 -0400
Subject: Re: Pinnacle PCTV 310i active antenna
From: hermann pitton <hermann-pitton@arcor.de>
To: Martin Konopka <martin.konopka@mknetz.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200908281827.58036.martin.konopka@mknetz.de>
References: <200907011701.43079.martin.konopka@mknetz.de>
	 <1248754507.3246.13.camel@pc07.localdom.local>
	 <1251421707.3674.18.camel@pc07.localdom.local>
	 <200908281827.58036.martin.konopka@mknetz.de>
Content-Type: multipart/mixed; boundary="=-PjrdUodxv5zZlODMv+hR"
Date: Sun, 30 Aug 2009 01:38:35 +0200
Message-Id: <1251589115.26402.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-PjrdUodxv5zZlODMv+hR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Martin,

Am Freitag, den 28.08.2009, 18:27 +0200 schrieb Martin Konopka:
> Hallo Hermann,
> 
> ich schreibe einmal abseits der Maillingliste, da ich eine Frage zu Windows 
> habe. Ich konnte mit meiner PCTV 310i die Antennenspannung in der Tv-Software 
> von Pinnacle nicht aktivieren, da das Feld "Aktivantennen" grau war. Konntest 
> Du die Antennenspannung dort aktivieren? Der einzige Unterschied scheint eine 
> etwas neuere Hardwareversion bei mir als bei Dir zu sein:

Yes, as replied in German, I can get voltage to the antenna in windows
on my card. The older driver from 2005 provides a tool to manually
switch it on or off at any time, the current driver has only voltage for
DVB-T and that tool is gone.

> saa7133[0]: found at 0000:04:06.0, rev: 209, irq: 20, latency: 64, mmio: 
> 0xfbfff800
> 
> Ziel ist es aber natürlich, die Spannung unter Linux zu aktivieren. :-)

Yes, of course. We don't know, if it is on all cards the same and if all
cards do support it.

In combination with the LNA unknowns it might improve the mess not to
know that too.

A testhack, not a clean implementation, is attached and should give you
voltage to the active antenna when using DVB-T.

BTW, the radio seems to be broken since some weeks.
It is not by that patch here.

Cheers,
Hermann

> Vielen Dank!
> 
> Martin
> Am Freitag, 28. August 2009 03:08:27 schrieben Sie:
> > Hi Martin,
> >
> > Am Dienstag, den 28.07.2009, 06:15 +0200 schrieb hermann pitton:
> > > Hi Martin,
> > >
> > > Am Montag, den 27.07.2009, 21:36 +0200 schrieb Martin Konopka:
> > > > Hi Hermann,
> > > >
> > > > I'm using kernel 2.6.28-11 on a mythbuntu distribution.  I tried to
> > > > load the drivers with the card=50 option and antenna_pwr=1.
> > > >
> > > > [ 8745.007384] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV
> > > > 300i DVB-T + PAL [card=50,insmod option]
> > > > [ 8745.007628] saa7133[0]: board init: gpio is 600c000
> > > > [ 8745.007641] saa7133[0]: gpio: mode=0x0008000 in=0x6004000
> > > > out=0x0008000 [pre-init]
> > > > [ 8745.148374] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> > > >
> > > > [..]
> > > >
> > > > [ 8802.196576] dvb_init() allocating 1 frontend
> > > > [ 8802.196583] saa7133[0]/dvb: pinnacle 300i dvb setup
> > > > [ 8802.196845] mt352_read_register: readreg error (reg=127, ret==-5)
> > > > [ 8802.196953] saa7133[0]/dvb: frontend initialization failed
> > > >
> > > > The antenna power is not activated. I then installed microsoft stuff.
> > > > To my horror it turned out that the active antenna switch is greyed out
> > > > in Pinnacle's TV application.
> > > >
> > > > So the card obviously does not have an active antenna, although the
> > > > manual mentions it. Probably copy and paste from the 300i manual.
> > > >
> > > > Regards,
> > > >
> > > > Martin
> > >
> > > thanks a lot for reporting and for going to all that testing stuff.
> > >
> > > Since neither Hartmut nor me ever had such a card, Hartmut would be much
> > > better than me on such, we should be able to exclude active voltage to
> > > support the antenna on it now.
> > >
> > > For the other issues since 2.6.26 I don't have new ideas and such cards
> > > seem not to be available on some e/xbay currently.
> > >
> > > The Hauppauge/Pinnacle US guys can't help much either currently and
> > > there is no reason to blame them for something they don't know. (yet)
> > >
> > > So it is only what is posted so far.
> > >
> > > Thanks,
> > > Hermann
> >
> > also for the record.
> >
> > The early variant of the 310i I have now has clearly support for 5 Volt
> > antenna output. Easy to measure.
> >
> > I can install currently three different driver versions under vista, all
> > with different gpio configuration. The one for testing the 5 Volt switch
> > for now is with the original driver CD from 2005.
> >
> > Unfortunately, it has also these always changing gpios, like the TS
> > interface is always on, but the voltage switch is no problem on vista
> > with that old XP driver. Other stuff is ...
> >
> > dmesg from mine.
> >
> > saa7133[1]: registered device video1 [v4l2]
> > saa7133[1]: registered device vbi1
> > saa7133[2]: setting pci latency timer to 64
> > saa7133[2]: found at 0000:04:03.0, rev: 208, irq: 21, latency: 64, mmio:
> > 0xfebfe800 saa7133[2]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i
> > [card=101,insmod option] saa7133[2]: board init: gpio is 600e000
> > IRQ 21/saa7133[2]: IRQF_DISABLED is not guaranteed on shared IRQs
> > saa7133[2]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7133[2]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2c b0 22 ff ff
> > saa7133[2]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a5 ff 21 00 c2
> > saa7133[2]: i2c eeprom 30: 96 10 03 32 15 20 ff ff 0c 22 17 88 03 44 31 f9
> > saa7133[2]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > input: i2c IR (Pinnacle PCTV) as /class/input/input6
> > ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-3/3-0047/ir0
> > [saa7133[2]] tuner 3-004b: chip found @ 0x96 (saa7133[2])
> > tda829x 3-004b: setting tuner address to 61
> > tda829x 3-004b: type set to tda8290+75a
> > saa7133[2]: registered device video2 [v4l2]
> > saa7133[2]: registered device vbi2
> > saa7133[2]: registered device radio0
> > dvb_init() allocating 1 frontend
> > DVB: registering new adapter (saa7133[0])
> > DVB: registering adapter 0 frontend 0 (Philips TDA10086 DVB-S)...
> > dvb_init() allocating 1 frontend
> > DVB: registering new adapter (saa7133[1])
> > DVB: registering adapter 1 frontend 0 (Philips TDA10086 DVB-S)...
> > dvb_init() allocating 1 frontend
> > DVB: registering new adapter (saa7133[2])
> > DVB: registering adapter 2 frontend 0 (Philips TDA10046H DVB-T)...
> > tda1004x: setting up plls for 48MHz sampling clock
> > tda1004x: found firmware revision 29 -- ok
> >
> > board init: gpio is 600e000 can also change to 0x600c000.
> >
> > BTW, not totally unrelated, the recent NXP Creatix driver for the Medion
> > Quad (CTX944) does support also 13 Volt on the second DVB-S device now.
> >
> > Another problem we still have to resolve.
> >
> > Cheers,
> > Hermann
> >
> > > > Am Sonntag, 5. Juli 2009 02:18:01 schrieben Sie:
> > > > > Hi Martin,
> > > > >
> > > > > Am Mittwoch, den 01.07.2009, 17:01 +0200 schrieb Martin Konopka:
> > > > > > Hi all,
> > > > > >
> > > > > > my Pinnacle 310i is working well with linux, except for the active
> > > > > > antenna that is attached to it. I need it in order to watch some
> > > > > > weaker channels. Is there any way to activate the antenna power of
> > > > > > this card with recent drivers? The Windows software has an option
> > > > > > to do that.
> > > > >
> > > > > on which kernel you are currently?
> > > > >
> > > > > We have some reports, that what was assumed to be support for an
> > > > > additional LNA on it is broken on 2.6.26 and onwards, IIRC.
> > > > >
> > > > > There are no previous reports for such an active antenna switch for
> > > > > the 310i I do believe, but Gerd had such an option for the earlier
> > > > > 300i. (card=50)
> > > > >
> > > > > If you don't have any further details, like gpio settings reported
> > > > > from DScaler's regspy, you might try to force the use of that card,
> > > > > nothing won't work, but eventually you get voltage to the antenna.
> > > > > ("modinfo saa7134-dvb")
> > > > >
> > > > > Cheers,
> > > > > Hermann
> 
> 

--=-PjrdUodxv5zZlODMv+hR
Content-Disposition: inline; filename*0=saa7134_pinnacle-310i_enable_antenna_voltage_for_dvb-t_testha; filename*1=ck.patch
Content-Type: text/x-patch; name*0=saa7134_pinnacle-310i_enable_antenna_voltage_for_dvb-t_testhack.p; name*1=atch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 6f58a5d8c7c6 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 29 09:01:54 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Aug 30 00:13:19 2009 +0200
@@ -3244,29 +3244,38 @@
 		.radio_addr     = ADDR_UNSET,
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
-		.gpiomask       = 0x000200000,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 4,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name = name_comp1,
-			.vmux = 1,
-			.amux = LINE2,
-		},{
-			.name = name_comp2,
-			.vmux = 0,
-			.amux = LINE2,
-		},{
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE2,
-		}},
-		.radio = {
-			.name = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
+		.gpiomask       = 0x04200000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 4,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x04000000,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE2,
+			.gpio = 0x04000000,
+		}, {
+			.name = name_comp2,
+			.vmux = 0,
+			.amux = LINE2,
+			.gpio = 0x04000000,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x04000000,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x04200000,
+		},
+		.mute  = {
+			.name = name_mute,
+			.amux = TV,
+			.gpio = 0x04000000,
 		},
 	},
 	[SAA7134_BOARD_AVERMEDIA_STUDIO_507] = {
diff -r 6f58a5d8c7c6 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Aug 29 09:01:54 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Aug 30 00:13:19 2009 +0200
@@ -514,8 +514,8 @@
 
 	switch (state->config->antenna_switch) {
 	case 0: break;
-	case 1:	dprintk("setting GPIO21 to 0 (TV antenna?)\n");
-		saa7134_set_gpio(dev, 21, 0);
+	case 1:	dprintk("setting GPIO26 to 0 (antenna voltage on)\n");
+		saa7134_set_gpio(dev, 26, 0);
 		break;
 	case 2: dprintk("setting GPIO21 to 1 (Radio antenna?)\n");
 		saa7134_set_gpio(dev, 21, 1);
@@ -531,8 +531,8 @@
 
 	switch (state->config->antenna_switch) {
 	case 0: break;
-	case 1: dprintk("setting GPIO21 to 1 (Radio antenna?)\n");
-		saa7134_set_gpio(dev, 21, 1);
+	case 1: dprintk("setting GPIO26 to 1 (antenna voltage off)\n");
+		saa7134_set_gpio(dev, 26, 1);
 		break;
 	case 2:	dprintk("setting GPIO21 to 0 (TV antenna?)\n");
 		saa7134_set_gpio(dev, 21, 0);
@@ -673,6 +673,7 @@
 	.if_freq       = TDA10046_FREQ_045,
 	.i2c_gate      = 0x4b,
 	.tuner_address = 0x61,
+	.antenna_switch = 1,
 	.request_firmware = philips_tda1004x_request_firmware
 };
 

--=-PjrdUodxv5zZlODMv+hR--

