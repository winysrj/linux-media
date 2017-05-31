Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:35166 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751169AbdEaMDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:03:33 -0400
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com [209.85.218.54])
        by imap.netup.ru (Postfix) with ESMTPSA id BAB1F8B3E79
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:03:24 +0300 (MSK)
Received: by mail-oi0-f54.google.com with SMTP id w10so12357912oif.0
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:03:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-9-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-9-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:03:02 -0400
Message-ID: <CAK3bHNUievM6OoQTmrt5rGYD1LjxwNirnAw7=x2PCJ7Y372vSg@mail.gmail.com>
Subject: Re: [PATCH 08/19] [media] dvb-frontends/cxd2841er: support IF speed
 calc from tuner values
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
> Add a AUTO_IFHZ flag and a function that will read IF speed values from any
> attached tuner if the tuner supports this and if AUTO_IFHZ is enabled, and
> else the passed default value (which probably matches Sony ASCOT tuners)
> will be passed back. The returned value is then used to calculate the iffeq
> which the demod will be programmed with.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 64 +++++++++++++++++++++++----------
>  drivers/media/dvb-frontends/cxd2841er.h |  1 +
>  2 files changed, 47 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 162a0f5..fa6a963 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -327,6 +327,20 @@ static u32 cxd2841er_calc_iffreq(u32 ifhz)
>         return cxd2841er_calc_iffreq_xtal(SONY_XTAL_20500, ifhz);
>  }
>
> +static int cxd2841er_get_if_hz(struct cxd2841er_priv *priv, u32 def_hz)
> +{
> +       u32 hz;
> +
> +       if (priv->frontend.ops.tuner_ops.get_if_frequency
> +                       && (priv->flags & CXD2841ER_AUTO_IFHZ))
> +               priv->frontend.ops.tuner_ops.get_if_frequency(
> +                       &priv->frontend, &hz);
> +       else
> +               hz = def_hz;
> +
> +       return hz;
> +}
> +
>  static int cxd2841er_tuner_set(struct dvb_frontend *fe)
>  {
>         struct cxd2841er_priv *priv = fe->demodulator_priv;
> @@ -2147,7 +2161,7 @@ static int cxd2841er_dvbt2_set_plp_config(struct cxd2841er_priv *priv,
>  static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
>                                                 u32 bandwidth)
>  {
> -       u32 iffreq;
> +       u32 iffreq, ifhz;
>         u8 data[MAX_WRITE_REGSIZE];
>
>         const uint8_t nominalRate8bw[3][5] = {
> @@ -2253,7 +2267,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef8bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4800000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4800000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2281,7 +2296,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef7bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4200000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4200000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2309,7 +2325,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef6bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3600000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2337,7 +2354,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef5bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3600000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2365,7 +2383,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef17bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3500000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3500000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2384,7 +2403,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
>                 struct cxd2841er_priv *priv, u32 bandwidth)
>  {
>         u8 data[MAX_WRITE_REGSIZE];
> -       u32 iffreq;
> +       u32 iffreq, ifhz;
>         u8 nominalRate8bw[3][5] = {
>                 /* TRCG Nominal Rate [37:0] */
>                 {0x11, 0xF0, 0x00, 0x00, 0x00}, /* 20.5MHz XTal */
> @@ -2464,7 +2483,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef8bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4800000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4800000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2499,7 +2519,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef7bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4200000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4200000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2534,7 +2555,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef6bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3600000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2569,7 +2591,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
>                 cxd2841er_write_regs(priv, I2C_SLVT,
>                                 0xA6, itbCoef5bw[priv->xtal], 14);
>                 /* <IF freq setting> */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3600000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2602,7 +2625,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
>  static int cxd2841er_sleep_tc_to_active_i_band(
>                 struct cxd2841er_priv *priv, u32 bandwidth)
>  {
> -       u32 iffreq;
> +       u32 iffreq, ifhz;
>         u8 data[3];
>
>         /* TRCG Nominal Rate */
> @@ -2671,7 +2694,8 @@ static int cxd2841er_sleep_tc_to_active_i_band(
>                                 0xA6, itbCoef8bw[priv->xtal], 14);
>
>                 /* IF freq setting */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4750000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4750000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2700,7 +2724,8 @@ static int cxd2841er_sleep_tc_to_active_i_band(
>                                 0xA6, itbCoef7bw[priv->xtal], 14);
>
>                 /* IF freq setting */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4150000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4150000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2729,7 +2754,8 @@ static int cxd2841er_sleep_tc_to_active_i_band(
>                                 0xA6, itbCoef6bw[priv->xtal], 14);
>
>                 /* IF freq setting */
> -               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3550000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3550000);
> +               iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, ifhz);
>                 data[0] = (u8) ((iffreq >> 16) & 0xff);
>                 data[1] = (u8)((iffreq >> 8) & 0xff);
>                 data[2] = (u8)(iffreq & 0xff);
> @@ -2772,7 +2798,7 @@ static int cxd2841er_sleep_tc_to_active_c_band(struct cxd2841er_priv *priv,
>                 0x27, 0xA7, 0x28, 0xB3, 0x02, 0xF0, 0x01, 0xE8,
>                 0x00, 0xCF, 0x00, 0xE6, 0x23, 0xA4 };
>         u8 b10_b6[3];
> -       u32 iffreq;
> +       u32 iffreq, ifhz;
>
>         if (bandwidth != 6000000 &&
>                         bandwidth != 7000000 &&
> @@ -2790,13 +2816,15 @@ static int cxd2841er_sleep_tc_to_active_c_band(struct cxd2841er_priv *priv,
>                 cxd2841er_write_regs(
>                         priv, I2C_SLVT, 0xa6,
>                         bw7_8mhz_b10_a6, sizeof(bw7_8mhz_b10_a6));
> -               iffreq = cxd2841er_calc_iffreq(4900000);
> +               ifhz = cxd2841er_get_if_hz(priv, 4900000);
> +               iffreq = cxd2841er_calc_iffreq(ifhz);
>                 break;
>         case 6000000:
>                 cxd2841er_write_regs(
>                         priv, I2C_SLVT, 0xa6,
>                         bw6mhz_b10_a6, sizeof(bw6mhz_b10_a6));
> -               iffreq = cxd2841er_calc_iffreq(3700000);
> +               ifhz = cxd2841er_get_if_hz(priv, 3700000);
> +               iffreq = cxd2841er_calc_iffreq(ifhz);
>                 break;
>         default:
>                 dev_err(&priv->i2c->dev, "%s(): unsupported bandwidth %d\n",
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 15564af..38d7f9f 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -25,6 +25,7 @@
>  #include <linux/dvb/frontend.h>
>
>  #define CXD2841ER_USE_GATECTRL 1
> +#define CXD2841ER_AUTO_IFHZ    2
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
