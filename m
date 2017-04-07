Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35447 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756000AbdDGJnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 05:43:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/8] v4l: fwnode: Support generic fwnode for parsing standardised properties
Date: Fri, 07 Apr 2017 12:44:27 +0300
Message-ID: <2366571.B7YdK6QUO2@avalon>
In-Reply-To: <1491484330-12040-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com> <1491484330-12040-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 06 Apr 2017 16:12:04 Sakari Ailus wrote:
> The fwnode_handle is a more generic way than OF device_node to describe
> firmware nodes. Instead of the OF API, use more generic fwnode API to
> obtain the same information.

I would mention that this is a copy of v4l2-of.c with the OF API replaced with 
the fwnode API.

> As the V4L2 fwnode support will be required by a small minority of e.g.
> ACPI based systems (the same might actually go for OF), make this a module
> instead of embedding it in the videodev module.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/Kconfig       |   3 +
>  drivers/media/v4l2-core/Makefile      |   1 +
>  drivers/media/v4l2-core/v4l2-fwnode.c | 353 +++++++++++++++++++++++++++++++
>  include/media/v4l2-fwnode.h           | 104 ++++++++++
>  4 files changed, 461 insertions(+)
>  create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
>  create mode 100644 include/media/v4l2-fwnode.h
> 
> diff --git a/drivers/media/v4l2-core/Kconfig
> b/drivers/media/v4l2-core/Kconfig index 6b1b78f..a35c336 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -55,6 +55,9 @@ config V4L2_FLASH_LED_CLASS
> 
>  	  When in doubt, say N.
> 
> +config V4L2_FWNODE
> +	tristate
> +
>  # Used by drivers that need Videobuf modules
>  config VIDEOBUF_GEN
>  	tristate
> diff --git a/drivers/media/v4l2-core/Makefile
> b/drivers/media/v4l2-core/Makefile index 795a535..cf77a63 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -13,6 +13,7 @@ endif
>  ifeq ($(CONFIG_OF),y)
>    videodev-objs += v4l2-of.o
>  endif
> +obj-$(CONFIG_V4L2_FWNODE) += v4l2-fwnode.o
>  ifeq ($(CONFIG_TRACEPOINTS),y)
>    videodev-objs += vb2-trace.o v4l2-trace.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> b/drivers/media/v4l2-core/v4l2-fwnode.c new file mode 100644
> index 0000000..4f69b11
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -0,0 +1,353 @@
> +/*
> + * V4L2 fwnode binding parsing library
> + *
> + * Copyright (c) 2016 Intel Corporation.
> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> + *
> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * Copyright (C) 2012 Renesas Electronics Corp.
> + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/acpi.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/property.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +#include <media/v4l2-fwnode.h>
> +
> +static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwn,
> +					      struct v4l2_fwnode_endpoint 
*vfwn)
> +{
> +	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vfwn->bus.mipi_csi2;
> +	bool have_clk_lane = false;
> +	unsigned int flags = 0, lanes_used = 0;
> +	unsigned int i;
> +	u32 v;
> +	int rval;

I would have used "ret" instead of "rval" ;-)

> +	rval = fwnode_property_read_u32_array(fwn, "data-lanes", NULL, 0);
> +	if (rval > 0) {
> +		u32 array[ARRAY_SIZE(bus->data_lanes)];
> +
> +		bus->num_data_lanes =
> +			min_t(int, ARRAY_SIZE(bus->data_lanes), rval);
> +
> +		fwnode_property_read_u32_array(
> +			fwn, "data-lanes", array, bus->num_data_lanes);

Is there anything wrong with the usual way to wrap code ?

		fwnode_property_read_u32_array(fwn, "data-lanes", array,
					       bus->num_data_lanes);

> +
> +		for (i = 0; i < bus->num_data_lanes; i++) {
> +			if (lanes_used & BIT(array[i]))
> +				pr_warn("duplicated lane %u in data-lanes\n",
> +					array[i]);
> +			lanes_used |= BIT(array[i]);
> +
> +			bus->data_lanes[i] = array[i];
> +		}
> +	}
> +
> +	rval = fwnode_property_read_u32_array(fwn, "lane-polarities", NULL, 
0);
> +	if (rval > 0) {
> +		u32 array[ARRAY_SIZE(bus->lane_polarities)];
> +
> +		if (rval < 1 + bus->num_data_lanes /* clock + data */) {
> +			pr_warn("too few lane-polarities entries (need %u, got 
%u)\n",
> +				1 + bus->num_data_lanes, rval);
> +			return -EINVAL;
> +		}
> +
> +		fwnode_property_read_u32_array(
> +			fwn, "lane-polarities", array, 1 + bus-
>num_data_lanes);

