Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:53014 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdI0LwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 07:52:02 -0400
Received: by mail-oi0-f41.google.com with SMTP id p126so16271070oih.9
        for <linux-media@vger.kernel.org>; Wed, 27 Sep 2017 04:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170926211021.11036-2-tvboxspy@gmail.com>
References: <20170926211021.11036-1-tvboxspy@gmail.com> <20170926211021.11036-2-tvboxspy@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 27 Sep 2017 13:52:01 +0200
Message-ID: <CAAeHK+xTS5EE_DG0LBWsxu5PPxsjYHMXiEKe7MdF_TVyJCFJOg@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: dvb-usb-v2: lmedm04: move ts2020 attach to dm04_lme2510_tuner
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 26, 2017 at 11:10 PM, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> When the tuner was split from m88rs2000 the attach function is in wrong
> place.
>
> Move to dm04_lme2510_tuner to trap errors on failure and removing
> a call to lme_coldreset.
>
> Prevents driver starting up without any tuner connected.
>
> Fixes to trap for ts2020 fail.
> LME2510(C): FE Found M88RS2000
> ts2020: probe of 0-0060 failed with error -11
> ...
> LME2510(C): TUN Found RS2000 tuner
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
>
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

Tested-by: Andrey Konovalov <andreyknvl@google.com>

These 2 patches fix the crash with the reproducer that I have.

Thanks!

> ---
>  drivers/media/usb/dvb-usb-v2/lmedm04.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index 992f2011a6ba..be26c029546b 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -1076,8 +1076,6 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
>
>                 if (adap->fe[0]) {
>                         info("FE Found M88RS2000");
> -                       dvb_attach(ts2020_attach, adap->fe[0], &ts2020_config,
> -                                       &d->i2c_adap);
>                         st->i2c_tuner_gate_w = 5;
>                         st->i2c_tuner_gate_r = 5;
>                         st->i2c_tuner_addr = 0x60;
> @@ -1143,17 +1141,18 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
>                         ret = st->tuner_config;
>                 break;
>         case TUNER_RS2000:
> -               ret = st->tuner_config;
> +               if (dvb_attach(ts2020_attach, adap->fe[0],
> +                              &ts2020_config, &d->i2c_adap))
> +                       ret = st->tuner_config;
>                 break;
>         default:
>                 break;
>         }
>
> -       if (ret)
> +       if (ret) {
>                 info("TUN Found %s tuner", tun_msg[ret]);
> -       else {
> -               info("TUN No tuner found --- resetting device");
> -               lme_coldreset(d);
> +       } else {
> +               info("TUN No tuner found");
>                 return -ENODEV;
>         }
>
> --
> 2.14.1
>
