Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:36428 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbeJJQ0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 12:26:06 -0400
Received: by mail-it1-f195.google.com with SMTP id c85-v6so6914427itd.1
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 02:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20181008211205.2900-1-vz@mleia.com> <20181008211205.2900-7-vz@mleia.com>
In-Reply-To: <20181008211205.2900-7-vz@mleia.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 10 Oct 2018 11:04:41 +0200
Message-ID: <CACRpkdbMMnXzA_j_p=nGgT1SyECrhCNRC6wWQ-+COMEkSQdPAA@mail.gmail.com>
Subject: Re: [PATCH 6/7] pinctrl: ds90ux9xx: add TI DS90Ux9xx pinmux and GPIO
 controller driver
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

thanks for your patch! Some review comments:

On Mon, Oct 8, 2018 at 11:12 PM Vladimir Zapolskiy <vz@mleia.com> wrote:

> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>
> The change adds an MFD cell driver for managing pin functions on
> TI DS90Ux9xx de-/serializers.
>
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>

Please mention in the commit that you are also adding a GPIO
chip driver.

> +// SPDX-License-Identifier: GPL-2.0-or-later

I prefer the simple "GPL-2.0+" here.

> +#include <linux/of_gpio.h>

You should not need this include. If you do, something is wrong.

> +#define SER_REG_PIN_CTRL               0x12
> +#define PIN_CTRL_RGB18                 BIT(2)
> +#define PIN_CTRL_I2S_DATA_ISLAND       BIT(1)
> +#define PIN_CTRL_I2S_CHANNEL_B         (BIT(0) | BIT(3))
> +
> +#define SER_REG_I2S_SURROUND           0x1A
> +#define PIN_CTRL_I2S_SURR_BIT          BIT(0)
> +
> +#define DES_REG_INDIRECT_PASS          0x16
> +
> +#define OUTPUT_HIGH                    BIT(3)
> +#define REMOTE_CONTROL                 BIT(2)
> +#define DIR_INPUT                      BIT(1)
> +#define ENABLE_GPIO                    BIT(0)
> +
> +#define GPIO_AS_INPUT                  (ENABLE_GPIO | DIR_INPUT)
> +#define GPIO_AS_OUTPUT                 ENABLE_GPIO
> +#define GPIO_OUTPUT_HIGH               (GPIO_AS_OUTPUT | OUTPUT_HIGH)
> +#define GPIO_OUTPUT_LOW                        GPIO_AS_OUTPUT
> +#define GPIO_OUTPUT_REMOTE             (GPIO_AS_OUTPUT | REMOTE_CONTROL)

These have a creepily generic look, like they hit the global GPIO
namespace without really clashing. It gets confusing when reading
the code.

Do you think you could prefix them with DS90_* or something
so it is clear that these defines belong in this driver?

> +static const struct gpio_chip ds90ux9xx_gpio_chip = {
> +       .owner                  = THIS_MODULE,
> +       .get                    = ds90ux9xx_gpio_get,
> +       .set                    = ds90ux9xx_gpio_set,
> +       .get_direction          = ds90ux9xx_gpio_get_direction,
> +       .direction_input        = ds90ux9xx_gpio_direction_input,
> +       .direction_output       = ds90ux9xx_gpio_direction_output,
> +       .base                   = -1,
> +       .can_sleep              = 1,

This is bool so set it = true;

Overall it's a very nice driver. It is pretty complex but pin control
is complex so that's a fact of life.

Yours,
Linus Walleij
