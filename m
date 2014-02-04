Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:36048 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaBDSrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 13:47:40 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N0H00E6TIVFAP70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Feb 2014 13:47:39 -0500 (EST)
Date: Tue, 04 Feb 2014 16:47:34 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] em28xx-i2c: do not map -ENXIO errors to -ENODEV for
 empty i2c transfers
Message-id: <20140204164734.62354b70@samsung.com>
In-reply-to: <1390168117-2925-4-git-send-email-fschaefer.oss@googlemail.com>
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
 <1390168117-2925-4-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 19 Jan 2014 22:48:36 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Commit e63b009d6e "" changed the error codes i2c ACK errors from -ENODEV to -ENXIO.
> But it also introduced a line that maps -ENXIO back to -ENODEV in case of empty i2c
> messages, which makes no sense, because
> 1.) an ACK error is an ACK error no matter what the i2c message content is
> 2.) -ENXIO is perfectly suited for probing, too

I don't agree with this patch. 0-byte messages are only usin during device
probe.

> 3.) we are loosing the ability to distinguish USB device disconnects

Huh?

> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c |    1 -
>  1 Datei geändert, 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index ba6433c..a26d7d4 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -539,7 +539,6 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>  				if (rc == -ENXIO) {
>  					if (i2c_debug > 1)
>  						printk(KERN_CONT " no device\n");
> -					rc = -ENODEV;
>  				} else {
>  					if (i2c_debug > 1)
>  						printk(KERN_CONT " ERROR: %i\n", rc);


-- 

Cheers,
Mauro
