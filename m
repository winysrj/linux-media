Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:55095 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbeBZKRm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 05:17:42 -0500
Received: by mail-it0-f68.google.com with SMTP id c11so892560ith.4
        for <linux-media@vger.kernel.org>; Mon, 26 Feb 2018 02:17:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519633504-64357-1-git-send-email-leo.wen@rock-chips.com>
References: <1519633504-64357-1-git-send-email-leo.wen@rock-chips.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 26 Feb 2018 11:17:41 +0100
Message-ID: <CACRpkdaD+kFcOKP+V642r86hqwOO7h1UyA4wWBqGWdm3mjuhLA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] dt-bindings: Document the Rockchip RK1608 bindings
To: Wen Nuan <leo.wen@rock-chips.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        jacob2.chen@rock-chips.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Eddie Cai <eddie.cai@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 26, 2018 at 9:25 AM, Wen Nuan <leo.wen@rock-chips.com> wrote:

> From: Leo Wen <leo.wen@rock-chips.com>
>
> Add DT bindings documentation for Rockchip RK1608.
>
> Changes V2:
> - Delete spi-min-frequency property.
> - Add the external sensor's control pin and clock properties.
> - Delete the '&pinctrl' node.
>
> Signed-off-by: Leo Wen <leo.wen@rock-chips.com>

(...)
> +- reset-gpio           : GPIO connected to reset pin;
> +- irq-gpio             : GPIO connected to irq pin;
> +- sleepst-gpio         : GPIO connected to sleepst pin;
> +- wakeup-gpio          : GPIO connected to wakeup pin;
> +- powerdown-gpio       : GPIO connected to powerdown pin;

All these should be named something like:

reset-gpios = <>;
irq-gpios = <>;
etc

See
Documentation/devicetree/bindings/gpio/gpio.txt

So all in pluralis even if it is just one line, that is the standard.

> +- rockchip,powerdown0  : GPIO connected to the sensor0's powerdown pin;
> +- rockchip,reset0      : GPIO connected to the sensor0's reset pin;
> +- rockchip,powerdown1  : GPIO connected to the sensor1's powerdown pin;
> +- rockchip,reset1      : GPIO connected to the sensor1's reset pin;

Also get rid of the custom names here, either no lines should
have a "rockchip", prefix or all of them. Use the name of the
pin on the component, I suspect just

powerdown0-gpios
reset0-gpios
etc

By using the standard "*-gpios" suffix the kernel consumer API
will be much happier as well when you use gpiod_get() & friends.

Yours,
Linus Walleij
