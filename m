Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:52267 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbdEaMYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:24:22 -0400
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com [209.85.218.53])
        by imap.netup.ru (Postfix) with ESMTPSA id 63E308B3F66
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:24:20 +0300 (MSK)
Received: by mail-oi0-f53.google.com with SMTP id h4so12922217oib.3
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:24:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-16-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-16-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:23:58 -0400
Message-ID: <CAK3bHNXDV3V+UmsNJaCv1L9JBVbfcmuD+KOOVBx9gO-R5wHB7g@mail.gmail.com>
Subject: Re: [PATCH 15/19] [media] dvb-frontends/cxd2841er: improved snr reporting
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
> On DVB-T/T2 at least, SNR might be reported as >2500dB, which not only is
> just wrong but also ridiculous, so fix this by improving the conversion
> of the register value.
>
> The INTLOG10X100 function/macro and the way the values are converted were
> both taken from DD's cxd2843 driver.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index efb2795..a01ac58 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -38,6 +38,8 @@
>  #define MAX_WRITE_REGSIZE      16
>  #define LOG2_E_100X 144
>
> +#define INTLOG10X100(x) ((u32) (((u64) intlog10(x) * 100) >> 24))
> +
>  /* DVB-C constellation */
>  enum sony_dvbc_constellation_t {
>         SONY_DVBC_CONSTELLATION_16QAM,
> @@ -1817,7 +1819,7 @@ static int cxd2841er_read_snr_t(struct cxd2841er_priv *priv, u32 *snr)
>         }
>         if (reg > 4996)
>                 reg = 4996;
> -       *snr = 10000 * ((intlog10(reg) - intlog10(5350 - reg)) >> 24) + 28500;
> +       *snr = 100 * ((INTLOG10X100(reg) - INTLOG10X100(5350 - reg)) + 285);
>         return 0;
>  }
>
> @@ -1846,8 +1848,7 @@ static int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
>         }
>         if (reg > 10876)
>                 reg = 10876;
> -       *snr = 10000 * ((intlog10(reg) -
> -               intlog10(12600 - reg)) >> 24) + 32000;
> +       *snr = 100 * ((INTLOG10X100(reg) - INTLOG10X100(12600 - reg)) + 320);
>         return 0;
>  }
>
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
