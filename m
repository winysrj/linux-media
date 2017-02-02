Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53319 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751365AbdBBLxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 06:53:10 -0500
Message-ID: <1486036237.2289.37.camel@pengutronix.de>
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
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
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 02 Feb 2017 12:50:37 +0100
In-Reply-To: <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-01-06 at 18:11 -0800, Steve Longerbeam wrote:
> Adds MIPI CSI-2 Receiver subdev driver. This subdev is required
> for sensors with a MIPI CSI2 interface.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Makefile        |   1 +
>  drivers/staging/media/imx/imx-mipi-csi2.c | 501 ++++++++++++++++++++++++++++++
>  2 files changed, 502 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx-mipi-csi2.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index fe9e992..0decef7 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-ic.o
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-camif.o
> +obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-mipi-csi2.o
> diff --git a/drivers/staging/media/imx/imx-mipi-csi2.c b/drivers/staging/media/imx/imx-mipi-csi2.c
> new file mode 100644
> index 0000000..daa6e1d
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-mipi-csi2.c
> @@ -0,0 +1,501 @@
> +/*
> + * MIPI CSI-2 Receiver Subdev for Freescale i.MX5/6 SOC.
> + *
> + * Copyright (c) 2012-2014 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <video/imx-ipu-v3.h>
> +#include "imx-media.h"
> +
> +/*
> + * there must be 5 pads: 1 input pad from sensor, and
> + * the 4 virtual channel output pads
> + */
> +#define CSI2_NUM_SINK_PADS  1
> +#define CSI2_NUM_SRC_PADS   4
> +#define CSI2_NUM_PADS       5
> +
> +struct imxcsi2_dev {
> +	struct device          *dev;
> +	struct imx_media_dev   *md;
> +	struct v4l2_subdev      sd;
> +	struct media_pad       pad[CSI2_NUM_PADS];
> +	struct v4l2_mbus_framefmt format_mbus;
> +	struct v4l2_subdev     *src_sd;
> +	struct v4l2_subdev     *sink_sd[CSI2_NUM_SRC_PADS];

I see no reason to store pointers to the remote v4l2_subdevs.

> +	int                    input_pad;
> +	struct clk             *dphy_clk;
> +	struct clk             *cfg_clk;
> +	struct clk             *pix_clk; /* what is this? */
> +	void __iomem           *base;
> +	int                     intr1;
> +	int                     intr2;

The interrupts are not used, I'd remove them and the dead code in
_probe.

> +	struct v4l2_of_bus_mipi_csi2 bus;
> +	bool                    on;
> +	bool                    stream_on;
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
> +#define CSI2_DATA_IDS_1         0x018
> +#define CSI2_DATA_IDS_2         0x01c
> +#define CSI2_ERR1               0x020
> +#define CSI2_ERR2               0x024
> +#define CSI2_MSK1               0x028
> +#define CSI2_MSK2               0x02c
> +#define CSI2_PHY_TST_CTRL0      0x030
> +#define CSI2_PHY_TST_CTRL1      0x034
> +#define CSI2_SFT_RESET          0xf00
> +
> +static inline struct imxcsi2_dev *sd_to_dev(struct v4l2_subdev *sdev)
> +{
> +	return container_of(sdev, struct imxcsi2_dev, sd);
> +}
> +
> +static inline u32 imxcsi2_read(struct imxcsi2_dev *csi2, unsigned int regoff)
> +{
> +	return readl(csi2->base + regoff);
> +}
> +
> +static inline void imxcsi2_write(struct imxcsi2_dev *csi2, u32 val,
> +				 unsigned int regoff)
> +{
> +	writel(val, csi2->base + regoff);
> +}

Do those two wrappers really make the code more readable?

> +static void imxcsi2_set_lanes(struct imxcsi2_dev *csi2)
> +{
> +	int lanes = csi2->bus.num_data_lanes;
> +
> +	imxcsi2_write(csi2, lanes - 1, CSI2_N_LANES);
> +}
> +
> +static void imxcsi2_enable(struct imxcsi2_dev *csi2, bool enable)
> +{
> +	if (enable) {
> +		imxcsi2_write(csi2, 0xffffffff, CSI2_PHY_SHUTDOWNZ);
> +		imxcsi2_write(csi2, 0xffffffff, CSI2_DPHY_RSTZ);
> +		imxcsi2_write(csi2, 0xffffffff, CSI2_RESETN);

Given that these registers only contain a single bit, and bits 31:1 are
documented as reserved, 0, I think these should write 1 instead of
0xffffffff.

> +	} else {
> +		imxcsi2_write(csi2, 0x0, CSI2_PHY_SHUTDOWNZ);
> +		imxcsi2_write(csi2, 0x0, CSI2_DPHY_RSTZ);
> +		imxcsi2_write(csi2, 0x0, CSI2_RESETN);
> +	}
> +}
> +
> +static void imxcsi2_reset(struct imxcsi2_dev *csi2)
> +{
> +	imxcsi2_enable(csi2, false);
> +
> +	imxcsi2_write(csi2, 0x00000001, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL1);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00010044, CSI2_PHY_TST_CTRL1);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000014, CSI2_PHY_TST_CTRL1);
> +	imxcsi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);

