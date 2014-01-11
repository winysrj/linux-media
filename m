Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:48996 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaAKUKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 15:10:22 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ9004P86P8UB50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 11 Jan 2014 15:10:20 -0500 (EST)
Date: Sat, 11 Jan 2014 18:10:15 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 1/3] [media] em28xx-i2c: Fix error code for I2C error
 transfers
Message-id: <20140111181015.0bf93da2@samsung.com>
In-reply-to: <52D1393D.4000006@googlemail.com>
References: <1389342820-12605-1-git-send-email-m.chehab@samsung.com>
 <1389342820-12605-2-git-send-email-m.chehab@samsung.com>
 <52D1393D.4000006@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Jan 2014 13:29:49 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 10.01.2014 09:33, schrieb Mauro Carvalho Chehab:
> > Follow the error codes for I2C as described at Documentation/i2c/fault-codes.
> >
> > In the case of the I2C status register (0x05), this is mapped into:
> >
> > 	- ENXIO - when reg 05 returns 0x10
> > 	- ETIMEDOUT - when the device is not temporarily not responding
> > 		      (e. g. reg 05 returning something not 0x10 or 0x00)
> > 	- EIO - for generic I/O errors that don't fit into the above.
> >
> > In the specific case of 0-byte reads, used only during I2C device
> > probing, it keeps returning -ENODEV.
> >
> > TODO: return EBUSY when reg 05 returns 0x20 on em2874 and upper.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-i2c.c | 37 +++++++++++++++++++----------------
> >  1 file changed, 20 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> > index 342f35ad6070..76f956635bd9 100644
> > --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> > +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> > @@ -80,7 +80,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  		if (ret == 0x80 + len - 1)
> >  			return len;
> >  		if (ret == 0x94 + len - 1) {
> > -			return -ENODEV;
> > +			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> >  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> > @@ -90,7 +90,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  		msleep(5);
> >  	}
> >  	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> > -	return -EIO;
> > +	return -ETIMEDOUT;
> Hmmm... we don't know anything about these unknown 2800 errors, they
> probably do not exist at all.
> But as the warning talks about a timeout, yes, let's return ETIMEDOUT
> for now.
> 
> >  }
> >  
> >  /*
> > @@ -123,7 +123,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  		if (ret == 0x84 + len - 1)
> >  			break;
> >  		if (ret == 0x94 + len - 1) {
> > -			return -ENODEV;
> > +			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> >  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> Now that I'm looking at this function again, the whole last code section
> looks suspicious.
> Maybe it is really necessary to make a pseudo read from regs 0x00-0x03,
> but I wonder why we return the read data in this error case...
> OTOH, I've spend a very long time on these functions making lots of
> experiments, so I assume I had a good reason for this. ;)

Except for the return codes, better to not touch on em2800 I2C code. 
There are few em2800 devices in the market. I remember that someone
did some cleanup on that code in the past. It took couple years to be
noticed.

Thankfully, the original author of the em2800 driver fixed it.

> > @@ -199,7 +199,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		if (ret == 0) /* success */
> >  			return len;
> >  		if (ret == 0x10) {
> > -			return -ENODEV;
> > +			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> >  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> > @@ -213,9 +213,8 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		 * (even with high payload) ...
> >  		 */
> >  	}
> > -
> > -	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> > -	return -EIO;
> > +	em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n", addr, ret);
> > +	return -ETIMEDOUT;
> >  }
> if (ret == 0x02 || ret == 0x04) { /* you may want to narrow this down a
> bit more */
>     em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
> addr, ret);
>     return -ETIMEDOUT;
> 
> em28xx_warn("write to i2c device at 0x%x failed with unknown error
> (status=%i)\n", addr, ret);
> return -EIO;

Let's keep it as-is for now. -ETIMEDOUT is enough to detect that the
error happened at reg 05, with makes easier for anyone to increase the
timeout time and see if this fixes an issue related to timeout.

I considered adding there ret = 0x20 to return -EBUSY, but it seems
unlikely that this error will ever be detected.

> >  
> >  /*
> > @@ -245,7 +244,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  	 * bytes if we are on bus B AND there was no write attempt to the
> >  	 * specified slave address before AND no device is present at the
> >  	 * requested slave address.
> > -	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
> > +	 * Anyway, the next check will fail with -ENXIO in this case, so avoid
> >  	 * spamming the system log on device probing and do nothing here.
> >  	 */
> >  
> > @@ -259,10 +258,10 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  		return ret;
> >  	}
> >  	if (ret == 0x10)
> > -		return -ENODEV;
> > +		return -ENXIO;
> >  
> >  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
> > -	return -EIO;
> > +	return -ETIMEDOUT;
> The same here.
> 
> >  }
> >  
> >  /*
> > @@ -318,7 +317,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	if (!ret)
> >  		return len;
> >  	else if (ret > 0)
> > -		return -ENODEV;
> > +		return -ENXIO;
> >  
> >  	return ret;
> >  	/*
> > @@ -356,7 +355,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	 * bytes if we are on bus B AND there was no write attempt to the
> >  	 * specified slave address before AND no device is present at the
> >  	 * requested slave address.
> > -	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
> > +	 * Anyway, the next check will fail with -ENXIO in this case, so avoid
> >  	 * spamming the system log on device probing and do nothing here.
> >  	 */
> >  
> > @@ -369,7 +368,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	if (!ret)
> >  		return len;
> >  	else if (ret > 0)
> > -		return -ENODEV;
> > +		return -ENXIO;
> >  
> >  	return ret;
> >  	/*
> > @@ -410,7 +409,7 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
> >  		rc = em2800_i2c_check_for_device(dev, addr);
> >  	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
> >  		rc = em25xx_bus_B_check_for_device(dev, addr);
> > -	if (rc == -ENODEV) {
> > +	if (rc == -ENXIO) {
> >  		if (i2c_debug)
> >  			printk(" no device\n");
> >  	}
> > @@ -498,11 +497,15 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
> >  			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
> >  			       i == num - 1 ? "stop" : "nonstop",
> >  			       addr, msgs[i].len);
> > -		if (!msgs[i].len) { /* no len: check only for device presence */
> > +		if (!msgs[i].len) {
> > +			/*
> > +			 * no len: check only for device presence
> > +			 * This code is only called during device probe.
> > +			 */
> >  			rc = i2c_check_for_device(i2c_bus, addr);
> > -			if (rc == -ENODEV) {
> > +			if (rc == -ENXIO) {
> >  				rt_mutex_unlock(&dev->i2c_bus_lock);
> > -				return rc;
> > +				return -ENODEV;
> I assume this is a small mistake ? ;)

No. This is actually the only place where returning -ENODEV makes sense.
Messages with size 0 are used only during device probing.

> 
> >  			}
> >  		} else if (msgs[i].flags & I2C_M_RD) {
> >  			/* read bytes */
> 


-- 

Cheers,
Mauro
