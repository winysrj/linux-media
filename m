Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:58082 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdEaMTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:19:51 -0400
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])
        by imap.netup.ru (Postfix) with ESMTPSA id 315DE8B3F2B
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:19:50 +0300 (MSK)
Received: by mail-oi0-f46.google.com with SMTP id b204so12817938oii.1
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-14-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-14-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:19:28 -0400
Message-ID: <CAK3bHNW1aoeebRGMbTnPjVo563L2cP9_iY2k51zusNBnL4QsHQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] [media] dvb-frontends/cxd2841er: configurable IFAGCNEG
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
> Adds a flag to enable or disable the IFAGCNEG bit in cxd2841er_init_tc().
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 5 +++--
>  drivers/media/dvb-frontends/cxd2841er.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 67d4399..67bd13c 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3783,9 +3783,10 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
>         dev_dbg(&priv->i2c->dev, "%s() bandwidth_hz=%d\n",
>                         __func__, p->bandwidth_hz);
>         cxd2841er_shutdown_to_sleep_tc(priv);
> -       /* SONY_DEMOD_CONFIG_IFAGCNEG = 1 */
> +       /* SONY_DEMOD_CONFIG_IFAGCNEG = 1 (0 for NO_AGCNEG */
>         cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
> -       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xcb, 0x40, 0x40);
> +       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xcb,
> +               ((priv->flags & CXD2841ER_NO_AGCNEG) ? 0x00 : 0x40), 0x40);
>         /* SONY_DEMOD_CONFIG_IFAGC_ADC_FS = 0 */
>         cxd2841er_write_reg(priv, I2C_SLVT, 0xcd, 0x50);
>         /* SONY_DEMOD_CONFIG_PARALLEL_SEL = 1 */
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index d77b59f..4f94422 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -30,6 +30,7 @@
>  #define CXD2841ER_ASCOT                8       /* bit 3 */
>  #define CXD2841ER_EARLY_TUNE   16      /* bit 4 */
>  #define CXD2841ER_NO_WAIT_LOCK 32      /* bit 5 */
> +#define CXD2841ER_NO_AGCNEG    64      /* bit 6 */
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
