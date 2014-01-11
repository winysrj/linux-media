Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58370 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaAKNN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 08:13:28 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so1960312eek.34
        for <linux-media@vger.kernel.org>; Sat, 11 Jan 2014 05:13:27 -0800 (PST)
Message-ID: <52D143BE.3090607@googlemail.com>
Date: Sat, 11 Jan 2014 14:14:38 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 3/3] [media] em28xx: add timeout debug information
 if i2c_debug enabled
References: <1389342820-12605-1-git-send-email-m.chehab@samsung.com> <1389342820-12605-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389342820-12605-4-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.01.2014 09:33, schrieb Mauro Carvalho Chehab:
> If i2c_debug is enabled, we splicitly want to know when a
> device fails with timeout.
>
> If i2c_debug==2, this is already provided, for each I2C transfer
> that fails.
>
> However, most of the time, we don't need to go that far. We just
> want to know that I2C transfers fail.
>
> So, add such errors for normal (ret == 0x10) I2C aborted timeouts.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index e8eb83160d36..7e1724076ac4 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -80,6 +80,9 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		if (ret == 0x80 + len - 1)
>  			return len;
>  		if (ret == 0x94 + len - 1) {
> +			if (i2c_debug == 1)
> +				em28xx_warn("R05 returned 0x%02x: I2C timeout",
> +					    ret);
>  			return -ENXIO;
>  		}
>  		if (ret < 0) {
> @@ -124,6 +127,9 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		if (ret == 0x84 + len - 1)
>  			break;
>  		if (ret == 0x94 + len - 1) {
> +			if (i2c_debug == 1)
> +				em28xx_warn("R05 returned 0x%02x: I2C timeout",
> +					    ret);
>  			return -ENXIO;
>  		}
>  		if (ret < 0) {
> @@ -203,6 +209,9 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  		if (ret == 0) /* success */
>  			return len;
>  		if (ret == 0x10) {
> +			if (i2c_debug == 1)
> +				em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> +					    addr);
>  			return -ENXIO;
>  		}
>  		if (ret < 0) {
> @@ -263,8 +272,12 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
>  			    ret);
>  		return ret;
>  	}
> -	if (ret == 0x10)
> +	if (ret == 0x10) {
> +		if (i2c_debug == 1)
> +			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> +				    addr);
>  		return -ENXIO;
> +	}
>  
>  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
>  	return -ETIMEDOUT;
> @@ -322,8 +335,12 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	 */
>  	if (!ret)
>  		return len;
> -	else if (ret > 0)
> +	else if (ret > 0) {
> +		if (i2c_debug == 1)
> +			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
> +				    ret);
>  		return -ENXIO;
> +	}
>  
>  	return ret;
>  	/*
> @@ -373,8 +390,12 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	 */
>  	if (!ret)
>  		return len;
> -	else if (ret > 0)
> +	else if (ret > 0) {
> +		if (i2c_debug == 1)
> +			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
> +				    ret);
>  		return -ENXIO;
> +	}
>  
>  	return ret;
>  	/*

The error description should be "I2C ACK error".

You are using (i2c_debug == 1) checks here, which should either be
changed to (i2c_debug > 0) in case of 3 debug levels.


