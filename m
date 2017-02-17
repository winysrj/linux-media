Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:37411 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755857AbdBQKsk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 05:48:40 -0500
Message-ID: <1487328479.3107.21.camel@pengutronix.de>
Subject: Re: [PATCH v4 23/36] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 17 Feb 2017 11:47:59 +0100
In-Reply-To: <1487211578-11360-24-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-24-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
> Adds MIPI CSI-2 Receiver subdev driver. This subdev is required
> for sensors with a MIPI CSI2 interface.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Makefile         |   1 +
>  drivers/staging/media/imx/imx6-mipi-csi2.c | 573 +++++++++++++++++++++++++++++
>  2 files changed, 574 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx6-mipi-csi2.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 878a126..3569625 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-vdic.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-ic.o
>  
>  obj-$(CONFIG_VIDEO_IMX_CSI) += imx-media-csi.o
> +obj-$(CONFIG_VIDEO_IMX_CSI) += imx6-mipi-csi2.o
> diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
> new file mode 100644
> index 0000000..23dca80
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
> @@ -0,0 +1,573 @@
> +/*
> + * MIPI CSI-2 Receiver Subdev for Freescale i.MX6 SOC.
> + *
> + * Copyright (c) 2012-2017 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include "imx-media.h"
> +
> +/*
> + * there must be 5 pads: 1 input pad from sensor, and
> + * the 4 virtual channel output pads
> + */
> +#define CSI2_SINK_PAD       0
> +#define CSI2_NUM_SINK_PADS  1
> +#define CSI2_NUM_SRC_PADS   4
> +#define CSI2_NUM_PADS       5
> +
> +struct csi2_dev {
> +	struct device          *dev;
> +	struct v4l2_subdev      sd;
> +	struct media_pad       pad[CSI2_NUM_PADS];
> +	struct v4l2_mbus_framefmt format_mbus;
> +	struct clk             *dphy_clk;
> +	struct clk             *cfg_clk;
> +	struct clk             *pix_clk; /* what is this? */
> +	void __iomem           *base;
> +	struct v4l2_of_bus_mipi_csi2 bus;
> +	bool                    on;
> +	bool                    stream_on;
> +	bool                    src_linked;
> +	bool                    sink_linked[CSI2_NUM_SRC_PADS];
> +};
> +
> +#define DEVICE_NAME "imx6-mipi-csi2"
> +
> +/* Register offsets */
> +#define CSI2_VERSION            0x000
> +#define CSI2_N_LANES            0x004
> +#define CSI2_PHY_SHUTDOWNZ      0x008
> +#define CSI2_DPHY_RSTZ          0x00c
> +#define CSI2_RESETN             0x010
> +#define CSI2_PHY_STATE          0x014
> +#define PHY_STOPSTATEDATA_BIT   4
> +#define PHY_STOPSTATEDATA(n)    BIT(PHY_STOPSTATEDATA_BIT + (n))
> +#define PHY_RXCLKACTIVEHS       BIT(8)
> +#define PHY_RXULPSCLKNOT        BIT(9)
> +#define PHY_STOPSTATECLK        BIT(10)
> +#define CSI2_DATA_IDS_1         0x018
> +#define CSI2_DATA_IDS_2         0x01c
> +#define CSI2_ERR1               0x020
> +#define CSI2_ERR2               0x024
> +#define CSI2_MSK1               0x028
> +#define CSI2_MSK2               0x02c
> +#define CSI2_PHY_TST_CTRL0      0x030
> +#define PHY_TESTCLR		BIT(0)
> +#define PHY_TESTCLK		BIT(1)
> +#define CSI2_PHY_TST_CTRL1      0x034
> +#define PHY_TESTEN		BIT(16)
> +#define CSI2_SFT_RESET          0xf00
> +
> +static inline struct csi2_dev *sd_to_dev(struct v4l2_subdev *sdev)
> +{
> +	return container_of(sdev, struct csi2_dev, sd);
> +}
> +
> +static void csi2_enable(struct csi2_dev *csi2, bool enable)
> +{
> +	if (enable) {
> +		writel(0x1, csi2->base + CSI2_PHY_SHUTDOWNZ);
> +		writel(0x1, csi2->base + CSI2_DPHY_RSTZ);
> +		writel(0x1, csi2->base + CSI2_RESETN);
> +	} else {
> +		writel(0x0, csi2->base + CSI2_PHY_SHUTDOWNZ);
> +		writel(0x0, csi2->base + CSI2_DPHY_RSTZ);
> +		writel(0x0, csi2->base + CSI2_RESETN);
> +	}
> +}
> +
> +static void csi2_set_lanes(struct csi2_dev *csi2)
> +{
> +	int lanes = csi2->bus.num_data_lanes;
> +
> +	writel(lanes - 1, csi2->base + CSI2_N_LANES);
> +}
> +
> +static void dw_mipi_csi2_phy_write(struct csi2_dev *csi2,
> +				   u32 test_code, u32 test_data)
> +{
> +	/* Clear PHY test interface */
> +	writel(PHY_TESTCLR, csi2->base + CSI2_PHY_TST_CTRL0);
> +	writel(0x0, csi2->base + CSI2_PHY_TST_CTRL1);
> +	writel(0x0, csi2->base + CSI2_PHY_TST_CTRL0);
> +
> +	/* Raise test interface strobe signal */
> +	writel(PHY_TESTCLK, csi2->base + CSI2_PHY_TST_CTRL0);
> +
> +	/* Configure address write on falling edge and lower strobe signal */
> +	writel(PHY_TESTEN | test_code, csi2->base + CSI2_PHY_TST_CTRL1);
> +	writel(0x0, csi2->base + CSI2_PHY_TST_CTRL0);
> +
> +	/* Configure data write on rising edge and raise strobe signal */
> +	writel(test_data, csi2->base + CSI2_PHY_TST_CTRL1);
> +	writel(PHY_TESTCLK, csi2->base + CSI2_PHY_TST_CTRL0);
> +
> +	/* Clear strobe signal */
> +	writel(0x0, csi2->base + CSI2_PHY_TST_CTRL0);
> +}
> +
> +static void csi2_dphy_init(struct csi2_dev *csi2)
> +{
> +	/*
> +	 * FIXME: 0x14 is derived from a fixed D-PHY reference
> +	 * clock from the HSI_TX PLL, and a fixed target lane max
> +	 * bandwidth of 300 Mbps. This value should be derived

If the table in https://community.nxp.com/docs/DOC-94312 is correct,
this should be 850 Mbps. Where does this 300 Mbps value come from?

regards
Philipp
