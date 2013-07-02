Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:50093 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GBG7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 02:59:03 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	linux-fbdev@vger.kernel.org, 'Hui Wang' <jason77.wang@gmail.com>,
	Jingoo Han <jg1.han@samsung.com>
References: <005301ce761b$32adf960$9809ec20$@samsung.com>
 <51D1DCF0.50803@gmail.com>
In-reply-to: <51D1DCF0.50803@gmail.com>
Subject: Re: [PATCH V3 2/3] phy: Add driver for Exynos DP PHY
Date: Tue, 02 Jul 2013 15:58:44 +0900
Message-id: <000001ce76f1$97e47210$c7ad5630$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, July 02, 2013 4:48 AM, Sylwester Nawrocki wrote:
> On 07/01/2013 07:24 AM, Jingoo Han wrote:
> > Add a PHY provider driver for the Samsung Exynos SoC DP PHY.
> >
> > Signed-off-by: Jingoo Han<jg1.han@samsung.com>
> > Cc: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > Acked-by: Felipe Balbi<balbi@ti.com>
> > ---
> >   .../devicetree/bindings/phy/samsung-phy.txt        |    8 ++
> >   drivers/phy/Kconfig                                |    5 +
> >   drivers/phy/Makefile                               |    1 +
> >   drivers/phy/phy-exynos-dp-video.c                  |  118 ++++++++++++++++++++
> >   4 files changed, 132 insertions(+)
> >   create mode 100644 drivers/phy/phy-exynos-dp-video.c
> >
> > diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> > index 5ff208c..3fb656a 100644
> > --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> > +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> > @@ -12,3 +12,11 @@ the PHY specifier identifies the PHY and its meaning is as follows:
> >     1 - MIPI DSIM 0,
> >     2 - MIPI CSIS 1,
> >     3 - MIPI DSIM 1.
> > +
> > +Samsung EXYNOS SoC series DP PHY
> 
> I would make it "Samsung EXYNOS SoC series Display Port PHY"

OK.

> 
> > +-------------------------------------------------
> > +
> > +Required properties:
> > +- compatible : should be "samsung,exynos5250-dp-video-phy";
> > +- reg : offset and length of the DP PHY register set;
> > +- #phy-cells : from the generic phy bindings, must be 0;
> 
> s/phy/PHY ?

OK.

> 
> > \ No newline at end of file
> 
> Missing new line character.

OK.

> 
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index 6f446d0..760f55a 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -19,4 +19,9 @@ config PHY_EXYNOS_MIPI_VIDEO
> >   	help
> >   	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung
> >   	  S5P and EXYNOS SoCs.
> > +
> > +config PHY_EXYNOS_DP_VIDEO
> > +	tristate "EXYNOS SoC series DP PHY driver"
> 
> "EXYNOS SoC series Display Port PHY driver" ?
> 
> > +	help
> > +	  Support for DP PHY found on Samsung EXYNOS SoCs.
> 
> s/DP/Display Port ?

OK.

