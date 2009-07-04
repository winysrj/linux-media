Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.18]:7803 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZGDSF7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 14:05:59 -0400
Message-Id: <200907041805.n64I5xQ04085@neptune.localwarp.net>
Date: Sat, 4 Jul 2009 20:05:38 +0200 (CEST)
From: eric.paturage@orange.fr
Reply-To: eric.paturage@orange.fr
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
 tune anymore
To: hermann-pitton@arcor.de
cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On  4 Jul, hermann pitton wrote:
> 
> Hello,
> 
> Am Samstag, den 04.07.2009, 15:16 +0200 schrieb eric.paturage@orange.fr:
>> hello 
>> 
>> I had my  Pinnacle PCTV 50i analog tv card working quite well for several years
>> with linux . but since mid june it can not tune anymore when using the latest mercurial version 
>> of the v4l2 drivers . 
>> It is working fine up to the official V4l2 driver of 2.6.30 .
>> 
>> 
>> here is an example of /var/log/messages with official v4l2 drivers of 2.6.27.4 (working well) :
> 
> [snip]
>> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> TUNER: Unable to find symbol tda829x_probe()
> ..^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
>> tuner 1-004b: chip found @ 0x96 (saa7133[0])
>> DVB: Unable to find symbol tda9887_attach()
>> saa7133[0]: registered device video0 [v4l2]
>> saa7133[0]: registered device vbi0
>> saa7133[0]: registered device radio0
>> saa7134 ALSA driver for DMA sound loaded
>> IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
>> saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11 registered as card -1
>> 
>> Jul  2 09:12:43 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
>> Jul  2 09:19:14 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
>> Jul  2 09:20:16 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
>> Jul  2 09:20:26 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
>> 
>> 
>> 
>> any idea what is going on ? 
> 
> out of some reason you don't have the tda8290 analog IF demodulator
> module.
> 
> In theory this should be only possible, if you have selected
> "Customize analog and hybrid tuner modules to build" and deselected
> "TDA 8290/8295 + 8275(a)/18271 tuner combo".
> 
> I'm writing from a 2.6.29 and don't have such problems, but what makes
> me wonder is, that you also don't have the tda9887. You don't need it
> for that card, but I can't even deselect it at all.
> 
> With deselected tda8290 it gets loaded here instead, since within the
> same address range.
> 
> Can you check with make xconfig/menuconfig, if the tda8290 is selected
> on your build and watch if it is compiled at the beginning of "make"?
> 
> Cheers,
> Hermann

> 
Hi Hermann

i checked the xconfig menu , I unselected "Customize analog and hybrid tuner modules to build" (just to be sure)
the module tda8290.ko gets built  and installed (i double checked ) .
[root@neptune / ]# cd /lib/modules/2.6.29.4
[root@neptune 2.6.29.4]# find . -name "tda829*"
./kernel/drivers/media/common/tuners/tda8290.ko
[root@neptune 2.6.29.4]# uname -a
Linux neptune.localwarp.net 2.6.29.4 #1 Mon Jun 1 11:01:38 CEST 2009 i686 AMD Athlon(tm) Processor unknown GNU/Linux
[root@neptune 2.6.29.4]# find . -name "tda829*" -ls
 36948   16 -rw-r--r--   1 root     root        15908 Jul  4 19:44 ./kernel/drivers/media/common/tuners/tda8290.ko

but it does not get loaded automatically . I tried to load it manualy with modprobe , but, even with that module loaded 
i still get :

tuner 1-004b: Tuner has no way to set tv freq
tuner 1-004b: Tuner has no way to set tv freq
tuner 1-004b: Tuner has no way to set tv freq


cheers ,


