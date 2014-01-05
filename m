Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaAEPo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 10:44:29 -0500
Date: Sun, 5 Jan 2014 13:44:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 12/22] [media] em28xx: properly implement AC97 wait
 code
Message-ID: <20140105134421.7f5d344f@infradead.org>
In-Reply-To: <20140105112002.226567f3@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
	<1388832951-11195-13-git-send-email-m.chehab@samsung.com>
	<52C93FCD.2010507@googlemail.com>
	<20140105112002.226567f3@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 11:20:02 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 05 Jan 2014 12:19:41 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> 
> > Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > > Instead of assuming that msleep() is precise, use a jiffies
> > > based code to wait for AC97 to be available.
> > >
> > > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > > ---
> > >  drivers/media/usb/em28xx/em28xx-core.c | 7 +++++--
> > >  drivers/media/usb/em28xx/em28xx.h      | 5 ++++-
> > >  2 files changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > > index 818248d3fd28..36b2f1ab4474 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > > @@ -23,6 +23,7 @@
> > >   */
> > >  
> > >  #include <linux/init.h>
> > > +#include <linux/jiffies.h>
> > >  #include <linux/list.h>
> > >  #include <linux/module.h>
> > >  #include <linux/slab.h>
> > > @@ -254,16 +255,18 @@ EXPORT_SYMBOL_GPL(em28xx_toggle_reg_bits);
> > >   */
> > >  static int em28xx_is_ac97_ready(struct em28xx *dev)
> > >  {
> > > -	int ret, i;
> > > +	unsigned long timeout = jiffies + msecs_to_jiffies(EM2800_AC97_XFER_TIMEOUT);
> > > +	int ret;
> > >  
> > >  	/* Wait up to 50 ms for AC97 command to complete */
> > > -	for (i = 0; i < 10; i++, msleep(5)) {
> > > +	while (time_is_after_jiffies(timeout)) {
> > time_is_before_jiffies(timeout)
> > 
> > >  		ret = em28xx_read_reg(dev, EM28XX_R43_AC97BUSY);
> > >  		if (ret < 0)
> > >  			return ret;
> > >  
> > >  		if (!(ret & 0x01))
> > >  			return 0;
> > > +		msleep (5);
> > >  	}
> > >  
> > >  	em28xx_warn("AC97 command still being executed: not handled properly!\n");
> > > diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> > > index 9d6f43e4681f..ac79501f5d9f 100644
> > > --- a/drivers/media/usb/em28xx/em28xx.h
> > > +++ b/drivers/media/usb/em28xx/em28xx.h
> > > @@ -182,9 +182,12 @@
> > >  
> > >  #define EM28XX_INTERLACED_DEFAULT 1
> > >  
> > > -/* time in msecs to wait for i2c writes to finish */
> > > +/* time in msecs to wait for i2c xfers to finish */
> > >  #define EM2800_I2C_XFER_TIMEOUT		20
> > >  
> > > +/* time in msecs to wait for AC97 xfers to finish */
> > > +#define EM2800_AC97_XFER_TIMEOUT	100
> > > +
> > I applies to all chips supporting AC97 audio, so call it
> > EM28XX_AC97_XFER_TIMEOUT.
> 
> Ok.
> 
> > Why did you increase the timeout from 50ms to 100ms ?
> > 50ms already seems to be a lot !

Err... actually, the code is currently waiting for up to 100ms.

The thing is that msleep(5) will wait for a minimum time of 1/CONFIG_HZ.

If CONFIG_HZ is equal to 100 (the minimum), that means that it will
wait for 10 ms. So,

for (i = 0; i < 10; i++, msleep(5)) {
	...
}

Will actually wait up to 10*10ms = 100ms at the worse case. 

The patch is just keeping the maximum timeout equal for all setups, no
matter what's set at CONFIG_HZ.

Arbitrarily changing it to a lower value seems risky, as it may cause
regressions on some boards.

So, I'll just rename the define here, preserving 100ms as timeout.

Regards,
Mauro
