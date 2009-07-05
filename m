Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:42460 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbZGEXDh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jul 2009 19:03:37 -0400
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
	tune anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: eric.paturage@orange.fr
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <200907050708.n6578BL04018@neptune.localwarp.net>
References: <200907050708.n6578BL04018@neptune.localwarp.net>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 01:03:40 +0200
Message-Id: <1246835020.16770.30.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eric,

Am Sonntag, den 05.07.2009, 09:08 +0200 schrieb eric.paturage@orange.fr:
> On  4 Jul, hermann pitton wrote:
> > 
> > 
> > Am Samstag, den 04.07.2009, 20:05 +0200 schrieb eric.paturage@orange.fr:
> >> On  4 Jul, hermann pitton wrote:
> >> > 
> >> > Hello,
> >> > 
> >> > Am Samstag, den 04.07.2009, 15:16 +0200 schrieb eric.paturage@orange.fr:
> >> >> hello 
> >> >> 
> >> >> I had my  Pinnacle PCTV 50i analog tv card working quite well for several years
> >> >> with linux . but since mid june it can not tune anymore when using the latest mercurial version 
> >> >> of the v4l2 drivers . 
> >> >> It is working fine up to the official V4l2 driver of 2.6.30 .
> >> >> 
> >> >> 
> >> >> here is an example of /var/log/messages with official v4l2 drivers of 2.6.27.4 (working well) :
> >> > 
> >> > [snip]
> >> >> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> >> TUNER: Unable to find symbol tda829x_probe()
> >> > ..^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >> > 
> >> >> tuner 1-004b: chip found @ 0x96 (saa7133[0])
> >> >> DVB: Unable to find symbol tda9887_attach()
> >> >> saa7133[0]: registered device video0 [v4l2]
> >> >> saa7133[0]: registered device vbi0
> >> >> saa7133[0]: registered device radio0
> >> >> saa7134 ALSA driver for DMA sound loaded
> >> >> IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> >> >> saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11 registered as card -1
> >> >> 
> >> >> Jul  2 09:12:43 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> >> >> Jul  2 09:19:14 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> >> >> Jul  2 09:20:16 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> >> >> Jul  2 09:20:26 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> >> >> 
> >> >> 
> >> >> 
> >> >> any idea what is going on ? 
> >> > 
> >> > out of some reason you don't have the tda8290 analog IF demodulator
> >> > module.
> >> > 
> >> > In theory this should be only possible, if you have selected
> >> > "Customize analog and hybrid tuner modules to build" and deselected
> >> > "TDA 8290/8295 + 8275(a)/18271 tuner combo".
> >> > 
> >> > I'm writing from a 2.6.29 and don't have such problems, but what makes
> >> > me wonder is, that you also don't have the tda9887. You don't need it
> >> > for that card, but I can't even deselect it at all.
> >> > 
> >> > With deselected tda8290 it gets loaded here instead, since within the
> >> > same address range.
> >> > 
> >> > Can you check with make xconfig/menuconfig, if the tda8290 is selected
> >> > on your build and watch if it is compiled at the beginning of "make"?
> >> > 
> >> > Cheers,
> >> > Hermann
> >> 
> >> > 
> >> Hi Hermann
> >> 
> >> i checked the xconfig menu , I unselected "Customize analog and hybrid tuner modules to build" (just to be sure)
> >> the module tda8290.ko gets built  and installed (i double checked ) .
> >> [root@neptune / ]# cd /lib/modules/2.6.29.4
> >> [root@neptune 2.6.29.4]# find . -name "tda829*"
> >> ./kernel/drivers/media/common/tuners/tda8290.ko
> >> [root@neptune 2.6.29.4]# uname -a
> >> Linux neptune.localwarp.net 2.6.29.4 #1 Mon Jun 1 11:01:38 CEST 2009 i686 AMD Athlon(tm) Processor unknown GNU/Linux
> >> [root@neptune 2.6.29.4]# find . -name "tda829*" -ls
> >>  36948   16 -rw-r--r--   1 root     root        15908 Jul  4 19:44 ./kernel/drivers/media/common/tuners/tda8290.ko
> >> 
> >> but it does not get loaded automatically . I tried to load it manualy with modprobe , but, even with that module
> >> loaded i still get :
> >> 
> >> tuner 1-004b: Tuner has no way to set tv freq
> >> tuner 1-004b: Tuner has no way to set tv freq
> >> tuner 1-004b: Tuner has no way to set tv freq
> >> 
> >> 
> >> cheers ,
> >> 
> > 
> > Hi Eric, 
> > 
> > hm, are you sure all old modules have been unloaded previously with
> > "make rmmod". saa7134-alsa might be in use by some mixer application und
> > you can't unload the tuner stuff anymore independently from saa7134,
> > like it was in all the prior years.
> > 
> > Do you also still see the unresolved symbols?
> > 
> > Then maybe try a reboot.
> > 
> > Cheers,
> > Hermann
> 
> 
> 
> Hi Hermann 
> 
> I rebooted everytime i recompiled v4l . 
> I also t unloaded saa7134 , tuner , saa7134_alsa 
> just after reboot . 
> 
> reloaded tda8290 , then tuner , then saa7134 .
> I do not get unresolved symbols then,
> but no picture either , and the tv application hangs . 

