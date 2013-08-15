Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48938 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799Ab3HOItQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 04:49:16 -0400
Date: Thu, 15 Aug 2013 09:49:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Rob Landley <rob@landley.net>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
Message-ID: <20130815084900.GA28366@e106331-lin.cambridge.arm.com>
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 14, 2013 at 06:27:01PM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds support to ST RC driver, which is basically a IR/UHF
> receiver and transmitter. This IP is common across all the ST parts for
> settop box platforms. IRB is embedded in ST COMMS IP block.
> It supports both Rx & Tx functionality.
> 
> In this driver adds only Rx functionality via LIRC codec.

Is there anything that additionally needs to be in the dt to support Tx
functionality?

> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
> Hi Chehab,
> 
> This is a very simple rc driver for IRB controller found in STi ARM CA9 SOCs.
> STi ARM SOC support went in 3.11 recently.
> This driver is a raw driver which feeds data to lirc codec for the user lircd
> to decode the keys.
> 
> This patch is based on git://linuxtv.org/media_tree.git master branch.
> 
> Comments?
> 
> Thanks,
> srini
> 
>  Documentation/devicetree/bindings/media/st-rc.txt |   18 +
>  drivers/media/rc/Kconfig                          |   10 +
>  drivers/media/rc/Makefile                         |    1 +
>  drivers/media/rc/st_rc.c                          |  371 +++++++++++++++++++++
>  4 files changed, 400 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/st-rc.txt
>  create mode 100644 drivers/media/rc/st_rc.c
> 
> diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/media/st-rc.txt
> new file mode 100644
> index 0000000..57f9ee8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/st-rc.txt
> @@ -0,0 +1,18 @@
> +Device-Tree bindings for ST IR and UHF receiver
> +
> +Required properties:
> +       - compatible: should be "st,rc".

That "rc" should be made more specific, and it seems like this is a
subset of a larger block of IP (the ST COMMS IP block). Is this really a
standalone piece of hardware, or is it always in the larger comms block?

What's the full name of this unit as it appears in documentation?

> +       - st,uhfmode: boolean property to indicate if reception is in UHF.