Ditto with

		fwnode_property_read_u32_array(fwn, "lane-polarities", array,
					       1 + bus->num_data_lanes);

> +		for (i = 0; i < 1 + bus->num_data_lanes; i++)
> +			bus->lane_polarities[i] = array[i];
> +	}
> +
> +	if (!fwnode_property_read_u32(fwn, "clock-lanes", &v)) {
> +		if (lanes_used & BIT(v))
> +			pr_warn("duplicated lane %u in clock-lanes\n", v);
> +		lanes_used |= BIT(v);
> +
> +		bus->clock_lane = v;
> +		have_clk_lane = true;
> +	}
> +
> +	if (fwnode_property_present(fwn, "clock-noncontinuous"))
> +		flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
> +	else if (have_clk_lane || bus->num_data_lanes > 0)
> +		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +
> +	bus->flags = flags;
> +	vfwn->bus_type = V4L2_MBUS_CSI2;
> +
> +	return 0;
> +}
> +
> +static void v4l2_fwnode_endpoint_parse_parallel_bus(
> +	struct fwnode_handle *fwn, struct v4l2_fwnode_endpoint *vfwn)
> +{
> +	struct v4l2_fwnode_bus_parallel *bus = &vfwn->bus.parallel;
> +	unsigned int flags = 0;
> +	u32 v;
> +
> +	if (!fwnode_property_read_u32(fwn, "hsync-active", &v))
> +		flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
> +			V4L2_MBUS_HSYNC_ACTIVE_LOW;
> +
> +	if (!fwnode_property_read_u32(fwn, "vsync-active", &v))
> +		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
> +			V4L2_MBUS_VSYNC_ACTIVE_LOW;
> +
> +	if (!fwnode_property_read_u32(fwn, "field-even-active", &v))
> +		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
> +			V4L2_MBUS_FIELD_EVEN_LOW;
> +	if (flags)
> +		vfwn->bus_type = V4L2_MBUS_PARALLEL;
> +	else
> +		vfwn->bus_type = V4L2_MBUS_BT656;
> +
> +	if (!fwnode_property_read_u32(fwn, "pclk-sample", &v))
> +		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
> +			V4L2_MBUS_PCLK_SAMPLE_FALLING;
> +
> +	if (!fwnode_property_read_u32(fwn, "data-active", &v))
> +		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
> +			V4L2_MBUS_DATA_ACTIVE_LOW;
> +
> +	if (fwnode_property_present(fwn, "slave-mode"))
> +		flags |= V4L2_MBUS_SLAVE;
> +	else
> +		flags |= V4L2_MBUS_MASTER;
> +
> +	if (!fwnode_property_read_u32(fwn, "bus-width", &v))
> +		bus->bus_width = v;
> +
> +	if (!fwnode_property_read_u32(fwn, "data-shift", &v))
> +		bus->data_shift = v;
> +
> +	if (!fwnode_property_read_u32(fwn, "sync-on-green-active", &v))
> +		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
> +			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
> +
> +	bus->flags = flags;
> +
> +}
> +
> +/**
> + * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
> + * @fwn: pointer to fwnode_handle

I would say "the endpoint's fwnode handle", or "pointer to the endpoint's 
fwnode handle". Otherwise which fwnode handle should be passed won't be clear.

> + * @vfwn: pointer to the V4L2 fwnode data structure
> + *
> + * All properties are optional. If none are found, we don't set any flags.
> + * This means the port has a static configuration and no properties have
> + * to be specified explicitly.
> + * If any properties that identify the bus as parallel are found and
> + * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we
> recognise
> + * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
> + * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
> + * The caller should hold a reference to @node.

s/@node/@fwn/

By the way, have you tried to compile the documentation ?

> + *
> + * NOTE: This function does not parse properties the size of which is
> + * variable without a low fixed limit. Please use
> + * v4l2_fwnode_endpoint_alloc_parse() in new drivers instead.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwn,
> +			       struct v4l2_fwnode_endpoint *vfwn)

Is there a specific reason not to keep the original parameter name "endpoint" 
? vfwn seems to stand for v4l2_fwnode, not v4l2_fwnode_endpoint. Same comment 
for all other locations in this patch.

> +{
> +	int rval;
> +
> +	fwnode_graph_parse_endpoint(fwn, &vfwn->base);
> +
> +	/* Zero fields from bus_type to until the end */
> +	memset(&vfwn->bus_type, 0, sizeof(*vfwn) -
> +	       offsetof(typeof(*vfwn), bus_type));
> +
> +	rval = v4l2_fwnode_endpoint_parse_csi_bus(fwn, vfwn);
> +	if (rval)
> +		return rval;
> +	/*
> +	 * Parse the parallel video bus properties only if none
> +	 * of the MIPI CSI-2 specific properties were found.
> +	 */
> +	if (vfwn->bus.mipi_csi2.flags == 0)
> +		v4l2_fwnode_endpoint_parse_parallel_bus(fwn, vfwn);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_fwnode_endpoint_parse);

