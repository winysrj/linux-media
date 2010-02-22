Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0BVRId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 12:08:33 -0500
Message-ID: <4B82BA08.8070102@redhat.com>
Date: Mon, 22 Feb 2010 14:08:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 1/3] tm6000: add send and recv function
References: <1266855693-5554-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266855693-5554-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> add separately send and receive function

Still broken:

drivers/staging/tm6000/tm6000-i2c.c: In function ‘tm6000_i2c_xfer’:
drivers/staging/tm6000/tm6000-i2c.c:107: error: expected ‘)’ before ‘{’ token
drivers/staging/tm6000/tm6000-i2c.c: In function ‘tm6000_i2c_eeprom’:
drivers/staging/tm6000/tm6000-i2c.c:161: error: implicit declaration of function ‘tm6000_i2c_revc_regs’

> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-i2c.c |   48 +++++++++++++++++++++++++---------
>  1 files changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
> index 656cd19..2222b39 100644
> --- a/drivers/staging/tm6000/tm6000-i2c.c
> +++ b/drivers/staging/tm6000/tm6000-i2c.c
> @@ -44,6 +44,32 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
>  			printk(KERN_DEBUG "%s at %s: " fmt, \
>  			dev->name, __FUNCTION__ , ##args); } while (0)
>  
> +int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr, __u8 reg, char *buf, int len)
> +{
> +	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
> +}
> +
> +/* read from a 8bit register */
> +int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr, __u8 reg, char *buf, int len)
> +{
> +	int rc;
> +
> +		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
> +
> +	return rc;
> +}
> +
> +/* read from a 16bit register
> + * for example xc2028, xc3028 or xc3028L 
> + */
> +int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char addr, __u16 reg, char *buf, int len)
> +{
> +	return tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
> +} 
> +
>  static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			   struct i2c_msg msgs[], int num)
>  {
> @@ -78,13 +104,14 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			i2c_dprintk(2, "; joined to read %s len=%d:",
>  				    i == num - 2 ? "stop" : "nonstop",
>  				    msgs[i + 1].len);
> -			rc = tm6000_read_write_usb (dev,
> -				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -				msgs[i].len == 1 ? REQ_16_SET_GET_I2C_WR1_RDN
> -						 : REQ_14_SET_GET_I2C_WR2_RDN,
> -				addr | msgs[i].buf[0] << 8,
> -				msgs[i].len == 1 ? 0 : msgs[i].buf[1],
> +			if (msgs{i].len == 1) {
> +				rc = tm6000_i2c_recv_regs(dev, addr, msgs[i].buf[0],
>  				msgs[i + 1].buf, msgs[i + 1].len);
> +			} else {
> +				rc = tm6000_i2c_recv_regs(dev, addr, msgs[i].buf[0] << 8 | msgs[i].buf[1],
> +				msgs[i + 1].buf, msgs[i + 1].len);
> +			}
> +
>  			i++;
>  
>  			if (addr == dev->tuner_addr) {
> @@ -99,10 +126,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			if (i2c_debug >= 2)
>  				for (byte = 0; byte < msgs[i].len; byte++)
>  					printk(" %02x", msgs[i].buf[byte]);
> -			rc = tm6000_read_write_usb(dev,
> -				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -				REQ_16_SET_GET_I2C_WR1_RDN,
> -				addr | msgs[i].buf[0] << 8, 0,
> +			rc = tm6000_i2c_send_regs(dev, addr, msgs[i].buf[0],
>  				msgs[i].buf + 1, msgs[i].len - 1);
>  
>  			if (addr == dev->tuner_addr) {
> @@ -134,9 +158,7 @@ static int tm6000_i2c_eeprom(struct tm6000_core *dev,
>  	bytes[16] = '\0';
>  	for (i = 0; i < len; ) {
>  	*p = i;
> -	rc = tm6000_read_write_usb (dev,
> -		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -		REQ_16_SET_GET_I2C_WR1_RDN, 0xa0 | i<<8, 0, p, 1);
> +	rc = tm6000_i2c_revc_regs(dev, 0xa0, i, p, 1);
>  		if (rc < 1) {
>  			if (p == eedata)
>  				goto noeeprom;


-- 

Cheers,
Mauro
