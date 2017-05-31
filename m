Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:59085 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdEaCsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 22:48:43 -0400
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com [209.85.223.172])
        by imap.netup.ru (Postfix) with ESMTPSA id CE6CF8B31C4
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:48:40 +0300 (MSK)
Received: by mail-io0-f172.google.com with SMTP id f102so6653826ioi.2
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 19:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-5-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-5-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 30 May 2017 22:48:18 -0400
Message-ID: <CAK3bHNWaLZaBbTrdPHshuyojjbEv64hFQWT5LWE1zixu27VWqA@mail.gmail.com>
Subject: Re: [PATCH 04/19] [media] dvb-frontends/cxd2841er: support
 CXD2837/38/43ER demods/Chip IDs
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
> Those demods are programmed in the same way as the CXD2841ER/54ER and can
> be handled by this driver. Support added in a way matching the existing
> code, supported delivery systems are set according to what each demod
> supports.
>
> Updates the type string setting used for printing the "attaching..." log
> line aswell.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c      | 24 +++++++++++++++++++++++-
>  drivers/media/dvb-frontends/cxd2841er_priv.h |  3 +++
>  2 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 09c25d7..72a27cc 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3733,16 +3733,39 @@ static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
>                 priv->i2c_addr_slvx, priv->i2c_addr_slvt);
>         chip_id = cxd2841er_chip_id(priv);
>         switch (chip_id) {
> +       case CXD2837ER_CHIP_ID:
> +               snprintf(cxd2841er_t_c_ops.info.name, 128,
> +                               "Sony CXD2837ER DVB-T/T2/C demodulator");
> +               name = "CXD2837ER";
> +               type = "C/T/T2";
> +               break;
> +       case CXD2838ER_CHIP_ID:
> +               snprintf(cxd2841er_t_c_ops.info.name, 128,
> +                               "Sony CXD2838ER ISDB-T demodulator");
> +               cxd2841er_t_c_ops.delsys[0] = SYS_ISDBT;
> +               cxd2841er_t_c_ops.delsys[1] = SYS_UNDEFINED;
> +               cxd2841er_t_c_ops.delsys[2] = SYS_UNDEFINED;
> +               name = "CXD2838ER";
> +               type = "ISDB-T";
> +               break;
>         case CXD2841ER_CHIP_ID:
>                 snprintf(cxd2841er_t_c_ops.info.name, 128,
>                                 "Sony CXD2841ER DVB-T/T2/C demodulator");
>                 name = "CXD2841ER";
> +               type = "T/T2/C/ISDB-T";
> +               break;
> +       case CXD2843ER_CHIP_ID:
> +               snprintf(cxd2841er_t_c_ops.info.name, 128,
> +                               "Sony CXD2843ER DVB-T/T2/C/C2 demodulator");
> +               name = "CXD2843ER";
> +               type = "C/C2/T/T2";
>                 break;
>         case CXD2854ER_CHIP_ID:
>                 snprintf(cxd2841er_t_c_ops.info.name, 128,
>                                 "Sony CXD2854ER DVB-T/T2/C and ISDB-T demodulator");
>                 cxd2841er_t_c_ops.delsys[3] = SYS_ISDBT;
>                 name = "CXD2854ER";
> +               type = "C/C2/T/T2/ISDB-T";
>                 break;
>         default:
>                 dev_err(&priv->i2c->dev, "%s(): invalid chip ID 0x%02x\n",
> @@ -3762,7 +3785,6 @@ static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
>                 memcpy(&priv->frontend.ops,
>                         &cxd2841er_t_c_ops,
>                         sizeof(struct dvb_frontend_ops));
> -               type = "T/T2/C/ISDB-T";
>         }
>
>         dev_info(&priv->i2c->dev,
> diff --git a/drivers/media/dvb-frontends/cxd2841er_priv.h b/drivers/media/dvb-frontends/cxd2841er_priv.h
> index 0bbce45..6a71264 100644
> --- a/drivers/media/dvb-frontends/cxd2841er_priv.h
> +++ b/drivers/media/dvb-frontends/cxd2841er_priv.h
> @@ -25,7 +25,10 @@
>  #define I2C_SLVX                       0
>  #define I2C_SLVT                       1
>
> +#define CXD2837ER_CHIP_ID              0xb1
> +#define CXD2838ER_CHIP_ID              0xb0
>  #define CXD2841ER_CHIP_ID              0xa7
> +#define CXD2843ER_CHIP_ID              0xa4
>  #define CXD2854ER_CHIP_ID              0xc1
>
>  #define CXD2841ER_DVBS_POLLING_INVL    10
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
