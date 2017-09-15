Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36598 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdIOJaM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:30:12 -0400
Received: by mail-qt0-f193.google.com with SMTP id t46so1120871qtj.3
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 02:30:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <be4198870b124684d5ce566cb8176e7298eae371.1505466580.git.mchehab@s-opensource.com>
References: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
 <be4198870b124684d5ce566cb8176e7298eae371.1505466580.git.mchehab@s-opensource.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 15 Sep 2017 11:30:11 +0200
Message-ID: <CAJbz7-3UQntON2hj6=4SCr82G_TrXvU5Voz8OAV=BPw=F+8xeQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] media: stv6110: get rid of a srate dead code
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Max Kellermann <max.kellermann@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, you are so speedy :)

2017-09-15 11:10 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> The stv6110 has a weird code that checks if get_property
> and set_property ioctls are defined. If they're, it initializes
> a "srate" var from properties cache. Otherwise, it sets to
> 15MBaud, with won't make any sense.
>
> Thankfully, it seems that someone already noticed, as the
> "srate" is not used anywhere!

Hehe! "Someone else" :)

>
> So, get rid of that really weird dead code logic.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reported-by: Honza Petrous <jpetrous@gmail.com>

> ---
>  drivers/media/dvb-frontends/stv6110.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
> index e4fd9c1b0560..2821f6da6764 100644
> --- a/drivers/media/dvb-frontends/stv6110.c
> +++ b/drivers/media/dvb-frontends/stv6110.c
> @@ -262,7 +262,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
>         u8 ret = 0x04;
>         u32 divider, ref, p, presc, i, result_freq, vco_freq;
>         s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
> -       s32 srate;
>
>         dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
>                                                 frequency, priv->mclk);
> @@ -273,13 +272,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
>                                 ((((priv->mclk / 1000000) - 16) & 0x1f) << 3);
>
>         /* BB_GAIN = db/2 */
> -       if (fe->ops.set_property && fe->ops.get_property) {
> -               srate = c->symbol_rate;
> -               dprintk("%s: Get Frontend parameters: srate=%d\n",
> -                                                       __func__, srate);
> -       } else
> -               srate = 15000000;
> -
>         priv->regs[RSTV6110_CTRL2] &= ~0x0f;
>         priv->regs[RSTV6110_CTRL2] |= (priv->gain & 0x0f);
>
> --
> 2.13.5
>

Don't be offended, I simply smiled on the therm "someone else"

/Honza
