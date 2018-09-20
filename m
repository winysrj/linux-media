Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55166 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732768AbeITTD3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 15:03:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Luis Oliveira <Luis.Oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao.Pinto@synopsys.com, festevam@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [V2, 3/5] media: platform: dwc: Add DW MIPI DPHY Rx platform
Date: Thu, 20 Sep 2018 16:20:07 +0300
Message-ID: <2037079.W48hn0vDH1@avalon>
In-Reply-To: <20180920111648.27000-4-lolivei@synopsys.com>
References: <20180920111648.27000-1-lolivei@synopsys.com> <20180920111648.27000-4-lolivei@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Louis,

Thank you for the patch.

On Thursday, 20 September 2018 14:16:41 EEST Luis Oliveira wrote:
> Add of Synopsys MIPI D-PHY in RX mode support.
> Separated in the implementation are platform dependent probing functions.
> 
> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> ---
> Changelog
> v2:
> - fix uninitialization warning
> - fix SDPX License to match: Documentation/process/license-rules.rst
> 
>  drivers/media/platform/dwc/Kconfig        |  32 ++
>  drivers/media/platform/dwc/Makefile       |   2 +
>  drivers/media/platform/dwc/dw-dphy-plat.c | 365 ++++++++++++++++++
>  drivers/media/platform/dwc/dw-dphy-rx.c   | 594 +++++++++++++++++++++++++++
>  drivers/media/platform/dwc/dw-dphy-rx.h   | 176 +++++++++

Is there really a need to split this in two source files ? It smells of OS 
abstraction layers.

>  5 files changed, 1169 insertions(+)
>  create mode 100644 drivers/media/platform/dwc/dw-dphy-plat.c
>  create mode 100644 drivers/media/platform/dwc/dw-dphy-rx.c
>  create mode 100644 drivers/media/platform/dwc/dw-dphy-rx.h

As this is a PHY driver, shouldn't it be located in drivers/phy/ ?

> diff --git a/drivers/media/platform/dwc/Kconfig
> b/drivers/media/platform/dwc/Kconfig index e69de29..a573297 100644
> --- a/drivers/media/platform/dwc/Kconfig
> +++ b/drivers/media/platform/dwc/Kconfig
> @@ -0,0 +1,32 @@
> +#
> +#  Synopsys DWC Platform drivers
> +#	Most drivers here are currently for MIPI CSI-2 and MIPI DPHY support
> +
> +config DWC_MIPI_CSI2_HOST
> +	bool "Synopsys Designware CSI-2 Host Controller and DPHY-RX support"

There's no CSI-2 host controller in this patch.

> +	select VIDEO_DEV
> +	select VIDEO_V4L2
> +	select VIDEO_V4L2_SUBDEV_API
> +	select VIDEOBUF2_VMALLOC
> +	select VIDEOBUF2_DMA_CONTIG

All these don't seem to be needed.

> +	select GENERIC_PHY
> +	select VIDEO_OV5647

And I'm pretty sure you can use the PHY without an OV5647 sensor :-)

> +	help
> +	 This selects the CSI-2 host controller support.
> +
> +	 If you have a controller with this interface, say Y.
> +
> +	  If unsure, say N.
> +
> +if DWC_MIPI_CSI2_HOST
> +
> +config DWC_MIPI_TC_DPHY_G128
> +	tristate "DesignWare platform support using a G128 Test Chip"
> +	depends on DWC_MIPI_CSI2_HOST
> +	help
> +	 Synopsys Test Chip is a MIPI D-PHY for prototyping purposes.
> +
> +	  If unsure, say N.
> +
> +endif # DWC_MIPI_CSI2_HOST
> +
> diff --git a/drivers/media/platform/dwc/Makefile
> b/drivers/media/platform/dwc/Makefile index e69de29..8be6f68 100644
> --- a/drivers/media/platform/dwc/Makefile
> +++ b/drivers/media/platform/dwc/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_DWC_MIPI_TC_DPHY_G128)	+= dw-dphy-platfrm.o
> +dw-dphy-platfrm-objs	:= dw-dphy-plat.o dw-dphy-rx.o
> diff --git a/drivers/media/platform/dwc/dw-dphy-plat.c
> b/drivers/media/platform/dwc/dw-dphy-plat.c new file mode 100644
> index 0000000..8e298f5
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw-dphy-plat.c
> @@ -0,0 +1,365 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * dw-dphy-plat.c
> + *
> + * Copyright(c) 2018-present, Synopsys, Inc. and/or its affiliates.

I don't think that -present is right. The copyright notice should list the 
years explicitly.

