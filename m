Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41580 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754409AbdGSKoX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:44:23 -0400
Subject: Re: [PATCH v3 12/23] media: camms: Add core files
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-13-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4b06c0d5-ef9c-e5af-7db2-735bebd227e8@xs4all.nl>
Date: Wed, 19 Jul 2017 12:44:17 +0200
MIME-Version: 1.0
In-Reply-To: <1500287629-23703-13-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Just one comment:

On 17/07/17 12:33, Todor Tomov wrote:
> These files implement the platform driver code.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  drivers/media/platform/qcom/camss-8x16/camss.c | 705 +++++++++++++++++++++++++
>  drivers/media/platform/qcom/camss-8x16/camss.h |  97 ++++
>  2 files changed, 802 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
> new file mode 100644
> index 0000000..097d4ec
> --- /dev/null
> +++ b/drivers/media/platform/qcom/camss-8x16/camss.c
> @@ -0,0 +1,705 @@
> +/*
> + * camss.c
> + *
> + * Qualcomm MSM Camera Subsystem - Core
> + *
> + * Copyright (c) 2015, The Linux Foundation. All rights reserved.
> + * Copyright (C) 2015-2017 Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/clk.h>
> +#include <linux/media-bus-format.h>
> +#include <linux/media.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-device.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-mc.h>
> +#include <media/v4l2-fwnode.h>
> +
> +#include "camss.h"
> +
> +static const struct resources csiphy_res[] = {
> +	/* CSIPHY0 */
> +	{
> +		.regulator = { NULL },
> +		.clock = { "camss_top_ahb", "ispif_ahb",
> +			   "camss_ahb", "csiphy0_timer" },
> +		.clock_rate = { 0, 0, 0, 200000000 },
> +		.reg = { "csiphy0", "csiphy0_clk_mux" },
> +		.interrupt = { "csiphy0" }
> +	},
> +
> +	/* CSIPHY1 */
> +	{
> +		.regulator = { NULL },
> +		.clock = { "camss_top_ahb", "ispif_ahb",
> +			   "camss_ahb", "csiphy1_timer" },
> +		.clock_rate = { 0, 0, 0, 200000000 },
> +		.reg = { "csiphy1", "csiphy1_clk_mux" },
> +		.interrupt = { "csiphy1" }
> +	}
> +};
> +
> +static const struct resources csid_res[] = {
> +	/* CSID0 */
> +	{
> +		.regulator = { "vdda" },
> +		.clock = { "camss_top_ahb", "ispif_ahb",
> +			   "csi0_ahb", "camss_ahb",
> +			   "csi0", "csi0_phy", "csi0_pix", "csi0_rdi" },
> +		.clock_rate = { 0, 0, 0, 0, 200000000, 0, 0, 0 },
> +		.reg = { "csid0" },
> +		.interrupt = { "csid0" }
> +	},
> +
> +	/* CSID1 */
> +	{
> +		.regulator = { "vdda" },
> +		.clock = { "camss_top_ahb", "ispif_ahb",
> +			   "csi1_ahb", "camss_ahb",
> +			   "csi1", "csi1_phy", "csi1_pix", "csi1_rdi" },
> +		.clock_rate = { 0, 0, 0, 0, 200000000, 0, 0, 0 },
> +		.reg = { "csid1" },
> +		.interrupt = { "csid1" }
> +	},
> +};
> +
> +static const struct resources_ispif ispif_res = {
> +	/* ISPIF */
> +	.clock = { "camss_top_ahb", "camss_ahb", "ispif_ahb",
> +		   "csi0", "csi0_pix", "csi0_rdi",
> +		   "csi1", "csi1_pix", "csi1_rdi" },
> +	.clock_for_reset = { "camss_vfe_vfe", "camss_csi_vfe" },
> +	.reg = { "ispif", "csi_clk_mux" },
> +	.interrupt = "ispif"
> +
> +};
> +
> +static const struct resources vfe_res = {
> +	/* VFE0 */
> +	.regulator = { NULL },
> +	.clock = { "camss_top_ahb", "camss_vfe_vfe", "camss_csi_vfe",
> +		   "iface", "bus", "camss_ahb" },
> +	.clock_rate = { 0, 320000000, 0, 0, 0, 0, 0, 0 },
> +	.reg = { "vfe0" },
> +	.interrupt = { "vfe0" }
> +};
> +
> +/*
> + * camss_enable_clocks - Enable multiple clocks
> + * @nclocks: Number of clocks in clock array
> + * @clock: Clock array
> + * @dev: Device
> + *
> + * Return 0 on success or a negative error code otherwise
> + */
> +int camss_enable_clocks(int nclocks, struct clk **clock, struct device *dev)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < nclocks; i++) {
> +		ret = clk_prepare_enable(clock[i]);
> +		if (ret) {
> +			dev_err(dev, "clock enable failed: %d\n", ret);
> +			goto error;
> +		}
> +	}
> +
> +	return 0;
> +
> +error:
> +	for (i--; i >= 0; i--)
> +		clk_disable_unprepare(clock[i]);
> +
> +	return ret;
> +}
> +
> +/*
> + * camss_disable_clocks - Disable multiple clocks
> + * @nclocks: Number of clocks in clock array
> + * @clock: Clock array
> + */
> +void camss_disable_clocks(int nclocks, struct clk **clock)
> +{
> +	int i;
> +
> +	for (i = nclocks - 1; i >= 0; i--)
> +		clk_disable_unprepare(clock[i]);
> +}
> +
> +/*
> + * camss_find_sensor - Find a linked media entity which represents a sensor
> + * @entity: Media entity to start searching from
> + *
> + * Return a pointer to sensor media entity or NULL if not found
> + */
> +static struct media_entity *camss_find_sensor(struct media_entity *entity)
> +{
> +	struct media_pad *pad;
> +
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			return NULL;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			return NULL;
> +
> +		entity = pad->entity;
> +
> +		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
> +			return entity;
> +	}
> +}
> +
> +/*
> + * camss_get_pixel_clock - Get pixel clock rate from sensor
> + * @entity: Media entity in the current pipeline
> + * @pixel_clock: Received pixel clock value
> + *
> + * Return 0 on success or a negative error code otherwise
> + */
> +int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock)
> +{
> +	struct media_entity *sensor;
> +	struct v4l2_subdev *subdev;
> +	struct v4l2_ext_controls ctrls = { { 0 } };
> +	struct v4l2_ext_control ctrl = { 0 };
> +	int ret;
> +
> +	sensor = camss_find_sensor(entity);
> +	if (!sensor)
> +		return -ENODEV;
> +
> +	subdev = media_entity_to_v4l2_subdev(sensor);
> +
> +	ctrl.id = V4L2_CID_PIXEL_RATE;
> +
> +	ctrls.count = 1;
> +	ctrls.controls = &ctrl;
> +
> +	ret = v4l2_g_ext_ctrls(subdev->ctrl_handler, &ctrls);

Don't use v4l2_g_ext_ctrls for this, it is not meant for use in drivers.
Instead do this:

	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(subdev->ctrl_handler, V4L2_CID_PIXEL_RATE);

	if (ctrl == NULL)
		return -EINVAL;  // or some other error code

	*pixel_clock = v4l2_ctrl_g_ctrl_int64(ctrl);

> +	if (ret < 0)
> +		return ret;
> +
> +	*pixel_clock = ctrl.value64;
> +
> +	return 0;
> +}

Regards,

	Hans
