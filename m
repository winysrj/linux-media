Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42043 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaAASwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 13:52:23 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so5077125eek.41
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 10:52:22 -0800 (PST)
Message-ID: <52C46428.1060101@googlemail.com>
Date: Wed, 01 Jan 2014 19:53:28 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: unlisted-recipients:; Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 12/24] tuner-xc2028: remove unused code
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com> <1388232976-20061-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-13-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.12.2013 13:16, schrieb Mauro Carvalho Chehab:
> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
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
Looks good and works, so this patch can is ready for the media tree.


