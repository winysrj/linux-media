Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59917 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933444AbeCPQDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 12:03:15 -0400
Date: Fri, 16 Mar 2018 13:03:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: I2C media binding model
Message-ID: <20180316130309.1f89476f@vento.lan>
In-Reply-To: <30147ff6-d0c2-a337-86d2-75fa5454c86c@gmail.com>
References: <20180307122547.6c38f600@vento.lan>
        <30147ff6-d0c2-a337-86d2-75fa5454c86c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Mar 2018 23:50:31 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> Hi,
> 
> As the new i2c binding helper was introduced,
> I am now re-writing the following patches to use new helper functions.
> 
> > 5. Jan,16 2015: [v2,1/2] dvb: tua6034: add a new driver for Infineon tua6034 tuner
> >         http://patchwork.linuxtv.org/patch/27927 
> > 6. Jan,16 2015: [v2,2/2] dvb-usb-friio: split and merge into dvb-usbv2-gl861
> >         http://patchwork.linuxtv.org/patch/27928   

Thank you!

> But I noticed that the tua6034 (used in Friio devices) can be supported
> by "tuner-simple" driver.
> Since "tuner-simple" is not an i2c driver,
> I am wondering if
> 1) I should use/modify "tuner-simple" driver without adding new one
>     but with one more dvb_attach un-replaced, or,
> 2) I should make a new i2c driver as my previous patch #27927
>    but with the duplicated function with tuner-simple.
> 
> Re-writing tuner-simple into a new i2c driver does not seem to be
> an option to me, because that would affect lots of dvb/v4l drivers,
> and I cannot test them.

If the driver is pure DVB, then maybe the best would be to add support
for it at:

	./drivers/media/dvb-frontends/dvb-pll.c

It basically does the same as a "tuner-simple" driver, but without all
the complexity required to handle V4L2 calls.

It should be simple to convert it to also accept the new I2C binding
and use the new I2C binding at the caller drivers.

> In addition, I also intend to re-write "earth-pt1" driver in the future
> by decomposing the current monolithic module into component drivers:
>   bridge: earth-pt1 (cut down one)
>   demod:  tc90522
>   TERR-tuner: tda6654 (NEW?)
>   SAT-tuner:  qm1d1b0004 (NEW)

Sounds nice!

> There exists a "tda665x" tuner driver (in dvb-frontends/),
> but it does not use the new i2c binding helpers either,
> and it seems that it can be supported by "tuner-simple" as well.
> So the similar situation here, though the tda665x driver is
> used only by "mantis" currently.

It it is just a PLL, then it could also be converted to use
dvb-pll.h at the Mantis driver, and we could get rid of the
driver.

Regards,
Mauro
