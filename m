Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:37583 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752515AbdFUA1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 20:27:21 -0400
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com [209.85.218.42])
        by imap.netup.ru (Postfix) with ESMTPSA id 9A2A78BB962
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 03:27:16 +0300 (MSK)
Received: by mail-oi0-f42.google.com with SMTP id p187so23705029oif.3
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 17:27:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170620195724.8271-1-d.scheller.oss@gmail.com>
References: <20170620195724.8271-1-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 20 Jun 2017 20:26:54 -0400
Message-ID: <CAK3bHNWgaUyHO0j75zBzrRyrF7Uf=Ki2WM9db7ykuPMVkG6BdQ@mail.gmail.com>
Subject: Re: [PATCH] [media] dvb-frontends/lnbh25: improve kernellog output
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kozlov Sergey <serjk@netup.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good for me.

Acked-by: Abylay Ospan <aospan@netup.ru>


2017-06-20 15:57 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> Use dev_dbg() in conjunction with the %*ph format macro to print the vmon
> status debug, thus hiding continuous hexdumping from default log levels.
> Also, change the attach success log line from error to info severity.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/lnbh25.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/lnbh25.c b/drivers/media/dvb-frontends/lnbh25.c
> index ef3021e964be..cb486e879fdd 100644
> --- a/drivers/media/dvb-frontends/lnbh25.c
> +++ b/drivers/media/dvb-frontends/lnbh25.c
> @@ -76,8 +76,8 @@ static int lnbh25_read_vmon(struct lnbh25_priv *priv)
>                         return ret;
>                 }
>         }
> -       print_hex_dump_bytes("lnbh25_read_vmon: ",
> -               DUMP_PREFIX_OFFSET, status, sizeof(status));
> +       dev_dbg(&priv->i2c->dev, "%s(): %*ph\n",
> +               __func__, (int) sizeof(status), status);
>         if ((status[0] & (LNBH25_STATUS_OFL | LNBH25_STATUS_VMON)) != 0) {
>                 dev_err(&priv->i2c->dev,
>                         "%s(): voltage in failure state, status reg 0x%x\n",
> @@ -178,7 +178,7 @@ struct dvb_frontend *lnbh25_attach(struct dvb_frontend *fe,
>         fe->ops.release_sec = lnbh25_release;
>         fe->ops.set_voltage = lnbh25_set_voltage;
>
> -       dev_err(&i2c->dev, "%s(): attached at I2C addr 0x%02x\n",
> +       dev_info(&i2c->dev, "%s(): attached at I2C addr 0x%02x\n",
>                 __func__, priv->i2c_address);
>         return fe;
>  }
> --
> 2.13.0
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
