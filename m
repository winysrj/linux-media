Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:46998 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbdEaL5w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 07:57:52 -0400
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com [209.85.218.51])
        by imap.netup.ru (Postfix) with ESMTPSA id 8F0A78B3E6D
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 14:57:50 +0300 (MSK)
Received: by mail-oi0-f51.google.com with SMTP id l18so12140903oig.2
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 04:57:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-7-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-7-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 07:57:28 -0400
Message-ID: <CAK3bHNVwBE6WWH07dZeUO5PbdTBrg3szZwcRPWvo7SuXDkYmOQ@mail.gmail.com>
Subject: Re: [PATCH 06/19] [media] dvb-frontends/cxd2841er: add variable for
 configuration flags
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
> Throughout the patch series some configuration flags will be added to the
> demod driver. This patch prepares this by adding the flags var to
> struct cxd2841er_config, which will serve as a bitmask to toggle various
> options and behaviour in the driver.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 2 ++
>  drivers/media/dvb-frontends/cxd2841er.h | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 6648bd1..f49a09b 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -65,6 +65,7 @@ struct cxd2841er_priv {
>         u8                              system;
>         enum cxd2841er_xtal             xtal;
>         enum fe_caps caps;
> +       u32                             flags;
>  };
>
>  static const struct cxd2841er_cnr_data s_cn_data[] = {
> @@ -3736,6 +3737,7 @@ static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
>         priv->i2c_addr_slvx = (cfg->i2c_addr + 4) >> 1;
>         priv->i2c_addr_slvt = (cfg->i2c_addr) >> 1;
>         priv->xtal = cfg->xtal;
> +       priv->flags = cfg->flags;
>         priv->frontend.demodulator_priv = priv;
>         dev_info(&priv->i2c->dev,
>                 "%s(): I2C adapter %p SLVX addr %x SLVT addr %x\n",
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 7f1acfb..2fb8b38 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -33,6 +33,7 @@ enum cxd2841er_xtal {
>  struct cxd2841er_config {
>         u8      i2c_addr;
>         enum cxd2841er_xtal     xtal;
> +       u32     flags;
>  };
>
>  #if IS_REACHABLE(CONFIG_DVB_CXD2841ER)
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
