Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:40843 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754071AbeFUDJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 23:09:07 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "Abylay Ospan" <aospan@netup.ru>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        <linux-media@vger.kernel.org>
Cc: "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        =?iso-2022-jp?B?U3V6dWtpLCBLYXRzdWhpcm8vGyRCTmtMWhsoQiAbJEI+IUduGyhC?=
        <suzuki.katsuhiro@socionext.com>
References: <20180529010920.20320-1-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180529010920.20320-1-suzuki.katsuhiro@socionext.com>
Subject: Re: [RESEND PATCH] media: helene: fix xtal frequency setting at power on
Date: Thu, 21 Jun 2018 12:09:01 +0900
Message-ID: <001f01d4090d$34a04310$9de0c930$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Ping...

If I got some mistake, please comment it...

Regards,
--
Katsuhiro Suzuki


> -----Original Message-----
> From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> Sent: Tuesday, May 29, 2018 10:09 AM
> To: Abylay Ospan <aospan@netup.ru>; Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org>; linux-media@vger.kernel.org
> Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>; Jassi Brar
> <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Suzuki, Katsuhiro/鈴木 勝博
> <suzuki.katsuhiro@socionext.com>
> Subject: [RESEND PATCH] media: helene: fix xtal frequency setting at power on
> 
> This patch fixes crystal frequency setting when power on this device.
> 
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> Acked-by: Abylay Ospan <aospan@netup.ru>
> 
> ---
> 
> Changes from before:
>   - Add Abylay's Ack
> 
> ---
>  drivers/media/dvb-frontends/helene.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/helene.c
> b/drivers/media/dvb-frontends/helene.c
> index 0a4f312c4368..8fcf7a00782a 100644
> --- a/drivers/media/dvb-frontends/helene.c
> +++ b/drivers/media/dvb-frontends/helene.c
> @@ -924,7 +924,10 @@ static int helene_x_pon(struct helene_priv *priv)
>  	helene_write_regs(priv, 0x99, cdata, sizeof(cdata));
> 
>  	/* 0x81 - 0x94 */
> -	data[0] = 0x18; /* xtal 24 MHz */
> +	if (priv->xtal == SONY_HELENE_XTAL_16000)
> +		data[0] = 0x10; /* xtal 16 MHz */
> +	else
> +		data[0] = 0x18; /* xtal 24 MHz */
>  	data[1] = (uint8_t)(0x80 | (0x04 & 0x1F)); /* 4 x 25 = 100uA */
>  	data[2] = (uint8_t)(0x80 | (0x26 & 0x7F)); /* 38 x 0.25 = 9.5pF */
>  	data[3] = 0x80; /* REFOUT signal output 500mVpp */
> --
> 2.17.0
