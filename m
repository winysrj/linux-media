Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59174 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab3F1Fb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 01:31:56 -0400
Message-ID: <51CD1FA7.2010608@ti.com>
Date: Fri, 28 Jun 2013 11:01:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
	"'Felipe Balbi'" <balbi@ti.com>,
	"'Tomasz Figa'" <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>,
	"'Inki Dae'" <inki.dae@samsung.com>,
	"'Donghwa Lee'" <dh09.lee@samsung.com>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] phy: Add driver for Exynos DP PHY
References: <001501ce73bf$87c49c00$974dd400$@samsung.com>
In-Reply-To: <001501ce73bf$87c49c00$974dd400$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 28 June 2013 10:52 AM, Jingoo Han wrote:
> Add a PHY provider driver for the Samsung Exynos SoC DP PHY.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   .../phy/samsung,exynos5250-dp-video-phy.txt        |    7 ++
>   drivers/phy/Kconfig                                |    8 ++
>   drivers/phy/Makefile                               |    3 +-
>   drivers/phy/phy-exynos-dp-video.c                  |  130 ++++++++++++++++++++
>   4 files changed, 147 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
>   create mode 100644 drivers/phy/phy-exynos-dp-video.c
>
> diff --git a/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> b/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> new file mode 100644
> index 0000000..8b6fa79
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> @@ -0,0 +1,7 @@
> +Samsung EXYNOS SoC series DP PHY
> +-------------------------------------------------
> +
> +Required properties:
> +- compatible : should be "samsung,exynos5250-dp-video-phy";
> +- reg : offset and length of the DP PHY register set;
> +- #phy-cells : from the generic phy bindings, must be 1;
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 5f85909..6d10e3b 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -11,3 +11,11 @@ menuconfig GENERIC_PHY
>   	  devices present in the kernel. This layer will have the generic
>   	  API by which phy drivers can create PHY using the phy framework and
>   	  phy users can obtain reference to the PHY.
> +
> +if GENERIC_PHY
> +
> +config PHY_EXYNOS_DP_VIDEO
> +	tristate "EXYNOS SoC series DP PHY driver"
> +	help
> +	  Support for DP PHY found on Samsung EXYNOS SoCs.
> +endif
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 9e9560f..d8d861c 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -2,4 +2,5 @@
>   # Makefile for the phy drivers.
>   #
>
> -obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
> +obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> +obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
> diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
> new file mode 100644
> index 0000000..376b3bc2
> --- /dev/null
> +++ b/drivers/phy/phy-exynos-dp-video.c
> @@ -0,0 +1,130 @@
> +/*
> + * Samsung EXYNOS SoC series DP PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Jingoo Han <jg1.han@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/delay.h>

this header file is not needed here.

> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +
> +/* DPTX_PHY_CONTROL register */
> +#define EXYNOS_DPTX_PHY_ENABLE		(1 << 0)
> +
> +struct exynos_dp_video_phy {
> +	spinlock_t slock;
> +	struct phy *phys;
> +	void __iomem *regs;
> +};
> +
> +static int __set_phy_state(struct exynos_dp_video_phy *state, unsigned int on)
> +{
> +	void __iomem *addr;
> +	unsigned long flags;
> +	u32 reg;
> +
> +	addr = state->regs;
> +
> +	spin_lock_irqsave(&state->slock, flags);
> +	reg = readl(addr);
> +	if (on)
> +		reg |= EXYNOS_DPTX_PHY_ENABLE;
> +	else
> +		reg &= ~EXYNOS_DPTX_PHY_ENABLE;
> +	writel(reg, addr);
> +	spin_unlock_irqrestore(&state->slock, flags);
> +	return 0;
> +}
> +
> +static int exynos_dp_video_phy_power_on(struct phy *phy)
> +{
> +	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
> +
> +	return __set_phy_state(state, 1);
> +}
> +
> +static int exynos_dp_video_phy_power_off(struct phy *phy)
> +{
> +	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
> +
> +	return __set_phy_state(state, 0);
> +}
> +
> +static struct phy *exynos_dp_video_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct exynos_dp_video_phy *state = dev_get_drvdata(dev);
> +
> +	return state->phys;

you can instead use of_phy_simple_xlate for such simple cases.
> +}
> +
> +static struct phy_ops exynos_dp_video_phy_ops = {
> +	.power_on	= exynos_dp_video_phy_power_on,
> +	.power_off	= exynos_dp_video_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int exynos_dp_video_phy_probe(struct platform_device *pdev)
> +{
> +	struct exynos_dp_video_phy *state;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +
> +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	state->regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(state->regs))
> +		return PTR_ERR(state->regs);
> +
> +	dev_set_drvdata(dev, state);
> +
> +	phy_provider = devm_of_phy_provider_register(dev,
> +					exynos_dp_video_phy_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	state->phys = devm_phy_create(dev, 0, &exynos_dp_video_phy_ops, "dp");
> +	if (IS_ERR(state->phys)) {
> +		dev_err(dev, "failed to create DP PHY\n");
> +		return PTR_ERR(state->phys);
> +	}
> +	phy_set_drvdata(state->phys, state);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id exynos_dp_video_phy_of_match[] = {
> +	{ .compatible = "samsung,exynos5250-dp-video-phy" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);

This above should come inside #ifdef CONFIG_OF.
> +
> +static struct platform_driver exynos_dp_video_phy_driver = {
> +	.probe	= exynos_dp_video_phy_probe,

missing .remove?
> +	.driver = {
> +		.of_match_table	= exynos_dp_video_phy_of_match,
> +		.name  = "exynos-dp-video-phy",
> +		.owner = THIS_MODULE,
> +	}
> +};
> +module_platform_driver(exynos_dp_video_phy_driver);
> +
> +MODULE_DESCRIPTION("Samsung EXYNOS SoC DP PHY driver");
> +MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
> +MODULE_LICENSE("GPL v2");

Thanks
Kishon
