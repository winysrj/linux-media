Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1IRMoM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 08:44:12 -0400
Message-ID: <4E75E799.1010307@redhat.com>
Date: Sun, 18 Sep 2011 09:44:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] FM1216ME_MK3 AUX byte for FM mode
References: <20090423154046.7b54f7cc@glory.loctelecom.ru>
In-Reply-To: <20090423154046.7b54f7cc@glory.loctelecom.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitri,

Em 23-04-2009 02:40, Dmitri Belimov escreveu:
> Hi All
> 
> Write AUX byte to FM1216ME_MK3 when FM mode, better sensitivity. It can be
> usefull for other tuners.

Hmm... Found this patch. It were never applied, but it may make some sense
to apply it.

Could you please double-check if this patch is still valid, and, if so, re-send it
to me?

Thanks!
Mauro


> 
> diff -r 00a84f86671d linux/drivers/media/common/tuners/tuner-simple.c
> --- a/linux/drivers/media/common/tuners/tuner-simple.c	Mon Apr 20 22:07:44 2009 +0000
> +++ b/linux/drivers/media/common/tuners/tuner-simple.c	Thu Apr 23 10:26:54 2009 +1000
> @@ -751,6 +751,17 @@
>  	if (4 != rc)
>  		tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
>  
> +	/* Write AUX byte */
> +	switch (priv->type) {
> +	case TUNER_PHILIPS_FM1216ME_MK3:
> +		buffer[2] = 0x98;
> +		buffer[3] = 0x20; /* set TOP AGC */
> +		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
> +		if (4 != rc)
> +			tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
> +		break;
> +	}
> +
>  	return 0;
>  }
>  
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
> 
> 
> With my best regards, Dmitry.

