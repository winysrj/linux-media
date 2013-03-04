Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62857 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3CDVX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 16:23:58 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so4161927eek.24
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 13:23:56 -0800 (PST)
Message-ID: <5135111B.4010102@googlemail.com>
Date: Mon, 04 Mar 2013 22:24:43 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 06/11] em28xx: make sure we are at i2c bus A when calling
 em28xx_i2c_register()
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com> <1362339464-3373-7-git-send-email-fschaefer.oss@googlemail.com> <20130304161415.4cf0442d@redhat.com>
In-Reply-To: <20130304161415.4cf0442d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.03.2013 20:14, schrieb Mauro Carvalho Chehab:
> Em Sun,  3 Mar 2013 20:37:39 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> The current code first configures register EM28XX_R06_I2C_CLK, which includes
>> i2c speed, ack, wait and (on some devices) i2c bus selection.
>> The register value usually comes from the board definition.
>> em28xx_i2c_register() is called afterwards, which also tries to read the eeprom.
>> If the device uses i2c bus B, eeprom reading fails.
>>
>> Fix the problem by selecting bus A before calling em28xx_i2c_register() and
>> apply the board settings for register EM28XX_R06_I2C_CLK afterwards.
>> I also noticed that this is what the Windows driver does.
>> To be sure the i2c bus scan works as expected/before, remove its call from
>> em28xx_i2c_register() and call it directly after the i2c bus has been configured.
> This doesn't seen ok, for a few reasons:
>
> 	1) On all current em2874 (and upper) similar devices, the driver
> doesn't even care for any devices at bus A, as the TV demods, tuners, etc
> are at bus B. The only thing at bus A is the eeprom;

Right, and the patch doesn't change that. The bus switch is still done
when configuring register 0x06.

> 	2) It reduces the bus speed to the minimal rate, slowing down the
> device probing, as it doesn't honor the I2C bus speed bits;

No, the device probing ist still done _after_ register 0x06 (i2c speed
etc.) is configured.
That's why I moved the call to em28xx_do_i2c_scan() from
em28xx_i2c_register() to em28xx_init_dev() (after the register 0x06
configuration).
See the commit message.

Old code:
(device seems to starts up with bus B selected)
- configure EM28XX_R06_I2C_CLK    <=== SWITCHES TO BUS B
- call em28xx_i2c_register()
        - calls i2c_add_adapter() /* adapter registration */
        - calls em28xx_i2c_eeprom() /* read eeprom, calculate hash,
print content */        <=== FAILS, EEPROM IS ON BUS A
        - calls em28xx_do_i2c_scan() /* probes for presence of devices
at known i2c addresses */

New code:
(device seems to starts up with bus B selected)
- clear bit EM2874_I2C_SECONDARY_BUS_SELECT of register
EM28XX_R06_I2C_CLK (only for bridges that support it)        <= SWITCHES
TO BUS A
- call em28xx_i2c_register()
        - calls i2c_add_adapter() /* adapter registration */
        - calls em28xx_i2c_eeprom() /* read eeprom, calculate hash,
print content */
- configure EM28XX_R06_I2C_CLK    <=== SWITCHES TO BUS B
- call em28xx_do_i2c_scan() /* probes for presence of devices at known
i2c addresses */


The new order now is also exactly the same as used by the Windows driver
(mentioned in the commit message, too).


> 	3) It doesn't properly address the real issue: a separate I2C
> register is needed for bus B.

Definitely. :(
We talked about that at the beginning.

I have spent several ours working on this, but finally gave it up (for
now), because
a) it is a very huge change. I started changing/fixing one thing, then I
noticed that this requires fixing 2 other issues first, which again made
it necessary to change others and so on...
The main problem isn't the i2c adapter/bus changes, it's the subdevice
handling/tracking...
b) the resulting code has a big overhead and I'm not sure if it is
justified as long as there is no device yet using both busses in parallel.

Sure, we all like clean code and sooner or later we will likely be
forced to do it properly.
Maybe I will come back to it when the webcam stuff is finished.
But for now (with regards to the eeprom reading), reordering the bus
setup/configuration calls seems to be the easiest and appropriate
solution to me.

