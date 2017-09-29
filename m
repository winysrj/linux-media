Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:23094 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752438AbdI2R27 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 13:28:59 -0400
Date: Fri, 29 Sep 2017 12:27:09 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, <nm@ti.com>
Subject: Re: [PATCH v4 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20170929172709.GA3163@ti.com>
References: <20170922100823.18184-1-maxime.ripard@free-electrons.com>
 <20170922100823.18184-3-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20170922100823.18184-3-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Fri [2017-Sep-22 12:08:23 +0200]:
> The Cadence CSI-2 RX Controller is an hardware block meant to be used as a
> bridge between a CSI-2 bus and pixel grabbers.
> 
> It supports operating with internal or external D-PHY, with up to 4 lanes,
> or without any D-PHY. The current code only supports the former case.
> 
> It also support dynamic mapping of the CSI-2 virtual channels to the
> associated pixel grabbers, but that isn't allowed at the moment either.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/media/platform/Kconfig               |   1 +
>  drivers/media/platform/Makefile              |   2 +
>  drivers/media/platform/cadence/Kconfig       |  12 +
>  drivers/media/platform/cadence/Makefile      |   1 +
>  drivers/media/platform/cadence/cdns-csi2rx.c | 486 +++++++++++++++++++++++++++
>  5 files changed, 502 insertions(+)
>  create mode 100644 drivers/media/platform/cadence/Kconfig
>  create mode 100644 drivers/media/platform/cadence/Makefile
>  create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c
> 

<snip>

> +static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
> +				struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	unsigned char i;
> +	u32 reg;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	csi2rx->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(csi2rx->base))
> +		return PTR_ERR(csi2rx->base);
> +
> +	csi2rx->sys_clk = devm_clk_get(&pdev->dev, "sys_clk");
> +	if (IS_ERR(csi2rx->sys_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get sys clock\n");
> +		return PTR_ERR(csi2rx->sys_clk);
> +	}
> +
> +	csi2rx->p_clk = devm_clk_get(&pdev->dev, "p_clk");
> +	if (IS_ERR(csi2rx->p_clk)) {
> +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> +		return PTR_ERR(csi2rx->p_clk);
> +	}
> +
> +	csi2rx->dphy = devm_phy_optional_get(&pdev->dev, "dphy");
> +	if (IS_ERR(csi2rx->dphy)) {
> +		dev_err(&pdev->dev, "Couldn't get external D-PHY\n");
> +		return PTR_ERR(csi2rx->dphy);
> +	}
> +
> +	/*
> +	 * FIXME: Once we'll have external D-PHY support, the check
> +	 * will need to be removed.
> +	 */
> +	if (csi2rx->dphy) {
> +		dev_err(&pdev->dev, "External D-PHY not supported yet\n");
> +		return -EINVAL;
> +	}

I understand that in your current environment you do not have a
DPHY. But I am wondering in a real setup where you will have either
an internal or an external DPHY, how are they going to interact with
this driver or vice-versa?

> +
> +	clk_prepare_enable(csi2rx->p_clk);
> +	reg = readl(csi2rx->base + CSI2RX_DEVICE_CFG_REG);
> +	clk_disable_unprepare(csi2rx->p_clk);
> +
> +	csi2rx->max_lanes = (reg & 7);
> +	if (csi2rx->max_lanes > CSI2RX_LANES_MAX) {
> +		dev_err(&pdev->dev, "Invalid number of lanes: %u\n",
> +			csi2rx->max_lanes);
> +		return -EINVAL;
> +	}
> +
> +	csi2rx->max_streams = ((reg >> 4) & 7);
> +	if (csi2rx->max_streams > CSI2RX_STREAMS_MAX) {
> +		dev_err(&pdev->dev, "Invalid number of streams: %u\n",
> +			csi2rx->max_streams);
> +		return -EINVAL;
> +	}
> +
> +	csi2rx->has_internal_dphy = (reg & BIT(3)) ? true : false;
> +
> +	/*
> +	 * FIXME: Once we'll have internal D-PHY support, the check
> +	 * will need to be removed.
> +	 */
> +	if (csi2rx->has_internal_dphy) {
> +		dev_err(&pdev->dev, "Internal D-PHY not supported yet\n");
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < csi2rx->max_streams; i++) {
> +		char clk_name[16];
> +
> +		snprintf(clk_name, sizeof(clk_name), "pixel_if%u_clk", i);
> +		csi2rx->pixel_clk[i] = devm_clk_get(&pdev->dev, clk_name);
> +		if (IS_ERR(csi2rx->pixel_clk[i])) {
> +			dev_err(&pdev->dev, "Couldn't get clock %s\n", clk_name);
> +			return PTR_ERR(csi2rx->pixel_clk[i]);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
> +{
> +	struct v4l2_fwnode_endpoint v4l2_ep;
> +	struct device_node *ep, *remote;

*remote is now unused.

Regards,
Benoit

<snip>
