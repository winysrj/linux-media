Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:46073 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaAKU1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 15:27:41 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ9006KF7I5C350@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 11 Jan 2014 15:27:41 -0500 (EST)
Date: Sat, 11 Jan 2014 18:27:37 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 3/3] [media] em28xx: add timeout debug information if
 i2c_debug enabled
Message-id: <20140111182737.4cf40c81@samsung.com>
In-reply-to: <52D143BE.3090607@googlemail.com>
References: <1389342820-12605-1-git-send-email-m.chehab@samsung.com>
 <1389342820-12605-4-git-send-email-m.chehab@samsung.com>
 <52D143BE.3090607@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Jan 2014 14:14:38 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 10.01.2014 09:33, schrieb Mauro Carvalho Chehab:
> > If i2c_debug is enabled, we splicitly want to know when a
> > device fails with timeout.
> >
> > If i2c_debug==2, this is already provided, for each I2C transfer
> > that fails.
> >
> > However, most of the time, we don't need to go that far. We just
> > want to know that I2C transfers fail.
> >
> > So, add such errors for normal (ret == 0x10) I2C aborted timeouts.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-i2c.c | 27 ++++++++++++++++++++++++---
> >  1 file changed, 24 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> > index e8eb83160d36..7e1724076ac4 100644
> > --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> > +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> > @@ -80,6 +80,9 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  		if (ret == 0x80 + len - 1)
> >  			return len;
> >  		if (ret == 0x94 + len - 1) {
> > +			if (i2c_debug == 1)
> > +				em28xx_warn("R05 returned 0x%02x: I2C timeout",
> > +					    ret);
> >  			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> > @@ -124,6 +127,9 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  		if (ret == 0x84 + len - 1)
> >  			break;
> >  		if (ret == 0x94 + len - 1) {
> > +			if (i2c_debug == 1)
> > +				em28xx_warn("R05 returned 0x%02x: I2C timeout",
> > +					    ret);
> >  			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> > @@ -203,6 +209,9 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		if (ret == 0) /* success */
> >  			return len;
> >  		if (ret == 0x10) {
> > +			if (i2c_debug == 1)
> > +				em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> > +					    addr);
> >  			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> > @@ -263,8 +272,12 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  			    ret);
> >  		return ret;
> >  	}
> > -	if (ret == 0x10)
> > +	if (ret == 0x10) {
> > +		if (i2c_debug == 1)
> > +			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> > +				    addr);
> >  		return -ENXIO;
> > +	}
> >  
> >  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
> >  	return -ETIMEDOUT;
> > @@ -322,8 +335,12 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	 */
> >  	if (!ret)
> >  		return len;
> > -	else if (ret > 0)
> > +	else if (ret > 0) {
> > +		if (i2c_debug == 1)
> > +			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
> > +				    ret);
> >  		return -ENXIO;
> > +	}
> >  
> >  	return ret;
> >  	/*
> > @@ -373,8 +390,12 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	 */
> >  	if (!ret)
> >  		return len;
> > -	else if (ret > 0)
> > +	else if (ret > 0) {
> > +		if (i2c_debug == 1)
> > +			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
> > +				    ret);
> >  		return -ENXIO;
> > +	}
> >  
> >  	return ret;
> >  	/*
> 
> The error description should be "I2C ACK error".

Ok.

> 
> You are using (i2c_debug == 1) checks here, which should either be
> changed to (i2c_debug > 0) in case of 3 debug levels.

Actually, no. If you use i2c_debug = 2, you can't print anything on those
routines, as otherwise it will be printed on a line that it would supposed
to be a KERNEL_CONT message.

> 
> 


-- 

Cheers,
Mauro
