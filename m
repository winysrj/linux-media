Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:60206 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbeEPLEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 07:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <20180516084120.28674-1-suzuki.katsuhiro@socionext.com>
References: <20180516084120.28674-1-suzuki.katsuhiro@socionext.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 16 May 2018 06:56:58 -0400
Message-ID: <CAK3bHNVS26fjJVnccoTKAbT-nzd7RmY+3Y=DXddB+DWbgHTEmA@mail.gmail.com>
Subject: Re: [PATCH] media: helene: fix xtal frequency setting at power on
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Abylay Ospan <aospan@netup.ru>

2018-05-16 4:41 GMT-04:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>:
> This patch fixes crystal frequency setting when power on this device.
>
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> ---
>  drivers/media/dvb-frontends/helene.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
> index 0a4f312c4368..8fcf7a00782a 100644
> --- a/drivers/media/dvb-frontends/helene.c
> +++ b/drivers/media/dvb-frontends/helene.c
> @@ -924,7 +924,10 @@ static int helene_x_pon(struct helene_priv *priv)
>         helene_write_regs(priv, 0x99, cdata, sizeof(cdata));
>
>         /* 0x81 - 0x94 */
> -       data[0] = 0x18; /* xtal 24 MHz */
> +       if (priv->xtal == SONY_HELENE_XTAL_16000)
> +               data[0] = 0x10; /* xtal 16 MHz */
> +       else
> +               data[0] = 0x18; /* xtal 24 MHz */
>         data[1] = (uint8_t)(0x80 | (0x04 & 0x1F)); /* 4 x 25 = 100uA */
>         data[2] = (uint8_t)(0x80 | (0x26 & 0x7F)); /* 38 x 0.25 = 9.5pF */
>         data[3] = 0x80; /* REFOUT signal output 500mVpp */
> --
> 2.17.0
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
