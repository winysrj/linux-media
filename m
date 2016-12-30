Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:33298 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcL3NRj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 08:17:39 -0500
Received: by mail-qt0-f182.google.com with SMTP id p16so391552328qta.0
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2016 05:17:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483050455-10683-11-git-send-email-steve_longerbeam@mentor.com>
References: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com> <1483050455-10683-11-git-send-email-steve_longerbeam@mentor.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 30 Dec 2016 14:17:38 +0100
Message-ID: <CACRpkdZG2j4_LwP8KUVBTOtXma75YvYtC6CW1QqYwOm-MOZgHg@mail.gmail.com>
Subject: Re: [PATCH 10/20] gpio: pca953x: Add optional reset gpio control
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 29, 2016 at 11:27 PM, Steve Longerbeam
<slongerbeam@gmail.com> wrote:

> Add optional reset-gpios pin control. If present, de-assert the
> specified reset gpio pin to bring the chip out of reset.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

This seems like a separate patch from the other 19 patches so please send it
separately so I can handle logistics easier in the future.


> @@ -133,6 +134,7 @@ struct pca953x_chip {
>         const char *const *names;
>         unsigned long driver_data;
>         struct regulator *regulator;
> +       struct gpio_desc *reset_gpio;

Why do you even keep this around in the device state container?

As you only use it in the probe() function, use a local variable.

The descriptor will be free():ed by the devm infrastructure anyways.

> +               /* see if we need to de-assert a reset pin */
> +               chip->reset_gpio = devm_gpiod_get_optional(&client->dev,
> +                                                          "reset",
> +                                                          GPIOD_OUT_LOW);
> +               if (IS_ERR(chip->reset_gpio)) {
> +                       dev_err(&client->dev, "request for reset pin failed\n");
> +                       return PTR_ERR(chip->reset_gpio);
> +               }

Nice.

> +               if (chip->reset_gpio) {
> +                       /* bring chip out of reset */
> +                       dev_info(&client->dev, "releasing reset\n");
> +                       gpiod_set_value(chip->reset_gpio, 0);
> +               }

Is this really needed given that you set it low in the
devm_gpiod_get_optional()?

Yours,
Linus Walleij
