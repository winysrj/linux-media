Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab3CXLW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 07:22:59 -0400
Date: Sun, 24 Mar 2013 08:22:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] em28xx: add support for em25xx i2c bus B
 read/write/check device operations
Message-ID: <20130324082253.54dfc1c1@redhat.com>
In-Reply-To: <1364059632-29070-2-git-send-email-fschaefer.oss@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
	<1364059632-29070-2-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 23 Mar 2013 18:27:08 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> The webcam "SpeedLink VAD Laplace" (em2765 + ov2640) uses a special algorithm
> for i2c communication with the sensor, which is connected to a second i2c bus.
> 
> We don't know yet how to find out which devices support/use it.
> It's very likely used by all em25xx and em276x+ bridges.
> Tests with other em28xx chips (em2820, em2882/em2883) show, that this
> algorithm always succeeds there although no slave device is connected.
> 
> The algorithm likely also works for real i2c client devices (OV2640 uses SCCB),
> because the Windows driver seems to use it for probing Samsung and Kodak
> sensors.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |    8 +-
>  drivers/media/usb/em28xx/em28xx-i2c.c   |  229 +++++++++++++++++++++++++------
>  drivers/media/usb/em28xx/em28xx.h       |   10 +-
>  3 Dateien geändert, 205 Zeilen hinzugefügt(+), 42 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index cb7cdd3..033b6cb 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3139,15 +3139,19 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  	rt_mutex_init(&dev->i2c_bus_lock);
>  
>  	/* register i2c bus 0 */
> -	retval = em28xx_i2c_register(dev, 0);
> +	if (dev->board.is_em2800)
> +		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM2800);
> +	else
> +		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
>  	if (retval < 0) {
>  		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
>  			__func__, retval);
>  		goto unregister_dev;
>  	}
>  
> +	/* register i2c bus 1 */
>  	if (dev->def_i2c_bus) {
> -		retval = em28xx_i2c_register(dev, 1);
> +		retval = em28xx_i2c_register(dev, 1, EM28XX_I2C_ALGO_EM28XX);
>  		if (retval < 0) {
>  			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
>  				__func__, retval);
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 9e2fa41..ab14ac3 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -5,6 +5,7 @@
>  		      Markus Rechberger <mrechberger@gmail.com>
>  		      Mauro Carvalho Chehab <mchehab@infradead.org>
>  		      Sascha Sommer <saschasommer@freenet.de>
> +   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
>  
>     This program is free software; you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
> @@ -274,6 +275,176 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
>  }
>  
>  /*
> + * em25xx_bus_B_send_bytes
> + * write bytes to the i2c device
> + */
> +static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> +				   u16 len)
> +{
> +	int ret;
> +
> +	if (len < 1 || len > 64)
> +		return -EOPNOTSUPP;
> +	/* NOTE: limited by the USB ctrl message constraints
> +	 * Zero length reads always succeed, even if no device is connected */
> +
> +	/* Set register and write value */
> +	ret = dev->em28xx_write_regs_req(dev, 0x06, addr, buf, len);
> +	/* NOTE:
> +	 * 0 byte writes always succeed, even if no device is connected. */
> +	if (ret != len) {
> +		if (ret < 0) {
> +			em28xx_warn("writing to i2c device at 0x%x failed "
> +				    "(error=%i)\n", addr, ret);
> +			return ret;
> +		} else {
> +			em28xx_warn("%i bytes write to i2c device at 0x%x "
> +				    "requested, but %i bytes written\n",
> +				    len, addr, ret);
> +			return -EIO;
> +		}
> +	}
> +	/* Check success */
> +	ret = dev->em28xx_read_reg_req(dev, 0x08, 0x0000);
> +	/* NOTE: the only error we've seen so far is
> +	 * 0x01 when the slave device is not present */
> +	if (ret == 0x00) {
> +		return len;
> +	} else if (ret > 0) {
> +		return -ENODEV;
> +	}
> +
> +	return ret;
> +	/* NOTE: With chips which do not support this operation,
> +	 * it seems to succeed ALWAYS ! (even if no device connected) */
> +}
> +
> +/*
> + * em25xx_bus_B_recv_bytes
> + * read bytes from the i2c device
> + */
> +static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> +				   u16 len)
> +{
> +	int ret;
> +
> +	if (len < 1 || len > 64)
> +		return -EOPNOTSUPP;
> +	/* NOTE: limited by the USB ctrl message constraints
> +	 * Zero length reads always succeed, even if no device is connected */


Please stick with Kernel's coding style, as described on
Documentation/CodingStyle and on the common practices.

Multi-line comments are like:
	/*
	 * Foo
	 * bar
	 */

There are also a bunch of scripts/checkpatch.pl complains for this patch: 

WARNING: please, no spaces at the start of a line
#69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>$

WARNING: space prohibited between function name and open parenthesis '('
#69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>

WARNING: Avoid CamelCase: <Copyright>
#69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>

WARNING: Avoid CamelCase: <Frank>
#69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>

WARNING: Avoid CamelCase: <Sch>
#69: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:8:
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>

WARNING: quoted string split across lines
#97: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:298:
+			em28xx_warn("writing to i2c device at 0x%x failed "
+				    "(error=%i)\n", addr, ret);

WARNING: quoted string split across lines
#101: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:302:
+			em28xx_warn("%i bytes write to i2c device at 0x%x "
+				    "requested, but %i bytes written\n",

WARNING: braces {} are not necessary for any arm of this statement
#110: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:311:
+	if (ret == 0x00) {
[...]
+	} else if (ret > 0) {
[...]

WARNING: braces {} are not necessary for any arm of this statement
#156: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:357:
+	if (ret == 0x00) {
[...]
+	} else if (ret > 0) {
[...]

WARNING: braces {} are not necessary for any arm of this statement
#190: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:391:
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
[...]
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800) {
[...]
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
[...]

WARNING: printk() should include KERN_ facility level
#199: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:400:
+			printk(" no device\n");

WARNING: braces {} are not necessary for any arm of this statement
#211: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:412:
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
[...]
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800) {
[...]
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
[...]

WARNING: printk() should include KERN_ facility level
#220: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:421:
+			printk(" %02x", msg.buf[byte]);

WARNING: braces {} are not necessary for any arm of this statement
#236: FILE: drivers/media/usb/em28xx/em28xx-i2c.c:437:
+	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX) {
[...]
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800) {
[...]
+	} else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
[...]

total: 0 errors, 14 warnings, 333 lines checked

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

PS.: I'll write a separate email if I find any non-coding style issue on
this patch series. Won't comment anymore about coding style, as I'm
assuming that you'll be fixing it on the other patches of this series
if needed.

Regards,
Mauro
