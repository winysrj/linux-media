Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:40062 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaBDSuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 13:50:44 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N0H002WSJ0JHW50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Feb 2014 13:50:43 -0500 (EST)
Date: Tue, 04 Feb 2014 16:50:39 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] em28xx-i2c: remove duplicate error printing code from
 em28xx_i2c_xfer()
Message-id: <20140204165039.01ef46a0@samsung.com>
In-reply-to: <1390168117-2925-5-git-send-email-fschaefer.oss@googlemail.com>
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
 <1390168117-2925-5-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 19 Jan 2014 22:48:37 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c |   11 +++--------
>  1 Datei geändert, 3 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index a26d7d4..1a514ca 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -535,14 +535,9 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  			 * This code is only called during device probe.
>  			 */
>  			rc = i2c_check_for_device(i2c_bus, addr);
> -			if (rc < 0) {
> -				if (rc == -ENXIO) {
> -					if (i2c_debug > 1)
> -						printk(KERN_CONT " no device\n");
> -				} else {
> -					if (i2c_debug > 1)
> -						printk(KERN_CONT " ERROR: %i\n", rc);
> -				}
> +			if (rc == -ENXIO) {
> +				if (i2c_debug > 1)
> +					printk(KERN_CONT " no device\n");

Even if the previous patch were accepted, this one is wrong, as -ENXIO
doesn't always mean that there's no device. Also, other return codes
may happen here (like -EIO).

>  				rt_mutex_unlock(&dev->i2c_bus_lock);
>  				return rc;
>  			}


-- 

Cheers,
Mauro
