Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaKYI3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 03:29:55 -0500
Message-ID: <54743DE1.7020704@redhat.com>
Date: Tue, 25 Nov 2014 09:29:21 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com> <1416498928-1300-4-git-send-email-hdegoede@redhat.com> <20141121084933.GL24143@lukather> <546F0226.2040700@redhat.com> <20141124220327.GS4752@lukather>
In-Reply-To: <20141124220327.GS4752@lukather>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/24/2014 11:03 PM, Maxime Ripard wrote:
> On Fri, Nov 21, 2014 at 10:13:10AM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 11/21/2014 09:49 AM, Maxime Ripard wrote:
>>> Hi,
>>>
>>> On Thu, Nov 20, 2014 at 04:55:22PM +0100, Hans de Goede wrote:
>>>> Add a driver for mod0 clocks found in the prcm. Currently there is only
>>>> one mod0 clocks in the prcm, the ir clock.
>>>>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> ---
>>>>   Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>>>>   drivers/clk/sunxi/Makefile                        |  2 +-
>>>>   drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 +++++++++++++++++++++++
>>>>   drivers/mfd/sun6i-prcm.c                          | 14 +++++
>>>>   4 files changed, 79 insertions(+), 1 deletion(-)
>>>>   create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
>>>> index ed116df..342c75a 100644
>>>> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
>>>> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
>>>> @@ -56,6 +56,7 @@ Required properties:
>>>>   	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
>>>>   	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
>>>>   	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
>>>> +	"allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
>>>>
>>>>   Required properties for all clocks:
>>>>   - reg : shall be the control register address for the clock.
>>>> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
>>>> index 7ddc2b5..daf8b1c 100644
>>>> --- a/drivers/clk/sunxi/Makefile
>>>> +++ b/drivers/clk/sunxi/Makefile
>>>> @@ -10,4 +10,4 @@ obj-y += clk-sun8i-mbus.o
>>>>
>>>>   obj-$(CONFIG_MFD_SUN6I_PRCM) += \
>>>>   	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
>>>> -	clk-sun8i-apb0.o
>>>> +	clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
>>>> diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>>>> new file mode 100644
>>>> index 0000000..e80f18e
>>>> --- /dev/null
>>>> +++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>>>> @@ -0,0 +1,63 @@
>>>> +/*
>>>> + * Allwinner A31 PRCM mod0 clock driver
>>>> + *
>>>> + * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License as published by
>>>> + * the Free Software Foundation; either version 2 of the License, or
>>>> + * (at your option) any later version.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + */
>>>> +
>>>> +#include <linux/clk-provider.h>
>>>> +#include <linux/clkdev.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/of_address.h>
>>>> +#include <linux/platform_device.h>
>>>> +
>>>> +#include "clk-factors.h"
>>>> +#include "clk-mod0.h"
>>>> +
>>>> +static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] = {
>>>> +	{ .compatible = "allwinner,sun6i-a31-ir-clk" },
>>>> +	{ /* sentinel */ }
>>>> +};
>>>> +
>>>> +static DEFINE_SPINLOCK(sun6i_prcm_mod0_lock);
>>>> +
>>>> +static int sun6i_a31_prcm_mod0_clk_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct device_node *np = pdev->dev.of_node;
>>>> +	struct resource *r;
>>>> +	void __iomem *reg;
>>>> +
>>>> +	if (!np)
>>>> +		return -ENODEV;
>>>> +
>>>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +	reg = devm_ioremap_resource(&pdev->dev, r);
>>>> +	if (IS_ERR(reg))
>>>> +		return PTR_ERR(reg);
>>>> +
>>>> +	sunxi_factors_register(np, &sun4i_a10_mod0_data,
>>>> +			       &sun6i_prcm_mod0_lock, reg);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static struct platform_driver sun6i_a31_prcm_mod0_clk_driver = {
>>>> +	.driver = {
>>>> +		.name = "sun6i-a31-prcm-mod0-clk",
>>>> +		.of_match_table = sun6i_a31_prcm_mod0_clk_dt_ids,
>>>> +	},
>>>> +	.probe = sun6i_a31_prcm_mod0_clk_probe,
>>>> +};
>>>> +module_platform_driver(sun6i_a31_prcm_mod0_clk_driver);
>>>> +
>>>> +MODULE_DESCRIPTION("Allwinner A31 PRCM mod0 clock driver");
>>>> +MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
>>>> +MODULE_LICENSE("GPL");
>>>
>>> I don't think this is the right approach, mainly for two reasons: the
>>> compatible shouldn't change, and you're basically duplicating code
>>> there.
>>>
>>> I understand that you need the new compatible in order to avoid a
>>> double probing: one by CLK_OF_DECLARE, and one by the usual mechanism,
>>> and that also implies the second reason.
>>
>> Not only for that, we need a new compatible also because the mfd framework
>> needs a separate compatible per sub-node as that is how it finds nodes
>> to attach to the platform devices, so we need a new compatible anyways,
>> with your make the mod0 clock driver a platform driver solution we could
>> use:
>
> We have a single mod0 clock in there, so no, not really.

We have a single mod0 clock there today, but who knows what tomorrow brings,
arguably the 1wire clock is a mod0 clock too, so we already have 2 today.

> Plus, that seems like a bogus limitation from MFD, and it really
> shouldn't work that way.

Well AFAIK that is how it works.

>> 	compatible = "allwinner,sun6i-a31-ir-clk", "allwinner,sun4i-a10-mod0-clk";
>>
>> To work around this, but there are other problems, your make mod0clk a
>> platform driver solution cannot work because the clocks node in the dtsi
>> is not simple-bus compatible, so no platform-devs will be instantiated for
>> the clocks there.
>
> Then add the simple-bus compatible.

No, just no, that goes against the whole design of how of-clocks work.

>> Besides the compatible (which as said we need a separate one anyways),
>> your other worry is code duplication, but I've avoided that as much
>> as possible already, the new drivers/clk/sunxi/clk-sun6i-prcm-mod0.c is
>> just a very thin wrapper, waying in with all of 63 lines including
>> 16 lines GPL header.
>
> 47 lines that are doing exactly the same thing as the other code is
> doing. I'm sorry but you can't really argue it's not code duplication,
> it really is.

It is not doing the exact same thing, it is a platform driver, where as
the other code is an of_clk driver.

>> So sorry, I disagree I believe that this is the best solution.
>>
>>> However, as those are not critical clocks that need to be here early
>>> at boot, you can also fix this by turning the mod0 driver into a
>>> platform driver itself. The compatible will be kept, the driver will
>>> be the same.
>>>
>>> The only thing we need to pay attention to is how "client" drivers
>>> react when they cannot grab their clock. They should return
>>> -EPROBE_DEFER, but that remains to be checked.
>>
>> -EPROBE_DEFER is yet another reason to not make mod0-clk a platform
>> driver. Yes drivers should be able to handle this, but it is a pain,
>> and the more we use it the more pain it is. Also it makes booting a lot
>> slower as any driver using a mod0 clk now, will not complete its probe
>> until all the other drivers are done probing and the late_initcall
>> which starts the deferred-probe wq runs.
>
> The whole EPROBE_DEFER mechanism might need some fixing, but it's not
> really the point is it?

Well one reasons why clocks are instantiated the way they are is to have
them available as early as possible, which is really convenient and works
really well.

You are asking for a whole lot of stuff to be changed, arguably in a way
which makes it worse, just to save 47 lines of code...

Regards,

Hans
