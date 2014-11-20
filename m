Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKTTc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 14:32:56 -0500
Message-ID: <546E41C1.1070800@redhat.com>
Date: Thu, 20 Nov 2014 20:32:17 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com> <1416498928-1300-4-git-send-email-hdegoede@redhat.com> <CAGb2v66zoAy93mjZn+yf8zvCmkQ8AVWH92jKL-gyu90E5HLuuw@mail.gmail.com>
In-Reply-To: <CAGb2v66zoAy93mjZn+yf8zvCmkQ8AVWH92jKL-gyu90E5HLuuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/20/2014 07:24 PM, Chen-Yu Tsai wrote:
> Hi,
> 
> On Thu, Nov 20, 2014 at 7:55 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Add a driver for mod0 clocks found in the prcm. Currently there is only
>> one mod0 clocks in the prcm, the ir clock.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>>  drivers/clk/sunxi/Makefile                        |  2 +-
>>  drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 +++++++++++++++++++++++
>>  drivers/mfd/sun6i-prcm.c                          | 14 +++++
>>  4 files changed, 79 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>>
>> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
>> index ed116df..342c75a 100644
>> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
>> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
>> @@ -56,6 +56,7 @@ Required properties:
>>         "allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
>>         "allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
>>         "allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
>> +       "allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
>>
>>  Required properties for all clocks:
>>  - reg : shall be the control register address for the clock.
>> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
>> index 7ddc2b5..daf8b1c 100644
>> --- a/drivers/clk/sunxi/Makefile
>> +++ b/drivers/clk/sunxi/Makefile
>> @@ -10,4 +10,4 @@ obj-y += clk-sun8i-mbus.o
>>
>>  obj-$(CONFIG_MFD_SUN6I_PRCM) += \
>>         clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
>> -       clk-sun8i-apb0.o
>> +       clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
>> diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>> new file mode 100644
>> index 0000000..e80f18e
>> --- /dev/null
>> +++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>> @@ -0,0 +1,63 @@
>> +/*
>> + * Allwinner A31 PRCM mod0 clock driver
>> + *
>> + * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/clk-provider.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +
>> +#include "clk-factors.h"
>> +#include "clk-mod0.h"
>> +
>> +static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] = {
>> +       { .compatible = "allwinner,sun6i-a31-ir-clk" },
> 
> Could we use a generic name, like "sun6i-a31-prcm-mod0-clk"?
> IIRC, there is another one, the module clock for the 1-wire interface.

I wish we could use a generic name, but that does not work for mfd device
subnodes, as the mfd framework attaches resources (such as registers) to
the subnodes based on the compatible.

BTW it seems that that the 1-wire clock is not 100% mod0 clock compatible,
at least the ccmu.h in the allwinner SDK uses a different struct definition
for it.

Regards,

Hans
