Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:37548 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdEaMFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:05:07 -0400
Received: from mail-oi0-f52.google.com (mail-oi0-f52.google.com [209.85.218.52])
        by imap.netup.ru (Postfix) with ESMTPSA id 7EA2F8B3EB3
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:05:05 +0300 (MSK)
Received: by mail-oi0-f52.google.com with SMTP id l18so12359663oig.2
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:05:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-10-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-10-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:04:43 -0400
Message-ID: <CAK3bHNX6fJhVEvb+ORx+bzm9ED=TT_ZQ3NkQxMhvAW=14gB--w@mail.gmail.com>
Subject: Re: [PATCH 09/19] [media] dvb-frontends/cxd2841er: TS_SERIAL config flag
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
> Some constellations work/need a serial TS transport mode. This adds a flag
> that will toggle set up of such mode.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 18 ++++++++++++++++--
>  drivers/media/dvb-frontends/cxd2841er.h |  5 +++--
>  2 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index fa6a963..1df95c4 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -912,6 +912,18 @@ static void cxd2841er_set_ts_clock_mode(struct cxd2841er_priv *priv,
>
>         /*
>          * slave    Bank    Addr    Bit    default    Name
> +        * <SLV-T>  00h     C4h     [1:0]  2'b??      OSERCKMODE
> +        */
> +       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4,
> +               ((priv->flags & CXD2841ER_TS_SERIAL) ? 0x01 : 0x00), 0x03);
> +       /*
> +        * slave    Bank    Addr    Bit    default    Name
> +        * <SLV-T>  00h     D1h     [1:0]  2'b??      OSERDUTYMODE
> +        */
> +       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xd1,
> +               ((priv->flags & CXD2841ER_TS_SERIAL) ? 0x01 : 0x00), 0x03);
> +       /*
> +        * slave    Bank    Addr    Bit    default    Name
>          * <SLV-T>  00h     D9h     [7:0]  8'h08      OTSCKPERIOD
>          */
>         cxd2841er_write_reg(priv, I2C_SLVT, 0xd9, 0x08);
> @@ -925,7 +937,8 @@ static void cxd2841er_set_ts_clock_mode(struct cxd2841er_priv *priv,
>          * slave    Bank    Addr    Bit    default    Name
>          * <SLV-T>  00h     33h     [1:0]  2'b01      OREG_CKSEL_TSIF
>          */
> -       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x33, 0x00, 0x03);
> +       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x33,
> +               ((priv->flags & CXD2841ER_TS_SERIAL) ? 0x01 : 0x00), 0x03);
>         /*
>          * Enable TS IF Clock
>          * slave    Bank    Addr    Bit    default    Name
> @@ -3745,7 +3758,8 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
>         cxd2841er_write_reg(priv, I2C_SLVT, 0xcd, 0x50);
>         /* SONY_DEMOD_CONFIG_PARALLEL_SEL = 1 */
>         cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x00);
> -       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4, 0x00, 0x80);
> +       cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4,
> +               ((priv->flags & CXD2841ER_TS_SERIAL) ? 0x80 : 0x00), 0x80);
>
>         cxd2841er_init_stats(fe);
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 38d7f9f..58fbd98 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -24,8 +24,9 @@
>
>  #include <linux/dvb/frontend.h>
>
> -#define CXD2841ER_USE_GATECTRL 1
> -#define CXD2841ER_AUTO_IFHZ    2
> +#define CXD2841ER_USE_GATECTRL 1       /* bit 0 */
> +#define CXD2841ER_AUTO_IFHZ    2       /* bit 1 */
> +#define CXD2841ER_TS_SERIAL    4       /* bit 2 */
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
