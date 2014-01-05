Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:24514 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAENUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 08:20:07 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYX00K5QJPI2P50@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 05 Jan 2014 08:20:06 -0500 (EST)
Date: Sun, 05 Jan 2014 11:20:02 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 12/22] [media] em28xx: properly implement AC97 wait code
Message-id: <20140105112002.226567f3@samsung.com>
In-reply-to: <52C93FCD.2010507@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-13-git-send-email-m.chehab@samsung.com>
 <52C93FCD.2010507@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 12:19:41 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > Instead of assuming that msleep() is precise, use a jiffies
> > based code to wait for AC97 to be available.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-core.c | 7 +++++--
> >  drivers/media/usb/em28xx/em28xx.h      | 5 ++++-
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > index 818248d3fd28..36b2f1ab4474 100644
> > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > @@ -23,6 +23,7 @@
> >   */
> >  
> >  #include <linux/init.h>
> > +#include <linux/jiffies.h>
> >  #include <linux/list.h>
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
> > @@ -254,16 +255,18 @@ EXPORT_SYMBOL_GPL(em28xx_toggle_reg_bits);
> >   */
> >  static int em28xx_is_ac97_ready(struct em28xx *dev)
> >  {
> > -	int ret, i;
> > +	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_AC97_XFER_TIMEOUT);
> > +	int ret;
> >  
> >  	/* Wait up to 50 ms for AC97 command to complete */
> > -	for (i = 0; i < 10; i++, msleep(5)) {
> > +	while (time_is_after_jiffies(timeout)) {
> time_is_before_jiffies(timeout)
> 
> >  		ret = em28xx_read_reg(dev, EM28XX_R43_AC97BUSY);
> >  		if (ret < 0)
> >  			return ret;
> >  
> >  		if (!(ret & 0x01))
> >  			return 0;
> > +		msleep (5);
> >  	}
> >  
> >  	em28xx_warn("AC97 command still being executed: not handled properly!\n");
> > diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> > index 9d6f43e4681f..ac79501f5d9f 100644
> > --- a/drivers/media/usb/em28xx/em28xx.h
> > +++ b/drivers/media/usb/em28xx/em28xx.h
> > @@ -182,9 +182,12 @@
> >  
> >  #define EM28XX_INTERLACED_DEFAULT 1
> >  
> > -/* time in msecs to wait for i2c writes to finish */
> > +/* time in msecs to wait for i2c xfers to finish */
> >  #define EM2800_I2C_XFER_TIMEOUT		20
> >  
> > +/* time in msecs to wait for AC97 xfers to finish */
> > +#define EM2800_AC97_XFER_TIMEOUT	100
> > +
> I applies to all chips supporting AC97 audio, so call it
> EM28XX_AC97_XFER_TIMEOUT.

Ok.

> Why did you increase the timeout from 50ms to 100ms ?
> 50ms already seems to be a lot !
> 
> IIRC, the problem you are trying to fix is that the chip sometimes is
> not yet ready when probing.

Yes. I was also hoping that would make the code more reliable, as
there are some issues with audio here (with usb 3.0 and with xawtv
when trying to maximize the window).

> But that should be solved with a single sleep before accessing the AC97
> chip for the first time instead ?!

Maybe. I'll try it.

> >  /* max. number of button state polling addresses */
> >  #define EM28XX_NUM_BUTTON_ADDRESSES_MAX		5
> >  
> 


-- 

Cheers,
Mauro
