Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55641 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaAELGn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 06:06:43 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so7402859eek.31
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 03:06:42 -0800 (PST)
Message-ID: <52C93D07.4030405@googlemail.com>
Date: Sun, 05 Jan 2014 12:07:51 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 10/22] [media] tuner-xc2028: remove unused code
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-11-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> This macro is not used. remove it.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/tuners/tuner-xc2028.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
> index 4be5cf808a40..1057da54c6e0 100644
> --- a/drivers/media/tuners/tuner-xc2028.c
> +++ b/drivers/media/tuners/tuner-xc2028.c
> @@ -134,15 +134,6 @@ struct xc2028_data {
>  	_rc;								\
>  })
>  
> -#define i2c_rcv(priv, buf, size) ({					\
> -	int _rc;							\
> -	_rc = tuner_i2c_xfer_recv(&priv->i2c_props, buf, size);		\
> -	if (size != _rc)						\
> -		tuner_err("i2c input error: rc = %d (should be %d)\n",	\
> -			   _rc, (int)size); 				\
> -	_rc;								\
> -})
> -
>  #define i2c_send_recv(priv, obuf, osize, ibuf, isize) ({		\
>  	int _rc;							\
>  	_rc = tuner_i2c_xfer_send_recv(&priv->i2c_props, obuf, osize,	\

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

