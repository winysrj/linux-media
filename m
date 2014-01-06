Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:40854 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaAFNAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 08:00:10 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYZ00BY4DG9FU40@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Jan 2014 08:00:09 -0500 (EST)
Date: Mon, 06 Jan 2014 11:00:04 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] xc2028: disable device power-down because power state
 handling is broken
Message-id: <20140106110004.041e4fe6@samsung.com>
In-reply-to: <1388410678-12641-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1388410678-12641-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 14:37:58 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> xc2028 power state handling is broken.
> I2C read/write operations fail when the device is powered down at that moment,
> which causes the get_rf_strength and get_rf_strength callbacks (and probably
> others, too) to fail.
> I don't know how to fix this properly, so disable the device power-down until
> anyone comes up with a better solution.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/tuners/tuner-xc2028.c |    4 +++-
>  1 Datei geändert, 3 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
> index 4be5cf8..cb3dc5e 100644
> --- a/drivers/media/tuners/tuner-xc2028.c
> +++ b/drivers/media/tuners/tuner-xc2028.c
> @@ -1291,16 +1291,18 @@ static int xc2028_sleep(struct dvb_frontend *fe)
>  		dump_stack();
>  	}
>  
> +	/* FIXME: device power-up/-down handling is broken */
> +/*
>  	mutex_lock(&priv->lock);
>  
>  	if (priv->firm_version < 0x0202)
>  		rc = send_seq(priv, {0x00, XREG_POWER_DOWN, 0x00, 0x00});
>  	else
>  		rc = send_seq(priv, {0x80, XREG_POWER_DOWN, 0x00, 0x00});
> -
>  	priv->state = XC2028_SLEEP;
>  
>  	mutex_unlock(&priv->lock);
> +*/

This patch is completely broken.

First of all, there are both modprobe and config parameters that disables
the poweroff mode.

Second, it doesn't fix the bug, just hides it.

Third, it keeps the xc3028 energized, with spends power and heats the
device, with reduces its lifetime.

I'm working on a proper fix for it.

Cheers,
Mauro
