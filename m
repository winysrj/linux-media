Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57206 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3FSQcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 12:32:16 -0400
Message-id: <51C1DD0C.4030807@samsung.com>
Date: Wed, 19 Jun 2013 18:32:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kishon@ti.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
 <1371231951-1969-2-git-send-email-s.nawrocki@samsung.com>
 <3575249.Vg82ll65tN@flatron>
In-reply-to: <3575249.Vg82ll65tN@flatron>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 06/16/2013 11:11 PM, Tomasz Figa wrote:
> Hi Sylwester,
> 
> Looks good, but I added some nitpicks inline.
> 
> On Friday 14 of June 2013 19:45:47 Sylwester Nawrocki wrote:
>> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
>> receiver and MIPI DSI transmitter DPHYs.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  .../bindings/phy/exynos-video-mipi-phy.txt         |   16 ++
>>  drivers/phy/Kconfig                                |   10 ++
>>  drivers/phy/Makefile                               |    3 +-
>>  drivers/phy/exynos_video_mipi_phy.c                |  166
>> ++++++++++++++++++++ 4 files changed, 194 insertions(+), 1 deletion(-)
>>  create mode 100644
>> Documentation/devicetree/bindings/phy/exynos-video-mipi-phy.txt create
>> mode 100644 drivers/phy/exynos_video_mipi_phy.c
>>
>> diff --git
>> a/Documentation/devicetree/bindings/phy/exynos-video-mipi-phy.txt
>> b/Documentation/devicetree/bindings/phy/exynos-video-mipi-phy.txt new
>> file mode 100644
>> index 0000000..32311c89
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/exynos-video-mipi-phy.txt
>> @@ -0,0 +1,16 @@
>> +Samsung S5P/EXYNOS SoC series MIPI CSIS/DSIM DPHY
>> +-------------------------------------------------
>> +
>> +Required properties:
>> +- compatible : "samsung,<soc_name>-video-phy", currently most SoCs can
> 
> I don't like this <soc_name> here. It sounds like any SoC name can be put 
> here. IMHO just listing all supported compatible values should be enough.

Hmm, OK, I'll simply put there the one compatible string supported now.

>> claim +  compatibility with the S5PV210 MIPI CSIS/DSIM PHY and thus
>> should use +  "samsung,s5pv210-video-phy";
>> +- reg : offset and length of the MIPI DPHY register set;
>> +- #phy-cells : from the generic phy bindings, must be 1;
>> +
>> +For "samsung,s5pv210-video-phy" compatible DPHYs the second cell in the
>> PHY +specifier identifies the DPHY and its meaning is as follows:
>> +  0 - MIPI CSIS 0,
>> +  1 - MIPI DSIM 0,
>> +  2 - MIPI CSIS 1,
>> +  3 - MIPI DSIM 1.
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 0764a54..d234e99 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -11,3 +11,13 @@ menuconfig GENERIC_PHY
>>  	  devices present in the kernel. This layer will have the generic
>>  	  API by which phy drivers can create PHY using the phy framework 
> and
>>  	  phy users can obtain reference to the PHY.
>> +
>> +if GENERIC_PHY
>> +
>> +config EXYNOS_VIDEO_MIPI_PHY
>> +	bool "S5P/EXYNOS MIPI CSI-2/DSI PHY driver"
>> +	depends on OF
> 
> Hmm. Is this driver designed only for OF-enabled boards?

Yes, there seems currently to be no users of MIPI CSIS/DSIM in the mainline 
kernel among the non-dt platforms, so I initially focused on DT only. I will
rework this driver to make it usable on non-dt platforms, but I currently 
have not way to fully test it. I believe S5PV210 will get migrated to device
tree sooner than anyone needs the functionality this driver provides on 
non-dt, and S5PC100 seems to be forgotten anyway.

>> +	help
>> +	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung
>> +	  S5P and EXYNOS SoCs.
>> +endif
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 9e9560f..b16f2c1 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -2,4 +2,5 @@
>>  # Makefile for the phy drivers.
>>  #
>>
>> -obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>> +obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
>> +obj-$(CONFIG_EXYNOS_VIDEO_MIPI_PHY)	+= exynos_video_mipi_phy.o
>> diff --git a/drivers/phy/exynos_video_mipi_phy.c
>> b/drivers/phy/exynos_video_mipi_phy.c new file mode 100644
>> index 0000000..8d4976f
>> --- /dev/null
>> +++ b/drivers/phy/exynos_video_mipi_phy.c
>> @@ -0,0 +1,166 @@
>> +/*
>> + * Samsung S5P/EXYNOS SoC series MIPI CSIS/DSIM DPHY driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as +
>> * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/spinlock.h>
>> +
>> +/* MIPI_PHYn_CONTROL register bit definitions */
>> +#define EXYNOS_MIPI_PHY_ENABLE		(1 << 0)
>> +#define EXYNOS_MIPI_PHY_SRESETN		(1 << 1)
>> +#define EXYNOS_MIPI_PHY_MRESETN		(1 << 2)
>> +#define EXYNOS_MIPI_PHY_RESET_MASK	(3 << 1)
>> +
>> +#define EXYNOS_MAX_VIDEO_PHYS		4
>> +
>> +struct exynos_video_phy {
>> +	spinlock_t slock;
>> +	struct phy *phys[EXYNOS_MAX_VIDEO_PHYS];
>> +	void __iomem *regs;
>> +};
>> +
>> +/*
>> + * The @id argument specifies MIPI CSIS or DSIM PHY as follows:
>> + *  0 - MIPI CSIS 0
>> + *  1 - MIPI DSIM 0
>> + *  2 - MIPI CSIS 1
>> + *  3 - MIPI DSIM 1
>> + */
>> +static int set_phy_state(struct exynos_video_phy *state,
>> +					unsigned int id, int on)
>> +{
>> +	void __iomem *addr = id < 2 ? state->regs : state->regs + 4;
> 
> I don't find this statement too readable. What about:
> 
> 	void __iomem *addr = state->regs;
> 
> and below:
> 
> 	/* CSIS 1 and DSIM 1 PHYs have separate register */
> 	if (id >= 2)
> 		addr += 4;

OK, thanks for the suggestion. I've addressed this in v2.

>> +	unsigned long flags;
>> +	u32 reg, reset;
>> +
>> +	pr_debug("%s(): id: %d, on: %d, addr: %#x, base: %#x\n",
>> +		 __func__, id, on, (u32)addr, (u32)state->regs);
>> +
>> +	if (WARN_ON(id > EXYNOS_MAX_VIDEO_PHYS))
>> +		return -EINVAL;
>> +
>> +	if (id & 1)
> 
> Nice trick ;), but not very readable. What about creating an enum of PHYs 
> and using those defined values here:
> 
> 	if (id == PHY_DSI0 || id == PHY_DSI1)

