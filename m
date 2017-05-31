Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:57757 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdEaMX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:23:29 -0400
Received: from mail-oi0-f45.google.com (mail-oi0-f45.google.com [209.85.218.45])
        by imap.netup.ru (Postfix) with ESMTPSA id 49B568B3F51
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:23:27 +0300 (MSK)
Received: by mail-oi0-f45.google.com with SMTP id l18so12912705oig.2
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:23:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-15-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-15-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:23:05 -0400
Message-ID: <CAK3bHNWeSsdA5aPm8MRkh5rac4=N9zMBjohm0ecg=7N_Nv6-Bg@mail.gmail.com>
Subject: Re: [PATCH 14/19] [media] dvb-frontends/cxd2841er: more configurable TSBITS
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>, rjkm@metzlerbros.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Abylay Ospan <aospan@netup.ru>

2017-04-09 15:38 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> Bits 3 and 4 of the TSCONFIG register are important for certain hardware
> constellations, in that they need to be zeroed. Add a configuration flag
> to toggle this.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 4 ++++
>  drivers/media/dvb-frontends/cxd2841er.h | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 67bd13c..efb2795 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3794,6 +3794,10 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
>         cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4,
>                 ((priv->flags & CXD2841ER_TS_SERIAL) ? 0x80 : 0x00), 0x80);
>
> +       /* clear TSCFG bits 3+4 */
> +       if (priv->flags & CXD2841ER_TSBITS)
> +               cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4, 0x00, 0x18);
> +
>         cxd2841er_init_stats(fe);
>
>         return 0;
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 4f94422..dc32f5fb 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -31,6 +31,7 @@
>  #define CXD2841ER_EARLY_TUNE   16      /* bit 4 */
>  #define CXD2841ER_NO_WAIT_LOCK 32      /* bit 5 */
>  #define CXD2841ER_NO_AGCNEG    64      /* bit 6 */
> +#define CXD2841ER_TSBITS       128     /* bit 7 */
>
>  enum cxd2841er_xtal {
>         SONY_XTAL_20500, /* 20.5 MHz */
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