These magic constants should be replaced with proper defines for the
documented bitfields, if available.

#define PHY_TESTCLR		BIT(0)
#define PHY_TESTCLK		BIT(1)

#define PHY_TESTEN		BIT(16)

	/* Clear PHY test interface */
	imxcsi2_write(csi2, PHY_TESTCLR, CSI2_PHY_TST_CTRL0);
	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL1);
	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL0);

	/* Raise test interface strobe signal */
	imxcsi2_write(csi2, PHY_TESTCLK, CSI2_PHY_TST_CTRL0);

	/* Configure address write on falling edge and lower strobe signal */
	u8 addr = 0x44;
	imxcsi2_write(csi2, PHY_TESTEN | addr, CSI2_PHY_TST_CTRL1);
	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL0);

	/* Configure data write on rising edge and raise strobe signal */
	u8 data = 0x14;
	imxcsi2_write(csi2, data, CSI2_PHY_TST_CTRL1);
	imxcsi2_write(csi2, PHY_TESTCLK, CSI2_PHY_TST_CTRL0);

	/* Clear strobe signal */
	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL0);

The whole sequence should probably be encapsulated in a
dw_mipi_dphy_write function.

Actually, this exact function already exists as dw_mipi_dsi_phy_write in
drivers/gpu/drm/rockchip/dw-mipi-dsi.c, and it looks like the D-PHY
register 0x44 might contain a field called HSFREQRANGE_SEL.

