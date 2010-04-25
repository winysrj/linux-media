Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:43560 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0DYXoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 19:44:23 -0400
Received: by ewy20 with SMTP id 20so3496969ewy.1
        for <linux-media@vger.kernel.org>; Sun, 25 Apr 2010 16:44:22 -0700 (PDT)
Date: Mon, 26 Apr 2010 09:47:08 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] tm6000 fix i2c
Message-ID: <20100426094708.47dbcd5b@glory.loctelecom.ru>
In-Reply-To: <4BD1B985.8060703@arcor.de>
References: <20100423104804.784fb730@glory.loctelecom.ru>
	<4BD1B985.8060703@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

It's my error. This code good only for tm6010. Now I rework my patch.

With my best regards, Dmitry.

> Am 23.04.2010 02:48, schrieb Dmitri Belimov:
> > Hi
> >
> > Rework I2C for read word from connected devices, now it works well.
> > Add new functions for read/write blocks.
> >
> > diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-i2c.c
> > --- a/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Apr 05
> > 22:56:43 2010 -0400 +++
> > b/linux/drivers/staging/tm6000/tm6000-i2c.c	Fri Apr 23
> > 04:23:03 2010 +1000 @@ -24,6 +24,7 @@ #include <linux/kernel.h>
> >  #include <linux/usb.h>
> >  #include <linux/i2c.h>
> > +#include <linux/delay.h>
> >  
> >  #include "compat.h"
> >  #include "tm6000.h"
> > @@ -45,11 +46,39 @@
> >  			printk(KERN_DEBUG "%s at %s: " fmt, \
> >  			dev->name, __FUNCTION__ , ##args); } while
> > (0) 
> > +static void tm6000_i2c_reset(struct tm6000_core *dev)
> > +{
> > +	tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> > TM6000_GPIO_CLK, 0);
> > +	msleep(15);
> > +	tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> > TM6000_GPIO_CLK, 1);
> > +	msleep(15);
> > +}
> > +
> >  static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned
> > char addr, __u8 reg, char *buf, int len)
> >  {
> > -	return tm6000_read_write_usb(dev, USB_DIR_OUT |
> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > -		REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0,
> > buf, len);
> > +	int rc;
> > +	unsigned int tsleep;
> > +
> > +	if (!buf || len < 1 || len > 64)
> > +		return -1;
> > +
> > +	/* capture mutex */
> > +	rc = tm6000_read_write_usb(dev, USB_DIR_OUT |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> > +		addr | reg << 8, 0, buf, len);
> > +
> > +	if (rc < 0) {
> > +		/* release mutex */
> > +		return rc;
> > +	}
> > +
> > +	/* Calculate delay time, 14000us for 64 bytes */
> > +	tsleep = ((len * 200) + 200 + 1000) / 1000;
> > +	msleep(tsleep);
> > +
> > +	/* release mutex */
> > +	return rc;
> >  }
> >  
> >  /* Generic read - doesn't work fine with 16bit registers */
> > @@ -59,22 +88,30 @@
> >  	int rc;
> >  	u8 b[2];
> >  
> > -	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 ==
> > addr) && (reg % 2 == 0)) {
> > +	if (!buf || len < 1 || len > 64)
> > +		return -1;
> > +
> > +	/* capture mutex */
> > +	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 ==
> > addr)
> > +	&& (reg % 2 == 0)) {
> >  		/*
> >  		 * Workaround an I2C bug when reading from zl10353
> >  		 */
> >  		reg -= 1;
> >  		len += 1;
> >  
> > -		rc = tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > -			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg <<
> > 8, 0, b, len);
> > +		rc = tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> > +		addr | reg << 8, 0, b, len);
> >  
> >  		*buf = b[1];
> >  	} else {
> > -		rc = tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > -			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg <<
> > 8, 0, buf, len);
> > +		rc = tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> > +		addr | reg << 8, 0, buf, len);
> >  	}
> >  
> > +	/* release mutex */
> >  	return rc;
> >  }
> >  
> > @@ -85,8 +122,106 @@
> >  static int tm6000_i2c_recv_regs16(struct tm6000_core *dev,
> > unsigned char addr, __u16 reg, char *buf, int len)
> >  {
> > -	return tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > -		REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
> > +	int rc;
> > +	unsigned char ureg;
> > +
> > +	if (!buf || len != 2)
> > +		return -1;
> > +
> > +	/* capture mutex */
> > +	ureg = reg & 0xFF;
> > +	rc = tm6000_read_write_usb(dev, USB_DIR_OUT |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> > +		addr | (reg & 0xFF00), 0, &ureg, 1);
> > +
> > +	if (rc < 0) {
> > +		/* release mutex */
> > +		return rc;
> > +	}
> > +
> > +	msleep(1400 / 1000);
> > +	rc = tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
> > +		reg, 0, buf, len);
> > +
> >   
> not all can this request (chip revision 0xf3 and 0xf4 can it)
> > +	if (rc < 0) {
> > +		/* release mutex */
> > +		return rc;
> > +	}
> > +
> > +	/* release mutex */
> > +	return rc;
> > +}
> > +
> > +static int tm6000_i2c_read_sequence(struct tm6000_core *dev,
> > unsigned char addr,
> > +				  __u16 reg, char *buf, int len)
> > +{
> > +	int rc;
> > +
> > +	if (!buf || len < 1 || len > 64)
> > +		return -1;
> > +
> > +	/* capture mutex */
> > +	rc = tm6000_read_write_usb(dev, USB_DIR_IN |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
> > +		reg, 0, buf, len);
> >   
> ditto
> > +	/* release mutex */
> > +	return rc;
> > +}
> > +
> > +static int tm6000_i2c_write_sequence(struct tm6000_core *dev,
> > +				unsigned char addr, __u16 reg,
> > char *buf,
> > +				int len)
> > +{
> > +	int rc;
> > +	unsigned int tsleep;
> > +
> > +	if (!buf || len < 1 || len > 64)
> > +		return -1;
> > +
> > +	/* capture mutex */
> > +	rc = tm6000_read_write_usb(dev, USB_DIR_OUT |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> > +		addr | reg << 8, 0, buf+1, len-1);
> > +
> > +	if (rc < 0) {
> > +		/* release mutex */
> > +		return rc;
> > +	}
> > +
> > +	/* Calculate delay time, 13800us for 64 bytes */
> > +	tsleep = ((len * 200) + 1000) / 1000;
> > +	msleep(tsleep);
> > +
> > +	/* release mutex */
> > +	return rc;
> > +}
> > +
> > +static int tm6000_i2c_write_uni(struct tm6000_core *dev, unsigned
> > char addr,
> > +				  __u16 reg, char *buf, int len)
> > +{
> > +	int rc;
> > +	unsigned int tsleep;
> > +
> > +	if (!buf || len < 1 || len > 64)
> > +		return -1;
> > +
> > +	/* capture mutex */
> > +	rc = tm6000_read_write_usb(dev, USB_DIR_OUT |
> > USB_TYPE_VENDOR |
> > +		USB_RECIP_DEVICE, REQ_30_I2C_WRITE,
> > +		addr | reg << 8, 0, buf+1, len-1);
> > +
> > +	if (rc < 0) {
> > +		/* release mutex */
> > +		return rc;
> > +	}
> > +
> > +	/* Calculate delay time, 14800us for 64 bytes */
> > +	tsleep = ((len * 200) + 1000 + 1000) / 1000;
> > +	msleep(tsleep);
> > +
> > +	/* release mutex */
> > +	return rc;
> >  }
> >  
> >  static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
> >
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> >
> >
> > With my best regards, Dmitry.
> 
> 
> -- 
> Stefan Ringel <stefan.ringel@arcor.de>
> 