> 
> >   endif
> > diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> > index 71d8841..0fd1340 100644
> > --- a/drivers/phy/Makefile
> > +++ b/drivers/phy/Makefile
> > @@ -4,3 +4,4 @@
> >
> >   obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> >   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> > +obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
> > diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
> > new file mode 100644
> > index 0000000..75e1d11
> > --- /dev/null
> > +++ b/drivers/phy/phy-exynos-dp-video.c
> > @@ -0,0 +1,118 @@
> > +/*
> > + * Samsung EXYNOS SoC series DP PHY driver
> 
> s/DP/Display Port ?

OK.

> 
> > + *
> > + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > + * Author: Jingoo Han<jg1.han@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include<linux/io.h>
> > +#include<linux/kernel.h>
> > +#include<linux/module.h>
> > +#include<linux/of.h>
> > +#include<linux/of_address.h>
> > +#include<linux/phy/phy.h>
> > +#include<linux/platform_device.h>
> > +
> > +/* DPTX_PHY_CONTROL register */
> > +#define EXYNOS_DPTX_PHY_ENABLE		(1<<  0)
> > +
> > +struct exynos_dp_video_phy {
> > +	void __iomem *regs;
> > +};
> > +
> > +static int __set_phy_state(struct exynos_dp_video_phy *state, unsigned int on)
> > +{
> > +	void __iomem *addr;
> 
> How about just dropping this local variable ?

OK.
I will drop this local variable.

> 
> > +	u32 reg;
> > +
> > +	addr = state->regs;
> > +
> > +	reg = readl(addr);
> > +	if (on)
> > +		reg |= EXYNOS_DPTX_PHY_ENABLE;
> > +	else
> > +		reg&= ~EXYNOS_DPTX_PHY_ENABLE;
> > +	writel(reg, addr);
> > +
> > +	return 0;
> > +}
> > +
> > +static int exynos_dp_video_phy_power_on(struct phy *phy)
> > +{
> > +	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
> > +
> > +	return __set_phy_state(state, 1);
> > +}
> > +
> > +static int exynos_dp_video_phy_power_off(struct phy *phy)
> > +{
> > +	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
> > +
> > +	return __set_phy_state(state, 0);
> > +}
> > +
> > +static struct phy_ops exynos_dp_video_phy_ops = {
> > +	.power_on	= exynos_dp_video_phy_power_on,
> > +	.power_off	= exynos_dp_video_phy_power_off,
> > +	.owner		= THIS_MODULE,
> > +};
> > +
> > +static int exynos_dp_video_phy_probe(struct platform_device *pdev)
> > +{
> > +	struct exynos_dp_video_phy *state;
> > +	struct device *dev =&pdev->dev;
> > +	struct resource *res;
> > +	struct phy_provider *phy_provider;
> > +	struct phy *phy;
> > +
> > +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
> > +	if (!state)
> > +		return -ENOMEM;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > +	state->regs = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(state->regs))
> > +		return PTR_ERR(state->regs);
> > +
> > +	dev_set_drvdata(dev, state);
> 
> I can't see any corresponding dev_get_drvdata(), it should be safe
> to remove this assignment.

OK.
I will remove 'dev_set_drvdata(dev, state)'.

> 
> > +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> > +	if (IS_ERR(phy_provider))
> > +		return PTR_ERR(phy_provider);
> > +
> > +	phy = devm_phy_create(dev, 0,&exynos_dp_video_phy_ops, "dp");
> 
> The label could be NULL, since there is no need to support non-dt config.

OK.
I will replace "dp" with NULL.

> 
> > +	if (IS_ERR(phy)) {
> > +		dev_err(dev, "failed to create DP PHY\n");
> > +		return PTR_ERR(phy);
> > +	}
> > +	phy_set_drvdata(phy, state);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_OF
> 
> You don't use of_match_ptr() macro to assign of_match_table to the driver
> structure below. This means build with CONFIG_OF disabled is broken now.
> I would just remove that #ifdef and would make the driver depends on
> CONFIG_OF.

OK.
I will add 'depends on OF', then remove '#ifdef CONFIG_OF'.

Thank you for your detailed comment. :)

Best regards,
Jingoo Han

> 
> > +static const struct of_device_id exynos_dp_video_phy_of_match[] = {
> > +	{ .compatible = "samsung,exynos5250-dp-video-phy" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);
> > +#endif
> > +
> > +static struct platform_driver exynos_dp_video_phy_driver = {
> > +	.probe	= exynos_dp_video_phy_probe,
> > +	.driver = {
> > +		.name	= "exynos-dp-video-phy",
> > +		.owner	= THIS_MODULE,
> > +		.of_match_table	= exynos_dp_video_phy_of_match,
> > +	}
> > +};
> > +module_platform_driver(exynos_dp_video_phy_driver);
> > +
> > +MODULE_AUTHOR("Jingoo Han<jg1.han@samsung.com>");
> > +MODULE_DESCRIPTION("Samsung EXYNOS SoC DP PHY driver");
> > +MODULE_LICENSE("GPL v2");
> 
> Thanks,
> Sylwester

