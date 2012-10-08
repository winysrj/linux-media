Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12441 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHKDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 06:03:50 -0400
Message-id: <5072A501.6020602@samsung.com>
Date: Mon, 08 Oct 2012 12:03:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-6-git-send-email-g.liakhovetski@gmx.de>
In-reply-to: <1348754853-28619-6-git-send-email-g.liakhovetski@gmx.de>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 09/27/2012 04:07 PM, Guennadi Liakhovetski wrote:
> Add a V4L2 OF parser, implementing bindings, documented in
> Documentation/devicetree/bindings/media/v4l2.txt.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/v4l2-core/Makefile  |    3 +
>  drivers/media/v4l2-core/v4l2-of.c |  190 +++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-of.h           |   62 ++++++++++++
>  3 files changed, 255 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-of.c
>  create mode 100644 include/media/v4l2-of.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index c2d61d4..00f64d6 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -9,6 +9,9 @@ videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> +ifeq ($(CONFIG_OF),y)
> +  videodev-objs += v4l2-of.o
> +endif
>  
>  obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
>  obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> new file mode 100644
> index 0000000..f45d64b
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -0,0 +1,190 @@
> +/*
> + * V4L2 OF binding parsing library
> + *
> + * Copyright (C) 2012 Renesas Electronics Corp.
> + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/types.h>
> +
> +#include <media/v4l2-of.h>
> +
> +/*
> + * All properties are optional. If none are found, we don't set any flags. This
> + * means, the port has a static configuration and no properties have to be
> + * specified explicitly.
> + * If any properties are found, that identify the bus as parallel, and
> + * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we recognise the
> + * bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
> + * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
> + * The caller should hold a reference to "node."
> + */

Since this is a library function, how about converting this description
to kernel-doc ?

> +void v4l2_of_parse_link(const struct device_node *node,
> +			struct v4l2_of_link *link)
> +{
> +	const struct device_node *port_node = of_get_parent(node);
> +	int size;
> +	unsigned int v;
> +	u32 data_lanes[ARRAY_SIZE(link->mipi_csi_2.data_lanes)];
> +	bool data_lanes_present;
> +
> +	memset(link, 0, sizeof(*link));
> +
> +	link->local_node = node;
> +
> +	/* Doesn't matter, whether the below two calls succeed */
> +	of_property_read_u32(port_node, "reg", &link->port);
> +	of_property_read_u32(node, "reg", &link->addr);
> +
> +	if (!of_property_read_u32(node, "bus-width", &v))
> +		link->parallel.bus_width = v;
> +
> +	if (!of_property_read_u32(node, "data-shift", &v))
> +		link->parallel.data_shift = v;
> +
> +	if (!of_property_read_u32(node, "hsync-active", &v))
> +		link->mbus_flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
> +			V4L2_MBUS_HSYNC_ACTIVE_LOW;
> +
> +	if (!of_property_read_u32(node, "vsync-active", &v))
> +		link->mbus_flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
> +			V4L2_MBUS_VSYNC_ACTIVE_LOW;
> +
> +	if (!of_property_read_u32(node, "data-active", &v))
> +		link->mbus_flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
> +			V4L2_MBUS_DATA_ACTIVE_LOW;
> +
> +	if (!of_property_read_u32(node, "pclk-sample", &v))
> +		link->mbus_flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
> +			V4L2_MBUS_PCLK_SAMPLE_FALLING;
> +
> +	if (!of_property_read_u32(node, "field-even-active", &v))
> +		link->mbus_flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
> +			V4L2_MBUS_FIELD_EVEN_LOW;
> +
> +	if (of_get_property(node, "slave-mode", &size))
> +		link->mbus_flags |= V4L2_MBUS_SLAVE;
> +
> +	/* If any parallel-bus properties have been found, skip serial ones */
> +	if (link->parallel.bus_width || link->parallel.data_shift ||
> +	    link->mbus_flags) {
> +		/* Default parallel bus-master */
> +		if (!(link->mbus_flags & V4L2_MBUS_SLAVE))
> +			link->mbus_flags |= V4L2_MBUS_MASTER;
> +		return;
> +	}
> +
> +	if (!of_property_read_u32(node, "clock-lanes", &v))
> +		link->mipi_csi_2.clock_lane = v;
> +
> +	if (!of_property_read_u32_array(node, "data-lanes", data_lanes,
> +					ARRAY_SIZE(data_lanes))) {
> +		int i;
> +		for (i = 0; i < ARRAY_SIZE(data_lanes); i++)
> +			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> +		data_lanes_present = true;
> +	} else {
> +		data_lanes_present = false;
> +	}
> +
> +	if (of_get_property(node, "clock-noncontinuous", &size))
> +		link->mbus_flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
> +
> +	if ((link->mipi_csi_2.clock_lane || data_lanes_present) &&
> +	    !(link->mbus_flags & V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK))
> +		/* Default CSI-2: continuous clock */
> +		link->mbus_flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +}
> +EXPORT_SYMBOL(v4l2_of_parse_link);
> +
> +/*
> + * Return a refcounted next "link" DT node. Contrary to the common OF practice,
> + * we do not drop the reference to previous, users have to do it themselves,
> + * when they're done with the node.
> + */
> +struct device_node *v4l2_of_get_next_link(const struct device_node *parent,
> +					struct device_node *previous)

