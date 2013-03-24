Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab3CXOCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 10:02:19 -0400
Date: Sun, 24 Mar 2013 11:02:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] em28xx: add support for em25xx i2c bus B
 read/write/check device operations
Message-ID: <20130324110213.41564d09@redhat.com>
In-Reply-To: <514EF754.6080709@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
	<1364059632-29070-2-git-send-email-fschaefer.oss@googlemail.com>
	<20130324083846.199bdda6@redhat.com>
	<514EF754.6080709@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 24 Mar 2013 13:53:40 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 24.03.2013 12:38, schrieb Mauro Carvalho Chehab:
> > Em Sat, 23 Mar 2013 18:27:08 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> The webcam "SpeedLink VAD Laplace" (em2765 + ov2640) uses a special algorithm
> >> for i2c communication with the sensor, which is connected to a second i2c bus.
> >>
> >> We don't know yet how to find out which devices support/use it.
> >> It's very likely used by all em25xx and em276x+ bridges.
> >> Tests with other em28xx chips (em2820, em2882/em2883) show, that this
> >> algorithm always succeeds there although no slave device is connected.
> >>
> >> The algorithm likely also works for real i2c client devices (OV2640 uses SCCB),
> >> because the Windows driver seems to use it for probing Samsung and Kodak
> >> sensors.
> >>
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> ---
> >>  drivers/media/usb/em28xx/em28xx-cards.c |    8 +-
> >>  drivers/media/usb/em28xx/em28xx-i2c.c   |  229 +++++++++++++++++++++++++------
> >>  drivers/media/usb/em28xx/em28xx.h       |   10 +-
> >>  3 Dateien geändert, 205 Zeilen hinzugefügt(+), 42 Zeilen entfernt(-)
> >>
> >> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> >> index cb7cdd3..033b6cb 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> >> @@ -3139,15 +3139,19 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >>  	rt_mutex_init(&dev->i2c_bus_lock);
> >>  
> >>  	/* register i2c bus 0 */
> >> -	retval = em28xx_i2c_register(dev, 0);
> >> +	if (dev->board.is_em2800)
> >> +		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM2800);
> >> +	else
> >> +		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
> >>  	if (retval < 0) {
> >>  		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
> >>  			__func__, retval);
> >>  		goto unregister_dev;
> >>  	}
> >>  
> >> +	/* register i2c bus 1 */
> >>  	if (dev->def_i2c_bus) {
> >> -		retval = em28xx_i2c_register(dev, 1);
> >> +		retval = em28xx_i2c_register(dev, 1, EM28XX_I2C_ALGO_EM28XX);
> >>  		if (retval < 0) {
> >>  			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
> >>  				__func__, retval);
> >> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> >> index 9e2fa41..ab14ac3 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> >> @@ -5,6 +5,7 @@
> >>  		      Markus Rechberger <mrechberger@gmail.com>
> >>  		      Mauro Carvalho Chehab <mchehab@infradead.org>
> >>  		      Sascha Sommer <saschasommer@freenet.de>
> >> +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
> >>  
> >>     This program is free software; you can redistribute it and/or modify
> >>     it under the terms of the GNU General Public License as published by
> >> @@ -274,6 +275,176 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
> >>  }
> >>  
> >>  /*
> >> + * em25xx_bus_B_send_bytes
> >> + * write bytes to the i2c device
> >> + */
> >> +static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >> +				   u16 len)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (len < 1 || len > 64)
> >> +		return -EOPNOTSUPP;
> >> +	/* NOTE: limited by the USB ctrl message constraints
> >> +	 * Zero length reads always succeed, even if no device is connected */
> >> +
> >> +	/* Set register and write value */
> >> +	ret = dev->em28xx_write_regs_req(dev, 0x06, addr, buf, len);
> >> +	/* NOTE:
> >> +	 * 0 byte writes always succeed, even if no device is connected. */
> > You already noticed it on the previous note.
> 
> Yes. ;)

Well, there's no need to repeat the same thing twice at the same function ;)

> >
> >> +	if (ret != len) {
> >> +		if (ret < 0) {
> >> +			em28xx_warn("writing to i2c device at 0x%x failed "
> >> +				    "(error=%i)\n", addr, ret);
> >> +			return ret;
> >> +		} else {
> >> +			em28xx_warn("%i bytes write to i2c device at 0x%x "
> >> +				    "requested, but %i bytes written\n",
> >> +				    len, addr, ret);
> >> +			return -EIO;
> >> +		}
> >> +	}
> >> +	/* Check success */
> >> +	ret = dev->em28xx_read_reg_req(dev, 0x08, 0x0000);
> >> +	/* NOTE: the only error we've seen so far is
> >> +	 * 0x01 when the slave device is not present */
> >> +	if (ret == 0x00) {
> > 	Please simplify. just use:
> > 		if (!ret)
> 
> I would like to keep it as is because I think it better expresses the
> purposes of this check. I also used 0x00 instead of 0 on purpose.

Why do you think it better expresses it? It is just a more verbose way
of doing the same thing. 

If you want to better express, then add a comment:
	/* 
	 * Reg 08 value 0 means that the operation succeeded.
	 * different values indicate that the I2C device was not found.
	 */
	if (!ret)
		return len;

> ret is a mixed value which is negative on errors and contains the data
> bytes (0x00 to 0xff) on success.
> Ok, in this specific case all other values are covered with a single
> (ret > 0) check, but take a look at the comment and the em28xx-algo
> functions where we check for 0x10, too.
> 
> >
> >> +		return len;
> >> +	} else if (ret > 0) {
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	return ret;
> >> +	/* NOTE: With chips which do not support this operation,
> >> +	 * it seems to succeed ALWAYS ! (even if no device connected) */
> > Sorry, but I didn't get what you're trying to explain here. What are those
> > em25xx chips that don't support this operation?
> 
> Hmm... I don't know how to explain it better...
> The thing is, that this algo _seems_ to work also (at least with some)
> chips which actually don't support it (even if they don't provide a
> second i2c bus).

Again, what do you mean by "chips which actually don't support it"?

Are you talking about some versions of chips with this ID?
+	CHIP_ID_EM2765 = 54,

Or about something else? How those can be distinguished from the others
that don't support it? Or they can't be distinguished?

> >
> >> +}
> >> +
> >> +/*
> >> + * em25xx_bus_B_recv_bytes
> >> + * read bytes from the i2c device
> >> + */
> >> +static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >> +				   u16 len)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (len < 1 || len > 64)
> >> +		return -EOPNOTSUPP;
> >> +	/* NOTE: limited by the USB ctrl message constraints
> >> +	 * Zero length reads always succeed, even if no device is connected */
> > You already explained about the zero length before.
> 
> Yepp, but in another function. ;)
> 
> >> +
> >> +	/* Read value */
> >> +	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
> >> +	/* NOTE:
> >> +	 * 0 byte reads always succeed, even if no device is connected. */
> > You're insistent on that, won't you? ;)
> 
> Yeah, I like comments and I think there should be much more ! :)
> 
> But in this case I don't want to be insistent, I just want to make sure
> that important issues are expalined at all relevant code places.
> The alternative would be to reference comments at other places, which
> IMHO doesn't work well.

Well, you don't need to explain the same thing twice at the same function ;)
> 
> Regards,
> Frank
> 


-- 

Cheers,
Mauro