> +	imxcsi2_enable(csi2, true);
> +}
> +
> +static int imxcsi2_dphy_wait(struct imxcsi2_dev *csi2)
> +{
> +	u32 reg;
> +	int i;
> +
> +	/* wait for mipi sensor ready */

More specifically, wait for the clock lane module to leave ULP state.

> +	for (i = 0; i < 50; i++) {
> +		reg = imxcsi2_read(csi2, CSI2_PHY_STATE);
> +		if (reg != 0x200)

Magic constants are bad. This is PHY_RXULPSCLKNOT (clock lane module in
ultra low power state).

> +			break;
> +		usleep_range(10000, 20000);
> +	}

How about breaking this out into a wait function, or even better, using
readl_poll_timeout instead of open coding these loops multiple times?

> +
> +	if (i >= 50) {
> +		v4l2_err(&csi2->sd,
> +			 "wait for clock lane timeout, phy_state = 0x%08x\n",
> +			 reg);
> +		return -ETIME;
> +	}
> +
> +	/* wait for mipi stable */

Wait for error free transmission?

> +	for (i = 0; i < 50; i++) {
> +		reg = imxcsi2_read(csi2, CSI2_ERR1);
> +		if (reg == 0x0)
> +			break;
> +		usleep_range(10000, 20000);
> +	}

readl_poll_timeout

> +
> +	if (i >= 50) {
> +		v4l2_err(&csi2->sd,
> +			 "wait for controller timeout, err1 = 0x%08x\n",
> +			 reg);
> +		return -ETIME;
> +	}
> +
> +	/* finally let's wait for active clock on the clock lane */
> +	for (i = 0; i < 50; i++) {
> +		reg = imxcsi2_read(csi2, CSI2_PHY_STATE);
> +		if (reg & (1 << 8))

Yes, and that is PHY_RXCLKACTIVEHS.

> +			break;
> +		usleep_range(10000, 20000);
> +	}

readl_poll_timeout

> +
> +	if (i >= 50) {
> +		v4l2_err(&csi2->sd,
> +			 "wait for active clock timeout, phy_state = 0x%08x\n",
> +			 reg);
> +		return -ETIME;
> +	}
> +
> +	v4l2_info(&csi2->sd, "ready, dphy version 0x%x\n",
> +		  imxcsi2_read(csi2, CSI2_VERSION));

Noisy. (These are already removed for the next version.)

> +	return 0;
> +}
> +
> +/*
> + * V4L2 subdev operations
> + */
> +
> +static int imxcsi2_link_setup(struct media_entity *entity,
> +			      const struct media_pad *local,
> +			      const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
> +	struct v4l2_subdev *remote_sd;
> +
> +	dev_dbg(csi2->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
> +
> +	if (local->flags & MEDIA_PAD_FL_SOURCE) {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (csi2->sink_sd[local->index])
> +				return -EBUSY;
> +			csi2->sink_sd[local->index] = remote_sd;
> +		} else {
> +			csi2->sink_sd[local->index] = NULL;
> +		}
> +	} else {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (csi2->src_sd)
> +				return -EBUSY;
> +			csi2->src_sd = remote_sd;
> +		} else {
> +			csi2->src_sd = NULL;
> +		}
> +	}

This whole code block is just to check if there is another link already
active on the given pad. This could be stored in a boolean or a bit, no
need to store pointers to remote subdevices.

> +	return 0;
> +}
> +
> +static int imxcsi2_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
> +
> +	if (on && !csi2->on) {
> +		v4l2_info(&csi2->sd, "power ON\n");
> +		clk_prepare_enable(csi2->cfg_clk);
> +		clk_prepare_enable(csi2->dphy_clk);
> +		imxcsi2_set_lanes(csi2);
> +		imxcsi2_reset(csi2);
> +	} else if (!on && csi2->on) {
> +		v4l2_info(&csi2->sd, "power OFF\n");
> +		imxcsi2_enable(csi2, false);
> +		clk_disable_unprepare(csi2->dphy_clk);
> +		clk_disable_unprepare(csi2->cfg_clk);
> +	}
> +
> +	csi2->on = on;
> +	return 0;
> +}
> +
> +static int imxcsi2_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
> +	int i, ret = 0;
> +
> +	if (!csi2->src_sd)
> +		return -EPIPE;
> +	for (i = 0; i < CSI2_NUM_SRC_PADS; i++) {
> +		if (csi2->sink_sd[i])
> +			break;
> +	}
> +	if (i >= CSI2_NUM_SRC_PADS)
> +		return -EPIPE;
> +
> +	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
> +
> +	if (enable && !csi2->stream_on) {
> +		ret = clk_prepare_enable(csi2->pix_clk);
> +		if (ret)
> +			return ret;
> +
> +		ret = imxcsi2_dphy_wait(csi2);
> +		if (ret) {
> +			clk_disable_unprepare(csi2->pix_clk);
> +			return ret;
> +		}
> +	} else if (!enable && csi2->stream_on) {
> +		clk_disable_unprepare(csi2->pix_clk);
> +	}
> +
> +	csi2->stream_on = enable;
> +	return 0;
> +}
> +
> +static int imxcsi2_get_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *sdformat)
> +{
> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
> +
> +	sdformat->format = csi2->format_mbus;

The output formats are different from the input formats, see the media
bus format discussion in the other thread. The input pad is the MIPI
CSI-2 bus, but the four output pads are connected to the muxes / CSIs
via a 16-bit parallel bus.

So if the input format is UYVY8_1X16, for example, the output should be
set to UYVY8_2X8.

regards
Philipp

