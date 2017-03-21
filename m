Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:34344 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755077AbdCUAbY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 20:31:24 -0400
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com [209.85.218.42])
        by imap.netup.ru (Postfix) with ESMTPSA id C5CA988CD8A
        for <linux-media@vger.kernel.org>; Tue, 21 Mar 2017 03:23:53 +0300 (MSK)
Received: by mail-oi0-f42.google.com with SMTP id q19so30195420oic.0
        for <linux-media@vger.kernel.org>; Mon, 20 Mar 2017 17:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170319152639.18285-1-d.scheller.oss@gmail.com>
References: <20170319152639.18285-1-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 20 Mar 2017 20:23:31 -0400
Message-ID: <CAK3bHNWss4RNsWEziy9jKsRHJZ=5fKrMCgPW9awnLyO8Ub1vKQ@mail.gmail.com>
Subject: Re: [PATCH] [media] dvb-frontends/cxd2841er: define
 symbol_rate_min/max in T/C fe-ops
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Kozlov Sergey <serjk@netup.ru>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

looks good for me.
Acked-by: Abylay Ospan <aospan@netup.ru>

2017-03-19 11:26 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> Fixes "w_scan -f c" complaining with
>
>   This dvb driver is *buggy*: the symbol rate limits are undefined - please
>   report to linuxtv.org)
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 614bfb3..ce37dc2 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3852,7 +3852,9 @@ static struct dvb_frontend_ops cxd2841er_t_c_ops = {
>                         FE_CAN_MUTE_TS |
>                         FE_CAN_2G_MODULATION,
>                 .frequency_min = 42000000,
> -               .frequency_max = 1002000000
> +               .frequency_max = 1002000000,
> +               .symbol_rate_min = 870000,
> +               .symbol_rate_max = 11700000
>         },
>         .init = cxd2841er_init_tc,
>         .sleep = cxd2841er_sleep_tc,
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
