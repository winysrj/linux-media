Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46123 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAEUxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 15:53:50 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so7620581eak.39
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 12:53:49 -0800 (PST)
Message-ID: <52C9C6A0.30502@googlemail.com>
Date: Sun, 05 Jan 2014 21:54:56 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 19/22] [media] em28xx: cleanup I2C debug messages
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-20-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-20-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> The I2C output messages is too polluted. Clean it a little
> bit, by:
> 	- use the proper core support for memory dumps;
> 	- hide most stuff under the i2c_debug umbrella;
> 	- add the missing KERN_CONT where needed;
> 	- use 2 levels or verbosity. Only the second one
> 	  will show the I2C transfer data.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 94 +++++++++++++++++++----------------
>  1 file changed, 50 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index c3ba8ace5c94..e030e0b7d645 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -41,7 +41,7 @@ MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
>  
>  static unsigned int i2c_debug;
>  module_param(i2c_debug, int, 0644);
> -MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
> +MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I2C transfers)");
>  
>  /*
>   * em2800_i2c_send_bytes()
> @@ -80,7 +80,9 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		if (ret == 0x80 + len - 1)
>  			return len;
>  		if (ret == 0x94 + len - 1) {
> -			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
> +			if (i2c_debug)
> +				em28xx_warn("R05 returned 0x%02x: I2C timeout",
> +					    ret);
>  			return -EREMOTEIO;
>  		}
>  		if (ret < 0) {
> @@ -90,7 +92,8 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		}
>  		msleep(5);
>  	}
> -	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> +	if (i2c_debug)
> +		em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
>  	return -EREMOTEIO;
>  }
>  
> @@ -124,7 +127,9 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		if (ret == 0x84 + len - 1)
>  			break;
>  		if (ret == 0x94 + len - 1) {
> -			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
> +			if (i2c_debug)
> +				em28xx_warn("R05 returned 0x%02x: I2C timeout",
> +					    ret);
>  			return -EREMOTEIO;
>  		}
>  		if (ret < 0) {
> @@ -134,8 +139,11 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		}
>  		msleep(5);
>  	}
> -	if (ret != 0x84 + len - 1)
> -		em28xx_warn("read from i2c device at 0x%x timed out\n", addr);
> +	if (ret != 0x84 + len - 1) {
> +		if (i2c_debug)
> +			em28xx_warn("read from i2c device at 0x%x timed out\n",
> +				    addr);
> +	}
>  
>  	/* get the received message */
>  	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
> @@ -218,7 +226,8 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  		 */
>  	}
>  
> -	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> +	if (i2c_debug)
> +		em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
>  	return -EREMOTEIO;
>  }
>  
> @@ -263,7 +272,9 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
>  		return ret;
>  	}
>  	if (ret == 0x10) {
> -		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
> +		if (i2c_debug)
> +			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> +				    addr);
>  		return -EREMOTEIO;
>  	}
>  
> @@ -324,7 +335,9 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	if (!ret)
>  		return len;
>  	else if (ret > 0) {
> -		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
> +		if (i2c_debug)
> +			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
> +				    ret);
>  		return -EREMOTEIO;
>  	}
>  
> @@ -375,7 +388,9 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	if (!ret)
>  		return len;
>  	else if (ret > 0) {
> -		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
> +		if (i2c_debug)
> +			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
> +				    ret);
>  		return -EREMOTEIO;
>  	}
>  
> @@ -418,10 +433,6 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
>  		rc = em2800_i2c_check_for_device(dev, addr);
>  	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
>  		rc = em25xx_bus_B_check_for_device(dev, addr);
> -	if (rc < 0) {
> -		if (i2c_debug)
> -			printk(" no device\n");
> -	}
>  	return rc;
>  }
>  
> @@ -430,7 +441,7 @@ static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
>  {
>  	struct em28xx *dev = i2c_bus->dev;
>  	u16 addr = msg.addr << 1;
> -	int byte, rc = -EOPNOTSUPP;
> +	int rc = -EOPNOTSUPP;
>  
>  	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
>  		rc = em28xx_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
> @@ -438,10 +449,6 @@ static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
>  		rc = em2800_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
>  	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
>  		rc = em25xx_bus_B_recv_bytes(dev, addr, msg.buf, msg.len);
> -	if (i2c_debug) {
> -		for (byte = 0; byte < msg.len; byte++)
> -			printk(" %02x", msg.buf[byte]);
> -	}
>  	return rc;
>  }
>  
> @@ -450,12 +457,8 @@ static inline int i2c_send_bytes(struct em28xx_i2c_bus *i2c_bus,
>  {
>  	struct em28xx *dev = i2c_bus->dev;
>  	u16 addr = msg.addr << 1;
> -	int byte, rc = -EOPNOTSUPP;
> +	int rc = -EOPNOTSUPP;
>  
> -	if (i2c_debug) {
> -		for (byte = 0; byte < msg.len; byte++)
> -			printk(" %02x", msg.buf[byte]);
> -	}
>  	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
>  		rc = em28xx_i2c_send_bytes(dev, addr, msg.buf, msg.len, stop);
>  	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)
> @@ -500,7 +503,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  	}
>  	for (i = 0; i < num; i++) {
>  		addr = msgs[i].addr << 1;
> -		if (i2c_debug)
> +		if (i2c_debug > 1)
>  			printk(KERN_DEBUG "%s at %s: %s %s addr=%02x len=%d:",
>  			       dev->name, __func__ ,
>  			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
> @@ -509,24 +512,33 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  		if (!msgs[i].len) { /* no len: check only for device presence */
>  			rc = i2c_check_for_device(i2c_bus, addr);
>  			if (rc < 0) {
> +				if (i2c_debug > 1)
> +					printk(KERN_CONT " no device\n");
>  				rt_mutex_unlock(&dev->i2c_bus_lock);
>  				return rc;
>  			}
>  		} else if (msgs[i].flags & I2C_M_RD) {
>  			/* read bytes */
>  			rc = i2c_recv_bytes(i2c_bus, msgs[i]);
> +
> +			if (i2c_debug > 1 && rc >= 0)
> +				printk(KERN_CONT " %*ph",
> +				       msgs[i].len, msgs[i].buf);
>  		} else {
> +			if (i2c_debug > 1)
> +				printk(KERN_CONT " %*ph",
> +				       msgs[i].len, msgs[i].buf);
> +
>  			/* write bytes */
>  			rc = i2c_send_bytes(i2c_bus, msgs[i], i == num - 1);
>  		}
>  		if (rc < 0) {
> -			if (i2c_debug)
> -				printk(" ERROR: %i\n", rc);
> +			if (i2c_debug > 1)
> +				printk(KERN_CONT " ERROR: %i\n", rc);
>  			rt_mutex_unlock(&dev->i2c_bus_lock);
>  			return rc;
> -		}
> -		if (i2c_debug)
> -			printk("\n");
> +		} else if (i2c_debug > 1)
> +			printk(KERN_CONT "\n");
>  	}
>  
>  	rt_mutex_unlock(&dev->i2c_bus_lock);
> @@ -609,7 +621,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>  	 * calculation and returned device dataset. Simplifies the code a lot,
>  	 * but we might have to deal with multiple sizes in the future !
>  	 */
> -	int i, err;
> +	int err;
>  	struct em28xx_eeprom *dev_config;
>  	u8 buf, *data;
>  
> @@ -640,20 +652,14 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>  		goto error;
>  	}
>  
> -	/* Display eeprom content */
> -	for (i = 0; i < len; i++) {
> -		if (0 == (i % 16)) {
> -			if (dev->eeprom_addrwidth_16bit)
> -				em28xx_info("i2c eeprom %04x:", i);
> -			else
> -				em28xx_info("i2c eeprom %02x:", i);
> -		}
> -		printk(" %02x", data[i]);
> -		if (15 == (i % 16))
> -			printk("\n");
> +	if (i2c_debug) {
> +		/* Display eeprom content */
> +		print_hex_dump(KERN_INFO, "eeprom ", DUMP_PREFIX_OFFSET,
> +			       16, 1, data, len, true);
> +
> +		if (dev->eeprom_addrwidth_16bit)
> +			em28xx_info("eeprom %06x: ... (skipped)\n", 256);
>  	}
> -	if (dev->eeprom_addrwidth_16bit)
> -		em28xx_info("i2c eeprom %04x: ... (skipped)\n", i);
>  
>  	if (dev->eeprom_addrwidth_16bit &&
>  	    data[0] == 0x26 && data[3] == 0x00) {

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>