Regards,
Frank

> Regards,
> Mauro
>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-cards.c |   31 ++++++++++++++++++++-----------
>>  drivers/media/usb/em28xx/em28xx-i2c.c   |    7 -------
>>  2 Dateien geändert, 20 Zeilen hinzugefügt(+), 18 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
>> index 9332d05..0d74734 100644
>> --- a/drivers/media/usb/em28xx/em28xx-cards.c
>> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
>> @@ -66,6 +66,10 @@ module_param(usb_xfer_mode, int, 0444);
>>  MODULE_PARM_DESC(usb_xfer_mode,
>>  		 "USB transfer mode for frame data (-1 = auto, 0 = prefer isoc, 1 = prefer bulk)");
>>  
>> +static unsigned int i2c_scan;
>> +module_param(i2c_scan, int, 0444);
>> +MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
>> +
>>  
>>  /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
>>  static unsigned long em28xx_devused;
>> @@ -3074,8 +3078,20 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>>  		snprintf(dev->name, sizeof(dev->name), "%s #%d", chip_name, dev->devno);
>>  	}
>>  
>> +	/* Select i2c bus A (if necessary) */
>> +	if (dev->chip_id == CHIP_ID_EM2874 ||
>> +	    dev->chip_id == CHIP_ID_EM28174 ||
>> +	    dev->chip_id == CHIP_ID_EM2884)
>> +		em28xx_write_reg_bits(dev, EM28XX_R06_I2C_CLK, 0, EM2874_I2C_SECONDARY_BUS_SELECT);
>> +	/* Register i2c bus */
>> +	retval = em28xx_i2c_register(dev);
>> +	if (retval < 0) {
>> +		em28xx_errdev("%s: em28xx_i2c_register - error [%d]!\n",
>> +			__func__, retval);
>> +		return retval;
>> +	}
>> +	/* Configure i2c bus */
>>  	if (!dev->board.is_em2800) {
>> -		/* Resets I2C speed */
>>  		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
>>  		if (retval < 0) {
>>  			em28xx_errdev("%s: em28xx_write_reg failed!"
>> @@ -3084,6 +3100,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>>  			return retval;
>>  		}
>>  	}
>> +	/* Scan i2c bus */
>> +	if (i2c_scan)
>> +		em28xx_do_i2c_scan(dev);
>>  
>>  	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
>>  	if (retval < 0) {
>> @@ -3094,14 +3113,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>>  	v4l2_ctrl_handler_init(hdl, 8);
>>  	dev->v4l2_dev.ctrl_handler = hdl;
>>  
>> -	/* register i2c bus */
>> -	retval = em28xx_i2c_register(dev);
>> -	if (retval < 0) {
>> -		em28xx_errdev("%s: em28xx_i2c_register - error [%d]!\n",
>> -			__func__, retval);
>> -		goto unregister_dev;
>> -	}
>> -
>>  	/*
>>  	 * Default format, used for tvp5150 or saa711x output formats
>>  	 */
>> @@ -3173,8 +3184,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>>  fail:
>>  	em28xx_i2c_unregister(dev);
>>  	v4l2_ctrl_handler_free(&dev->ctrl_handler);
>> -
>> -unregister_dev:
>>  	v4l2_device_unregister(&dev->v4l2_dev);
>>  
>>  	return retval;
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index 19f3e4f..ebe4b20 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -33,10 +33,6 @@
>>  
>>  /* ----------------------------------------------------------- */
>>  
>> -static unsigned int i2c_scan;
>> -module_param(i2c_scan, int, 0444);
>> -MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
>> -
>>  static unsigned int i2c_debug;
>>  module_param(i2c_debug, int, 0644);
>>  MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
>> @@ -606,9 +602,6 @@ int em28xx_i2c_register(struct em28xx *dev)
>>  		return retval;
>>  	}
>>  
>> -	if (i2c_scan)
>> -		em28xx_do_i2c_scan(dev);
>> -
>>  	return 0;
>>  }
>>  

