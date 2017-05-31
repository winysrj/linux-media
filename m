Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:40579 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbdEaMSE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:18:04 -0400
Received: from mail-oi0-f43.google.com (mail-oi0-f43.google.com [209.85.218.43])
        by imap.netup.ru (Postfix) with ESMTPSA id F37558B3F00
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:18:02 +0300 (MSK)
Received: by mail-oi0-f43.google.com with SMTP id b204so12763346oii.1
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:18:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-12-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-12-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:17:40 -0400
Message-ID: <CAK3bHNUKm8+ZB+9rZH56gbp2S=i6b7zSGCxhKTsb3pfJKXRMLA@mail.gmail.com>
Subject: Re: [PATCH 11/19] [media] dvb-frontends/cxd2841er: optionally tune
 earlier in set_frontend()
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
> When AUTO_IFHZ is set and the tuner is supposed to provide proper IF speed
> values, it should be possible to have the tuner setup take place before
> the demod is configured, else the demod might be configured with either
> wrong (old), or even no values at all, which obviously will cause issues.
> To set this behaviour in the most flexible way, this is done with a
> separate flag instead of making this depend on AUTO_IFHZ.
>
> It should be evaluated if tuning shouldn't take place earlier in all cases
> and hardware constellations.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 14 ++++++++++++--
>  drivers/media/dvb-frontends/cxd2841er.h |  1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 7ca589a..894cb5a 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3306,6 +3306,10 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
>                 __func__,
>                 (p->delivery_system == SYS_DVBS ? "DVB-S" : "DVB-S2"),
>                  p->frequency, symbol_rate, priv->xtal);
> +
> +       if (priv->flags & CXD2841ER_EARLY_TUNE)
> +               cxd2841er_tuner_set(fe);
> +
>         switch (priv->state) {
>         case STATE_SLEEP_S:
>                 ret = cxd2841er_sleep_s_to_active_s(
> @@ -3325,7 +3329,8 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
>                 goto done;
>         }
>
> -       cxd2841er_tuner_set(fe);
> +       if (!(priv->flags & CXD2841ER_EARLY_TUNE))
> +               cxd2841er_tuner_set(fe);
>
>         cxd2841er_tune_done(priv);
>         timeout = ((3000000 + (symbol_rate - 1)) / symbol_rate) + 150;
> @@ -3365,6 +3370,10 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
>
>         dev_dbg(&priv->i2c->dev, "%s() delivery_system=%d bandwidth_hz=%d\n",
>                  __func__, p->delivery_system, p->bandwidth_hz);
> +
> +       if (priv->flags & CXD2841ER_EARLY_TUNE)
> +               cxd2841er_tuner_set(fe);
> +
>         if (p->delivery_system == SYS_DVBT) {
>                 priv->system = SYS_DVBT;
>                 switch (priv->state) {
> @@ -3447,7 +3456,8 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
>         if (ret)
>                 goto done;
>
> -       cxd2841er_tuner_set(fe);
> +       if (!(priv->flags & CXD2841ER_EARLY_TUNE))
> +               cxd2841er_tuner_set(fe);
>
>         cxd2841er_tune_done(priv);
>         timeout = 2500;
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 90ced97..061e551 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -28,6 +28,7 @@
>  #define CXD2841ER_AUTO_IFHZ    2       /* bit 1 */
>  #define CXD2841ER_TS_SERIAL    4       /* bit 2 */
>  #define CXD2841ER_ASCOT                8       /* bit 3 */
> +#define CXD2841ER_EARLY_TUNE   16      /* bit 4 */
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
