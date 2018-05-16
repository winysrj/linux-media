Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:37905 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751662AbeEPLEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 07:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <20180516084111.28618-1-suzuki.katsuhiro@socionext.com>
References: <20180516084111.28618-1-suzuki.katsuhiro@socionext.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 16 May 2018 06:58:13 -0400
Message-ID: <CAK3bHNW8=z2WH6xCijAP2XCX94iE5z-HwHRYNhbJwZvbOav10A@mail.gmail.com>
Subject: Re: [PATCH] media: helene: fix tuning frequency of satellite
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

True.
I'm curious but how did it worked before ...
Which hardware (dvb adapter) are you using ?

2018-05-16 4:41 GMT-04:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>:
> This patch fixes tuning frequency of satellite to kHz. That as same
> as terrestrial one.
>
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> ---
>  drivers/media/dvb-frontends/helene.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
> index 04033f0c278b..0a4f312c4368 100644
> --- a/drivers/media/dvb-frontends/helene.c
> +++ b/drivers/media/dvb-frontends/helene.c
> @@ -523,7 +523,7 @@ static int helene_set_params_s(struct dvb_frontend *fe)
>         enum helene_tv_system_t tv_system;
>         struct dtv_frontend_properties *p = &fe->dtv_property_cache;
>         struct helene_priv *priv = fe->tuner_priv;
> -       int frequencykHz = p->frequency;
> +       int frequencykHz = p->frequency / 1000;
>         uint32_t frequency4kHz = 0;
>         u32 symbol_rate = p->symbol_rate/1000;
>
> --
> 2.17.0
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
