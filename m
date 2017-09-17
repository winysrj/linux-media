Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:46189 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdIQJrx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 05:47:53 -0400
Received: by mail-io0-f171.google.com with SMTP id d16so13453436ioj.3
        for <linux-media@vger.kernel.org>; Sun, 17 Sep 2017 02:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170916142827.5878-4-hverkuil@xs4all.nl>
References: <20170916142827.5878-1-hverkuil@xs4all.nl> <20170916142827.5878-4-hverkuil@xs4all.nl>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 17 Sep 2017 11:47:51 +0200
Message-ID: <CACRpkdbApdos=mKJQZq8xfOM6O3hDS20gOc+0hGEkD7WqtQh5w@mail.gmail.com>
Subject: Re: [PATCHv5 3/5] dt-bindings: document the CEC GPIO bindings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 16, 2017 at 4:28 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Document the bindings for the cec-gpio module for hardware where the
> CEC line and optionally the HPD line are connected to GPIO lines.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Just to make things explicit:

> +Required properties:
> +  - compatible: value must be "cec-gpio".
> +  - cec-gpios: gpio that the CEC line is connected to.

Add "The line should be tagged as open drain."

> +Example for the Raspberry Pi 3 where the CEC line is connected to
> +pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
> +connected to pin 11 aka BCM17:
> +

#include <dt-bindings/gpio/gpio.h>

> +cec-gpio {
> +       compatible = "cec-gpio";
> +       cec-gpio = <&gpio 7 GPIO_OPEN_DRAIN>;

cec-gpios = <&gpio 7 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;

> +       hpd-gpio = <&gpio 17 GPIO_ACTIVE_HIGH>;

hpd-gpios = ..

With these fixups:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
