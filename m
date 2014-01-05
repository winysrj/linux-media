Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37141 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaAEUsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 15:48:51 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so7574823eae.33
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 12:48:50 -0800 (PST)
Message-ID: <52C9C575.5030804@googlemail.com>
Date: Sun, 05 Jan 2014 21:49:57 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 18/22] [media] em28xx: don't return -ENODEV for I2C
 xfer errors
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-19-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> -ENODEV reports a permanent condition where a device is not found,
> and used only during device probing or device removal, as stated
> at  the V4L2 spec:
> 	http://linuxtv.org/downloads/v4l-dvb-apis/gen_errors.html
>
> Except during device detection, this is not the case of I2C
> transfer timeout errors.
>
> So, change them to return -EREMOTEIO instead.
Mauro,

make a step back and think about this again.
What are you doing here ?

You noticed that your HVR-950 device is working unstable for an unknown
reason.
Your specific device seems to be the only one, nobody could reproduce
your issues so far and with the HVR-900 for example (which is nearly
identical) we don't see any errors.

Then you started playing with the em28xx i2c transfer functions and
noticed, that if you repeat the same i2c operations again and again, you
finally have luck and it succeeds.
>From that you draw the conclusion, that i2c status 0x10 can't be a
permanent error and hence 0x10 can't be -ENODEV.
But that's wrong. Your problems could also be caused by
sporadic/temporary circuit failures (such as loose contacts or whatever).
Hardware errors can always happen and they are no reason for not using
-ENODEV.
Whether -ENODEV is the appropriate error code or not depends on the
devices error detection capabilities.

The second assumption you make is that 0x10 means that a timeout occured.
Which timeout are you talking about ?
The only timeout I can think of can happen with devices which use clock
stretching and hold down SCL too long.
In any case you have no evidence for this theory, too.

What we can say for sure ist that 0x10 includes the NACK error case
because this happens when the slave device isn't present / doesn't respond.
But that's all. We have no idea what 0x10 really means in detail.
Maybe it also covers things like clock stretching timeouts or general
SCL and SDA line errors, but we'll never know that without the datasheet.

Interpreting 0x10 as -ENODEV and all other errors as -EIO has been
working fine for ages now.
Changing it based on such fragile theories is no good idea.

NACK from my side.

> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 8b35aa51b9bb..c3ba8ace5c94 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -81,7 +81,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  			return len;
>  		if (ret == 0x94 + len - 1) {
>  			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
> -			return -ENODEV;
> +			return -EREMOTEIO;
>  		}
>  		if (ret < 0) {
>  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> @@ -125,7 +125,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  			break;
>  		if (ret == 0x94 + len - 1) {
>  			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
> -			return -ENODEV;
> +			return -EREMOTEIO;
>  		}
>  		if (ret < 0) {
>  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> @@ -203,7 +203,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  		if (ret == 0x10) {
>  			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
>  				    addr);
> -			return -ENODEV;
> +			return -EREMOTEIO;
>  		}
>  		if (ret < 0) {
>  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> @@ -249,7 +249,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
>  	 * bytes if we are on bus B AND there was no write attempt to the
>  	 * specified slave address before AND no device is present at the
>  	 * requested slave address.
> -	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
> +	 * Anyway, the next check will fail with -EREMOTEIO in this case, so avoid
>  	 * spamming the system log on device probing and do nothing here.
>  	 */
>  
> @@ -264,7 +264,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
>  	}
>  	if (ret == 0x10) {
>  		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
> -		return -ENODEV;
> +		return -EREMOTEIO;
>  	}
>  
>  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
> @@ -325,7 +325,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  		return len;
>  	else if (ret > 0) {
>  		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
> -		return -ENODEV;
> +		return -EREMOTEIO;
>  	}
>  
>  	return ret;
> @@ -364,8 +364,6 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	 * bytes if we are on bus B AND there was no write attempt to the
>  	 * specified slave address before AND no device is present at the
>  	 * requested slave address.
> -	 * Anyway, the next check will fail with -ENODEV in this case, so avoid
> -	 * spamming the system log on device probing and do nothing here.
>  	 */
>  
>  	/* Check success */
> @@ -378,7 +376,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  		return len;
>  	else if (ret > 0) {
>  		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
> -		return -ENODEV;
> +		return -EREMOTEIO;
>  	}
>  
>  	return ret;
> @@ -420,7 +418,7 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
>  		rc = em2800_i2c_check_for_device(dev, addr);
>  	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
>  		rc = em25xx_bus_B_check_for_device(dev, addr);
> -	if (rc == -ENODEV) {
> +	if (rc < 0) {
>  		if (i2c_debug)
>  			printk(" no device\n");
>  	}
> @@ -510,7 +508,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			       addr, msgs[i].len);
>  		if (!msgs[i].len) { /* no len: check only for device presence */
>  			rc = i2c_check_for_device(i2c_bus, addr);
> -			if (rc == -ENODEV) {
> +			if (rc < 0) {
>  				rt_mutex_unlock(&dev->i2c_bus_lock);
>  				return rc;
>  			}

