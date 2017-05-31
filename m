Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:38322 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdEaL75 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 07:59:57 -0400
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com [209.85.218.53])
        by imap.netup.ru (Postfix) with ESMTPSA id E2A2D8B3E90
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 14:59:55 +0300 (MSK)
Received: by mail-oi0-f53.google.com with SMTP id b204so12208394oii.1
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 04:59:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-8-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-8-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 07:59:33 -0400
Message-ID: <CAK3bHNW=vTWTn6nxtL2GEy0Q-ZFYynbknrRGhsx4VDyby1utxQ@mail.gmail.com>
Subject: Re: [PATCH 07/19] [media] dvb-frontends/cxd2841er: make call to
 i2c_gate_ctrl optional
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
> Some cards/bridges wrap i2c_gate_ctrl handling with a mutex_lock(). This is
> e.g. done in ddbridge to protect against concurrent tuner access with
> regards to the dual tuner HW, where concurrent tuner reconfiguration can
> result in tuning fails or bad reception quality. When the tuner driver
> additionally tries to open the I2C gate (which e.g. the tda18212 driver
> does) when the demod already did this, this will lead to a deadlock. This
> makes the calls to i2c_gatectrl from the demod driver optional when the
> flag is set, leaving this to the tuner driver. For readability reasons and
> to not have the check duplicated multiple times, the setup is factored
> into cxd2841er_tuner_set().
>
> This commit also updates the netup card driver (which seems to be the only
> consumer of the cxd2841er as of now).
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c            | 32 ++++++++++++++--------
>  drivers/media/dvb-frontends/cxd2841er.h            |  2 ++
>  drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  3 +-
>  3 files changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index f49a09b..162a0f5 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -327,6 +327,20 @@ static u32 cxd2841er_calc_iffreq(u32 ifhz)
>         return cxd2841er_calc_iffreq_xtal(SONY_XTAL_20500, ifhz);
>  }
>
> +static int cxd2841er_tuner_set(struct dvb_frontend *fe)
> +{
> +       struct cxd2841er_priv *priv = fe->demodulator_priv;
> +
> +       if ((priv->flags & CXD2841ER_USE_GATECTRL) && fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 1);
> +       if (fe->ops.tuner_ops.set_params)
> +               fe->ops.tuner_ops.set_params(fe);
> +       if ((priv->flags & CXD2841ER_USE_GATECTRL) && fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       return 0;
> +}
> +
>  static int cxd2841er_dvbs2_set_symbol_rate(struct cxd2841er_priv *priv,
>                                            u32 symbol_rate)
>  {
> @@ -3251,12 +3265,9 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
>                 dev_dbg(&priv->i2c->dev, "%s(): tune failed\n", __func__);
>                 goto done;
>         }
> -       if (fe->ops.i2c_gate_ctrl)
> -               fe->ops.i2c_gate_ctrl(fe, 1);
> -       if (fe->ops.tuner_ops.set_params)
> -               fe->ops.tuner_ops.set_params(fe);
> -       if (fe->ops.i2c_gate_ctrl)
> -               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       cxd2841er_tuner_set(fe);
> +
>         cxd2841er_tune_done(priv);
>         timeout = ((3000000 + (symbol_rate - 1)) / symbol_rate) + 150;
>         for (i = 0; i < timeout / CXD2841ER_DVBS_POLLING_INVL; i++) {
> @@ -3376,12 +3387,9 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
>         }
>         if (ret)
>                 goto done;
> -       if (fe->ops.i2c_gate_ctrl)
> -               fe->ops.i2c_gate_ctrl(fe, 1);
> -       if (fe->ops.tuner_ops.set_params)
> -               fe->ops.tuner_ops.set_params(fe);
> -       if (fe->ops.i2c_gate_ctrl)
> -               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       cxd2841er_tuner_set(fe);
> +
>         cxd2841er_tune_done(priv);
>         timeout = 2500;
>         while (timeout > 0) {
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 2fb8b38..15564af 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -24,6 +24,8 @@
>
>  #include <linux/dvb/frontend.h>
>
> +#define CXD2841ER_USE_GATECTRL 1
> +
>  enum cxd2841er_xtal {
>         SONY_XTAL_20500, /* 20.5 MHz */
>         SONY_XTAL_24000, /* 24 MHz */
> diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
> index 191bd82..5e6553f 100644
> --- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
> +++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
> @@ -122,7 +122,8 @@ static void netup_unidvb_queue_cleanup(struct netup_dma *dma);
>
>  static struct cxd2841er_config demod_config = {
>         .i2c_addr = 0xc8,
> -       .xtal = SONY_XTAL_24000
> +       .xtal = SONY_XTAL_24000,
> +       .flags = CXD2841ER_USE_GATECTRL
>  };
>
>  static struct horus3a_config horus3a_conf = {
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
