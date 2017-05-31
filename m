Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:55878 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdEaMTZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:19:25 -0400
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])
        by imap.netup.ru (Postfix) with ESMTPSA id 626308B3F13
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:19:23 +0300 (MSK)
Received: by mail-oi0-f46.google.com with SMTP id l18so12790712oig.2
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:19:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-13-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-13-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:19:01 -0400
Message-ID: <CAK3bHNWJm-Yqs8ruybo21CMugA8D2JMRCaUz62i6phs6TjF7Nw@mail.gmail.com>
Subject: Re: [PATCH 12/19] [media] dvb-frontends/cxd2841er: make lock wait in
 set_fe_tc() optional
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
> Don't wait for FE_HAS_LOCK in set_frontend_tc() and thus don't hammer the
> lock status register with inquiries when CXD2841ER_NO_WAIT_LOCK is set
> in the configuration, which also unneccessarily blocks applications until
> a TS LOCK has been acquired. Rather, API and applications will check for
> a TS LOCK by utilising the tune fe_op, read_status and get_frontend ops,
> which is sufficient.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 4 ++++
>  drivers/media/dvb-frontends/cxd2841er.h | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 894cb5a..67d4399 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3460,6 +3460,10 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
>                 cxd2841er_tuner_set(fe);
>
>         cxd2841er_tune_done(priv);
> +
> +       if (priv->flags & CXD2841ER_NO_WAIT_LOCK)
> +               goto done;
> +
>         timeout = 2500;
>         while (timeout > 0) {
>                 ret = cxd2841er_read_status_tc(fe, &status);
> diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
> index 061e551..d77b59f 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.h
> +++ b/drivers/media/dvb-frontends/cxd2841er.h
> @@ -29,6 +29,7 @@
>  #define CXD2841ER_TS_SERIAL    4       /* bit 2 */
>  #define CXD2841ER_ASCOT                8       /* bit 3 */
>  #define CXD2841ER_EARLY_TUNE   16      /* bit 4 */
> +#define CXD2841ER_NO_WAIT_LOCK 32      /* bit 5 */
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
