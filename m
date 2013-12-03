Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:17482 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3LCPHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 10:07:03 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX800JM1KNQ7O10@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 10:07:02 -0500 (EST)
Date: Tue, 03 Dec 2013 13:06:58 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] af9035: fix broken I2C and USB I/O
Message-id: <20131203130658.5c80d75b.m.chehab@samsung.com>
In-reply-to: <1385584128-2632-2-git-send-email-crope@iki.fi>
References: <1385584128-2632-1-git-send-email-crope@iki.fi>
 <1385584128-2632-2-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Nov 2013 22:28:48 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> There was three small buffer len calculation bugs which caused
> driver non-working. These are coming from recent commit:
> commit 7760e148350bf6df95662bc0db3734e9d991cb03
> [media] af9035: Don't use dynamic static allocation
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/af9035.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index c8fcd78..403bf43 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -131,7 +131,7 @@ static int af9035_wr_regs(struct dvb_usb_device *d, u32 reg, u8 *val, int len)
>  {
>  	u8 wbuf[MAX_XFER_SIZE];
>  	u8 mbox = (reg >> 16) & 0xff;
> -	struct usb_req req = { CMD_MEM_WR, mbox, sizeof(wbuf), wbuf, 0, NULL };
> +	struct usb_req req = { CMD_MEM_WR, mbox, 6 + len, wbuf, 0, NULL };
>  
>  	if (6 + len > sizeof(wbuf)) {
>  		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
> @@ -238,7 +238,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>  		} else {
>  			/* I2C */
>  			u8 buf[MAX_XFER_SIZE];
> -			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
> +			struct usb_req req = { CMD_I2C_RD, 0, 5 + msg[0].len,

You should check first if msg[0].len + 5 is not bigger than sizeof(buf).

>  					buf, msg[1].len, msg[1].buf };
>  
>  			if (5 + msg[0].len > sizeof(buf)) {
> @@ -274,8 +274,8 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>  		} else {
>  			/* I2C */
>  			u8 buf[MAX_XFER_SIZE];
> -			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
> -					0, NULL };
> +			struct usb_req req = { CMD_I2C_WR, 0, 5 + msg[0].len,
> +					buf, 0, NULL };

Same here: you should check first if msg[0].len + 5 is not bigger than sizeof(buf).

>  
>  			if (5 + msg[0].len > sizeof(buf)) {
>  				dev_warn(&d->udev->dev,


-- 

Cheers,
Mauro