did not have time to think about it, since I'm sitting in some other
unrelated hardware troubles too, but that sounds strange.

Maybe our debugging for such cases is not good enough.

> I then tried this 2 cases  :
> -----------------------------------------
> case  1 : vanilla kernel 2.6.30.1
> (tv application works fine with saa7134),
> 
> bash-2.05b$ modinfo tuner
> <snip>
> depends:        i2c-core,tea5761,mt20xx,tuner-simple,tda9887,videodev,tea5767,xc5000,tuner-xc2028,tda8290,v4l2-common
> vermagic:       2.6.30.1 mod_unload K7
> 
> bash-2.05b$ modinfo tda8290
> <snip>
> depends:        tda18271,tda827x,i2c-core
> vermagic:       2.6.30.1 
> 
> 
> ----------------------------------------
> 
> case 2 
>  kernel 2.6.30.1 with mercurial v4l drivers
> tv application does not work : can not tune / no picture / hangs 
> 
>  modinfo tda8290
>  <snip>
> depends:        i2c-core
> vermagic:       2.6.30.1 SMP mod_unload K7
> 
> modinfo tuner
> <snip>
> depends:        i2c-core,videodev,,v4l2-common
> vermagic:       2.6.30.1 mod_unload K7
> ------------------------------------------------------------
> 
> there are a lot less modules dependencies with the v4l mercurial version . 
> is it normal ? or does it get built wrongly on my machine ? 

That should be all OK and I do have the same without any problems.

> my guess is that my problem is a build/configuration problem , not a bug wit saa7134 or tuner . 

Since you still get "tuning failed", it seems to be a problem with
tda8290 in the first place and then of course also with tda827x.

> for the moment i will stick  with vanilla 2.6.30.1  , and wait 
> for the latest gspca improvements (which i am after ) to filter
> into mainline kernel

I did fake your card on 2.6.29 to exclude to have "improvements" on
those cards I have, which also support DVB-T and DVB-S.

What was learned previously is, that a missing tda8290 module is
replaced by the tda9887, if present. No errors will show up and one even
gets some very decent type of picture ...

Without tda9887, one gets the "tuning failed" like you had it initially.

Why you still have it, now without any unresolved symbols, I don't know
yet. I doubt, that it could be caused by that you have tuner stuff
compiled into the kernel. (tda8290 module is loadable and no unresolved
symbols ?)

A successful tuning attempt faking your card, no auto detection of
course, does still look like that here.
(debug=1 for tuner, tda8290, tda827x and saa7134 i2c_debug)

tuner 3-004b: tv freq set to 196.25
tda829x 3-004b: setting tda829x to system B
saa7133[2]: i2c xfer: < 96 01 02 >
saa7133[2]: i2c xfer: < 96 02 00 >
saa7133[2]: i2c xfer: < 96 00 00 >
saa7133[2]: i2c xfer: < 96 01 82 >
saa7133[2]: i2c xfer: < 96 28 14 >
saa7133[2]: i2c xfer: < 96 0f 88 >
saa7133[2]: i2c xfer: < 96 05 04 >
saa7133[2]: i2c xfer: < 96 0d 47 >
saa7133[2]: i2c xfer: < 96 21 c0 >
tda827x: setting tda827x to system B
saa7133[2]: i2c xfer: < c0 00 32 c0 00 16 5a bb 1c 04 20 00 >
saa7133[2]: i2c xfer: < c0 90 ff e0 00 99 >
saa7133[2]: i2c xfer: < c0 a0 c0 >
saa7133[2]: i2c xfer: < c0 30 10 >
saa7133[2]: i2c xfer: < c1 =09 =32 >
tda827x: AGC2 gain is: 3
saa7133[2]: i2c xfer: < c0 60 3c >
saa7133[2]: i2c xfer: < c0 50 bf >
saa7133[2]: i2c xfer: < c0 80 28 >
saa7133[2]: i2c xfer: < c0 b0 01 >
saa7133[2]: i2c xfer: < c0 c0 19 >
saa7133[2]: i2c xfer: < 96 1b >
saa7133[2]: i2c xfer: < 97 =ff >
saa7133[2]: i2c xfer: < 96 1a >
saa7133[2]: i2c xfer: < 97 =00 >
saa7133[2]: i2c xfer: < 96 1d >
saa7133[2]: i2c xfer: < 97 =ff >
tda829x 3-004b: tda8290 is locked, AGC: 255
tda829x 3-004b: adjust gain, step 1. Agc: 255, ADC stat: 0, lock: 128
saa7133[2]: i2c xfer: < 96 28 64 >
saa7133[2]: i2c xfer: < 96 1d >
saa7133[2]: i2c xfer: < 97 =6d >
saa7133[2]: i2c xfer: < 96 1b >
saa7133[2]: i2c xfer: < 97 =ff >
saa7133[2]: i2c xfer: < 96 21 00 >
saa7133[2]: i2c xfer: < 96 0f 81 >

I have no picture, because of the rare/strange vmux = 4 for TV on your card,
but it all looks fine.

Ideas are welcome, and Eric, maybe provide more details for debugging on
what you currently have. Related "dmesg", kernel .config, "lsmod".

Cheers,
Hermann






 



