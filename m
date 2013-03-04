Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586Ab3CDUUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 15:20:14 -0500
Date: Mon, 4 Mar 2013 17:20:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] em28xx: add support for em25xx i2c bus B
 read/write/check device operations
Message-ID: <20130304172005.58590d43@redhat.com>
In-Reply-To: <1362339661-3446-2-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com>
	<1362339661-3446-2-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  3 Mar 2013 20:40:57 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> The webcam "SpeedLink VAD Laplace" (em2765 + ov2640) uses a special algorithm
> for i2c communication with the sensor, which is connected to a second i2c bus.
> 
> We don't know yet how to find out which devices support/use it.
> It's very likely used by all em25xx and em276x+ bridges.
> Tests with other em28xx chips (em2820, em2882/em2883) show, that this
> algorithm always succeeds there although no slave device is connected.
> 
> The algorithm likely also works for real I2C client devices (OV2640 uses SCCB),
> because the Windows driver seems to use it for probing Samsung and Kodak
> sensors.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |    6 +-
>  drivers/media/usb/em28xx/em28xx-i2c.c   |  164 +++++++++++++++++++++++++++----
>  drivers/media/usb/em28xx/em28xx.h       |    7 ++
>  3 Dateien geändert, 159 Zeilen hinzugefügt(+), 18 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 5a5b637..75d4aef 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3103,7 +3103,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  		return retval;
>  	}
>  	/* Configure i2c bus */
> -	if (!dev->board.is_em2800) {
> +	if (dev->board.is_em2800) {
> +		dev->i2c_algo_type = EM28XX_I2C_ALGO_EM2800;
> +	} else {
> +		dev->i2c_algo_type = EM28XX_I2C_ALGO_EM28XX;
> +
>  		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
>  		if (retval < 0) {
>  			em28xx_errdev("%s: em28xx_write_reg failed!"
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 44bef43..6e86ffc 100644
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
> @@ -270,6 +271,114 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
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
> +
> +	/* Read value */
> +	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
> +	/* NOTE:
> +	 * 0 byte reads always succeed, even if no device is connected. */
> +	if (ret != len) {
> +		if (ret < 0) {
> +			em28xx_warn("reading from i2c device at 0x%x failed "
> +				    "(error=%i)\n", addr, ret);
> +			return ret;
> +		} else {
> +			em28xx_warn("%i bytes requested from i2c device at "
> +				    "0x%x, but %i bytes received\n",
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
> + * em25xx_bus_B_check_for_device()
> + * check if there is a i2c device at the supplied address
> + */
> +static int em25xx_bus_B_check_for_device(struct em28xx *dev, u16 addr)
> +{
> +	u8 buf;
> +	int ret;
> +
> +	ret = em25xx_bus_B_recv_bytes(dev, addr, &buf, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +	/* NOTE: With chips which do not support this operation,
> +	 * it seems to succeed ALWAYS ! (even if no device connected) */
> +}
> +
> +/*
>   * em28xx_i2c_xfer()
>   * the main i2c transfer function
>   */
> @@ -277,7 +386,9 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			   struct i2c_msg msgs[], int num)
>  {
>  	struct em28xx *dev = i2c_adap->algo_data;
> -	int addr, rc, i, byte;
> +	int addr, i, byte;
> +	int rc = -EOPNOTSUPP;
> +	enum em28xx_i2c_algo_type algo_type = dev->i2c_algo_type;
>  
>  	if (num <= 0)
>  		return 0;
> @@ -290,10 +401,13 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			       i == num - 1 ? "stop" : "nonstop",
>  			       addr, msgs[i].len			     );
>  		if (!msgs[i].len) { /* no len: check only for device presence */
> -			if (dev->board.is_em2800)
> -				rc = em2800_i2c_check_for_device(dev, addr);
> -			else
> +			if (algo_type == EM28XX_I2C_ALGO_EM28XX) {
>  				rc = em28xx_i2c_check_for_device(dev, addr);
> +			} else if (algo_type == EM28XX_I2C_ALGO_EM2800) {
> +				rc = em2800_i2c_check_for_device(dev, addr);
> +			} else if (algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
> +				rc = em25xx_bus_B_check_for_device(dev, addr);
> +			}

That seems too messy. 

IMO, the best is to create 3 different em28xx_i2c_xfer() routines:
one for em2800, one for "standard" I2c protocol, and another one for
this em25xx one. Then, all you need to do is to embed 
static struct i2c_algorithm into struct em28xx and fill
em28xx_algo.master_transfer to point to the correct xfer.

That makes the code more readable and remove a little faster by removing
the unneeded ifs from the code.

>  			if (rc == -ENODEV) {
>  				if (i2c_debug)
>  					printk(" no device\n");
> @@ -301,14 +415,19 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			}
>  		} else if (msgs[i].flags & I2C_M_RD) {
>  			/* read bytes */
> -			if (dev->board.is_em2800)
> -				rc = em2800_i2c_recv_bytes(dev, addr,
> +			if (algo_type == EM28XX_I2C_ALGO_EM28XX) {
> +				rc = em28xx_i2c_recv_bytes(dev, addr,
>  							   msgs[i].buf,
>  							   msgs[i].len);
> -			else
> -				rc = em28xx_i2c_recv_bytes(dev, addr,
> +			} else if (algo_type == EM28XX_I2C_ALGO_EM2800) {
> +				rc = em2800_i2c_recv_bytes(dev, addr,
>  							   msgs[i].buf,
>  							   msgs[i].len);
> +			} else if (algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
> +				rc = em25xx_bus_B_recv_bytes(dev, addr,
> +							    msgs[i].buf,
> +							    msgs[i].len);
> +			}
>  			if (i2c_debug) {
>  				for (byte = 0; byte < msgs[i].len; byte++)
>  					printk(" %02x", msgs[i].buf[byte]);
> @@ -319,15 +438,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  				for (byte = 0; byte < msgs[i].len; byte++)
>  					printk(" %02x", msgs[i].buf[byte]);
>  			}
> -			if (dev->board.is_em2800)
> -				rc = em2800_i2c_send_bytes(dev, addr,
> -							   msgs[i].buf,
> -							   msgs[i].len);
> -			else
> +			if (algo_type == EM28XX_I2C_ALGO_EM28XX) {
>  				rc = em28xx_i2c_send_bytes(dev, addr,
>  							   msgs[i].buf,
>  							   msgs[i].len,
>  							   i == num - 1);
> +			} else if (algo_type == EM28XX_I2C_ALGO_EM2800) {
> +				rc = em2800_i2c_send_bytes(dev, addr,
> +							   msgs[i].buf,
> +							   msgs[i].len);
> +			} else if (algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
> +				rc = em25xx_bus_B_send_bytes(dev, addr,
> +							    msgs[i].buf,
> +							    msgs[i].len);
> +			}
>  		}
>  		if (rc < 0) {
>  			if (i2c_debug)
> @@ -589,10 +713,16 @@ error:
>  static u32 functionality(struct i2c_adapter *adap)
>  {
>  	struct em28xx *dev = adap->algo_data;
> -	u32 func_flags = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> -	if (dev->board.is_em2800)
> -		func_flags &= ~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
> -	return func_flags;
> +
> +	if ((dev->i2c_algo_type == EM28XX_I2C_ALGO_EM28XX) ||
> +	    (dev->i2c_algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)) {
> +		return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +	} else if (dev->i2c_algo_type == EM28XX_I2C_ALGO_EM2800)  {
> +		return (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL) &
> +			~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
> +	}
> +
> +	return 0; /* BUG */

Please create a separate I2C register logic for bus B. It was a mistake
to reuse the existing I2C bus for logic for both buses (ok, actually,
no device currently uses 2 buses, as they simply don't read eeproms on
2 bus devices). 

Btw, cx231xx has a similar issue: it has 3 buses. See how it was solved there:

drivers/media/usb/cx231xx/cx231xx-core.c: cx231xx_i2c_register(&dev->i2c_bus[0]);
drivers/media/usb/cx231xx/cx231xx-core.c: cx231xx_i2c_register(&dev->i2c_bus[1]);
drivers/media/usb/cx231xx/cx231xx-core.c: cx231xx_i2c_register(&dev->i2c_bus[2]);

Of course, the em28xx-cards will need to tell on what bus the tuner and
demods are. The em28xx I2C logic will also need to write to EM28XX_R06_I2C_CLK
if the bus is different - the windows driver is just stupid: it just precedes all
I2C writes by a write at reg 0x06 - we can certainly do better than that ;).

If you're in doubt on how to do it, I can seek for some time to address it
properly.

>  }
>  
>  static struct i2c_algorithm em28xx_algo = {
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 2d6d31a..b7c8134 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -175,6 +175,12 @@
>  /* time in msecs to wait for i2c writes to finish */
>  #define EM2800_I2C_XFER_TIMEOUT		20
>  
> +enum em28xx_i2c_algo_type {
> +	EM28XX_I2C_ALGO_EM28XX,
> +	EM28XX_I2C_ALGO_EM2800,
> +	EM28XX_I2C_ALGO_EM25XX_BUS_B,
> +};
> +
>  enum em28xx_mode {
>  	EM28XX_SUSPEND,
>  	EM28XX_ANALOG_MODE,
> @@ -510,6 +516,7 @@ struct em28xx {
>  	/* i2c i/o */
>  	struct i2c_adapter i2c_adap;
>  	struct i2c_client i2c_client;
> +	enum em28xx_i2c_algo_type i2c_algo_type;
>  	unsigned char eeprom_addrwidth_16bit:1;
>  	/* video for linux */
>  	int users;		/* user count for exclusive use */

-- 

Cheers,
Mauro
