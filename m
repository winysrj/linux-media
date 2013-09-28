Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33784 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3I1Tfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 15:35:53 -0400
Message-ID: <52472F93.7000205@gmail.com>
Date: Sat, 28 Sep 2013 21:35:47 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>, kishon@ti.com,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, tomi.valkeinen@ti.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V5 2/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com> <1380396467-29278-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1380396467-29278-3-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(adding missing devicetree mailing list at Cc)

On 09/28/2013 09:27 PM, Sylwester Nawrocki wrote:
> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
> receiver and MIPI DSI transmitter DPHYs.
>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
> Changes since v4:
>   - updated to latest version of the PHY framework - removed PHY
>     labels.
>
> The individual driver symbols in drivers/phy/Kconfig should
> presumably be prefixed with, e.g. PHY_. This is something that
> perhaps could be done as a follow up patch.
> ---
>   .../devicetree/bindings/phy/samsung-phy.txt        |   14 ++
>   drivers/phy/Kconfig                                |    6 +
>   drivers/phy/Makefile                               |    7 +-
>   drivers/phy/phy-exynos-mipi-video.c                |  176 ++++++++++++++++++++
>   4 files changed, 200 insertions(+), 3 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
>   create mode 100644 drivers/phy/phy-exynos-mipi-video.c
>
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> new file mode 100644
> index 0000000..5ff208c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -0,0 +1,14 @@
> +Samsung S5P/EXYNOS SoC series MIPI CSIS/DSIM DPHY
> +-------------------------------------------------
> +
> +Required properties:
> +- compatible : should be "samsung,s5pv210-mipi-video-phy";
> +- reg : offset and length of the MIPI DPHY register set;
> +- #phy-cells : from the generic phy bindings, must be 1;
> +
> +For "samsung,s5pv210-mipi-video-phy" compatible PHYs the second cell in
> +the PHY specifier identifies the PHY and its meaning is as follows:
> +  0 - MIPI CSIS 0,
> +  1 - MIPI DSIM 0,
> +  2 - MIPI CSIS 1,
> +  3 - MIPI DSIM 1.
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index ac239ac..0062d7e 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,6 +15,12 @@ config GENERIC_PHY
>   	  phy users can obtain reference to the PHY. All the users of this
>   	  framework should select this config.
>
> +config PHY_EXYNOS_MIPI_VIDEO
> +	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
> +	help
> +	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung S5P
> +	  and EXYNOS SoCs.
> +
>   config OMAP_USB2
>   	tristate "OMAP USB2 PHY Driver"
>   	depends on ARCH_OMAP2PLUS
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 0dd8a98..6344053 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -2,6 +2,7 @@
>   # Makefile for the phy drivers.
>   #
>
> -obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
> -obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
> -obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
> +obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> +obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
> +obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
> +obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
> new file mode 100644
> index 0000000..b73b86a
> --- /dev/null
> +++ b/drivers/phy/phy-exynos-mipi-video.c
> @@ -0,0 +1,176 @@
> +/*
> + * Samsung S5P/EXYNOS SoC series MIPI CSIS/DSIM DPHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki<s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/io.h>
> +#include<linux/kernel.h>
> +#include<linux/module.h>
> +#include<linux/of.h>
> +#include<linux/of_address.h>
> +#include<linux/phy/phy.h>
> +#include<linux/platform_device.h>
> +#include<linux/spinlock.h>
> +
> +/* MIPI_PHYn_CONTROL register offset: n = 0..1 */
> +#define EXYNOS_MIPI_PHY_CONTROL(n)	((n) * 4)
> +#define EXYNOS_MIPI_PHY_ENABLE		(1<<  0)
> +#define EXYNOS_MIPI_PHY_SRESETN		(1<<  1)
> +#define EXYNOS_MIPI_PHY_MRESETN		(1<<  2)
> +#define EXYNOS_MIPI_PHY_RESET_MASK	(3<<  1)
> +
> +enum exynos_mipi_phy_id {
> +	EXYNOS_MIPI_PHY_ID_CSIS0,
> +	EXYNOS_MIPI_PHY_ID_DSIM0,
> +	EXYNOS_MIPI_PHY_ID_CSIS1,
> +	EXYNOS_MIPI_PHY_ID_DSIM1,
> +	EXYNOS_MIPI_PHYS_NUM
> +};
> +
> +#define is_mipi_dsim_phy_id(id) \
> +	((id) == EXYNOS_MIPI_PHY_ID_DSIM0 || (id) == EXYNOS_MIPI_PHY_ID_DSIM1)
> +
> +struct exynos_mipi_video_phy {
> +	spinlock_t slock;
> +	struct video_phy_desc {
> +		struct phy *phy;
> +		unsigned int index;
> +	} phys[EXYNOS_MIPI_PHYS_NUM];
> +	void __iomem *regs;
> +};
> +
> +static int __set_phy_state(struct exynos_mipi_video_phy *state,
> +			enum exynos_mipi_phy_id id, unsigned int on)
> +{
> +	void __iomem *addr;
> +	u32 reg, reset;
> +
> +	addr = state->regs + EXYNOS_MIPI_PHY_CONTROL(id / 2);
> +
> +	if (is_mipi_dsim_phy_id(id))
> +		reset = EXYNOS_MIPI_PHY_MRESETN;
> +	else
> +		reset = EXYNOS_MIPI_PHY_SRESETN;
> +
> +	spin_lock(&state->slock);
> +	reg = readl(addr);
> +	if (on)
> +		reg |= reset;
> +	else
> +		reg&= ~reset;
> +	writel(reg, addr);
> +
> +	/* Clear ENABLE bit only if MRESETN, SRESETN bits are not set. */
> +	if (on)
> +		reg |= EXYNOS_MIPI_PHY_ENABLE;
> +	else if (!(reg&  EXYNOS_MIPI_PHY_RESET_MASK))
> +		reg&= ~EXYNOS_MIPI_PHY_ENABLE;
> +
> +	writel(reg, addr);
> +	spin_unlock(&state->slock);
> +	return 0;
> +}
> +
> +#define to_mipi_video_phy(desc) \
> +	container_of((desc), struct exynos_mipi_video_phy, phys[(desc)->index]);
> +
> +static int exynos_mipi_video_phy_power_on(struct phy *phy)
> +{
> +	struct video_phy_desc *phy_desc = phy_get_drvdata(phy);
> +	struct exynos_mipi_video_phy *state = to_mipi_video_phy(phy_desc);
> +
> +	return __set_phy_state(state, phy_desc->index, 1);
> +}
> +
> +static int exynos_mipi_video_phy_power_off(struct phy *phy)
> +{
> +	struct video_phy_desc *phy_desc = phy_get_drvdata(phy);
> +	struct exynos_mipi_video_phy *state = to_mipi_video_phy(phy_desc);
> +
> +	return __set_phy_state(state, phy_desc->index, 1);
> +}
> +
> +static struct phy *exynos_mipi_video_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct exynos_mipi_video_phy *state = dev_get_drvdata(dev);
> +
> +	if (WARN_ON(args->args[0]>  EXYNOS_MIPI_PHYS_NUM))
> +		return ERR_PTR(-ENODEV);
> +
> +	return state->phys[args->args[0]].phy;
> +}
> +
> +static struct phy_ops exynos_mipi_video_phy_ops = {
> +	.power_on	= exynos_mipi_video_phy_power_on,
> +	.power_off	= exynos_mipi_video_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
> +{
> +	struct exynos_mipi_video_phy *state;
> +	struct device *dev =&pdev->dev;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +	unsigned int i;
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
> +	spin_lock_init(&state->slock);
> +
> +	phy_provider = devm_of_phy_provider_register(dev,
> +					exynos_mipi_video_phy_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	for (i = 0; i<  EXYNOS_MIPI_PHYS_NUM; i++) {
> +		struct phy *phy = devm_phy_create(dev,
> +					&exynos_mipi_video_phy_ops, NULL);
> +		if (IS_ERR(phy)) {
> +			dev_err(dev, "failed to create PHY %d\n", i);
> +			return PTR_ERR(phy);
> +		}
> +
> +		state->phys[i].phy = phy;
> +		state->phys[i].index = i;
> +		phy_set_drvdata(phy,&state->phys[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id exynos_mipi_video_phy_of_match[] = {
> +	{ .compatible = "samsung,s5pv210-mipi-video-phy" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, exynos_mipi_video_phy_of_match);
> +
> +static struct platform_driver exynos_mipi_video_phy_driver = {
> +	.probe	= exynos_mipi_video_phy_probe,
> +	.driver = {
> +		.of_match_table	= exynos_mipi_video_phy_of_match,
> +		.name  = "exynos-mipi-video-phy",
> +		.owner = THIS_MODULE,
> +	}
> +};
> +module_platform_driver(exynos_mipi_video_phy_driver);
> +
> +MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC MIPI CSI-2/DSI PHY driver");
> +MODULE_AUTHOR("Sylwester Nawrocki<s.nawrocki@samsung.com>");
> +MODULE_LICENSE("GPL v2");
