Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34459 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdHaI2u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 04:28:50 -0400
Received: by mail-oi0-f44.google.com with SMTP id w10so321553oie.1
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 01:28:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170830161044.26571-5-hverkuil@xs4all.nl>
References: <20170830161044.26571-1-hverkuil@xs4all.nl> <20170830161044.26571-5-hverkuil@xs4all.nl>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 31 Aug 2017 10:28:49 +0200
Message-ID: <CACRpkdbuBhbq8tiuUjYfJc9UCGM8LRGc017ecLxW93QwTW3CVQ@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] cec-gpio: add HDMI CEC GPIO driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 30, 2017 at 6:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add a simple HDMI CEC GPIO driver that sits on top of the cec-pin framework.
>
> While I have heard of SoCs that use the GPIO pin for CEC (apparently an
> early RockChip SoC used that), the main use-case of this driver is to
> function as a debugging tool.
>
> By connecting the CEC line to a GPIO pin on a Raspberry Pi 3 for example
> it turns it into a CEC debugger and protocol analyzer.
>
> With 'cec-ctl --monitor-pin' the CEC traffic can be analyzed.
>
> But of course it can also be used with any hardware project where the
> HDMI CEC pin is hooked up to a pull-up gpio pin.
>
> In addition this has (optional) support for tracing HPD changes if the
> HPD is connected to a GPIO.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Pretty cool stuff!

> +config CEC_GPIO
> +       tristate "Generic GPIO-based CEC driver"
> +       depends on PREEMPT

depends on GPIOLIB

or

select GPIOLIB

your pick.

> +#include <linux/gpio.h>

This should not be needed in new code.

> +#include <linux/gpio/consumer.h>

This should be enough.

> +#include <linux/of_gpio.h>

Your should not need this either.

> +struct cec_gpio {
> +       struct cec_adapter      *adap;
> +       struct device           *dev;
> +       int                     gpio;
> +       int                     hpd_gpio;

Think this should be:

struct gpio_desc *gpio;
struct gpio_desc *hpd_gpio;

> +       int                     irq;
> +       int                     hpd_irq;
> +       bool                    hpd_is_high;
> +       ktime_t                 hpd_ts;
> +       bool                    is_low;
> +       bool                    have_irq;
> +};
> +
> +static bool cec_gpio_read(struct cec_adapter *adap)
> +{
> +       struct cec_gpio *cec = cec_get_drvdata(adap);
> +
> +       if (cec->is_low)
> +               return false;
> +       return gpio_get_value(cec->gpio);

Use descriptor accessors

gpiod_get_value()

> +static void cec_gpio_high(struct cec_adapter *adap)
> +{
> +       struct cec_gpio *cec = cec_get_drvdata(adap);
> +
> +       if (!cec->is_low)
> +               return;
> +       cec->is_low = false;
> +       gpio_direction_input(cec->gpio);

Are you setting the GPIO high by setting it as input?
That sounds like you should be requesting it as
open drain in the DTS file, see
Documentation/gpio/driver.txt
for details about open drain, and use
GPIO_LINE_OPEN_DRAIN
from <dt-bindings/gpio/gpio.h>

> +static void cec_gpio_low(struct cec_adapter *adap)
> +{
> +       struct cec_gpio *cec = cec_get_drvdata(adap);
> +
> +       if (cec->is_low)
> +               return;
> +       if (WARN_ON_ONCE(cec->have_irq))
> +               free_irq(cec->irq, cec);
> +       cec->have_irq = false;
> +       cec->is_low = true;
> +       gpio_direction_output(cec->gpio, 0);

Yeah this looks like you're doing open drain.
gpiod_direction_output() etc.

> +static int cec_gpio_read_hpd(struct cec_adapter *adap)
> +{
> +       struct cec_gpio *cec = cec_get_drvdata(adap);
> +
> +       if (cec->hpd_gpio < 0)
> +               return -ENOTTY;
> +       return gpio_get_value(cec->hpd_gpio);

gpiod_get_value()


> +static int cec_gpio_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       enum of_gpio_flags hpd_gpio_flags;
> +       struct cec_gpio *cec;
> +       int ret;
> +
> +       cec = devm_kzalloc(dev, sizeof(*cec), GFP_KERNEL);
> +       if (!cec)
> +               return -ENOMEM;
> +
> +       cec->gpio = of_get_named_gpio_flags(dev->of_node,
> +                                           "cec-gpio", 0, &hpd_gpio_flags);
> +       if (cec->gpio < 0)
> +               return cec->gpio;
> +
> +       cec->hpd_gpio = of_get_named_gpio_flags(dev->of_node,
> +                                           "hpd-gpio", 0, &hpd_gpio_flags);

This is a proper device so don't use all this trouble.

cec->gpio = gpiod_get(dev, "cec-gpio", GPIOD_IN);

or similar (grep for examples!)

Same for hdp_gpio.

> +       cec->irq = gpio_to_irq(cec->gpio);

gpiod_to_irq()

> +       gpio_direction_input(cec->gpio);

This is not needed with the above IN flag.

But as said above, maybe you are looking for an open drain
output actually.

> +       if (cec->hpd_gpio >= 0) {
> +               cec->hpd_irq = gpio_to_irq(cec->hpd_gpio);
> +               gpio_direction_input(cec->hpd_gpio);

Already done if you pass the right flag. This should be IN for sure.

Use gpiod_to_irq().

Please include me on subsequent posts, I want to try to use
descriptors as much as possible for new drivers.

Yours,
Linus Walleij