> + * Luis Oliveira <Luis.Oliveira@synopsys.com>
> + *
> + */
> +
> +#include "dw-dphy-rx.h"
> +
> +static struct phy *dw_dphy_xlate(struct device *dev,
> +			struct of_phandle_args *args)
> +{
> +	struct dw_dphy_rx *dphy = dev_get_drvdata(dev);
> +
> +	return dphy->phy;
> +}
> +
> +static ssize_t dphy_reset_show(struct device *dev,
> +			struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	char buffer[15];
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +	usleep_range(100, 200);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 1);
> +
> +	return strlcpy(buf, buffer, PAGE_SIZE);
> +}
> +
> +static ssize_t dphy_freq_store(struct device *dev,
> +			struct device_attribute *attr,
> +			const char *buf,
> +			size_t count)
> +{
> +	int ret;
> +	unsigned long freq;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +
> +	ret = kstrtoul(buf, 10, &freq);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (freq > 2500) {
> +		dev_info(dev, "Freq must be under 2500 Mhz\n");
> +		return count;
> +	}
> +	if (freq < 80) {
> +		dev_info(dev, "Freq must be over 80 Mhz\n");
> +		return count;
> +	}
> +
> +	dev_info(dev, "Data Rate %lu Mbps\n", freq);
> +	dphy->dphy_freq = freq * 1000;
> +
> +	return count;
> +
> +}
> +
> +static ssize_t dphy_freq_show(struct device *dev,
> +			struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	char buffer[15];
> +
> +	snprintf(buffer, 15, "Freq %d\n", dphy->dphy_freq / 1000);
> +
> +	return strlcpy(buf, buffer, PAGE_SIZE);
> +}
> +
> +static ssize_t dphy_addr_store(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int ret;
> +	u8 addr, payload;
> +
> +	ret = kstrtoul(buf, 32, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	payload = (u16)val;
> +	addr = (u16)(val >> 16);
> +
> +	dev_info(dev, "addr 0x%lX\n", val);
> +	dev_info(dev, "payload: 0x%X\n", addr);
> +
> +	dev_info(dev,
> +		"Addr [0x%x] -> 0x%x\n", (unsigned int)addr,
> +		dw_dphy_te_read(dphy, addr));
> +
> +	return count;
> +}
> +
> +static ssize_t idelay_show(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	char buffer[15];
> +
> +	snprintf(buffer, 15, "idelay %d\n", dw_dphy_if_get_idelay(dphy));
> +
> +	return strlcpy(buf, buffer, PAGE_SIZE);
> +}
> +
> +static ssize_t idelay_store(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	int ret;
> +	unsigned long val;
> +	u8 lane, delay;
> +
> +	ret = kstrtoul(buf, 16, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	lane = (u8)val;
> +	delay = (u8)(val >> 8);
> +
> +	dev_dbg(dev, "Lanes %u\n", lane);
> +	dev_dbg(dev, "Delay %u\n", delay);
> +
> +	dw_dphy_if_set_idelay_lane(dphy, delay, lane);
> +
> +	return count;
> +}
> +
> +static ssize_t len_config_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	int ret;
> +	unsigned long length;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +
> +	ret = kstrtoul(buf, 10, &length);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (length == BIT8)
> +		pr_info("Configured for 8-bit interface\n");
> +	else if (length == BIT12)
> +		pr_info("Configured for 12-bit interface\n");
> +	else
> +		return count;
> +
> +	dphy->dphy_te_len = length;
> +
> +	return count;
> +
> +}
> +
> +static ssize_t len_config_show(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	char buffer[20];
> +
> +	snprintf(buffer, 20, "Length %d\n", dphy->dphy_te_len);
> +
> +	return strlcpy(buf, buffer, PAGE_SIZE);
> +}
> +
> +static ssize_t dw_dphy_g118_settle_store(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t count)
> +{
> +	int ret;
> +	unsigned long lp_time;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +
> +	ret = kstrtoul(buf, 10, &lp_time);
> +	if (ret < 0)
> +		return ret;
> +
> +	if ((lp_time > 1) && (lp_time < 10000))
> +		dphy->lp_time = lp_time;
> +	else {
> +		pr_info("Invalid Value configuring for 1000 ns\n");
> +		dphy->lp_time = 1000;
> +	}
> +
> +	dphy->lp_time = lp_time;
> +
> +	return count;
> +
> +}
> +
> +static ssize_t dw_dphy_g118_settle_show(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dphy_rx *dphy = platform_get_drvdata(pdev);
> +	char buffer[10];
> +
> +	snprintf(buffer, 10, "Settle %d ns\n", dphy->lp_time);
> +
> +	return strlcpy(buf, buffer, PAGE_SIZE);
> +}
> +
> +static DEVICE_ATTR_RO(dphy_reset);
> +static DEVICE_ATTR_RW(dphy_freq);
> +static DEVICE_ATTR_WO(dphy_addr);
> +static DEVICE_ATTR_RW(idelay);
> +static DEVICE_ATTR_RW(len_config);
> +static DEVICE_ATTR_RW(dw_dphy_g118_settle);

If you want to expose an API through sysfs it should be properly documented. I 
don't think this is needed though, the PHY should be completely transparent 
for userspace, it should be handled fully within the kernel.

> +static struct phy_ops dw_dphy_ops = {
> +	.init = dw_dphy_init,
> +	.reset = dw_dphy_reset,
> +	.power_on = dw_dphy_power_on,
> +	.power_off = dw_dphy_power_off,
> +	.owner = THIS_MODULE,
> +};
> +
> +static int dw_dphy_rx_probe(struct platform_device *pdev)
> +{
> +	struct dw_dphy_rx *dphy;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +	struct phy *phy;
> +
> +	dphy = devm_kzalloc(dev, sizeof(*dphy), GFP_KERNEL);
> +	if (!dphy)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	dphy->base_address = devm_ioremap(dev, res->start, resource_size(res));
> +	if (IS_ERR(dphy->base_address)) {
> +		dev_err(dev, "error requesting base address\n");
> +		return PTR_ERR(dphy->base_address);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	dphy->dphy1_if_addr = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(dphy->dphy1_if_addr)) {
> +		dev_err(dev, "error requesting dphy 1 if regbank\n");
> +		return PTR_ERR(dphy->dphy1_if_addr);
> +	}
> +
> +	dphy->max_lanes =
> +		dw_dphy_if_read_msk(dphy, DPHYID, DPHY_ID_LANE_SUPPORT, 4);
> +
> +	dphy->dphy_gen = dw_dphy_if_read_msk(dphy, DPHYID, DPHY_ID_GEN, 4);
> +	dev_info(dev, "DPHY GEN %s with maximum %s lanes\n",
> +			dphy->dphy_gen == GEN3 ? "3" : "2",
> +			dphy->max_lanes == CTRL_8_LANES ? "8" : "4");
> +
> +	if (dphy->max_lanes == CTRL_8_LANES) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +		dphy->dphy2_if_addr =
> +			devm_ioremap(dev, res->start, resource_size(res));
> +
> +		if (IS_ERR(dphy->dphy2_if_addr)) {
> +			dev_err(dev, "error requesting dphy 2 if regbank\n");
> +			return PTR_ERR(dphy->dphy2_if_addr);
> +		}
> +
> +		dphy->config_gpio = of_get_gpio(dev->of_node, 0);
> +		if (!gpio_is_valid(dphy->config_gpio)) {
> +			dev_err(dev, "failed to parse config gpio\n");
> +			return dphy->config_gpio;
> +		}
> +	}
> +
> +	if (of_property_read_u32(dev->of_node,
> +			"snps,dphy-frequency",
> +			&dphy->dphy_freq)) {
> +		dev_err(dev, "failed to find dphy frequency\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(dev->of_node,
> +			"snps,dphy-te-len",
> +			&dphy->dphy_te_len)) {
> +		dev_err(dev, "failed to find dphy te length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(dev->of_node,
> +			"snps,compat-mode",
> +			&dphy->compat_mode)) {
> +		dev_err(dev, "failed to find compat mode\n");
> +		return -EINVAL;
> +	}
> +
> +	dev_set_drvdata(dev, dphy);
> +	spin_lock_init(&dphy->slock);
> +
> +	phy = devm_phy_create(dev, NULL, &dw_dphy_ops);
> +	if (IS_ERR(phy)) {
> +		dev_err(dev, "failed to create PHY\n");
> +		return PTR_ERR(phy);
> +	}
> +
> +	dphy->phy = phy;
> +	phy_set_drvdata(phy, dphy);
> +
> +	phy_provider = devm_of_phy_provider_register(dev, dw_dphy_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		dev_err(dev, "error getting phy provider\n");
> +		return PTR_ERR(phy_provider);
> +	}
> +
> +	dphy->lp_time = 1000; /* 1000 ns */
> +	dphy->lanes_config = dw_dphy_setup_config(dphy);
> +	dev_dbg(dev, "rx-dphy created\n");
> +
> +	device_create_file(&pdev->dev, &dev_attr_dphy_reset);
> +	device_create_file(&pdev->dev, &dev_attr_dphy_freq);
> +	device_create_file(&pdev->dev, &dev_attr_dphy_addr);
> +	device_create_file(&pdev->dev, &dev_attr_idelay);
> +	device_create_file(&pdev->dev, &dev_attr_len_config);
> +	device_create_file(&pdev->dev, &dev_attr_dw_dphy_g118_settle);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id dw_dphy_rx_of_match[] = {
> +	{ .compatible = "snps,dphy-rx" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, dw_dphy_rx_of_match);
> +
> +static struct platform_driver dw_dphy_rx_driver = {
> +	.probe	= dw_dphy_rx_probe,
> +	.driver = {
> +		.of_match_table	= dw_dphy_rx_of_match,
> +		.name  = "snps-dphy-rx",
> +		.owner = THIS_MODULE,
> +	}
> +};
> +module_platform_driver(dw_dphy_rx_driver);
> +
> +MODULE_DESCRIPTION("SNPS MIPI DPHY Rx driver");
> +MODULE_AUTHOR("Luis Oliveira <lolivei@synopsys.com>");
> +MODULE_LICENSE("GPL v2");

"GPL v2" means just that, while the SPDX header mentions GPL-2.0+. You can 
pick your license of choice (or rather your employer should, as it seems they 
own the copyright on the code based on the copyright header above), but SPDX 
and MODULE_LICENSE should match.

> diff --git a/drivers/media/platform/dwc/dw-dphy-rx.c
> b/drivers/media/platform/dwc/dw-dphy-rx.c new file mode 100644
> index 0000000..4100ea5
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw-dphy-rx.c
> @@ -0,0 +1,594 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Synopsys MIPI D-PHY driver
> + *
> + * Copyright (c) 2018 Synopsys, Inc. and/or its affiliates.
> + * Author: Luis Oliveira <Luis.Oliveira@synopsys.com>
> + *
> + */
> +
> +#include "dw-dphy-rx.h"
> +
> +struct range_dphy_gen2 {
> +	u64 freq;
> +	u8 hsfregrange;
> +};
> +
> +struct range_dphy_gen2 range_gen2[] = {
> +	{  80, 0x00}, {  90, 0x10}, { 100, 0x20},
> +	{ 110, 0x30}, { 120, 0x01}, { 130, 0x11},
> +	{ 140, 0x21}, { 150, 0x31}, { 160, 0x02},
> +	{ 170, 0x12}, { 180, 0x22}, { 190, 0x32},
> +	{ 205, 0x03}, { 220, 0x13}, { 235, 0x23},
> +	{ 250, 0x33}, { 275, 0x04}, { 300, 0x14},
> +	{ 325, 0x05}, { 350, 0x15}, { 400, 0x25},
> +	{ 450, 0x06}, { 500, 0x16}, { 550, 0x07},
> +	{ 600, 0x17}, { 650, 0x08}, { 700, 0x18},
> +	{ 750, 0x09}, { 800, 0x19}, { 850, 0x29},
> +	{ 900, 0x39}, { 950, 0x0A}, {1000, 0x1A},
> +	{1050, 0x2A}, {1100, 0x3A}, {1150, 0x0B},
> +	{1200, 0x1B}, {1250, 0x2B}, {1300, 0x3B},
> +	{1350, 0x0C}, {1400, 0x1C}, {1450, 0x2C},
> +	{1500, 0x3C}, {1550, 0x0D}, {1600, 0x1D},
> +	{1650, 0x2D}, {1700, 0x0E}, {1750, 0x1E},
> +	{1800, 0x2E}, {1850, 0x3E}, {1900, 0x0F},
> +	{1950, 0x1F}, {2000, 0x2F},
> +};
> +
> +struct range_dphy_gen3 {
> +	u64 freq;
> +	u8 hsfregrange;
> +	u32 osc_freq_target;
> +};
> +
> +struct range_dphy_gen3 range_gen3[] = {
> +
> +	{  80, 0x00, 0x1B6}, {  90, 0x10, 0x1B6}, { 100, 0x20, 0x1B6},
> +	{ 110, 0x30, 0x1B6}, { 120, 0x01, 0x1B6}, { 130, 0x11, 0x1B6},
> +	{ 140, 0x21, 0x1B6}, { 150, 0x31, 0x1B6}, { 160, 0x02, 0x1B6},
> +	{ 170, 0x12, 0x1B6}, { 180, 0x22, 0x1B6}, { 190, 0x32, 0x1B6},
> +	{ 205, 0x03, 0x1B6}, { 220, 0x13, 0x1B6}, { 235, 0x23, 0x1B6},
> +	{ 250, 0x33, 0x1B6}, { 275, 0x04, 0x1B6}, { 300, 0x14, 0x1B6},
> +	{ 325, 0x25, 0x1B6}, { 350, 0x35, 0x1B6}, { 400, 0x05, 0x1B6},
> +	{ 450, 0x16, 0x1B6}, { 500, 0x26, 0x1B6}, { 550, 0x37, 0x1B6},
> +	{ 600, 0x07, 0x1B6}, { 650, 0x18, 0x1B6}, { 700, 0x28, 0x1B6},
> +	{ 750, 0x39, 0x1B6}, { 800, 0x09, 0x1B6}, { 850, 0x19, 0x1B6},
> +	{ 900, 0x29, 0x1B6}, { 950, 0x3A, 0x1B6}, {1000, 0x0A, 0x1B6},
> +	{1050, 0x1A, 0x1B6}, {1100, 0x2A, 0x1B6}, {1150, 0x3B, 0x1B6},
> +	{1200, 0x0B, 0x1B6}, {1250, 0x1B, 0x1B6}, {1300, 0x2B, 0x1B6},
> +	{1350, 0x3C, 0x1B6}, {1400, 0x0C, 0x1B6}, {1450, 0x1C, 0x1B6},
> +	{1500, 0x2C, 0x1B6}, {1550, 0x3D, 0x10F}, {1600, 0x0D, 0x118},
> +	{1650, 0x1D, 0x121}, {1700, 0x2E, 0x12A}, {1750, 0x3E, 0x132},
> +	{1800, 0x0E, 0x13B}, {1850, 0x1E, 0x144}, {1900, 0x2F, 0x14D},
> +	{1950, 0x3F, 0x155}, {2000, 0x0F, 0x15E}, {2050, 0x40, 0x167},
> +	{2100, 0x41, 0x170}, {2150, 0x42, 0x178}, {2200, 0x43, 0x181},
> +	{2250, 0x44, 0x18A}, {2300, 0x45, 0x193}, {2350, 0x46, 0x19B},
> +	{2400, 0x47, 0x1A4}, {2450, 0x48, 0x1AD}, {2500, 0x49, 0x1B6}
> +};
> +
> +u8 dw_dphy_setup_config(struct dw_dphy_rx *dphy)
> +{
> +	u8 ret;
> +	int setup_config;
> +
> +	if (dphy->max_lanes == CTRL_4_LANES)
> +		return CTRL_4_LANES;
> +
> +	ret = gpio_request(dphy->config_gpio, "config");
> +	if (ret < 0) {
> +		pr_err("could not acquire config gpio (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	setup_config = gpio_get_value(dphy->config_gpio);
> +	pr_debug("CONFIG %s\n", setup_config == CTRL_8_LANES ? "8L" : "4+4L");
> +	gpio_free(dphy->config_gpio);
> +
> +	return setup_config;
> +}
> +void dw_dphy_if_write(struct dw_dphy_rx *dphy, u32 address, u32 data)
> +{
> +	iowrite32(data, dphy->dphy1_if_addr + address);
> +
> +	if (dphy->lanes_config == CTRL_4_LANES)
> +		return;
> +
> +	iowrite32(data, dphy->dphy2_if_addr + address);
> +}
> +
> +u32 dw_dphy_if_read(struct dw_dphy_rx *dphy, u64 address)
> +{
> +	u32 if1 = 0, if2 = 0;
> +
> +	if1 = ioread32(dphy->dphy1_if_addr + address);
> +
> +	if (dphy->lanes_config == CTRL_4_LANES)
> +		goto end;
> +
> +	if (dphy->lanes_config == DPHYID)
> +		goto end;
> +
> +	if2 = ioread32(dphy->dphy2_if_addr + address);
> +
> +	if (if1 != if2)
> +		pr_err("Values read different for each interface\n");
> +
> +end:
> +	return if1;
> +}
> +
> +void dw_dphy_write(struct dw_dphy_rx *dphy, u32 address, u32 data)
> +{
> +	iowrite32(data, dphy->base_address + address);
> +
> +	if (dphy->lanes_config == CTRL_4_LANES)
> +		return;
> +
> +	if (address == R_CSI2_DPHY_TST_CTRL0)
> +		iowrite32(data, dphy->base_address + R_CSI2_DPHY2_TST_CTRL0);
> +	else if (address == R_CSI2_DPHY_TST_CTRL1)
> +		iowrite32(data, dphy->base_address + R_CSI2_DPHY2_TST_CTRL1);
> +}
> +
> +u32 dw_dphy_read(struct dw_dphy_rx *dphy, u64 address)
> +{
> +	u32 dphy1 = 0, dphy2 = 0;
> +
> +	dphy1 = ioread32(dphy->base_address + address);
> +
> +	if (dphy->lanes_config == CTRL_4_LANES)
> +		goto end;
> +
> +	if (address == R_CSI2_DPHY_TST_CTRL0)
> +		dphy2 = ioread32(dphy->base_address + R_CSI2_DPHY2_TST_CTRL0);
> +	else if (address == R_CSI2_DPHY_TST_CTRL1)
> +		dphy2 = ioread32(dphy->base_address + R_CSI2_DPHY2_TST_CTRL1);
> +	else
> +		return -ENODEV;
> +
> +	if (dphy1 != dphy2)
> +		pr_err("Values read different for each dphy\n");
> +
> +end:
> +	return dphy1;
> +}
> +
> +void dw_dphy_write_msk(struct dw_dphy_rx *dev,
> +		u64 address, u64 data, u8 shift, u8 width)
> +{
> +	u32 mask = (1 << width) - 1;
> +	u32 temp = dw_dphy_read(dev, address);
> +
> +	temp &= ~(mask << shift);
> +	temp |= (data & mask) << shift;
> +	dw_dphy_write(dev, address, temp);
> +}
> +
> +static void dw_dphy_te_12b_write(struct dw_dphy_rx *dphy, u16 addr, u8
> data) +{
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 1, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0x00, PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy,
> +		R_CSI2_DPHY_TST_CTRL1, (u8) (addr >> 8), PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 1, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy,
> +		R_CSI2_DPHY_TST_CTRL1, (u8) addr, PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy,
> +		R_CSI2_DPHY_TST_CTRL1, (u8) data, PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +}
> +
> +static void dw_dphy_te_8b_write(struct dw_dphy_rx *dphy, u8 addr, u8 data)
> +{
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_TST_CTRL1, addr);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 1, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_TST_CTRL1, data);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +}
> +
> +static void dw_dphy_te_write(struct dw_dphy_rx *dphy, u16 addr, u8 data)
> +{
> +
> +	if (dphy->dphy_te_len == BIT12)
> +		dw_dphy_te_12b_write(dphy, addr, data);
> +	else
> +		dw_dphy_te_8b_write(dphy, addr, data);
> +}
> +
> +static int dw_dphy_te_12b_read(struct dw_dphy_rx *dphy, u32 addr)
> +{
> +	u8 ret;
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 0);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 1, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0x00, PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy,
> +		R_CSI2_DPHY_TST_CTRL1, (u8) (addr >> 8), PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 1, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy,
> +		R_CSI2_DPHY_TST_CTRL1, (u8) addr, PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0x00, 0, PHY_TESTDIN);
> +	ret = dw_dphy_read_msk(dphy, R_CSI2_DPHY_TST_CTRL1, PHY_TESTDOUT, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 1);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 1);
> +
> +	return ret;
> +}
> +
> +static int dw_dphy_te_8b_read(struct dw_dphy_rx *dphy, u32 addr)
> +{
> +	u8 ret;
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 0);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 1, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, addr, PHY_TESTDIN, 8);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTEN, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL1, 0, PHY_TESTDIN, 8);
> +	ret = dw_dphy_read_msk(dphy, R_CSI2_DPHY_TST_CTRL1, PHY_TESTDOUT, 8);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 1);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 1);
> +
> +	return ret;
> +}
> +
> +int dw_dphy_te_read(struct dw_dphy_rx *dphy, u32 addr)
> +{
> +	int ret;
> +
> +	if (dphy->dphy_te_len == BIT12)
> +		ret = dw_dphy_te_12b_read(dphy, addr);
> +	else
> +		ret = dw_dphy_te_8b_read(dphy, addr);
> +
> +	return ret;
> +}
> +
> +static void dw_dphy_if_init(struct dw_dphy_rx *dphy)
> +{
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, TX_PHY);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLR, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLR, 1);
> +	dw_dphy_if_write(dphy, DPHYZCALCTRL, 0);
> +	dw_dphy_if_write(dphy, DPHYZCALCTRL, 1);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, GLUELOGIC);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLR, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLR, 1);
> +	dw_dphy_if_write(dphy, DPHYZCALCTRL, 0);
> +	dw_dphy_if_write(dphy, DPHYZCALCTRL, 1);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RX_PHY);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLR, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLR, 1);
> +	dw_dphy_if_write(dphy, DPHYZCALCTRL, 0);
> +	dw_dphy_if_write(dphy, DPHYZCALCTRL, 1);
> +}
> +
> +static void dw_dphy_gen3_12bit_tc_power_up(struct dw_dphy_rx *dphy)
> +{
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, GLUELOGIC);
> +	dw_dphy_te_write(dphy, CFGCLKFREQRANGE_TX, 0x1C);
> +
> +	/* CLKSEL | UPDATEPLL | SHADOW_CLEAR | SHADOW_CTRL | FORCEPLL */
> +	dw_dphy_te_write(dphy, BYPASS, 0x3F);
> +
> +	/* IO_DS3 | IO_DS2 | IO_DS1 | IO_DS0 */
> +	if (dphy->dphy_freq > 1500)
> +		dw_dphy_te_write(dphy, IO_DS, 0x0F);
> +
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RX_PHY);
> +}
> +
> +static void dw_dphy_gen3_8bit_tc_power_up(struct dw_dphy_rx *dphy)
> +{
> +	u32 input_freq = dphy->dphy_freq / 1000;
> +
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, GLUELOGIC);
> +	dw_dphy_te_write(dphy, CFGCLKFREQRANGE_RX, 0x1C);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RESET);
> +	dw_dphy_if_write(dphy, DPHYGLUEIFTESTER, RX_PHY);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX0_MSB, 0x03);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX0_LSB, 0x02);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX1_MSB, 0x03);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX1_LSB, 0x02);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX2_MSB, 0x03);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX2_LSB, 0x02);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX3_MSB, 0x03);
> +	dw_dphy_te_write(dphy, OSC_FREQ_TARGET_RX3_LSB, 0x02);
> +	dw_dphy_te_write(dphy, BANDGAP_CTRL, 0x80);
> +
> +	if (input_freq < 2000)
> +		dw_dphy_te_write(dphy, HS_RX_CTRL_LANE0, 0xC0);
> +
> +	if (input_freq < 1000) {
> +		dw_dphy_te_write(dphy, HS_RX_CTRL_LANE1, 0xC0);
> +		dw_dphy_te_write(dphy, HS_RX_CTRL_LANE2, 0xC0);
> +		dw_dphy_te_write(dphy, HS_RX_CTRL_LANE3, 0xC0);
> +	}
> +}
> +
> +int dw_dphy_g118_settle(struct dw_dphy_rx *dphy)
> +{
> +	u32 input_freq, total_settle, settle_time, byte_clk, lp_time;
> +
> +	lp_time = dphy->lp_time;
> +	input_freq = dphy->dphy_freq / 1000;
> +
> +	settle_time = (8 * (1000000/(input_freq))) + 115000;
> +	byte_clk = (8000000/(input_freq));
> +	total_settle = (settle_time + lp_time * 1000) / byte_clk;
> +
> +	if (total_settle > 0xFF)
> +		total_settle = 0xFF;
> +
> +	return total_settle;
> +}
> +
> +static void dw_dphy_pwr_down(struct dw_dphy_rx *dphy)
> +{
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +	if (dphy->lanes_config == CTRL_8_LANES)
> +		dw_dphy_write_msk(dphy,
> +			R_CSI2_DPHY2_TST_CTRL0, 0, PHY_TESTCLK, 1);
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 0);
> +}
> +
> +static void dw_dphy_pwr_up(struct dw_dphy_rx *dphy)
> +{
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +	if (dphy->lanes_config == CTRL_8_LANES)
> +		dw_dphy_write_msk(dphy,
> +			R_CSI2_DPHY2_TST_CTRL0, 1, PHY_TESTCLK, 1);
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 1);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 1);
> +}
> +
> +static int dw_dphy_gen3_12bit_configure(struct dw_dphy_rx *dphy)
> +{
> +	u32 input_freq = dphy->dphy_freq;
> +	u8 range = 0;
> +
> +	pr_debug("PHY GEN 3 Freq: %u\n", input_freq);
> +	for (range = 0; (range < ARRAY_SIZE(range_gen3) - 1) &&
> +		((input_freq / 1000) > range_gen3[range].freq); range++)
> +		;
> +
> +	dw_dphy_gen3_12bit_tc_power_up(dphy);
> +
> +	dw_dphy_te_write(dphy, RX_SYS_1, range_gen3[range].hsfregrange);
> +	dw_dphy_te_write(dphy, RX_SYS_0, 0x20);
> +	dw_dphy_te_write(dphy, RX_RX_STARTUP_OVR_2,
> +			(u8) range_gen3[range].osc_freq_target);
> +	dw_dphy_te_write(dphy, RX_RX_STARTUP_OVR_3,
> +			(u8) (range_gen3[range].osc_freq_target >> 8));
> +	dw_dphy_te_write(dphy, RX_RX_STARTUP_OVR_4, 0x01);
> +
> +	if (dphy->compat_mode) {
> +		dw_dphy_te_write(dphy, RX_RX_STARTUP_OVR_1, 0x01);
> +		dw_dphy_te_write(dphy, RX_RX_STARTUP_OVR_0, 0x80);
> +	}
> +
> +	if ((dphy->compat_mode) || (input_freq <= 1500))
> +		dw_dphy_te_write(dphy, RX_SYS_7, 0x38);
> +
> +	return 0;
> +}
> +
> +static int dw_dphy_gen3_8bit_configure(struct dw_dphy_rx *dphy)
> +{
> +	u32 input_freq = dphy->dphy_freq;
> +	u8 data;
> +	u8 range = 0;
> +
> +	pr_debug("PHY GEN 3 Freq: %u\n", input_freq);
> +	for (range = 0; (range < ARRAY_SIZE(range_gen3) - 1) &&
> +		((input_freq / 1000) > range_gen3[range].freq); range++)
> +		;
> +
> +	dw_dphy_te_write(dphy, RX_SKEW_CAL, dw_dphy_g118_settle(dphy));
> +	data = 1<<7 | range_gen3[range].hsfregrange;
> +	dw_dphy_te_write(dphy, HSFREQRANGE_8BIT, data);
> +	dw_dphy_gen3_8bit_tc_power_up(dphy);
> +
> +	return 0;
> +}
> +
> +static int dw_dphy_gen2_configure(struct dw_dphy_rx *dphy)
> +{
> +	u32 input_freq = dphy->dphy_freq;
> +	u8 data;
> +	u8 range = 0;
> +
> +	/* provide an initial active-high test clear pulse in TESTCLR  */
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 1, PHY_TESTCLR, 1);
> +	dw_dphy_write_msk(dphy, R_CSI2_DPHY_TST_CTRL0, 0, PHY_TESTCLR, 1);
> +
> +	pr_debug("PHY GEN 2 Freq: %u\n", input_freq);
> +	for (range = 0; (range < ARRAY_SIZE(range_gen2) - 1) &&
> +		((input_freq / 1000) > range_gen2[range].freq); range++)
> +		;
> +
> +	data = range_gen2[range].hsfregrange << 1;
> +	dw_dphy_te_write(dphy, HSFREQRANGE_8BIT, data);
> +
> +	return 0;
> +}
> +
> +static int dw_dphy_configure(struct dw_dphy_rx *dphy)
> +{
> +	dw_dphy_pwr_down(dphy);
> +
> +	if (dphy->dphy_gen == GEN3) {
> +		dw_dphy_if_init(dphy);
> +
> +		if (dphy->dphy_te_len == BIT12)
> +			dw_dphy_gen3_12bit_configure(dphy);
> +		else
> +			dw_dphy_gen3_8bit_configure(dphy);
> +	} else
> +		dw_dphy_gen2_configure(dphy);
> +
> +	dw_dphy_pwr_up(dphy);
> +
> +	return 0;
> +}
> +
> +int dw_dphy_if_set_idelay(struct dw_dphy_rx *dphy, u8 dly, u8 cells)
> +{
> +	uint32_t val = 0;
> +
> +	dw_dphy_if_write(dphy, IDLYCFG, 0);
> +
> +	dw_dphy_if_write(dphy, IDLYSEL, cells);
> +	dw_dphy_if_write(dphy, IDLYCNTINVAL, dly);
> +
> +	/* Pulse Value Set */
> +	dw_dphy_if_write(dphy, IDLYCFG, 1);
> +	usleep_range(10, 20);
> +	dw_dphy_if_write(dphy, IDLYCFG, 0);
> +
> +	/* Pulse IDELAY CTRL Reset */
> +	dw_dphy_if_write(dphy, DPHY1REGRSTN, 0);
> +	usleep_range(10, 20);
> +	dw_dphy_if_write(dphy, DPHY1REGRSTN, 1);
> +
> +	/* Get Value*/
> +	val = dw_dphy_if_read(dphy, IDLYCNTOUTVAL);
> +
> +	if (val != dly) {
> +		pr_info("odelay config failed, set %d get %d", dly, val);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int dw_dphy_if_get_idelay(struct dw_dphy_rx *dphy)
> +{
> +	return dw_dphy_if_read(dphy, IDLYCNTOUTVAL);
> +}
> +
> +int dw_dphy_if_set_idelay_lane(struct dw_dphy_rx *dphy, u8 dly, u8 lane)
> +{
> +	int cell;
> +
> +	switch (lane) {
> +	case 0:
> +		for (cell = 3; cell <= 10; cell++)
> +			dw_dphy_if_set_idelay(dphy, dly, cell);
> +		break;
> +	case 1:
> +		for (cell = 14; cell <= 21; cell++)
> +			dw_dphy_if_set_idelay(dphy, dly, cell);
> +		break;
> +	case 2:
> +		for (cell = 24; cell <= 31; cell++)
> +			dw_dphy_if_set_idelay(dphy, dly, cell);
> +		break;
> +	case 3:
> +		for (cell = 34; cell <= 41; cell++)
> +			dw_dphy_if_set_idelay(dphy, dly, cell);
> +		break;
> +	case 4: /* ALL */
> +		dw_dphy_if_set_idelay(dphy, dly, 0x7F);
> +		break;
> +	default:
> +		pr_err("Lane Value not recognized\n");
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +int dw_dphy_init(struct phy *phy)
> +{
> +	struct dw_dphy_rx *dphy = phy_get_drvdata(phy);
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 0);
> +
> +	return 0;
> +}
> +
> +static int dw_dphy_set_phy_state(struct dw_dphy_rx *dphy, u32 on)
> +{
> +	u8 hs_freq;
> +
> +	dphy->lanes_config = dw_dphy_setup_config(dphy);
> +
> +	if (dphy->dphy_te_len == BIT12)
> +		hs_freq = RX_SYS_1;
> +	else
> +		hs_freq = HSFREQRANGE_8BIT;
> +
> +	if (on) {
> +		dw_dphy_configure(dphy);
> +		pr_debug("HS Code: 0X%x\n", dw_dphy_te_read(dphy, hs_freq));
> +	} else {
> +		dw_dphy_write(dphy, R_CSI2_DPHY_SHUTDOWNZ, 0);
> +		dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +int dw_dphy_power_on(struct phy *phy)
> +{
> +	struct dw_dphy_rx *dphy = phy_get_drvdata(phy);
> +
> +	return dw_dphy_set_phy_state(dphy, 1);
> +}
> +
> +int dw_dphy_power_off(struct phy *phy)
> +{
> +	struct dw_dphy_rx *dphy = phy_get_drvdata(phy);
> +
> +	return dw_dphy_set_phy_state(dphy, 0);
> +}
> +
> +int dw_dphy_reset(struct phy *phy)
> +{
> +	struct dw_dphy_rx *dphy = phy_get_drvdata(phy);
> +
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 0);
> +	usleep_range(100, 200);
> +	dw_dphy_write(dphy, R_CSI2_DPHY_RSTZ, 1);
> +
> +	return 0;
> +}
> diff --git a/drivers/media/platform/dwc/dw-dphy-rx.h
> b/drivers/media/platform/dwc/dw-dphy-rx.h new file mode 100644
> index 0000000..5375685
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw-dphy-rx.h
> @@ -0,0 +1,176 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Synopsys MIPI D-PHY driver
> + *
> + * Copyright (c) 2018 Synopsys, Inc. and/or its affiliates.
> + * Author: Luis Oliveira <Luis.Oliveira@synopsys.com>
> + */
> +
> +#ifndef __PHY_SNPS_DPHY_RX_H__
> +#define __PHY_SNPS_DPHY_RX_H__
> +
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_gpio.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +
> +/* DPHY interface register bank*/
> +#define R_CSI2_DPHY_SHUTDOWNZ 0x0
> +#define R_CSI2_DPHY_RSTZ 0x4
> +#define R_CSI2_DPHY_RX 0x8
> +#define	R_CSI2_DPHY_STOPSTATE 0xC
> +#define R_CSI2_DPHY_TST_CTRL0 0x10
> +#define R_CSI2_DPHY_TST_CTRL1 0x14
> +#define R_CSI2_DPHY2_TST_CTRL0 0x18
> +#define R_CSI2_DPHY2_TST_CTRL1 0x1C
> +
> +enum dphy_id_mask {
> +	DPHY_ID_LANE_SUPPORT = 0,
> +	DPHY_ID_IF = 4,
> +	DPHY_ID_GEN = 8,
> +};
> +
> +enum dphy_gen_values {
> +	GEN1 = 0,
> +	GEN2 = 1,
> +	GEN3 = 2,
> +};
> +
> +enum dphy_interface_length {
> +	BIT8 = 8,
> +	BIT12 = 12,
> +};
> +
> +enum tst_ctrl0 {
> +	PHY_TESTCLR = 0,
> +	PHY_TESTCLK = 1,
> +};
> +
> +enum tst_ctrl1 {
> +	PHY_TESTDIN = 0,
> +	PHY_TESTDOUT = 8,
> +	PHY_TESTEN = 16,
> +};
> +
> +enum lanes_config_values {
> +	CTRL_4_LANES = 0,
> +	CTRL_8_LANES = 1,
> +};
> +
> +enum dphy_tc {
> +	CFGCLKFREQRANGE_TX = 0x02,
> +	CFGCLKFREQRANGE_RX = 0x05,
> +	BYPASS = 0x20,
> +	IO_DS = 0x30,
> +};
> +
> +enum dphy_8bit_interface_addr {
> +	BANDGAP_CTRL = 0x24,
> +	HS_RX_CTRL_LANE0 = 0x42,
> +	HSFREQRANGE_8BIT = 0x44,
> +	OSC_FREQ_TARGET_RX0_LSB	= 0x4e,
> +	OSC_FREQ_TARGET_RX0_MSB	= 0x4f,
> +	HS_RX_CTRL_LANE1 = 0x52,
> +	OSC_FREQ_TARGET_RX1_LSB	= 0x5e,
> +	OSC_FREQ_TARGET_RX1_MSB	= 0x5f,
> +	RX_SKEW_CAL	= 0x7e,
> +	HS_RX_CTRL_LANE2 = 0x82,
> +	OSC_FREQ_TARGET_RX2_LSB	= 0x8e,
> +	OSC_FREQ_TARGET_RX2_MSB	= 0x8f,
> +	HS_RX_CTRL_LANE3 = 0x92,
> +	OSC_FREQ_TARGET_RX3_LSB	= 0x9e,
> +	OSC_FREQ_TARGET_RX3_MSB	= 0x9f,
> +};
> +
> +enum dphy_12bit_interface_addr {
> +	RX_SYS_0 = 0x01,
> +	RX_SYS_1 = 0x02,
> +	RX_SYS_7 = 0x08,
> +	RX_RX_STARTUP_OVR_0 = 0xe0,
> +	RX_RX_STARTUP_OVR_1 = 0xe1,
> +	RX_RX_STARTUP_OVR_2 = 0xe2,
> +	RX_RX_STARTUP_OVR_3 = 0xe3,
> +	RX_RX_STARTUP_OVR_4 = 0xe4,
> +};
> +
> +/* Gen3 interface register bank*/
> +#define IDLYCFG	0x00
> +#define IDLYSEL	0x04
> +#define IDLYCNTINVAL 0x08
> +#define IDLYCNTOUTVAL 0x0c
> +#define DPHY1REGRSTN 0x10
> +#define DPHYZCALSTAT 0x14
> +#define DPHYZCALCTRL 0x18
> +#define DPHYLANE0STAT 0x1c
> +#define DPHYLANE1STAT 0x20
> +#define DPHYLANE2STAT 0x24
> +#define DPHYLANE3STAT 0x28
> +#define DPHYCLKSTAT 0x2c
> +#define DPHYZCLKCTRL 0x30
> +#define TCGENPURPOSOUT 0x34
> +#define TCGENPURPOSIN 0x38
> +#define DPHYGENERICOUT 0x3c
> +#define DPHYGENERICIN 0x40
> +#define DPHYGLUEIFTESTER 0x44
> +#define DPHYID 0x100
> +
> +enum glueiftester {
> +	GLUELOGIC = 0x4,
> +	RX_PHY = 0x2,
> +	TX_PHY = 0x1,
> +	RESET = 0x0,
> +};
> +
> +struct dw_dphy_rx {
> +	spinlock_t slock;
> +	struct phy *phy;
> +	uint32_t dphy_freq;
> +	uint32_t dphy_gen;
> +	uint32_t dphy_te_len;
> +	uint32_t lanes_config;
> +	uint32_t max_lanes;
> +	uint32_t compat_mode;
> +	uint32_t lp_time;
> +
> +	void __iomem *base_address; /* test interface */
> +	void __iomem *dphy1_if_addr; /* gluelogic phy 1 */
> +	void __iomem *dphy2_if_addr; /* gluelogic phy 2 */
> +
> +	int config_gpio;
> +	uint8_t setup_config;
> +};
> +
> +int dw_dphy_init(struct phy *phy);
> +int dw_dphy_reset(struct phy *phy);
> +int dw_dphy_power_off(struct phy *phy);
> +int dw_dphy_power_on(struct phy *phy);
> +
> +u8 dw_dphy_setup_config(struct dw_dphy_rx *dphy);
> +u32 dw_dphy_if_read(struct dw_dphy_rx *dphy, u64 address);
> +void dw_dphy_write(struct dw_dphy_rx *dphy, u32 address, u32 data);
> +u32 dw_dphy_read(struct dw_dphy_rx *dphy, u64 address);
> +int dw_dphy_te_read(struct dw_dphy_rx *dphy, u32 addr);
> +int dw_dphy_if_get_idelay(struct dw_dphy_rx *dphy);
> +int dw_dphy_if_set_idelay_lane(struct dw_dphy_rx *dphy, u8 dly, u8 lane);
> +
> +static inline
> +u32 dw_dphy_if_read_msk(struct dw_dphy_rx *dphy,
> +		u32 address, u8 shift, u8 width)
> +{
> +	return (dw_dphy_if_read(dphy, address) >> shift) & ((1 << width) - 1);
> +}
> +
> +static inline
> +u32 dw_dphy_read_msk(struct dw_dphy_rx *dev, u32 address, u8 shift,  u8
> width) +{
> +	return (dw_dphy_read(dev, address) >> shift) & ((1 << width) - 1);
> +}
> +#endif /*__PHY_SNPS_DPHY_RX_H__*/


-- 
Regards,

Laurent Pinchart