Looks good to me. Only a proper kernel-doc description seems to be missing.
> +{
> +	struct device_node *child, *port;
> +
> +	if (!parent)
> +		return NULL;
> +
> +	if (!previous) {
> +		/*
> +		 * If this is the first call, we have to find a port within this
> +		 * node
> +		 */
> +		for_each_child_of_node(parent, port) {
> +			if (!of_node_cmp(port->name, "port"))
> +				break;
> +		}
> +		if (port) {
> +			/* Found a port, get a link */
> +			child = of_get_next_child(port, NULL);
> +			of_node_put(port);
> +		} else {
> +			child = NULL;
> +		}
> +		if (!child)
> +			pr_err("%s(): Invalid DT: %s has no link children!\n",
> +			       __func__, parent->name);
> +	} else {
> +		port = of_get_parent(previous);
> +		if (!port)
> +			/* Hm, has someone given us the root node?... */
> +			return NULL;
> +
> +		/* Avoid dropping previous refcount to 0 */
> +		of_node_get(previous);
> +		child = of_get_next_child(port, previous);
> +		if (child) {
> +			of_node_put(port);
> +			return child;
> +		}
> +
> +		/* No more links under this port, try the next one */
> +		do {
> +			port = of_get_next_child(parent, port);
> +			if (!port)
> +				return NULL;
> +		} while (of_node_cmp(port->name, "port"));
> +
> +		/* Pick up the first link on this port */
> +		child = of_get_next_child(port, NULL);
> +		of_node_put(port);
> +	}
> +
> +	return child;
> +}
> +EXPORT_SYMBOL(v4l2_of_get_next_link);
> +
> +/* Return a refcounted DT node, owning the link, referenced by "remote" */

Since this returns parent node of of a port on the other end of the link,
how about changing the name to v4l2_of_get_remote_link_parent() ?

Also kernel-doc description would be useful, so one doesn't have to
necessarily dig into the code to see what this function does exactly.

> +struct device_node *v4l2_of_get_remote(const struct device_node *node)
> +{
> +	struct device_node *remote, *tmp;
> +
> +	/* Get remote link DT node */
> +	remote = of_parse_phandle(node, "remote", 0);
> +	if (!remote)
> +		return NULL;
> +
> +	/* remote port */
> +	tmp = of_get_parent(remote);
> +	of_node_put(remote);
> +	if (!tmp)
> +		return NULL;
> +
> +	/* remote DT node */
> +	remote = of_get_parent(tmp);
> +	of_node_put(tmp);
> +
> +	return remote;
> +}
> +EXPORT_SYMBOL(v4l2_of_get_remote);

--

Thanks,
Sylwester
