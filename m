Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55014 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab0BCUpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 15:45:11 -0500
Received: by bwz19 with SMTP id 19so512794bwz.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 12:45:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B69DE57.4030509@arcor.de>
References: <4B673790.3030706@arcor.de> <4B675B19.3080705@redhat.com>
	 <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>
	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>
	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>
	 <4B69D8CC.2030008@arcor.de> <4B69DE57.4030509@arcor.de>
Date: Wed, 3 Feb 2010 15:45:08 -0500
Message-ID: <829197381002031245h50f4ec05p2eaef0628465b454@mail.gmail.com>
Subject: Re: [PATCH 13/15] - xc2028 bugfix for firmware 3.6 -> Zarlink use
	without shift in DTV8 or DTV78
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 3:36 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> --- a/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/drivers/media/common/tuners/tuner-xc2028.c
> @@ -1114,7 +1122,11 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>
>     /* All S-code tables need a 200kHz shift */
>     if (priv->ctrl.demod) {
> -        demod = priv->ctrl.demod + 200;
> +        if ((priv->ctrl.fname == "xc3028L-v36.fw") && (priv->ctrl.demod
> == XC3028_FE_ZARLINK456) && ((type & DTV78) | (type & DTV8)) ) {
> +            demod = priv->ctrl.demod;
> +        } else {
> +            demod = priv->ctrl.demod + 200;
> +        }
>         /*
>          * The DTV7 S-code table needs a 700 kHz shift.
>          * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
> @@ -1123,8 +1135,8 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>          * use this firmware after initialization, but a tune to a UHF
>          * channel should then cause DTV78 to be used.
>          */
> -        if (type & DTV7)
> -            demod += 500;
> +        if (type & DTV7)
> +            demod += 500;
>     }

Independent of the validity of this patch, you should not be
submitting patches that have a mix of whitespace changes and actual
changes.  In the above case (the if type & DTV7 part), it looks like
these shouldn't have been included at all since it makes no functional
change.

It sounds like a nit-pick, but the reality is that its inclusion had
me staring at it for 30 seconds trying to figure out whether there was
an *actual* difference there or if it was purely whitespace.

>
>     return generic_set_freq(fe, p->frequency,
> @@ -1240,6 +1252,10 @@ static const struct dvb_tuner_ops
> xc2028_dvb_tuner_ops = {
>     .get_rf_strength   = xc2028_signal,
>     .set_params        = xc2028_set_params,
>     .sleep             = xc2028_sleep,
> +#if 0
> +    int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
> +    int (*get_status)(struct dvb_frontend *fe, u32 *status);
> +#endif
>  };

Likewise, you should not be including unrelated changes in patches -
the above "#if 0" section not only is never compiled in to the code
(presumably it is debug code), but it has nothing to do with the fix
this patch is claiming to address.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
