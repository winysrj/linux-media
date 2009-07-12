Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:51977 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbZGLViK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 17:38:10 -0400
Subject: Re: Report: Compro Videomate Vista T750F
From: hermann pitton <hermann-pitton@arcor.de>
To: Samuel Rakitnican <semirocket@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <op.uwycxowt80yj81@localhost>
References: <op.uwycxowt80yj81@localhost>
Content-Type: multipart/mixed; boundary="=-A6LOqqLjL/tHYhJN3gwM"
Date: Sun, 12 Jul 2009 23:33:06 +0200
Message-Id: <1247434386.5152.28.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-A6LOqqLjL/tHYhJN3gwM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Samuel,

Am Sonntag, den 12.07.2009, 13:30 +0200 schrieb Samuel Rakitnican:
> As the card=139 (Compro Videomate T750)
> 
> DVB: Not working, not implemented
> Analog: Not working
> Audio In: ? (my T750F has additional connector ?)

if amux LINE2 doesn't work it is usually LINE1.
If both don't work, there is a external gpio controlled switch/mux chip.

Default is loop through for external audio in.
Means, if the saa7134 driver is unloaded, should be passed through to
audio out. If not, there is such a mux chip involved.

> Composite In: Working
> S-Video In: Working
> IR: Works with T300 codes and different keymap (needs to be implemented)
> 	(http://www.spinics.net/lists/linux-media/msg07705.html)

Should not be a problem anymore, since you have already unique codes for
all keys. 

It works with the same gpios, but generates different codes and the MCE
remote has more and different buttons. We likely need a new entry for
the T750F later and will have auto detection problems, because of the
same PCI subsystem. Detecting from eeprom does not work well with two
different remotes.

This is currently because the ir init happens already at hardware init
level 1, but epprom detection nedds working i2c at hardware level init
2. Unless ir init is not moved to hardware init 2, it needs to set the
card=number option to get the right keymap then.

> 
> Analog TV and XCeive:
> 
> Although John Newbigins reported that Analog is working in Apr 25 2007  
> with a patch. I did not try to implement this patch (by hand) because tree  
> changed big from that date, so it seems that this can not be done. At  
> least I can't.
> (http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017449.html)
> 
> With stock Slackware 12.2 it's showing a single channel (although tuner  
> does't work) that previously was selected in a windows application and  
> restarted.
> Thought I had to select in tvtime: Input configuration > Television  
> standard > PAL (Default was NTSC). And then Restart with new settings to  
> show up that channel. Otherwise it would still remain blue. XCeive is  
> recognized at 0xc2
> 
> With new v4l-dvb tree channel is not showing up any more no mather what I  
> do.
> New v4l also recognizes XCeive at 0xc2:
> tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
> xc2028 0-0061: creating new instance
> xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
> 
> 
> tvtime startup and shuting off:
> (Complete dump: http://pastebin.com/f376a8272)
> xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id  
> 0000000000000000.
> xc2028 1-0061: i2c output error: rc = -5 (should be 64)
> xc2028 1-0061: -5 returned from send
> xc2028 1-0061: Error -22 while loading base firmware
> (and then shutting off tvtime gives a line)
> xc2028 1-0061: Error on line 1141: -5

Hm, if I get it right, without using windows previously the XCeive at
0x61 is not found and then it is tried in vain to use the qt1010 at
0x62.

Also, after using windows gpio20 seems to be high.
Maybe that is the gpio to get the tuner out of reset.

Please try the attached patch as a shot into the dark.

> 
> eeproms T750 and T750F (maybe needed for automatic IR keymap selection)
> 
> T750
> saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 03 01 08 ff 00 89 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff 01 ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
> saa7133[0]: i2c eeprom 60: 30 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> T750F
> saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff 01 c6 ff 05 ff
-----------------------------------------------------------------^^
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
> saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 

We could use that 0xc6 byte for eeprom detection.
I don't know what it means here, but in this one 0xc4 is the qt1010
DVB-T tuner, 0x1e the demodulator and 0xc2 the analog tuner.

Cheers,
Hermann


--=-A6LOqqLjL/tHYhJN3gwM
Content-Disposition: inline; filename=compro-t750+t750f-gpio20-test.patch
Content-Type: text/x-patch; name=compro-t750+t750f-gpio20-test.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r d277b05c41fe linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jul 12 11:04:15 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jul 12 22:02:30 2009 +0200
@@ -4828,7 +4828,7 @@
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
-		.tuner_addr	= ADDR_UNSET,
+		.tuner_addr	= 0x61,
 		.radio_addr	= ADDR_UNSET,
 		.inputs = {{
 			.name   = name_tv,
@@ -6380,6 +6380,11 @@
 			msleep(10);
 			saa7134_set_gpio(dev, 18, 1);
 		break;
+		case SAA7134_BOARD_VIDEOMATE_T750:
+			saa7134_set_gpio(dev, 20, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 20, 1);
+		break;
 		}
 	return 0;
 	}

--=-A6LOqqLjL/tHYhJN3gwM--

