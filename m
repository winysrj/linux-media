Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:44550 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030512AbdADNdf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 08:33:35 -0500
Subject: Re: [PATCH v2 10/19] media: Add i.MX media core driver
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-11-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <c04a85dc-4f62-798f-2e37-d7848657730a@mentor.com>
Date: Wed, 4 Jan 2017 15:33:26 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-11-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> Add the core media driver for i.MX SOC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  Documentation/devicetree/bindings/media/imx.txt   | 205 +++++

v2 was sent before getting Rob's review comments, but still they
should be addressed in v3.

Also I would suggest to separate device tree binding documentation
change and place it as the first patch in the series, this should
make the following DTS changes valid.

>  Documentation/media/v4l-drivers/imx.rst           | 430 ++++++++++
>  drivers/staging/media/Kconfig                     |   2 +
>  drivers/staging/media/Makefile                    |   1 +
>  drivers/staging/media/imx/Kconfig                 |   8 +
>  drivers/staging/media/imx/Makefile                |   6 +
>  drivers/staging/media/imx/TODO                    |  18 +
>  drivers/staging/media/imx/imx-media-common.c      | 985 ++++++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c         | 479 +++++++++++
>  drivers/staging/media/imx/imx-media-fim.c         | 509 +++++++++++
>  drivers/staging/media/imx/imx-media-internal-sd.c | 457 ++++++++++
>  drivers/staging/media/imx/imx-media-of.c          | 291 +++++++
>  drivers/staging/media/imx/imx-media-of.h          |  25 +
>  drivers/staging/media/imx/imx-media.h             | 299 +++++++
>  include/media/imx.h                               |  15 +
>  include/uapi/Kbuild                               |   1 +
>  include/uapi/linux/v4l2-controls.h                |   4 +
>  include/uapi/media/Kbuild                         |   2 +
>  include/uapi/media/imx.h                          |  30 +

Probably Greg should ack the UAPI changes, you may consider
to split them into a separate patch.

>  19 files changed, 3767 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>  create mode 100644 Documentation/media/v4l-drivers/imx.rst
>  create mode 100644 drivers/staging/media/imx/Kconfig
>  create mode 100644 drivers/staging/media/imx/Makefile
>  create mode 100644 drivers/staging/media/imx/TODO
>  create mode 100644 drivers/staging/media/imx/imx-media-common.c
>  create mode 100644 drivers/staging/media/imx/imx-media-dev.c
>  create mode 100644 drivers/staging/media/imx/imx-media-fim.c
>  create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.h
>  create mode 100644 drivers/staging/media/imx/imx-media.h
>  create mode 100644 include/media/imx.h
>  create mode 100644 include/uapi/media/Kbuild
>  create mode 100644 include/uapi/media/imx.h
> 

[snip]

> +
> +struct imx_media_subdev *
> +imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
> +			    struct v4l2_subdev *sd)
> +{
> +	struct imx_media_subdev *imxsd;
> +	int i, ret = -ENODEV;
> +
> +	for (i = 0; i < imxmd->num_subdevs; i++) {
> +		imxsd = &imxmd->subdev[i];
> +		if (sd == imxsd->sd) {

This can be simplifed:

...

	if (sd == imxsd->sd)
		return imxsd;
}

return ERR_PTR(-ENODEV);

> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	return ret ? ERR_PTR(ret) : imxsd;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_sd);
> +
> +struct imx_media_subdev *
> +imx_media_find_subdev_by_id(struct imx_media_dev *imxmd, u32 grp_id)
> +{
> +	struct imx_media_subdev *imxsd;
> +	int i, ret = -ENODEV;
> +
> +	for (i = 0; i < imxmd->num_subdevs; i++) {
> +		imxsd = &imxmd->subdev[i];
> +		if (imxsd->sd && imxsd->sd->grp_id == grp_id) {
> +			ret = 0;
> +			break;

This can be simplifed:

...

	if (imxsd->sd && imxsd->sd->grp_id == grp_i)
		return imxsd;
}

return ERR_PTR(-ENODEV);

> +		}
> +	}
> +
> +	return ret ? ERR_PTR(ret) : imxsd;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_id);
> +

[snip]

> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> new file mode 100644
> index 0000000..8d22730
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -0,0 +1,479 @@
> +/*
> + * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/timer.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/platform_device.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/of_platform.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mc.h>

Please sort out the list of headers alphabetically.

> +#include <video/imx-ipu-v3.h>
> +#include <media/imx.h>
> +#include "imx-media.h"
> +#include "imx-media-of.h"
> +
> +#define DEVICE_NAME "imx-media"

I suppose you don't need this macro.

[snip]

> + */
> +static int imx_media_create_links(struct imx_media_dev *imxmd)
> +{
> +	struct imx_media_subdev *local_sd;
> +	struct imx_media_subdev *remote_sd;
> +	struct v4l2_subdev *source, *sink;
> +	struct imx_media_link *link;
> +	struct imx_media_pad *pad;
> +	u16 source_pad, sink_pad;
> +	int num_pads, i, j, k;
> +	int ret = 0;
> +
> +	for (i = 0; i < imxmd->num_subdevs; i++) {
> +		local_sd = &imxmd->subdev[i];
> +		num_pads = local_sd->num_sink_pads + local_sd->num_src_pads;
> +
> +		for (j = 0; j < num_pads; j++) {
> +			pad = &local_sd->pad[j];
> +
> +			for (k = 0; k < pad->num_links; k++) {
> +				link = &pad->link[k];
> +
> +				remote_sd = imx_media_find_async_subdev(
> +					imxmd, link->remote_sd_node,
> +					link->remote_devname);
> +				if (!remote_sd) {
> +					v4l2_warn(&imxmd->v4l2_dev,
> +						  "%s: no remote for %s:%d\n",
> +						  __func__, local_sd->sd->name,
> +						  link->local_pad);
> +					continue;
> +				}
> +
> +				/* only create the source->sink links */
> +				if (pad->pad.flags & MEDIA_PAD_FL_SINK)
> +					continue;
> +
> +				source = local_sd->sd;
> +				sink = remote_sd->sd;
> +				source_pad = link->local_pad;
> +				sink_pad = link->remote_pad;
> +
> +				v4l2_info(&imxmd->v4l2_dev,
> +					  "%s: %s:%d -> %s:%d\n", __func__,
> +					  source->name, source_pad,
> +					  sink->name, sink_pad);
> +
> +				ret = media_create_pad_link(&source->entity,
> +							    source_pad,
> +							    &sink->entity,
> +							    sink_pad,
> +							    0);
> +				if (ret) {
> +					v4l2_err(&imxmd->v4l2_dev,
> +						 "create_pad_link failed: %d\n",
> +						 ret);
> +					goto out;

Indentation depth is quite terrific.

> +				}
> +			}
> +		}
> +	}
> +
> +out:
> +	return ret;
>
[snip]

> +
> +static const struct of_device_id imx_media_dt_ids[] = {
> +	{ .compatible = "fsl,imx-media" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, imx_media_dt_ids);
> +
> +static struct platform_driver imx_media_pdrv = {
> +	.probe		= imx_media_probe,
> +	.remove		= imx_media_remove,
> +	.driver		= {
> +		.name	= DEVICE_NAME,
> +		.owner	= THIS_MODULE,

Setting of .owner is not needed nowadays IIRC.

> +		.of_match_table	= imx_media_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(imx_media_pdrv);
> +
> +MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
> new file mode 100644
> index 0000000..52bfa8d
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-fim.c
> @@ -0,0 +1,509 @@
> +/*
> + * Frame Interval Monitor.
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#ifdef CONFIG_IMX_GPT_ICAP
> +#include <linux/mxc_icap.h>
> +#endif

This looks clumsy. Include it unconditionally, if needed
do #ifdef's inside the header file.

> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Please sort out the list alphabetically.

> +#include <media/imx.h>
> +#include "imx-media.h"
> +

[snip]

> +
> +static int of_parse_fim(struct imx_media_fim *fim, struct device_node *np)
> +{
> +	struct device_node *fim_np;
> +	u32 val, tol[2], icap[2];
> +	int ret;
> +
> +	fim_np = of_get_child_by_name(np, "fim");
> +	if (!fim_np) {
> +		/* set to the default defaults */
> +		fim->of_defaults[FIM_CL_ENABLE] = FIM_CL_ENABLE_DEF;
> +		fim->of_defaults[FIM_CL_NUM] = FIM_CL_NUM_DEF;
> +		fim->of_defaults[FIM_CL_NUM_SKIP] = FIM_CL_NUM_SKIP_DEF;
> +		fim->of_defaults[FIM_CL_TOLERANCE_MIN] =
> +			FIM_CL_TOLERANCE_MIN_DEF;
> +		fim->of_defaults[FIM_CL_TOLERANCE_MAX] =
> +			FIM_CL_TOLERANCE_MAX_DEF;
> +		fim->icap_channel = -1;
> +		return 0;
> +	}
> +
> +	ret = of_property_read_u32(fim_np, "enable", &val);
> +	if (ret)
> +		val = FIM_CL_ENABLE_DEF;
> +	fim->of_defaults[FIM_CL_ENABLE] = val;
> +
> +	ret = of_property_read_u32(fim_np, "num-avg", &val);
> +	if (ret)
> +		val = FIM_CL_NUM_DEF;
> +	fim->of_defaults[FIM_CL_NUM] = val;
> +
> +	ret = of_property_read_u32(fim_np, "num-skip", &val);
> +	if (ret)
> +		val = FIM_CL_NUM_SKIP_DEF;
> +	fim->of_defaults[FIM_CL_NUM_SKIP] = val;
> +
> +	ret = of_property_read_u32_array(fim_np, "tolerance-range", tol, 2);
> +	if (ret) {
> +		tol[0] = FIM_CL_TOLERANCE_MIN_DEF;
> +		tol[1] = FIM_CL_TOLERANCE_MAX_DEF;
> +	}
> +	fim->of_defaults[FIM_CL_TOLERANCE_MIN] = tol[0];
> +	fim->of_defaults[FIM_CL_TOLERANCE_MAX] = tol[1];
> +
> +	fim->icap_channel = -1;
> +	if (IS_ENABLED(CONFIG_IMX_GPT_ICAP)) {
> +		ret = of_property_read_u32_array(fim_np,
> +						 "input-capture-channel",
> +						 icap, 2);
> +		if (!ret) {
> +			fim->icap_channel = icap[0];
> +			fim->icap_flags = icap[1];
> +		}

Should you return error otherwise?

> +	}
> +
> +	of_node_put(fim_np);
> +	return 0;
> +}

[snip]

> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
> new file mode 100644
> index 0000000..018d05a
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-of.c
> @@ -0,0 +1,291 @@
> +/*
> + * Media driver for Freescale i.MX5/6 SOC
> + *
> + * Open Firmware parsing.
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/of_platform.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Please sort out the list alphabetically.

> +#include <video/imx-ipu-v3.h>
> +#include "imx-media.h"
> +
> +static int of_add_pad_link(struct imx_media_dev *imxmd,
> +			   struct imx_media_pad *pad,
> +			   struct device_node *local_sd_node,
> +			   struct device_node *remote_sd_node,
> +			   int local_pad, int remote_pad)
> +{
> +	dev_dbg(imxmd->dev, "%s: adding %s:%d -> %s:%d\n", __func__,
> +		local_sd_node->name, local_pad,
> +		remote_sd_node->name, remote_pad);
> +
> +	return imx_media_add_pad_link(imxmd, pad, remote_sd_node, NULL,
> +				      local_pad, remote_pad);
> +}
> +
> +/* parse inputs property from a sensor node */
> +static void of_parse_sensor_inputs(struct imx_media_dev *imxmd,
> +				   struct imx_media_subdev *sensor,
> +				   struct device_node *sensor_np)
> +{
> +	struct imx_media_sensor_input *sinput = &sensor->input;
> +	int ret, i;
> +
> +	for (i = 0; i < IMX_MEDIA_MAX_SENSOR_INPUTS; i++) {
> +		const char *input_name;
> +		u32 val;
> +
> +		ret = of_property_read_u32_index(sensor_np, "inputs", i, &val);
> +		if (ret)
> +			break;
> +
> +		sinput->value[i] = val;
> +
> +		ret = of_property_read_string_index(sensor_np, "input-names",
> +						    i, &input_name);
> +		/*
> +		 * if input-names not provided, they will be set using
> +		 * the subdev name once the sensor is known during
> +		 * async bind
> +		 */
> +		if (!ret)
> +			strncpy(sinput->name[i], input_name,
> +				sizeof(sinput->name[i]));
> +	}
> +
> +	sinput->num = i;
> +
> +	/* if no inputs provided just assume a single input */
> +	if (sinput->num == 0)
> +		sinput->num = 1;
> +}
> +
> +static void of_parse_sensor(struct imx_media_dev *imxmd,
> +			    struct imx_media_subdev *sensor,
> +			    struct device_node *sensor_np)
> +{
> +	struct device_node *endpoint;
> +
> +	of_parse_sensor_inputs(imxmd, sensor, sensor_np);
> +
> +	endpoint = of_graph_get_next_endpoint(sensor_np, NULL);
> +	if (endpoint) {
> +		v4l2_of_parse_endpoint(endpoint, &sensor->sensor_ep);
> +		of_node_put(endpoint);
> +	}
> +}
> +
> +static int of_get_port_count(const struct device_node *np)
> +{
> +	struct device_node *child;
> +	int num = 0;
> +
> +	/* if this node is itself a port, return 1 */
> +	if (of_node_cmp(np->name, "port") == 0)
> +		return 1;
> +
> +	for_each_child_of_node(np, child) {
> +		if (of_node_cmp(child->name, "port") == 0)
> +			num++;
> +	}

Unneeded bracers.

> +	return num;
> +}
> +
> +/*
> + * find the remote device node and remote port id (remote pad #)
> + * given local endpoint node
> + */
> +static void of_get_remote_pad(struct device_node *epnode,
> +			      struct device_node **remote_node,
> +			      int *remote_pad)
> +{
> +	struct device_node *rp, *rpp;
> +	struct device_node *remote;
> +
> +	rp = of_graph_get_remote_port(epnode);
> +	rpp = of_graph_get_remote_port_parent(epnode);
> +
> +	if (of_device_is_compatible(rpp, "fsl,imx6q-ipu")) {
> +		/* the remote is one of the CSI ports */
> +		remote = rp;
> +		*remote_pad = 0;
> +		of_node_put(rpp);
> +	} else {
> +		remote = rpp;
> +		of_property_read_u32(rp, "reg", remote_pad);
> +		of_node_put(rp);
> +	}
> +
> +	if (!remote || !of_device_is_available(remote)) {
> +		of_node_put(remote);
> +		*remote_node = NULL;
> +	} else {
> +		*remote_node = remote;
> +	}
> +}
> +
> +static struct imx_media_subdev *
> +of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
> +		bool is_csi_port)
> +{
> +	struct imx_media_subdev *imxsd;
> +	int i, num_pads, ret;
> +
> +	if (!of_device_is_available(sd_np)) {
> +		dev_dbg(imxmd->dev, "%s: %s not enabled\n", __func__,
> +			sd_np->name);
> +		return NULL;
> +	}
> +
> +	/* register this subdev with async notifier */
> +	imxsd = imx_media_add_async_subdev(imxmd, sd_np, NULL);
> +	if (!imxsd)
> +		return NULL;
> +	if (IS_ERR(imxsd))
> +		return imxsd;

if (IS_ERR_OR_NULL(imxsd))
	return imxsd;

> +
> +	if (is_csi_port) {
> +		/*
> +		 * the ipu-csi has one sink port and one source port.
> +		 * The source port is not represented in the device tree,
> +		 * but is described by the internal pads and links later.
> +		 */
> +		num_pads = 2;
> +		imxsd->num_sink_pads = 1;
> +	} else if (of_device_is_compatible(sd_np, "fsl,imx-mipi-csi2")) {
> +		num_pads = of_get_port_count(sd_np);
> +		/* the mipi csi2 receiver has only one sink port */
> +		imxsd->num_sink_pads = 1;
> +	} else if (of_device_is_compatible(sd_np, "imx-video-mux")) {
> +		num_pads = of_get_port_count(sd_np);
> +		/* for the video mux, all but the last port are sinks */
> +		imxsd->num_sink_pads = num_pads - 1;
> +	} else {
> +		/* must be a sensor */
> +		num_pads = 1;
> +		imxsd->num_sink_pads = 0;
> +	}
> +
> +	if (imxsd->num_sink_pads >= num_pads)
> +		return ERR_PTR(-EINVAL);
> +
> +	imxsd->num_src_pads = num_pads - imxsd->num_sink_pads;
> +
> +	dev_dbg(imxmd->dev, "%s: %s has %d pads (%d sink, %d src)\n",
> +		__func__, sd_np->name, num_pads,
> +		imxsd->num_sink_pads, imxsd->num_src_pads);
> +
> +	if (imxsd->num_sink_pads == 0) {
> +		/* this might be a sensor */
> +		of_parse_sensor(imxmd, imxsd, sd_np);
> +	}

Unneeded bracers.

> +
> +	for (i = 0; i < num_pads; i++) {
> +		struct device_node *epnode = NULL, *port, *remote_np;
> +		struct imx_media_subdev *remote_imxsd;
> +		struct imx_media_pad *pad;
> +		int remote_pad;

Too deep indentation, may be move the cycle body into a separate function?

> +
> +		/* init this pad */
> +		pad = &imxsd->pad[i];
> +		pad->pad.flags = (i < imxsd->num_sink_pads) ?
> +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> +
> +		if (is_csi_port)
> +			port = (i < imxsd->num_sink_pads) ? sd_np : NULL;
> +		else
> +			port = of_graph_get_port_by_id(sd_np, i);
> +		if (!port)
> +			continue;
> +
> +		while ((epnode = of_get_next_child(port, epnode))) {

Please reuse for_each_child_of_node() here.

> +			of_get_remote_pad(epnode, &remote_np, &remote_pad);
> +			if (!remote_np) {
> +				of_node_put(epnode);

Please remove of_node_put() here, of_get_next_child() does it.

> +				continue;
> +			}
> +
> +			ret = of_add_pad_link(imxmd, pad, sd_np, remote_np,
> +					      i, remote_pad);
> +			if (ret) {
> +				imxsd = ERR_PTR(ret);
> +				break;
> +			}
> +
> +			if (i < imxsd->num_sink_pads) {
> +				/* follow sink endpoints upstream */
> +				remote_imxsd = of_parse_subdev(imxmd,
> +							       remote_np,
> +							       false);
> +				if (IS_ERR(remote_imxsd)) {
> +					imxsd = remote_imxsd;
> +					break;
> +				}
> +			}
> +
> +			of_node_put(remote_np);
> +			of_node_put(epnode);
> +		}
> +
> +		if (port != sd_np)
> +			of_node_put(port);
> +		if (IS_ERR(imxsd)) {
> +			of_node_put(remote_np);
> +			of_node_put(epnode);
> +			break;
> +		}
> +	}
> +
> +	return imxsd;
> +}
> +
> +int imx_media_of_parse(struct imx_media_dev *imxmd,
> +		       struct imx_media_subdev *(*csi)[4],
> +		       struct device_node *np)
> +{
> +	struct device_node *csi_np;
> +	struct imx_media_subdev *lcsi;

Please swap two lines above to get the reverse christmas tree ordering.

> +	u32 ipu_id, csi_id;
> +	int i, ret;
> +
> +	for (i = 0; ; i++) {
> +		csi_np = of_parse_phandle(np, "ports", i);
> +		if (!csi_np)
> +			break;
> +
> +		lcsi = of_parse_subdev(imxmd, csi_np, true);
> +		if (IS_ERR(lcsi)) {
> +			ret = PTR_ERR(lcsi);
> +			goto err_put;
> +		}
> +
> +		of_property_read_u32(csi_np, "reg", &csi_id);

Not sure if it is safe enough to ignore return value and potentially
left csi_id uninitialized.

> +		ipu_id = of_alias_get_id(csi_np->parent, "ipu");
> +
> +		if (ipu_id > 1 || csi_id > 1) {
> +			dev_err(imxmd->dev, "%s: invalid ipu/csi id (%u/%u)\n",
> +				__func__, ipu_id, csi_id);
> +			ret = -EINVAL;
> +			goto err_put;
> +		}
> +
> +		of_node_put(csi_np);

You can put the node right after of_alias_get_id() call, then in case
of error return right from the if block and remove the goto label.

> +
> +		(*csi)[ipu_id * 2 + csi_id] = lcsi;
> +	}
> +
> +	return 0;
> +err_put:
> +	of_node_put(csi_np);
> +	return ret;
> +}
> diff --git a/drivers/staging/media/imx/imx-media-of.h b/drivers/staging/media/imx/imx-media-of.h
> new file mode 100644
> index 0000000..0c61b05
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-of.h
> @@ -0,0 +1,25 @@
> +/*
> + * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
> + *
> + * Open Firmware parsing.
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef _IMX_MEDIA_OF_H
> +#define _IMX_MEDIA_OF_H
> +

I do believe you should include some headers or add declarations
of "struct imx_media_dev", "struct imx_media_subdev", "struct device_node".

> +struct imx_media_subdev *
> +imx_media_of_find_subdev(struct imx_media_dev *imxmd,
> +			 struct device_node *np,
> +			 const char *name);
> +
> +int imx_media_of_parse(struct imx_media_dev *dev,
> +		       struct imx_media_subdev *(*csi)[4],
> +		       struct device_node *np);
> +
> +#endif
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> new file mode 100644
> index 0000000..6a018a9
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -0,0 +1,299 @@
> +/*
> + * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef _IMX_MEDIA_H
> +#define _IMX_MEDIA_H

Please insert here an empty line to improve readability.

> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-of.h>

Please sort out the list alphabetically.

> +#include <media/videobuf2-dma-contig.h>
> +#include <video/imx-ipu-v3.h>
> +
> +/*
> + * This is somewhat arbitrary, but we need at least:
> + * - 2 camera interface subdevs
> + * - 3 IC subdevs
> + * - 2 CSI subdevs
> + * - 1 mipi-csi2 receiver subdev
> + * - 2 video-mux subdevs
> + * - 3 camera sensor subdevs (2 parallel, 1 mipi-csi2)
> + *
> + * And double the above numbers for quad i.mx!
> + */

[snip]

--
With best wishes,
Vladimir
