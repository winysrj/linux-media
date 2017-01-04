Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:59400 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968160AbdADPFR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 10:05:17 -0500
Subject: Re: [PATCH v2 15/19] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-16-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <ecfcd8e5-01bd-b9a4-8653-7bbbdece4231@mentor.com>
Date: Wed, 4 Jan 2017 17:05:10 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-16-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> Adds MIPI CSI-2 Receiver subdev driver. This subdev is required
> for sensors with a MIPI CSI2 interface.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Makefile        |   1 +
>  drivers/staging/media/imx/imx-mipi-csi2.c | 509 ++++++++++++++++++++++++++++++
>  2 files changed, 510 insertions(+)
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
> index 0000000..84df16e
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-mipi-csi2.c
> @@ -0,0 +1,509 @@
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
> +#include <linux/module.h>
> +#include <linux/export.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/list.h>
> +#include <linux/irq.h>
> +#include <linux/of_device.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-async.h>

Please sort the list of headers alphabetically.

> +#include <asm/mach/irq.h>

Why do you need to include this header?

> +#include <video/imx-ipu-v3.h>
> +#include "imx-media.h"
> +

[snip]

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
> +		clk_prepare_enable(csi2->pix_clk);

It can complicate the design for you, but in general clk_prepare_enable()
can return an error.

> +		ret = imxcsi2_dphy_wait(csi2);
> +		if (ret)
> +			clk_disable_unprepare(csi2->pix_clk);
> +	} else if (!enable && csi2->stream_on) {
> +		clk_disable_unprepare(csi2->pix_clk);
> +	}
> +
> +	if (!ret)
> +		csi2->stream_on = enable;
> +	return ret;
> +}
> +

[snip]

> +
> +static int imxcsi2_parse_endpoints(struct imxcsi2_dev *csi2)
> +{
> +	struct device_node *node = csi2->dev->of_node;
> +	struct device_node *epnode;
> +	struct v4l2_of_endpoint ep;
> +	int ret = 0;
> +
> +	epnode = of_graph_get_next_endpoint(node, NULL);
> +	if (!epnode) {
> +		v4l2_err(&csi2->sd, "failed to get endpoint node\n");
> +		return -EINVAL;
> +	}
> +
> +	v4l2_of_parse_endpoint(epnode, &ep);

Do of_node_put(epnode) here and remove 'out' goto label.

> +	if (ep.bus_type != V4L2_MBUS_CSI2) {
> +		v4l2_err(&csi2->sd, "invalid bus type, must be MIPI CSI2\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	csi2->bus = ep.bus.mipi_csi2;
> +
> +	v4l2_info(&csi2->sd, "data lanes: %d\n", csi2->bus.num_data_lanes);
> +	v4l2_info(&csi2->sd, "flags: 0x%08x\n", csi2->bus.flags);
> +out:
> +	of_node_put(epnode);
> +	return ret;
> +}
> +

[snip]

> +static const struct of_device_id imxcsi2_dt_ids[] = {
> +	{ .compatible = "fsl,imx-mipi-csi2", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, imxcsi2_dt_ids);
> +
> +static struct platform_driver imxcsi2_driver = {
> +	.driver = {
> +		.name = DEVICE_NAME,
> +		.owner = THIS_MODULE,

Please drop .owner assignment.

> +		.of_match_table = imxcsi2_dt_ids,
> +	},
> +	.probe = imxcsi2_probe,
> +	.remove = imxcsi2_remove,
> +};
> +
> +module_platform_driver(imxcsi2_driver);
> +
> +MODULE_DESCRIPTION("i.MX5/6 MIPI CSI-2 Receiver driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> +
> 

--
With best wishes,
Vladimir