According to Mauro in http://www.mail-archive.com/linux-media@vger.kernel.org/msg110809.html you should use EXPORT_SYMBOL_GPL.

> +
> +/*
> + * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
> + * v4l2_fwnode_endpoint_alloc_parse()
> + * @fwn - the V4L2 fwnode the resources of which are to be released

Mayeb "the V4L2 fwnode whose resources are to be released" ?

> + *
> + * It is safe to call this function with NULL argument or on an

s/on an/on a/

> + * V4L2 fwnode the parsing of which failed.

"whose parsing failed" ?

> + */
> +void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vfwn)
> +{
> +	if (IS_ERR_OR_NULL(vfwn))
> +		return;
> +
> +	kfree(vfwn->link_frequencies);
> +	kfree(vfwn);
> +}
> +EXPORT_SYMBOL(v4l2_fwnode_endpoint_free);
> +
> +/**
> + * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
> + * @node: pointer to fwnode_handle

s/@node/@fwn/

Here too, I would say "the endpoint's fwnode handle", or "pointer to the 
endpoint's fwnode handle".

> + *
> + * All properties are optional. If none are found, we don't set any flags.
> + * This means the port has a static configuration and no properties have
> + * to be specified explicitly.
> + * If any properties that identify the bus as parallel are found and
> + * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we
> recognise
> + * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
> + * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
> + * The caller should hold a reference to @node.

s/@node/@fwn/

> + *
> + * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
> + * v4l2_fwnode_endpoint_parse():
> + *
> + * 1. It also parses variable size data and

Nitpicking, a valid sentence doesn't end with "and$". You could write

1. It also parses variable size data.
2. The memory it has allocated to store the variable size data must
   be freed using v4l2_fwnode_endpoint_free() when no longer needed.

or

1. it also parses variable size data; and
2. the memory it has allocated to store the variable size data must
   be freed using v4l2_fwnode_endpoint_free() when no longer needed.

> + *
> + * 2. The memory it has allocated to store the variable size data must
> + *    be freed using v4l2_fwnode_endpoint_free() when no longer needed.
> + *
> + * Return: Pointer to v4l2_fwnode_endpoint if successful, on error a
> + * negative error code.

The function returns an error pointer on error.

> + */
> +struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
> +	struct fwnode_handle *fwn)
> +{
> +	struct v4l2_fwnode_endpoint *vfwn;
> +	int rval;

ret ? :-)

> +
> +	vfwn = kzalloc(sizeof(*vfwn), GFP_KERNEL);
> +	if (!vfwn)
> +		return ERR_PTR(-ENOMEM);
> +
> +	rval = v4l2_fwnode_endpoint_parse(fwn, vfwn);
> +	if (rval < 0)
> +		goto out_err;
> +
> +	rval = fwnode_property_read_u64_array(fwn, "link-frequencies",
> +					      NULL, 0);
> +

No need for a blank line.

