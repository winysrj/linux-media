Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:40354 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbeCGI4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 03:56:25 -0500
Received: by mail-it0-f49.google.com with SMTP id e64so2446725ita.5
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 00:56:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520301560-114573-2-git-send-email-leo.wen@rock-chips.com>
References: <1520301560-114573-1-git-send-email-leo.wen@rock-chips.com> <1520301560-114573-2-git-send-email-leo.wen@rock-chips.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 7 Mar 2018 09:56:23 +0100
Message-ID: <CACRpkdYKNiaEqCNyWq=xjOs3Xz0_YRkhkWkxuS4okD-XRVRj9w@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] [media] Add Rockchip RK1608 driver
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

On Tue, Mar 6, 2018 at 2:59 AM, Wen Nuan <leo.wen@rock-chips.com> wrote:

Thank you for the patch! Nice improvements over all!

> From: Leo Wen <leo.wen@rock-chips.com>
>
> Rk1608 is used as a PreISP to link on Soc, which mainly has two functions.
> One is to download the firmware of RK1608, and the other is to match the
> extra sensor such as camera and enable sensor by calling sensor's s_power.
>
> use below v4l2-ctl command to capture frames.
>
>     v4l2-ctl --verbose -d /dev/video1 --stream-mmap=2
>     --stream-to=/tmp/stream.out --stream-count=60 --stream-poll
>
> use below command to playback the video on your PC.
>
>     mplayer ./stream.out -loop 0 -demuxer rawvideo -rawvideo
>     w=640:h=480:size=$((640*480*3/2)):format=NV12
>
> Changes V3:
> - Instead use the new GPIO API.

This is looking really nice from a GPIO point of view!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

The comments below are just nitpicky good-to-have.

> +       pdata->gpios.reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
> +       if (IS_ERR(pdata->gpios.reset)) {
> +               dev_err(dev, "could not get reset gpio\n");
> +               return PTR_ERR(pdata->gpios.reset);
> +       }
> +       ret = gpiod_direction_output(pdata->gpios.reset, 0);
> +       if (ret) {
> +               dev_err(dev, "reset gpio set output error %d\n", ret);
> +               return ret;
> +       }

So what you do here is first assert reset and then de-assert it,
triggering a reset? Maybe you should add a comment
about that so people get it.

> +       pdata->gpios.irq = devm_gpiod_get(dev, "irq", GPIOD_OUT_LOW);
> +       if (IS_ERR(pdata->gpios.irq)) {
> +               dev_err(dev, "could not get irq gpio\n");
> +               return PTR_ERR(pdata->gpios.irq);
> +       }
> +       ret = gpiod_direction_input(pdata->gpios.irq);
> +       if (ret) {
> +               dev_err(dev, "GPIO irq set output error %d\n", ret);
> +               return ret;
> +       }

Why is it necessary to request the GPIO as output
and drive it low and then immediately turn it into an input?
Why not just request it with the flag GPIOD_IN and
skip the second statement?

> +       pdata->gpios.pdown = devm_gpiod_get(dev, "powerdown", GPIOD_OUT_HIGH);
> +       if (IS_ERR(pdata->gpios.pdown)) {
> +               dev_err(dev, "could not get powerdown gpio\n");
> +               return PTR_ERR(pdata->gpios.pdown);
> +       }
> +       ret = gpiod_direction_output(pdata->gpios.pdown, 0);
> +       if (ret) {
> +               dev_err(dev, "GPIO powerdown set output error %d\n", ret);
> +               return ret;
> +       }

This looks dangerous. Like you assert powerdown and then de-assert
it (similar to reset above). Why not just request it as
GPIOD_OUT_LOW?

> +       pdata->gpios.sleepst = devm_gpiod_get(dev, "sleepst", GPIOD_OUT_HIGH);
> +       if (IS_ERR(pdata->gpios.sleepst)) {
> +               dev_err(dev, "Could not get powerdown gpio\n");
> +               return PTR_ERR(pdata->gpios.sleepst);
> +       }
> +       ret = gpiod_direction_input(pdata->gpios.sleepst);
> +       if (ret) {
> +               dev_err(dev, "GPIO sleepst set input error %d\n", ret);
> +               return ret;
> +       }

Just request as GPIOD_IN and skip the second statement?

> +       pdata->gpios.wakeup = devm_gpiod_get(dev, "wakeup", GPIOD_OUT_HIGH);
> +       if (IS_ERR(pdata->gpios.wakeup)) {
> +               dev_err(dev, "Could not get wakeup gpio\n");
> +               return PTR_ERR(pdata->gpios.wakeup);
> +       }
> +       ret = gpiod_direction_output(pdata->gpios.wakeup, 0);
> +       if (ret) {
> +               dev_err(dev, "GPIO wakeup set output error %d\n", ret);
> +               return ret;
> +       }

Just request as GPIOD_OUT_LOW?

> +struct rk1608_gpios {
> +       struct gpio_desc        *reset;
> +       struct gpio_desc        *irq;
> +       struct gpio_desc        *sleepst;
> +       struct gpio_desc        *wakeup;
> +       struct gpio_desc        *pdown;
> +};

Very nice :)

Yours,
Linus Walleij
