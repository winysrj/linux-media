Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:37481 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZGDQ6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 12:58:06 -0400
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
	tune anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: eric.paturage@orange.fr
Cc: linux-media@vger.kernel.org
In-Reply-To: <200907041316.n64DGiQ04366@neptune.localwarp.net>
References: <200907041316.n64DGiQ04366@neptune.localwarp.net>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 18:48:44 +0200
Message-Id: <1246726124.3947.19.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Am Samstag, den 04.07.2009, 15:16 +0200 schrieb eric.paturage@orange.fr:
> hello 
> 
> I had my  Pinnacle PCTV 50i analog tv card working quite well for several years
> with linux . but since mid june it can not tune anymore when using the latest mercurial version 
> of the v4l2 drivers . 
> It is working fine up to the official V4l2 driver of 2.6.30 .
> 
> 
> here is an example of /var/log/messages with official v4l2 drivers of 2.6.27.4 (working well) :

[snip]
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> TUNER: Unable to find symbol tda829x_probe()
..^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> tuner 1-004b: chip found @ 0x96 (saa7133[0])
> DVB: Unable to find symbol tda9887_attach()
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> saa7134 ALSA driver for DMA sound loaded
> IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11 registered as card -1
> 
> Jul  2 09:12:43 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> Jul  2 09:19:14 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> Jul  2 09:20:16 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> Jul  2 09:20:26 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> 
> 
> 
> any idea what is going on ? 

out of some reason you don't have the tda8290 analog IF demodulator
module.

In theory this should be only possible, if you have selected
"Customize analog and hybrid tuner modules to build" and deselected
"TDA 8290/8295 + 8275(a)/18271 tuner combo".

I'm writing from a 2.6.29 and don't have such problems, but what makes
me wonder is, that you also don't have the tda9887. You don't need it
for that card, but I can't even deselect it at all.

With deselected tda8290 it gets loaded here instead, since within the
same address range.

Can you check with make xconfig/menuconfig, if the tda8290 is selected
on your build and watch if it is compiled at the beginning of "make"?

Cheers,
Hermann