> +	if (rval < 0)
> +		goto out_err;
> +
> +	vfwn->link_frequencies =
> +		kmalloc_array(rval, sizeof(*vfwn->link_frequencies),
> +			      GFP_KERNEL);
> +	if (!vfwn->link_frequencies) {
> +		rval = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	vfwn->nr_of_link_frequencies = rval;
> +
> +	rval = fwnode_property_read_u64_array(
> +		fwn, "link-frequencies", vfwn->link_frequencies,
> +		vfwn->nr_of_link_frequencies);

	rval = fwnode_property_read_u64_array(fwn, "link-frequencies",
					      vfwn->link_frequencies,
					      vfwn->nr_of_link_frequencies);

> +	if (rval < 0)
> +		goto out_err;
> +
> +	return vfwn;
> +
> +out_err:
> +	v4l2_fwnode_endpoint_free(vfwn);
> +	return ERR_PTR(rval);
> +}
> +EXPORT_SYMBOL(v4l2_fwnode_endpoint_alloc_parse);
> +
> +/**
> + * v4l2_fwnode_endpoint_parse_link() - parse a link between two endpoints
> + * @node: pointer to the fwnode at the local end of the link

The parameter is called __fwn. I believe you should rename it to fwn, 
otherwise the documentation will look weird.

As explained before, you should mention that this is an endpoint fwnode 
handle.

> + * @link: pointer to the V4L2 fwnode link data structure
> + *
> + * Fill the link structure with the local and remote nodes and port
> numbers.
> + * The local_node and remote_node fields are set to point to the local and
> + * remote port's parent nodes respectively (the port parent node being the
> + * parent node of the port node if that node isn't a 'ports' node, or the
> + * grand-parent node of the port node otherwise).
> + *
> + * A reference is taken to both the local and remote nodes, the caller
> + * must use v4l2_fwnode_endpoint_put_link() to drop the references
> + * when done with the link.

Just curious, is there a reason to wrap earlier than the 80 columns limit ?

 * A reference is taken to both the local and remote nodes, the caller must 
use 
 * v4l2_fwnode_endpoint_put_link() to drop the references when done with the
 * link.

would work.

> + * Return: 0 on success, or -ENOLINK if the remote fwnode can't be found.

Here too you should mention remote endpoint.

> + */
> +int v4l2_fwnode_parse_link(struct fwnode_handle *__fwn,
> +			   struct v4l2_fwnode_link *link)
> +{
> +	struct fwnode_handle *fwn;
> +	const char *port_prop = is_of_node(__fwn) ? "reg" : "port";
> +
> +	memset(link, 0, sizeof(*link));
> +
> +	fwn = fwnode_get_parent(__fwn);
> +	fwnode_property_read_u32(fwn, port_prop, &link->local_port);
> +	fwn = fwnode_get_next_parent(fwn);
> +	if (is_of_node(fwn)) {
> +		if (of_node_cmp(to_of_node(fwn)->name, "ports") == 0)
> +			fwn = fwnode_get_next_parent(fwn);
> +	} else {
> +		/* The "ports" node is always there in ACPI. */
> +		fwn = fwnode_get_next_parent(fwn);
> +	}

To avoid duplicating the fwnode_get_next_parent(fwn) call, you could write

	if (!is_of_node(fwn) ||
	    of_node_cmp(to_of_node(fwn)->name, "ports") == 0) {
		/* The "ports" node is always there in ACPI. */
		fwn = fwnode_get_next_parent(fwn);
	}

> +	link->local_node = fwn;
> +
> +	fwn = fwnode_graph_get_remote_endpoint(fwn);
> +	if (!fwn) {
> +		fwnode_handle_put(fwn);
> +		return -ENOLINK;
> +	}
> +
> +	fwn = fwnode_get_parent(fwn);
> +	fwnode_property_read_u32(fwn, port_prop, &link->remote_port);
> +	fwn = fwnode_get_next_parent(fwn);
> +	if (is_of_node(fwn)) {
> +		if (of_node_cmp(to_of_node(fwn)->name, "ports") == 0)
> +			fwn = fwnode_get_next_parent(fwn);
> +	} else {
> +		/* The "ports" node is always there in ACPI. */
> +		fwn = fwnode_get_next_parent(fwn);
> +	}

Same comment here.

> +	link->remote_node = fwn;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_fwnode_parse_link);
> +
> +/**
> + * v4l2_fwnode_put_link() - drop references to nodes in a link
> + * @link: pointer to the V4L2 fwnode link data structure
> + *
> + * Drop references to the local and remote nodes in the link. This
> + * function must be called on every link parsed with
> + * v4l2_fwnode_parse_link().
> + */
> +void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
> +{
> +	fwnode_handle_put(link->local_node);
> +	fwnode_handle_put(link->remote_node);
> +}
> +EXPORT_SYMBOL(v4l2_fwnode_put_link);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> +MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> +MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> new file mode 100644
> index 0000000..a675d8a
> --- /dev/null
> +++ b/include/media/v4l2-fwnode.h
> @@ -0,0 +1,104 @@
> +/*
> + * V4L2 fwnode binding parsing library
> + *
> + * Copyright (c) 2016 Intel Corporation.
> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> + *
> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * Copyright (C) 2012 Renesas Electronics Corp.
> + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _V4L2_FWNODE_H
> +#define _V4L2_FWNODE_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/of_graph.h>

Alphabetical order please.

> +#include <media/v4l2-mediabus.h>
> +
> +struct fwnode_handle;
> +
> +/**
> + * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
> + * @flags: media bus (V4L2_MBUS_*) flags
> + * @data_lanes: an array of physical data lane indexes
> + * @clock_lane: physical lane index of the clock lane
> + * @num_data_lanes: number of data lanes
> + * @lane_polarities: polarity of the lanes. The order is the same of
> + *		   the physical lanes.
> + */
> +struct v4l2_fwnode_bus_mipi_csi2 {
> +	unsigned int flags;
> +	unsigned char data_lanes[4];
> +	unsigned char clock_lane;
> +	unsigned short num_data_lanes;
> +	bool lane_polarities[5];
> +};
> +
> +/**
> + * struct v4l2_fwnode_bus_parallel - parallel data bus data structure
> + * @flags: media bus (V4L2_MBUS_*) flags
> + * @bus_width: bus width in bits
> + * @data_shift: data shift in bits
> + */
> +struct v4l2_fwnode_bus_parallel {
> +	unsigned int flags;
> +	unsigned char bus_width;
> +	unsigned char data_shift;
> +};
> +
> +/**
> + * struct v4l2_fwnode_endpoint - the endpoint data structure
> + * @base: fwnode endpoint of the v4l2_fwnode
> + * @bus_type: bus type
> + * @bus: bus configuration data structure
> + * @link_frequencies: array of supported link frequencies
> + * @nr_of_link_frequencies: number of elements in link_frequenccies array
> + */
> +struct v4l2_fwnode_endpoint {
> +	struct fwnode_endpoint base;
> +	/*
> +	 * Fields below this line will be zeroed by
> +	 * v4l2_fwnode_parse_endpoint()
> +	 */
> +	enum v4l2_mbus_type bus_type;
> +	union {
> +		struct v4l2_fwnode_bus_parallel parallel;
> +		struct v4l2_fwnode_bus_mipi_csi2 mipi_csi2;
> +	} bus;
> +	u64 *link_frequencies;
> +	unsigned int nr_of_link_frequencies;
> +};
> +
> +/**
> + * struct v4l2_fwnode_link - a link between two endpoints
> + * @local_node: pointer to device_node of this endpoint
> + * @local_port: identifier of the port this endpoint belongs to
> + * @remote_node: pointer to device_node of the remote endpoint
> + * @remote_port: identifier of the port the remote endpoint belongs to
> + */
> +struct v4l2_fwnode_link {
> +	struct fwnode_handle *local_node;
> +	unsigned int local_port;
> +	struct fwnode_handle *remote_node;
> +	unsigned int remote_port;
> +};
> +
> +int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwn,
> +			       struct v4l2_fwnode_endpoint *vfwn);
> +struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
> +	struct fwnode_handle *fwn);
> +void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vfwn);
> +int v4l2_fwnode_parse_link(struct fwnode_handle *fwn,
> +			   struct v4l2_fwnode_link *link);
> +void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> +
> +#endif /* _V4L2_FWNODE_H */

-- 
Regards,

Laurent Pinchart
