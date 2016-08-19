Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36561 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755045AbcHSWXV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 18:23:21 -0400
Received: by mail-pa0-f44.google.com with SMTP id pp5so19663720pac.3
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2016 15:23:20 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, carlo@caione.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        mchehab@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/6] pinctrl: amlogic: gxbb: add the IR remote pin
References: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
        <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
        <20160819215547.20063-2-martin.blumenstingl@googlemail.com>
Date: Fri, 19 Aug 2016 15:23:19 -0700
In-Reply-To: <20160819215547.20063-2-martin.blumenstingl@googlemail.com>
        (Martin Blumenstingl's message of "Fri, 19 Aug 2016 23:55:42 +0200")
Message-ID: <7h4m6g7608.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> This adds the IR remote receiver to the AO domain devices.

nit Re: Subject: should specify IR remote *input* pin.

> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/pinctrl/meson/pinctrl-meson-gxbb.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
> index cb4d6ad..8fffb31 100644
> --- a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
> +++ b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
> @@ -225,6 +225,8 @@ static const unsigned int i2c_sda_ao_pins[] = {PIN(GPIOAO_5, 0) };
>  static const unsigned int i2c_slave_sck_ao_pins[] = {PIN(GPIOAO_4, 0) };
>  static const unsigned int i2c_slave_sda_ao_pins[] = {PIN(GPIOAO_5, 0) };
>  
> +static const unsigned int ir_in_ao_pins[] = {PIN(GPIOAO_7, 0) };
> +

I'm trying to keep the names here so they match the datasheet, which
calls this remote_input_ao.  Please update throughout the patch.

Otherwise looks good to me.  Feel free to add

Reviewed-by: Kevin Hilman <khilman@baylibre.com>

and Linus W can queue it up.

Thanks,

Kevin
