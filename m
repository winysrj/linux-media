Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3CDTOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 14:14:21 -0500
Date: Mon, 4 Mar 2013 16:14:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 06/11] em28xx: make sure we are at i2c bus A when
 calling em28xx_i2c_register()
Message-ID: <20130304161415.4cf0442d@redhat.com>
In-Reply-To: <1362339464-3373-7-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
	<1362339464-3373-7-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  3 Mar 2013 20:37:39 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> The current code first configures register EM28XX_R06_I2C_CLK, which includes
> i2c speed, ack, wait and (on some devices) i2c bus selection.
> The register value usually comes from the board definition.
> em28xx_i2c_register() is called afterwards, which also tries to read the eeprom.
> If the device uses i2c bus B, eeprom reading fails.
> 
> Fix the problem by selecting bus A before calling em28xx_i2c_register() and
> apply the board settings for register EM28XX_R06_I2C_CLK afterwards.
> I also noticed that this is what the Windows driver does.
> To be sure the i2c bus scan works as expected/before, remove its call from
> em28xx_i2c_register() and call it directly after the i2c bus has been configured.

This doesn't seen ok, for a few reasons:

	1) On all current em2874 (and upper) similar devices, the driver
doesn't even care for any devices at bus A, as the TV demods, tuners, etc
are at bus B. The only thing at bus A is the eeprom;

	2) It reduces the bus speed to the minimal rate, slowing down the
device probing, as it doesn't honor the I2C bus speed bits;

	3) It doesn't properly address the real issue: a separate I2C
register is needed for bus B.

Regards,
Mauro

> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |   31 ++++++++++++++++++++-----------
>  drivers/media/usb/em28xx/em28xx-i2c.c   |    7 -------
>  2 Dateien geändert, 20 Zeilen hinzugefügt(+), 18 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 9332d05..0d74734 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -66,6 +66,10 @@ module_param(usb_xfer_mode, int, 0444);
>  MODULE_PARM_DESC(usb_xfer_mode,
>  		 "USB transfer mode for frame data (-1 = auto, 0 = prefer isoc, 1 = prefer bulk)");
>  
> +static unsigned int i2c_scan;
> +module_param(i2c_scan, int, 0444);
> +MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
> +
>  
>  /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
>  static unsigned long em28xx_devused;
> @@ -3074,8 +3078,20 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  		snprintf(dev->name, sizeof(dev->name), "%s #%d", chip_name, dev->devno);
>  	}
>  
> +	/* Select i2c bus A (if necessary) */
> +	if (dev->chip_id == CHIP_ID_EM2874 ||
> +	    dev->chip_id == CHIP_ID_EM28174 ||
> +	    dev->chip_id == CHIP_ID_EM2884)
> +		em28xx_write_reg_bits(dev, EM28XX_R06_I2C_CLK, 0, EM2874_I2C_SECONDARY_BUS_SELECT);
> +	/* Register i2c bus */
> +	retval = em28xx_i2c_register(dev);
> +	if (retval < 0) {
> +		em28xx_errdev("%s: em28xx_i2c_register - error [%d]!\n",
> +			__func__, retval);
> +		return retval;
> +	}
> +	/* Configure i2c bus */
>  	if (!dev->board.is_em2800) {
> -		/* Resets I2C speed */
>  		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
>  		if (retval < 0) {
>  			em28xx_errdev("%s: em28xx_write_reg failed!"
> @@ -3084,6 +3100,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  			return retval;
>  		}
>  	}
> +	/* Scan i2c bus */
> +	if (i2c_scan)
> +		em28xx_do_i2c_scan(dev);
>  
>  	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
>  	if (retval < 0) {
> @@ -3094,14 +3113,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  	v4l2_ctrl_handler_init(hdl, 8);
>  	dev->v4l2_dev.ctrl_handler = hdl;
>  
> -	/* register i2c bus */
> -	retval = em28xx_i2c_register(dev);
> -	if (retval < 0) {
> -		em28xx_errdev("%s: em28xx_i2c_register - error [%d]!\n",
> -			__func__, retval);
> -		goto unregister_dev;
> -	}
> -
>  	/*
>  	 * Default format, used for tvp5150 or saa711x output formats
>  	 */
> @@ -3173,8 +3184,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  fail:
>  	em28xx_i2c_unregister(dev);
>  	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> -
> -unregister_dev:
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	return retval;
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 19f3e4f..ebe4b20 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -33,10 +33,6 @@
>  
>  /* ----------------------------------------------------------- */
>  
> -static unsigned int i2c_scan;
> -module_param(i2c_scan, int, 0444);
> -MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
> -
>  static unsigned int i2c_debug;
>  module_param(i2c_debug, int, 0644);
>  MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
> @@ -606,9 +602,6 @@ int em28xx_i2c_register(struct em28xx *dev)
>  		return retval;
>  	}
>  
> -	if (i2c_scan)
> -		em28xx_do_i2c_scan(dev);
> -
>  	return 0;
>  }
>  


-- 

Cheers,
Mauro
