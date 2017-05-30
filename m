Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:46374 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbdE3Qtc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 12:49:32 -0400
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com [209.85.218.44])
        by imap.netup.ru (Postfix) with ESMTPSA id ED50C8B295F
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 19:49:27 +0300 (MSK)
Received: by mail-oi0-f44.google.com with SMTP id l18so118743987oig.2
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 09:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-3-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-3-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 30 May 2017 12:49:05 -0400
Message-ID: <CAK3bHNWcsBTV5q=FugN4qxT4P+R1Vp1jpXtCcNcSrBSP5nciTQ@mail.gmail.com>
Subject: Re: [PATCH 02/19] [media] dvb-frontends/cxd2841er: do I2C reads in
 one go
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
> Doing the I2C read operation with two calls to i2c_transfer() causes the
> exclusive I2C bus lock of the underlying adapter to be released. While this
> isn't an issue if only one demodulator is attached to the bus, having two
> or even more causes troubles in that concurrent accesses to the different
> demods will cause all kinds of issues due to wrong data being returned on
> read operations (for example, the TS config register will be set wrong).
> This changes the read_regs() function to do the operation in one go (by
> calling i2c_transfer with the whole msg list instead of one by one) to not
> loose the I2C bus lock, fixing all sorts of random runtime failures.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 60d85ce..525d006 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -282,17 +282,8 @@ static int cxd2841er_read_regs(struct cxd2841er_priv *priv,
>                 }
>         };
>
> -       ret = i2c_transfer(priv->i2c, &msg[0], 1);
> -       if (ret >= 0 && ret != 1)
> -               ret = -EIO;
> -       if (ret < 0) {
> -               dev_warn(&priv->i2c->dev,
> -                       "%s: i2c rw failed=%d addr=%02x reg=%02x\n",
> -                       KBUILD_MODNAME, ret, i2c_addr, reg);
> -               return ret;
> -       }
> -       ret = i2c_transfer(priv->i2c, &msg[1], 1);
> -       if (ret >= 0 && ret != 1)
> +       ret = i2c_transfer(priv->i2c, msg, 2);
> +       if (ret >= 0 && ret != 2)
>                 ret = -EIO;
>         if (ret < 0) {
>                 dev_warn(&priv->i2c->dev,
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