That's not a very clear name. Is this a physical property of the device
(i.e. it's wired to either an IR receiver or a UHF receiver), or is this
a choice as to how it's used at runtime?

If it's fixed property of how the device is wired, it might make more
sense to have a string mode property that's either "uhf" or "infared".

> +       - reg: base physical address of the controller and length of memory
> +       mapped  region.
> +       - interrupts: interrupt number to the cpu. The interrupt specifier
> +       format depends on the interrupt controller parent.
> +
> +Example node:
> +
> +       rc: rc@fe518000 {
> +               compatible      = "st,rc";
> +               reg             = <0xfe518000 0x234>;
> +               interrupts      =  <0 203 0>;
> +       };
> +

[...]

> +++ b/drivers/media/rc/st_rc.c
> @@ -0,0 +1,371 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics Limited
> + * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/kernel.h>
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <media/rc-core.h>
> +#include <linux/pinctrl/consumer.h>
> +
> +struct st_rc_device {
> +       struct device                   *dev;
> +       int                             irq;
> +       int                             irq_wake;
> +       struct clk                      *sys_clock;
> +       void                            *base;  /* Register base address */
> +       void                            *rx_base;/* RX Register base address */
> +       struct rc_dev                   *rdev;
> +       bool                            overclocking;
> +       int                             sample_mult;
> +       int                             sample_div;
> +       bool                            rxuhfmode;
> +};

[...]

> +static void st_rc_hardware_init(struct st_rc_device *dev)
> +{
> +       int baseclock, freqdiff;
> +       unsigned int rx_max_symbol_per = MAX_SYMB_TIME;
> +       unsigned int rx_sampling_freq_div;
> +
> +       clk_prepare_enable(dev->sys_clock);

This clock should be defined in the binding.

> +       baseclock = clk_get_rate(dev->sys_clock);
> +
> +       /* IRB input pins are inverted internally from high to low. */
> +       writel(1, dev->rx_base + IRB_RX_POLARITY_INV);
> +
> +       rx_sampling_freq_div = baseclock / IRB_SAMPLE_FREQ;
> +       writel(rx_sampling_freq_div, dev->base + IRB_SAMPLE_RATE_COMM);
> +
> +       freqdiff = baseclock - (rx_sampling_freq_div * IRB_SAMPLE_FREQ);
> +       if (freqdiff) { /* over clocking, workout the adjustment factors */
> +               dev->overclocking = true;
> +               dev->sample_mult = 1000;
> +               dev->sample_div = baseclock / (10000 * rx_sampling_freq_div);
> +               rx_max_symbol_per = (rx_max_symbol_per * 1000)/dev->sample_div;
> +       }
> +
> +       writel(rx_max_symbol_per, dev->rx_base + IRB_MAX_SYM_PERIOD);
> +}
> +
> +static int st_rc_remove(struct platform_device *pdev)
> +{
> +       struct st_rc_device *rc_dev = platform_get_drvdata(pdev);
> +       clk_disable_unprepare(rc_dev->sys_clock);
> +       rc_unregister_device(rc_dev->rdev);

Is a call to rc_free_device() not necessary?

There are separate calls to rc_allocate_device() and rc_register_device
in the probe function, and an rc_free_device() in its failure path.

> +       return 0;
> +}

[...]

> +static int st_rc_probe(struct platform_device *pdev)
> +{
> +       int ret = -EINVAL;
> +       struct rc_dev *rdev;
> +       struct device *dev = &pdev->dev;
> +       struct resource *res;
> +       struct st_rc_device *rc_dev;
> +       struct device_node *np = pdev->dev.of_node;
> +
> +       rc_dev = devm_kzalloc(dev, sizeof(struct st_rc_device), GFP_KERNEL);
> +       rdev = rc_allocate_device();
> +
> +       if (!rc_dev || !rdev)
> +               return -ENOMEM;
> +
> +       if (np)
> +               rc_dev->rxuhfmode = of_property_read_bool(np, "st,uhfmode");

I see of_property_read_bool has an implicit NULL check on np via
__of_find_property, though I'm not sure if we want people to rely on
that.

I don't think a boolean property is the best way of encoding this,
regardless.

> +
> +       rc_dev->sys_clock = devm_clk_get(dev, NULL);
> +       if (IS_ERR(rc_dev->sys_clock)) {
> +               dev_err(dev, "System clock not found\n");
> +               ret = PTR_ERR(rc_dev->sys_clock);
> +               goto err;
> +       }
> +
> +       rc_dev->irq = platform_get_irq(pdev, 0);
> +       if (rc_dev->irq < 0) {
> +               ret = rc_dev->irq;
> +               goto clkerr;
> +       }
> +
> +       ret = -ENODEV;
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res)
> +               goto clkerr;
> +
> +       rc_dev->base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(rc_dev->base))
> +               goto clkerr;
> +
> +       if (rc_dev->rxuhfmode)
> +               rc_dev->rx_base = rc_dev->base + 0x40;
> +       else
> +               rc_dev->rx_base = rc_dev->base;
> +
> +       rc_dev->dev = dev;
> +       platform_set_drvdata(pdev, rc_dev);
> +       st_rc_hardware_init(rc_dev);
> +
> +       rdev->driver_type = RC_DRIVER_IR_RAW;
> +       rdev->allowed_protos = RC_TYPE_LIRC;
> +       rdev->priv = rc_dev;
> +       rdev->open = st_rc_open;
> +       rdev->close = st_rc_close;
> +       rdev->driver_name = IR_ST_NAME;
> +       rdev->map_name = RC_MAP_LIRC;
> +       rdev->input_name = "ST Remote Control Receiver";
> +
> +       /* enable wake via this device */
> +       device_set_wakeup_capable(dev, true);
> +       device_set_wakeup_enable(dev, true);
> +
> +       ret = rc_register_device(rdev);
> +       if (ret < 0)
> +               goto clkerr;
> +
> +       rc_dev->rdev = rdev;
> +       if (devm_request_irq(dev, rc_dev->irq, st_rc_rx_interrupt,
> +                       IRQF_NO_SUSPEND, IR_ST_NAME, rc_dev) < 0) {
> +               dev_err(dev, "IRQ %d register failed\n", rc_dev->irq);
> +               ret = -EINVAL;
> +               goto rcerr;
> +       }
> +
> +       /* for LIRC_MODE_MODE2 or LIRC_MODE_PULSE or LIRC_MODE_RAW
> +        * lircd expects a long space first before a signal train to sync. */

Comment should be like:

	/*
	 * Multi-line comment.
	 * Preceding and trailing / 
	 */

> +       st_rc_send_lirc_timeout(rdev);
> +
> +       dev_info(dev, "setup in %s mode\n", rc_dev->rxuhfmode ? "UHF" : "IR");
> +
> +       return ret;
> +rcerr:
> +       rc_unregister_device(rdev);
> +       rdev = NULL;

Why? Doesn't that mean rdev never gets freed?

> +clkerr:
> +       clk_disable_unprepare(rc_dev->sys_clock);
> +err:
> +       rc_free_device(rdev);
> +       dev_err(dev, "Unable to register device (%d)\n", ret);
> +       return ret;
> +}

Thanks,
Mark.
