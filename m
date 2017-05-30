Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:49924 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751767AbdE3OqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 10:46:07 -0400
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com [209.85.218.48])
        by imap.netup.ru (Postfix) with ESMTPSA id 1BC988B265D
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 17:46:06 +0300 (MSK)
Received: by mail-oi0-f48.google.com with SMTP id w10so114114073oif.0
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 07:46:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-2-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-2-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 30 May 2017 10:45:43 -0400
Message-ID: <CAK3bHNWwuoAdX01xGDWvJh1kdx25Lyt+MSPNCVAcPZew03wD6A@mail.gmail.com>
Subject: Re: [PATCH 01/19] [media] dvb-frontends/cxd2841er: remove kernel log
 spam in non-debug levels
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
> This moves the I2C debug dump into the preceding dev_dbg() call by
> utilising the %*ph format macro and removes the call to
> print_hex_debug_bytes().
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 614bfb3..60d85ce 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -214,10 +214,8 @@ static void cxd2841er_i2c_debug(struct cxd2841er_priv *priv,
>                                 const u8 *data, u32 len)
>  {
>         dev_dbg(&priv->i2c->dev,
> -               "cxd2841er: I2C %s addr %02x reg 0x%02x size %d\n",
> -               (write == 0 ? "read" : "write"), addr, reg, len);
> -       print_hex_dump_bytes("cxd2841er: I2C data: ",
> -               DUMP_PREFIX_OFFSET, data, len);
> +               "cxd2841er: I2C %s addr %02x reg 0x%02x size %d data %*ph\n",
> +               (write == 0 ? "read" : "write"), addr, reg, len, len, data);
>  }
>
>  static int cxd2841er_write_regs(struct cxd2841er_priv *priv,
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
