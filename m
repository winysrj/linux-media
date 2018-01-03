Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:33086 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbeACSOg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 13:14:36 -0500
MIME-Version: 1.0
In-Reply-To: <20180103173726.GH9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
 <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
 <CAOMZO5CjrXfzum7JgimGqvnM7kjMyZZdtpEhvYwO-DLnig=uMQ@mail.gmail.com>
 <20180103171347.GF9493@w540> <CAOMZO5Biwbwct_vBD3zXyFvFgW00JxVnFoDcQthARVLxdqPYhA@mail.gmail.com>
 <20180103173726.GH9493@w540>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 3 Jan 2018 16:14:35 -0200
Message-ID: <CAOMZO5AGEt7pvjLnFN4P19qR28f2d128+80OnJ8SC59-pSgBpA@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] media: i2c: tw9910: Remove soc_camera dependencies
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 3, 2018 at 3:37 PM, jacopo mondi <jacopo@jmondi.org> wrote:

>> Initially the rest GPIO was doing:
>>
>> -       gpio_set_value(GPIO_PTT3, 0);
>> -       mdelay(10);
>> -       gpio_set_value(GPIO_PTT3, 1);
>> -       mdelay(10); /* wait to let chip come out of reset */
>
> And that's what my driver code does :)

No, on 5/9 you converted the original code to:

GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_HIGH)

It should be GPIO_ACTIVE_LOW instead.

> My point is that if I read the manual and I see an active low gpio (0
> is reset state) then the driver code uses it as and active high one (1
> is the reset state), that would be weird to me.

Then on this patch you should do:

gpiod_set_value(priv->rstb_gpio, 1);  ---> This tells the GPIO to go
to its active state (In this case active == logic level 0)
usleep_range(500, 1000);
gpiod_set_value(priv->rstb_gpio, 0); ---> This tells the GPIO to go to
its inactive state (In this case inactive == logic level 1)

You can also look at Documentation/gpio/consumer.txt where the usage
of the gpiod_xxx API is described.

It seems you are confusing it with the legacy gpio_set_value() API
(Documentation/gpio/gpio-legacy.txt)

Hope this helps.
