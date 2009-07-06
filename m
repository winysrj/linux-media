Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:45195 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbZGFWux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 18:50:53 -0400
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
	tune anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: eric.paturage@orange.fr
Cc: linux-media@vger.kernel.org
In-Reply-To: <200907062148.n66Lm5m04279@neptune.localwarp.net>
References: <200907062148.n66Lm5m04279@neptune.localwarp.net>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 00:48:46 +0200
Message-Id: <1246920526.8164.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 06.07.2009, 23:47 +0200 schrieb eric.paturage@orange.fr:
> > 
> > I did fake your card on 2.6.29 to exclude to have "improvements" on
> > those cards I have, which also support DVB-T and DVB-S.
> > 
> > What was learned previously is, that a missing tda8290 module is
> > replaced by the tda9887, if present. No errors will show up and one even
> > gets some very decent type of picture ...
> > 
> > Without tda9887, one gets the "tuning failed" like you had it initially.
> > 
> > Why you still have it, now without any unresolved symbols, I don't know
> > yet. I doubt, that it could be caused by that you have tuner stuff
> > compiled into the kernel. (tda8290 module is loadable and no unresolved
> > symbols ?)
> > 
> > A successful tuning attempt faking your card, no auto detection of
> > course, does still look like that here.
> > (debug=1 for tuner, tda8290, tda827x and saa7134 i2c_debug)
> > 
> > tuner 3-004b: tv freq set to 196.25
> > tda829x 3-004b: setting tda829x to system B
> > saa7133[2]: i2c xfer: < 96 01 02 >
> > saa7133[2]: i2c xfer: < 96 02 00 >
> > saa7133[2]: i2c xfer: < 96 00 00 >
> > saa7133[2]: i2c xfer: < 96 01 82 >
> > saa7133[2]: i2c xfer: < 96 28 14 >
> > saa7133[2]: i2c xfer: < 96 0f 88 >
> > saa7133[2]: i2c xfer: < 96 05 04 >
> > saa7133[2]: i2c xfer: < 96 0d 47 >
> > saa7133[2]: i2c xfer: < 96 21 c0 >
> > tda827x: setting tda827x to system B
> > saa7133[2]: i2c xfer: < c0 00 32 c0 00 16 5a bb 1c 04 20 00 >
> > saa7133[2]: i2c xfer: < c0 90 ff e0 00 99 >
> > saa7133[2]: i2c xfer: < c0 a0 c0 >
> > saa7133[2]: i2c xfer: < c0 30 10 >
> > saa7133[2]: i2c xfer: < c1 =09 =32 >
> > tda827x: AGC2 gain is: 3
> > saa7133[2]: i2c xfer: < c0 60 3c >
> > saa7133[2]: i2c xfer: < c0 50 bf >
> > saa7133[2]: i2c xfer: < c0 80 28 >
> > saa7133[2]: i2c xfer: < c0 b0 01 >
> > saa7133[2]: i2c xfer: < c0 c0 19 >
> > saa7133[2]: i2c xfer: < 96 1b >
> > saa7133[2]: i2c xfer: < 97 =ff >
> > saa7133[2]: i2c xfer: < 96 1a >
> > saa7133[2]: i2c xfer: < 97 =00 >
> > saa7133[2]: i2c xfer: < 96 1d >
> > saa7133[2]: i2c xfer: < 97 =ff >
> > tda829x 3-004b: tda8290 is locked, AGC: 255
> > tda829x 3-004b: adjust gain, step 1. Agc: 255, ADC stat: 0, lock: 128
> > saa7133[2]: i2c xfer: < 96 28 64 >
> > saa7133[2]: i2c xfer: < 96 1d >
> > saa7133[2]: i2c xfer: < 97 =6d >
> > saa7133[2]: i2c xfer: < 96 1b >
> > saa7133[2]: i2c xfer: < 97 =ff >
> > saa7133[2]: i2c xfer: < 96 21 00 >
> > saa7133[2]: i2c xfer: < 96 0f 81 >
> > 
> > I have no picture, because of the rare/strange vmux = 4 for TV on your card,
> > but it all looks fine.
> > 
> > Ideas are welcome, and Eric, maybe provide more details for debugging on
> > what you currently have. Related "dmesg", kernel .config, "lsmod".
> > 
> > Cheers,
> > Hermann
> > 
> 
> Hi Hermann 
> 
> 
> i put the following debug in modprobe.conf :
> options saa7134 pinnacle_remote=1
> options saa7134 secam=L   
> options saa7134 irq_debug=1 gpio_tracking=1 core_debug=1 i2c_debug=1 ts_debug=1 
> video_debug=1 
> options tuner secam=l debug=1 show_i2c=1
> options  tda8290 debug=1
> options  tda827x debug=1
> 
> i attach /var/log/messages (when doing modprobe saa7134 ) 
> dmesg (when loading saa7134)   
> dmesg (when using xawtv and attempting to tune ) 
> .config from kernel 
> 
> there seems to be some i2c  errors when loading saa7134  (??)
> tda8290  does not get automaticaly loaded , 
> 
> if it is loaded manually once (and unloaded) 
> errors about missing symbols disappear .
> 
> 
> result with applications are :
> xawtv : no picture (black) , no tuning (apparently )
> xdtv : hangs badly (cannot be killed by kill -9 )  no picture (black) , 
> svv : no picture (black) .
> all the pictures i get are black ( no snow , as in between channels ) 
> 
> (all those apps work nicely with the vanilla kernel )
> 
> Regards 
> 

Hi Eric,

on a first short look only at lsmod and your kernel .config,
I can see tda8290 and tda827x are not loaded and you have nothing
conflicting in your kernel .config.

Must be a bug in the build system and I need to get a recent 2.6.30 I
guess, since else not reproducible.

Did you try to load the tda827x manually too?
If it is not successfully tuned it shows that black.

Try to load all tuner modules before the saa7134 and on a second look
try also to disable the IR for now.

Cheers,
Hermann








