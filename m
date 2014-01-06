Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:36663 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaAFKhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 05:37:48 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYZ00BE76UZGB40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Jan 2014 05:37:47 -0500 (EST)
Date: Mon, 06 Jan 2014 08:37:41 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 18/22] [media] em28xx: don't return -ENODEV for I2C xfer
 errors
Message-id: <20140106083741.7f0c4308@samsung.com>
In-reply-to: <52C9C575.5030804@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-19-git-send-email-m.chehab@samsung.com>
 <52C9C575.5030804@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 21:49:57 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > -ENODEV reports a permanent condition where a device is not found,
> > and used only during device probing or device removal, as stated
> > at  the V4L2 spec:
> > 	http://linuxtv.org/downloads/v4l-dvb-apis/gen_errors.html
> >
> > Except during device detection, this is not the case of I2C
> > transfer timeout errors.
> >
> > So, change them to return -EREMOTEIO instead.
> Mauro,
> 
> make a step back and think about this again.
> What are you doing here ?
> 
> You noticed that your HVR-950 device is working unstable for an unknown
> reason.
> Your specific device seems to be the only one, nobody could reproduce
> your issues so far and with the HVR-900 for example (which is nearly
> identical) we don't see any errors.
> 
> Then you started playing with the em28xx i2c transfer functions and
> noticed, that if you repeat the same i2c operations again and again, you
> finally have luck and it succeeds.
> From that you draw the conclusion, that i2c status 0x10 can't be a
> permanent error and hence 0x10 can't be -ENODEV.
> But that's wrong. Your problems could also be caused by
> sporadic/temporary circuit failures (such as loose contacts or whatever).
> Hardware errors can always happen and they are no reason for not using
> -ENODEV.

There is: it violates both V4L2 API and I2C error fault code. -ENODEV should
only be used on device probing time, according with
Documentation/i2c/fault-codes [1]:
	ENODEV
		Returned by driver probe() methods. 

[1] V4L2 spec also allows using it at device removal (e. g. when the
USB device is physically disconnected).

According with I2C fault codes, the proper error for a timeout is ETIMEDOUT:

	ETIMEDOUT
		This is returned by drivers when an operation took too much
		time, and was aborted before it completed.

		SMBus adapters may return it when an operation took more
		time than allowed by the SMBus specification; for example,
		when a slave stretches clocks too far.  I2C has no such
		timeouts, but it's normal for I2C adapters to impose some
		arbitrary limits (much longer than SMBus!) too.

> Whether -ENODEV is the appropriate error code or not depends on the
> devices error detection capabilities.

No, it depends if the code is called during probing time or not. Outside
device probing, an I2C driver should _never_ return ENODEV.

> The second assumption you make is that 0x10 means that a timeout occured.
> Which timeout are you talking about ?
> The only timeout I can think of can happen with devices which use clock
> stretching and hold down SCL too long.
> In any case you have no evidence for this theory, too.
> What we can say for sure ist that 0x10 includes the NACK error case
> because this happens when the slave device isn't present / doesn't respond.

You can't affirm that the device isn't present.

Let remind a conversation we had with Devin at #v4l back on Seg 27 Mai 2013,
where he checked those error codes on his datasheets:

(16:23:05) mchehab: btw, talking about missing data, register 0x05 is also not documented, although it is one of the most used register
(16:24:11) frankschaefer: This is definitely no kernel bloating.
(16:24:29) devinheitmueller: 5[5] is busy and 5[4] is aborted. Last I checked the driver implemented them properly so I didn't see a need for anything additional.
(16:25:17) frankschaefer: "busy" and "aborted" what ?
(16:25:22) devinheitmueller: i2c.
(16:25:40) devinheitmueller: Oh wait, busy was only on em2874. But aborted was on both versions of the chip.

Again, according with Documentation/i2c/fault-codes, for an I2C
aborted I/O, the error code is ETIMEDOUT.

> But that's all. We have no idea what 0x10 really means in detail.
> Maybe it also covers things like clock stretching timeouts or general
> SCL and SDA line errors, but we'll never know that without the datasheet.
> 
> Interpreting 0x10 as -ENODEV and all other errors as -EIO has been
> working fine for ages now.

When originally written, the only case where -ENODEV was returned was 
during I2C device probing time (I2C reads or writes with size equal to 
zero).

Latter patches corrupted it, and added -ENODEV to be returned outsize
the probing time.

> Changing it based on such fragile theories is no good idea.

The API specs is not a fragile theory. Is a document to be followed,
to warrant compliance.

> NACK from my side.
> 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-i2c.c | 20 +++++++++-----------
> >  1 file changed, 9 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> > index 8b35aa51b9bb..c3ba8ace5c94 100644
> > --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> > +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> > @@ -81,7 +81,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  			return len;
> >  		if (ret == 0x94 + len - 1) {
> >  			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
> > -			return -ENODEV;
> > +			return -EREMOTEIO;
> >  		}
> >  		if (ret < 0) {
> >  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> > @@ -125,7 +125,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  			break;
> >  		if (ret == 0x94 + len - 1) {
> >  			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
> > -			return -ENODEV;
> > +			return -EREMOTEIO;
> >  		}
> >  		if (ret < 0) {
> >  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> > @@ -203,7 +203,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		if (ret == 0x10) {
> >  			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> >  				    addr);
> > -			return -ENODEV;
> > +			return -EREMOTEIO;
> >  		}
> >  		if (ret < 0) {
> >  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> > @@ -249,7 +249,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  	 * bytes if we are on bus B AND there was no write attempt to the
> >  	 * specified slave address before AND no device is present at the
> >  	 * requested slave address.
> > -	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
> > +	 * Anyway, the next check will fail with -EREMOTEIO in this case, so avoid
> >  	 * spamming the system log on device probing and do nothing here.
> >  	 */
> >  
> > @@ -264,7 +264,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  	}
> >  	if (ret == 0x10) {
> >  		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
> > -		return -ENODEV;
> > +		return -EREMOTEIO;
> >  	}
> >  
> >  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
> > @@ -325,7 +325,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		return len;
> >  	else if (ret > 0) {
> >  		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
> > -		return -ENODEV;
> > +		return -EREMOTEIO;
> >  	}
> >  
> >  	return ret;
> > @@ -364,8 +364,6 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	 * bytes if we are on bus B AND there was no write attempt to the
> >  	 * specified slave address before AND no device is present at the
> >  	 * requested slave address.
> > -	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
> > -	 * spamming the system log on device probing and do nothing here.
> >  	 */
> >  
> >  	/* Check success */
> > @@ -378,7 +376,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		return len;
> >  	else if (ret > 0) {
> >  		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
> > -		return -ENODEV;
> > +		return -EREMOTEIO;
> >  	}
> >  
> >  	return ret;
> > @@ -420,7 +418,7 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
> >  		rc = em2800_i2c_check_for_device(dev, addr);
> >  	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
> >  		rc = em25xx_bus_B_check_for_device(dev, addr);
> > -	if (rc == -ENODEV) {
> > +	if (rc < 0) {
> >  		if (i2c_debug)
> >  			printk(" no device\n");
> >  	}
> > @@ -510,7 +508,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
> >  			       addr, msgs[i].len);
> >  		if (!msgs[i].len) { /* no len: check only for device presence */
> >  			rc = i2c_check_for_device(i2c_bus, addr);
> > -			if (rc == -ENODEV) {
> > +			if (rc < 0) {
> >  				rt_mutex_unlock(&dev->i2c_bus_lock);
> >  				return rc;
> >  			}
> 


-- 

Cheers,
Mauro