Yeah, good point. Fixed.

>> +		reset = EXYNOS_MIPI_PHY_MRESETN;
>> +	else
>> +		reset = EXYNOS_MIPI_PHY_SRESETN;
>> +
>> +	spin_lock_irqsave(&state->slock, flags);
>> +
>> +	reg = readl(addr);
>> +	if (on)
>> +		reg |= reset;
>> +	else
>> +		reg &= ~reset;
>> +	writel(reg, addr);
>> +
>> +	if (on)
>> +		reg |= EXYNOS_MIPI_PHY_ENABLE;
> 
> I believe this is a kind of reference counting, but a comment here would 
> be nice.

Indeed, I've added a comment.

>> +	else if (!(reg & EXYNOS_MIPI_PHY_RESET_MASK))
>> +		reg &= ~EXYNOS_MIPI_PHY_ENABLE;
>> +
>> +	writel(reg, addr);
>> +
>> +	spin_unlock_irqrestore(&state->slock, flags);
>> +	return 0;
>> +}
>> +
>> +static int exynos_video_phy_power_on(struct phy *phy)
>> +{
>> +	struct exynos_video_phy *state = dev_get_drvdata(&phy->dev);
>> +	return set_phy_state(state, phy->id, 1);
>> +}
>> +
>> +static int exynos_video_phy_power_off(struct phy *phy)
>> +{
>> +	struct exynos_video_phy *state = dev_get_drvdata(&phy->dev);
>> +	return set_phy_state(state, phy->id, 0);
>> +}
>> +
>> +static struct phy *exynos_video_phy_xlate(struct device *dev,
>> +					struct of_phandle_args *args)
>> +{
>> +	struct exynos_video_phy *state = dev_get_drvdata(dev);
>> +
>> +	if (WARN_ON(args->args[0] > EXYNOS_MAX_VIDEO_PHYS))
>> +		return NULL;
>> +
>> +	return state->phys[args->args[0]];
>> +}
>> +
>> +static struct phy_ops exynos_video_phy_ops = {
>> +	.power_on	= exynos_video_phy_power_on,
>> +	.power_off	= exynos_video_phy_power_off,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int exynos_video_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct exynos_video_phy *state;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource res;
>> +	struct phy_provider *phy_provider;
>> +	int ret, i;
>> +
>> +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
>> +	if (!state)
>> +		return -ENOMEM;
>> +
>> +	ret = of_address_to_resource(dev->of_node, 0, &res);
>> +	if (ret < 0)
>> +		return ret;
> 
> You can use platform_get_resource() here to get a resource generated for 
> you by of_platform_populate().
> 
> In addition you don't need to check the pointer returned by 
> platform_get_resource() because it is checked in devm_ioremap_resource().

Fixed.

>> +
>> +	state->regs = devm_ioremap_resource(dev, &res);
>> +	if (IS_ERR(state->regs))
>> +		return PTR_ERR(state->regs);
>> +
>> +	dev_set_drvdata(dev, state);
>> +
>> +	phy_provider = devm_of_phy_provider_register(dev, THIS_MODULE,
>> +					    exynos_video_phy_xlate);
>> +	if (IS_ERR(phy_provider))
>> +		return PTR_ERR(phy_provider);
>> +
>> +	for (i = 0; i < EXYNOS_MAX_VIDEO_PHYS; i++) {
>> +		state->phys[i] = devm_phy_create(dev, i, 
> &exynos_video_phy_ops,
>> +									
> state);
>> +		if (IS_ERR(state->phys[i])) {
>> +			dev_err(dev, "failed to create PHY %d\n", i);
>> +			return PTR_ERR(state->phys[i]);
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id exynos_video_phy_of_match[] = {
>> +	{ .compatible = "samsung,s5pv210-video-phy" },
>> +	{ },
>> +};
> 
> IMHO a MODULE_DEVICE_TABLE should be added here.

True, added after modifying the Kconfig entry to allow this driver 
to be built as a module.

Regards,
Sylwester
