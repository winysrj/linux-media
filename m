Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:41853 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbcJJGkK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:40:10 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 61DC120B16
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:37:33 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:37:31 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/26] dibusb: don't do DMA on stack
Message-ID: <20161010083731.0efad775@posteo.de>
In-Reply-To: <801c76677194f958a58622129df3a0fcd59a5447.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <801c76677194f958a58622129df3a0fcd59a5447.1475860773.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  7 Oct 2016 14:24:19 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/dibusb-common.c | 106
> +++++++++++++++++++++---------
> drivers/media/usb/dvb-usb/dibusb.h        |   5 ++ 2 files changed,
> 81 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c
> b/drivers/media/usb/dvb-usb/dibusb-common.c index
> 4b08c2a47ae2..76b26dc7339c 100644 ---
> a/drivers/media/usb/dvb-usb/dibusb-common.c +++
> b/drivers/media/usb/dvb-usb/dibusb-common.c @@ -12,9 +12,6 @@
>  #include <linux/kconfig.h>
>  #include "dibusb.h"
>  
> -/* Max transfer size done by I2C transfer functions */
> -#define MAX_XFER_SIZE  64
> -
>  static int debug;
>  module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=info (|-able))."
> DVB_USB_DEBUG_STATUS); @@ -63,72 +60,109 @@
> EXPORT_SYMBOL(dibusb_pid_filter_ctrl); 
>  int dibusb_power_ctrl(struct dvb_usb_device *d, int onoff)
>  {
> -	u8 b[3];
> +	u8 *b;
>  	int ret;
> +
> +	b = kmalloc(3, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> +
>  	b[0] = DIBUSB_REQ_SET_IOCTL;
>  	b[1] = DIBUSB_IOCTL_CMD_POWER_MODE;
>  	b[2] = onoff ? DIBUSB_IOCTL_POWER_WAKEUP :
> DIBUSB_IOCTL_POWER_SLEEP;
> -	ret = dvb_usb_generic_write(d,b,3);
> +
> +	ret = dvb_usb_generic_write(d, b, 3);
> +
> +	kfree(b);
> +
>  	msleep(10);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(dibusb_power_ctrl);
>  
>  int dibusb2_0_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  {
> -	u8 b[3] = { 0 };
> +	struct dibusb_state *st = adap->priv;
>  	int ret;
>  
>  	if ((ret = dibusb_streaming_ctrl(adap,onoff)) < 0)
>  		return ret;
>  
>  	if (onoff) {
> -		b[0] = DIBUSB_REQ_SET_STREAMING_MODE;
> -		b[1] = 0x00;
> -		if ((ret = dvb_usb_generic_write(adap->dev,b,2)) < 0)
> +		st->data[0] = DIBUSB_REQ_SET_STREAMING_MODE;
> +		st->data[1] = 0x00;
> +		ret = dvb_usb_generic_write(adap->dev, st->data, 2);
> +		if (ret  < 0)
>  			return ret;
>  	}
>  
> -	b[0] = DIBUSB_REQ_SET_IOCTL;
> -	b[1] = onoff ? DIBUSB_IOCTL_CMD_ENABLE_STREAM :
> DIBUSB_IOCTL_CMD_DISABLE_STREAM;
> -	return dvb_usb_generic_write(adap->dev,b,3);
> +	st->data[0] = DIBUSB_REQ_SET_IOCTL;
> +	st->data[1] = onoff ? DIBUSB_IOCTL_CMD_ENABLE_STREAM :
> DIBUSB_IOCTL_CMD_DISABLE_STREAM;
> +	return dvb_usb_generic_write(adap->dev, st->data, 3);
>  }
>  EXPORT_SYMBOL(dibusb2_0_streaming_ctrl);
>  
>  int dibusb2_0_power_ctrl(struct dvb_usb_device *d, int onoff)
>  {
> -	if (onoff) {
> -		u8 b[3] = { DIBUSB_REQ_SET_IOCTL,
> DIBUSB_IOCTL_CMD_POWER_MODE, DIBUSB_IOCTL_POWER_WAKEUP };
> -		return dvb_usb_generic_write(d,b,3);
> -	} else
> +	u8 *b;
> +	int ret;
> +
> +	if (!onoff)
>  		return 0;
> +
> +	b = kmalloc(3, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> +
> +	b[0] = DIBUSB_REQ_SET_IOCTL;
> +	b[1] = DIBUSB_IOCTL_CMD_POWER_MODE;
> +	b[2] = DIBUSB_IOCTL_POWER_WAKEUP;
> +
> +	ret = dvb_usb_generic_write(d, b, 3);
> +
> +	kfree(b);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(dibusb2_0_power_ctrl);
>  
>  static int dibusb_i2c_msg(struct dvb_usb_device *d, u8 addr,
>  			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
>  {
> -	u8 sndbuf[MAX_XFER_SIZE]; /* lead(1) devaddr,direction(1)
> addr(2) data(wlen) (len(2) (when reading)) */
> +	u8 *sndbuf;
> +	int ret, wo, len;
> +
>  	/* write only ? */
> -	int wo = (rbuf == NULL || rlen == 0),
> -		len = 2 + wlen + (wo ? 0 : 2);
> +	wo = (rbuf == NULL || rlen == 0);
>  
> -	if (4 + wlen > sizeof(sndbuf)) {
> +	len = 2 + wlen + (wo ? 0 : 2);
> +
> +	sndbuf = kmalloc(MAX_XFER_SIZE, GFP_KERNEL);
> +	if (!sndbuf)
> +		return -ENOMEM;
> +
> +	if (4 + wlen > MAX_XFER_SIZE) {
>  		warn("i2c wr: len=%d is too big!\n", wlen);
> -		return -EOPNOTSUPP;
> +		ret = -EOPNOTSUPP;
> +		goto ret;
>  	}
>  
>  	sndbuf[0] = wo ? DIBUSB_REQ_I2C_WRITE : DIBUSB_REQ_I2C_READ;
>  	sndbuf[1] = (addr << 1) | (wo ? 0 : 1);
>  
> -	memcpy(&sndbuf[2],wbuf,wlen);
> +	memcpy(&sndbuf[2], wbuf, wlen);
>  
>  	if (!wo) {
> -		sndbuf[wlen+2] = (rlen >> 8) & 0xff;
> -		sndbuf[wlen+3] = rlen & 0xff;
> +		sndbuf[wlen + 2] = (rlen >> 8) & 0xff;
> +		sndbuf[wlen + 3] = rlen & 0xff;
>  	}
>  
> -	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
> +	ret = dvb_usb_generic_rw(d, sndbuf, len, rbuf, rlen, 0);
> +
> +ret:
> +	kfree(sndbuf);
> +	return ret;
>  }
>  
>  /*
> @@ -320,11 +354,23 @@ EXPORT_SYMBOL(rc_map_dibusb_table);
>  
>  int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  {
> -	u8 key[5],cmd = DIBUSB_REQ_POLL_REMOTE;
> -	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
> -	dvb_usb_nec_rc_key_to_event(d,key,event,state);
> -	if (key[0] != 0)
> -		deb_info("key: %*ph\n", 5, key);
> +	u8 *buf;
> +
> +	buf = kmalloc(5, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	buf[0] = DIBUSB_REQ_POLL_REMOTE;
> +
> +	dvb_usb_generic_rw(d, buf, 1, buf, 5, 0);
> +
> +	dvb_usb_nec_rc_key_to_event(d, buf, event, state);
> +
> +	if (buf[0] != 0)
> +		deb_info("key: %*ph\n", 5, buf);
> +
> +	kfree(buf);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(dibusb_rc_query);
> diff --git a/drivers/media/usb/dvb-usb/dibusb.h
> b/drivers/media/usb/dvb-usb/dibusb.h index 3f82163d8ab8..42e9750393e5
> 100644 --- a/drivers/media/usb/dvb-usb/dibusb.h
> +++ b/drivers/media/usb/dvb-usb/dibusb.h
> @@ -96,10 +96,15 @@
>  #define DIBUSB_IOCTL_CMD_ENABLE_STREAM	0x01
>  #define DIBUSB_IOCTL_CMD_DISABLE_STREAM	0x02
>  
> +/* Max transfer size done by I2C transfer functions */
> +#define MAX_XFER_SIZE  64
> +
>  struct dibusb_state {
>  	struct dib_fe_xfer_ops ops;
>  	int mt2060_present;
>  	u8 tuner_addr;
> +
> +	unsigned char data[MAX_XFER_SIZE];
>  };
>  
>  struct dibusb_device_state {

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
