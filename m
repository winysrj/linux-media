Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41904 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3CKXqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 19:46:47 -0400
Received: by mail-ea0-f174.google.com with SMTP id q10so1499183eaj.33
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 16:46:46 -0700 (PDT)
Message-ID: <513E6CE3.70207@gmail.com>
Date: Tue, 12 Mar 2013 00:46:43 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	devicetree-discuss@lists.ozlabs.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v7] [media] Add a V4L2 OF parser
References: <1362757563-30825-1-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1303111442420.21241@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303111442420.21241@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 03/11/2013 04:03 PM, Guennadi Liakhovetski wrote:
> Hi Sylwester
>
> Thanks for continuing this work! You have made a great progress compared
> to my initial version, and I should really have looked at each your
> submitted new revision, unfortunately, I haven't managed that. So, sorry
> for chiming back in so late in the game, but maybe we still manage to get
> it in on time for 3.10. Let me know if you'd like me to do the next couple
> of rounds :) Or if you disagree with my comments and prefer your present
> state.

I'm glad to hear you can focus on this again. Please feel free to spin
next improved version of this. :-)

And let me hold on predicting in which kernel version this patch has
a chance to be merged upstream ;) In fact, I couldn't spent as much time
on this as I would like to..

When we are more or less done with the parser I would like to carry on
with the asynchronous subdev registration support. I have a bit different
idea on how it could be implemented, comparing to your latest proposal.
But don't yet have any POC. My feelings are we should integrate it more
with existing V4L2 data structures, and have the clocks associated with
struct device, rather than subdev driver. But then come issues at the
common clock framework, like not implemented clk_unregister() or no
clk_get/clk_put per a clock provider driver.

> On Fri, 8 Mar 2013, Sylwester Nawrocki wrote:
>
>> From: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>>
>> Add a V4L2 OF parser, implementing bindings documented in
>> Documentation/devicetree/bindings/media/video-interfaces.txt.
>>
>> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>> [s.nawrocki@samsung.com: various corrections and improvements
>> since the initial version]
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> ---
>> The last version of the bindings documentation patch can be found
>> at: https://patchwork.kernel.org/patch/2074951
>>
>> Changes since v6:
>>   - minor v4l2_of_get_remote_port_parent() function cleanup.
>>
>> Changes since v5:
>>   - renamed v4l2_of_parse_mipi_csi2 ->  v4l2_of_parse_csi_bus,
>>   - corrected v4l2_of_get_remote_port_parent() function declaration
>>     for !CONFIG_OF,
>>   - reworked v4l2_of_get_next_endpoint() function to consider the
>>     'port' nodes can be grouped under optional 'ports' node,
>>   - added kerneldoc description for v4l2_of_get_next_endpoint()
>>     function.
>>
>> Changes since v4:
>>   - reworked v4l2_of_get_remote_port() function to consider cases
>>     where 'port' nodes are grouped in a parent 'ports' node,
>>   - rearranged struct v4l2_of_endpoint and related changes added
>>     in the parser code,
>>   - added kerneldoc description for struct v4l2_of_endpoint,
>>   - s/link/endpoint in the comments,
>> ---
>>   drivers/media/v4l2-core/Makefile  |    3 +
>>   drivers/media/v4l2-core/v4l2-of.c |  261 +++++++++++++++++++++++++++++++++++++
>>   include/media/v4l2-of.h           |   98 ++++++++++++++
>>   3 files changed, 362 insertions(+)
>>   create mode 100644 drivers/media/v4l2-core/v4l2-of.c
>>   create mode 100644 include/media/v4l2-of.h
>>
>> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
>> index c2d61d4..00f64d6 100644
>> --- a/drivers/media/v4l2-core/Makefile
>> +++ b/drivers/media/v4l2-core/Makefile
>> @@ -9,6 +9,9 @@ videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>>   ifeq ($(CONFIG_COMPAT),y)
>>     videodev-objs += v4l2-compat-ioctl32.o
>>   endif
>> +ifeq ($(CONFIG_OF),y)
>> +  videodev-objs += v4l2-of.o
>> +endif
>>
>>   obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
>>   obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
>> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
>> new file mode 100644
>> index 0000000..cbd18f6
>> --- /dev/null
>> +++ b/drivers/media/v4l2-core/v4l2-of.c
>> @@ -0,0 +1,261 @@
>> +/*
>> + * V4L2 OF binding parsing library
>> + *
>> + * Copyright (C) 2012 Renesas Electronics Corp.
>> + * Author: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>> + *
>> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
>> + * Sylwester Nawrocki<s.nawrocki@samsung.com>
>
> You probably want to put your copyright at the top as the newer one, isn't
> it the usual order - newest first?

Yes, I guess you're right.

>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + */
>> +#include<linux/kernel.h>
>> +#include<linux/module.h>
>> +#include<linux/of.h>
>> +#include<linux/string.h>
>> +#include<linux/types.h>
>> +
>> +#include<media/v4l2-of.h>
>> +
>> +/**
>> + * v4l2_of_parse_csi_bus() - parse MIPI CSI-2 bus properties
>> + * @node: pointer to endpoint device_node
>> + * @endpoint: pointer to v4l2_of_endpoint data structure
>> + *
>> + * Return: 0 on success or negative error value otherwise.
>> + */
>> +int v4l2_of_parse_csi_bus(const struct device_node *node,
>> +			  struct v4l2_of_endpoint *endpoint)
>> +{
>> +	struct v4l2_mbus_mipi_csi2 *mipi_csi2 =&endpoint->mbus.mipi_csi2;
>> +	u32 data_lanes[ARRAY_SIZE(mipi_csi2->data_lanes)];
>> +	struct property *prop;
>> +	const __be32 *lane = NULL;
>> +	u32 v;
>> +	int i = 0;
>> +
>> +	prop = of_find_property(node, "data-lanes", NULL);
>> +	if (!prop)
>> +		return -EINVAL;
>
> Oh... Well, first - this isn't an error to not specify "data-lanes." Below
> you also try to continue configuring the CSI-2 properties in this "error"
> case, but since you return here, you skip parsing all clock-related
> properties...

Yes, that's indeed a bug I've overlooked, we should not return an error
here and instead read the array when "data-lanes" is available.
IIRC I have even noticed something is wrong here but have forgotten to
correct it afterwards.

>> +	do {
>> +		lane = of_prop_next_u32(prop, lane,&data_lanes[i]);
>> +	} while (lane&&  i++<  ARRAY_SIZE(data_lanes));
>
> you could do this as a "for" loop, but then you'd have an additional
> if-break check inside, so, maybe your do-while is a prettier solution
> here.

Whichever looks more readable is fine by me. The "for" version might
be indeed a better option.

	for (i = 0; i < ARRAY_SIZE(data_lanes); i++) {
		lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
		if (!lane)
			break;
	}

>> +	mipi_csi2->num_data_lanes = i;
>> +	while (i--)
>> +		mipi_csi2->data_lanes[i] = data_lanes[i];
>> +
>> +	if (!of_property_read_u32(node, "clock-lanes",&v))
>> +		mipi_csi2->clock_lane = v;
>> +
>> +	if (of_get_property(node, "clock-noncontinuous",&v))
>> +		endpoint->mbus.flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(v4l2_of_parse_csi_bus);
>> +
>> +/**
>> + * v4l2_of_parse_parallel_bus() - parse parallel bus properties
>> + * @node: pointer to endpoint device_node
>> + * @endpoint: pointer to v4l2_of_endpoint data structure
>> + */
>> +void v4l2_of_parse_parallel_bus(const struct device_node *node,
>> +				struct v4l2_of_endpoint *endpoint)
>> +{
>> +	unsigned int flags = 0;
>> +	u32 v;
>> +
>> +	if (WARN_ON(!endpoint))
>> +		return;
>> +
>> +	if (!of_property_read_u32(node, "hsync-active",&v))
>> +		flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
>> +			V4L2_MBUS_HSYNC_ACTIVE_LOW;
>> +
>> +	if (!of_property_read_u32(node, "vsync-active",&v))
>> +		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
>> +			V4L2_MBUS_VSYNC_ACTIVE_LOW;
>> +
>> +	if (!of_property_read_u32(node, "pclk-sample",&v))
>> +		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
>> +			V4L2_MBUS_PCLK_SAMPLE_FALLING;
>> +
>> +	if (!of_property_read_u32(node, "field-even-active",&v))
>> +		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
>> +			V4L2_MBUS_FIELD_EVEN_LOW;
>> +	if (flags)
>> +		endpoint->mbus.type = V4L2_MBUS_PARALLEL;
>> +	else
>> +		endpoint->mbus.type = V4L2_MBUS_BT656;
>> +
>> +	if (!of_property_read_u32(node, "data-active",&v))
>> +		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
>> +			V4L2_MBUS_DATA_ACTIVE_LOW;
>> +
>> +	if (of_get_property(node, "slave-mode",&v))
>> +		flags |= V4L2_MBUS_SLAVE;
>> +
>> +	if (!of_property_read_u32(node, "bus-width",&v))
>> +		endpoint->mbus.parallel.bus_width = v;
>> +
>> +	if (!of_property_read_u32(node, "data-shift",&v))
>> +		endpoint->mbus.parallel.data_shift = v;
>> +
>> +	endpoint->mbus.flags = flags;
>> +}
>> +EXPORT_SYMBOL(v4l2_of_parse_parallel_bus);
>> +
>> +/**
>> + * v4l2_of_parse_endpoint() - parse all endpoint node properties
>> + * @node: pointer to endpoint device_node
>> + * @endpoint: pointer to v4l2_of_endpoint data structure
>> + *
>> + * All properties are optional. If none are found, we don't set any flags.
>> + * This means the port has a static configuration and no properties have
>> + * to be specified explicitly.
>> + * If any properties that identify the bus as parallel are found and
>> + * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we recognise
>> + * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
>> + * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
>> + * The caller should hold a reference to @node.
>> + */
>> +void v4l2_of_parse_endpoint(const struct device_node *node,
>> +			    struct v4l2_of_endpoint *endpoint)
>> +{
>> +	const struct device_node *port_node = of_get_parent(node);
>> +	struct v4l2_of_mbus *mbus =&endpoint->mbus;
>> +	bool data_lanes_present = false;
>> +
>> +	memset(endpoint, 0, sizeof(*endpoint));
>> +
>> +	endpoint->local_node = node;
>> +	/*
>> +	 * It doesn't matter whether the two calls below succeed. If they
>> +	 * don't then the default value 0 is used.
>> +	 */
>> +	of_property_read_u32(port_node, "reg",&endpoint->port);
>> +	of_property_read_u32(node, "reg",&endpoint->id);
>> +
>> +	v4l2_of_parse_parallel_bus(node, endpoint);
>
> I don't really know why you export both these helper functions to parse
> only parallel or CSI-2 bus properties, but if you do - doesn't the code
> below belong to parsing the parallel bus too?

Yes, I think this comes from when I wasn't really aware what the SLAVE
and MASTER flags are exactly for. My bad, it indeed belongs to the function
above.

As to why I want to have separate functions for parsing the serial and the
parallel bus properties - there are cases when you know which bus a driver
is interested in. And parsing several properties of a parallel bus in
a MIPI CSI-2 receiver driver is something I would prefer to avoid. Even
though it's "only" about 10 properties.

>> +
>> +	/* If any parallel bus properties have been found, skip serial ones. */
>> +	if (mbus->parallel.bus_width || mbus->parallel.data_shift ||
>> +	    mbus->flags) {
>> +		/* Default parallel bus-master. */
>> +		if (!(mbus->flags&  V4L2_MBUS_SLAVE))
>> +			mbus->flags |= V4L2_MBUS_MASTER;
>> +		return;
>> +	}
>> +
>> +	mbus->type = V4L2_MBUS_CSI2;
>
> For symmetry you can move the above assignment inside the CSI2 parser
> function.

Agreed.

>> +	if (!v4l2_of_parse_csi_bus(node, endpoint))
>
> ditto - don't you want to move setting the continuous clock flag inside
> the function?
>
>> +		data_lanes_present = true;
>
> Was this a conscious change in behaviour respective the original version?
> Your v4l2_of_parse_csi_bus() also returns 0 if no data-lane related
> properties have been detected, which is different from the original
> implementation and makes the name of the variable wrong.

Indeed, there is a bug when "data-lanes" is an empty property. Uh, why
nobody else has noticed it before ?.. :)

>> +	if ((mbus->mipi_csi2.clock_lane || data_lanes_present)&&
>> +	    !(mbus->flags&  V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK)) {
>
> superfluous braces

I don't like superfluous braces too, but in this case it really looked more
readable to me.

>> +		/* Default CSI-2: continuous clock. */
>> +		mbus->flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
>> +	}
>> +}
>> +EXPORT_SYMBOL(v4l2_of_parse_endpoint);
>> +
>> +/**
>> + * v4l2_of_get_next_endpoint() - get next endpoint node
>> + * @parent: pointer to the parent's device node
>> + * @prev: previous endpoint node, or NULL to get first
>> + *
>> + * Return: An 'endpoint' node pointer with refcount incremented. Refcount
>> + * of the passed @prev node is not decremented, the caller have to use
>> + * of_node_put() on it when done.
>> + */
>> +struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
>> +					struct device_node *prev)
>> +{
>> +	struct device_node *endpoint, *port = NULL;
>> +
>> +	if (!parent)
>> +		return NULL;
>> +
>> +	if (!prev) {
>> +		/*
>> +		 * It's the first call, we have to find a port subnode
>> +		 * within this node or within an optional 'ports' node.
>> +		 */
>> +		while ((port = of_get_next_child(parent, port))) {
>
> Hm, I think such assignment-within-condition is discouraged.

True, anyway nobody complained about it so far ;) I didn't get too many
reviews of it either though..

>> +			if (!of_node_cmp(port->name, "port"))
>> +				break;
>> +			if (!of_node_cmp(port->name, "ports")) {
>> +				parent = port;
>> +				of_node_put(port);
>> +				port = NULL;
>
> Can we do this a bit differently: you shouldn't have both - a "ports"
> subnode and single "port" subnodes within this node, right? So, why don't
> we first check for a "ports" subnode. If we find one - use it as a parent
> for our scan, if we don't - use the parent from the function argument. If
> we do find "ports" we can also optionally sanity-check for direct "port"
> subnodes too.

Not sure if such a sanity check is needed. Nevertheless a warning about 
such
a broken device tree structure might be useful.

> Then, after this initial parent discovery, we can use the normal
> for_each_child_of_node() loop - as in the original version.

Yeah, that sounds much more clean. I wasn't trying hard enough to make it
using for_each_child_of_node() then. :)

>> +		};
>> +		if (port) {
>> +			/* Found a port, get an endpoint. */
>> +			endpoint = of_get_next_child(port, NULL);
>> +			of_node_put(port);
>> +		} else {
>> +			endpoint = NULL;
>> +		}
>> +		if (!endpoint)
>> +			pr_err("%s(): no endpoint nodes specified for %s\n",
>> +			       __func__, parent->full_name);
>> +	} else {
>> +		port = of_get_parent(prev);
>> +		if (!port)
>> +			/* Hm, has someone given us the root node ?... */
>> +			return NULL;
>> +
>> +		/* Avoid dropping prev node refcount to 0. */
>> +		of_node_get(prev);
>> +		endpoint = of_get_next_child(port, prev);
>> +		if (endpoint) {
>> +			of_node_put(port);
>> +			return endpoint;
>> +		}
>> +
>> +		/* No more endpoints under this port, try the next one. */
>> +		do {
>> +			port = of_get_next_child(parent, port);
>> +			if (!port)
>> +				return NULL;
>> +		} while (of_node_cmp(port->name, "port"));
>> +
>> +		/* Pick up the first endpoint in this port. */
>> +		endpoint = of_get_next_child(port, NULL);
>> +		of_node_put(port);
>> +	}
>> +
>> +	return endpoint;
>> +}
>> +EXPORT_SYMBOL(v4l2_of_get_next_endpoint);
>> +
>> +/**
>> + * v4l2_of_get_remote_port_parent() - get remote port's parent node
>> + * @node: pointer to a local endpoint device_node
>> + *
>> + * Return: Remote device node associated with remote endpoint node linked
>> + *	   to @node. Use of_node_put() on it when done.
>> + */
>> +struct device_node *v4l2_of_get_remote_port_parent(
>> +			       const struct device_node *node)
>> +{
>> +	struct device_node *np;
>> +	unsigned int depth = 3;
>> +
>> +	/* Get remote endpoint node. */
>> +	np = of_parse_phandle(node, "remote-endpoint", 0);
>> +
>> +	/* Walk 3 levels up only if there is 'ports' node. */
>> +	while (np&&  --depth>= 0) {
>
> unsigned int depth>= 0 is always true. Why not
>
> 	for (depth = 3; depth&&  np; depth--)
>
> or similar?

Gah, a similar mistake again :( Definitely this needs a correction.

>> +		np = of_get_next_parent(np);
>> +		if (depth == 1&&  of_node_cmp(np->name, "ports"))
>> +			break;
>> +	}
>> +	return np;
>> +}
>> +EXPORT_SYMBOL(v4l2_of_get_remote_port_parent);
>> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
>> new file mode 100644
>> index 0000000..458e97b
>> --- /dev/null
>> +++ b/include/media/v4l2-of.h
>> @@ -0,0 +1,98 @@
>> +/*
>> + * V4L2 OF binding parsing library
>> + *
>> + * Copyright (C) 2012 Renesas Electronics Corp.
>> + * Author: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>> + *
>> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
>> + * Sylwester Nawrocki<s.nawrocki@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + */
>> +#ifndef _V4L2_OF_H
>> +#define _V4L2_OF_H
>> +
>> +#include<linux/list.h>
>> +#include<linux/types.h>
>> +#include<linux/errno.h>
>> +
>> +#include<media/v4l2-mediabus.h>
>> +
>> +struct device_node;
>> +
>> +struct v4l2_mbus_mipi_csi2 {
>> +	unsigned char data_lanes[4];
>> +	unsigned char clock_lane;
>> +	unsigned short num_data_lanes;
>> +};
>> +
>> +struct v4l2_mbus_parallel {
>> +	unsigned char bus_width;
>> +	unsigned char data_shift;
>> +};
>
> You really need the above two structs? Even if you do - I wouldn't call
> them "v4l2_mbus_*" - that's a different namespace.

Now that I look at them again they are not that useful and are used in
the parser code only. Probably it would be OK to move these definitions
inside the union below and to make them anonymous structs.

>> +/**
>> + * struct v4l2_of_endpoint - the endpoint data structure
>> + * @port: identifier (value of reg property) of a port this endpoint belongs to
>> + * @id: identifier (value of reg property) of this endpoint
>> + * @head: list head for this structure
>> + * @local_node: pointer to device_node of this endpoint
>> + * @remote: phandle to remote endpoint node
>> + * @type: media bus type
>> + * @flags: media bus (V4L2_MBUS_*) flags
>> + * @mipi_csi2: MIPI CSI-2 bus configuration data structure
>> + * @parallel: parallel bus configuration data structure
>> + */
>> +struct v4l2_of_endpoint {
>> +	unsigned int port;
>> +	unsigned int id;
>> +	struct list_head head;
>> +	const struct device_node *local_node;
>> +	const __be32 *remote;
>> +	struct v4l2_of_mbus {

This should probably just be "v4l2_of_bus"

>> +		enum v4l2_mbus_type type;
>> +		unsigned int flags;
>> +		union {
>> +			struct v4l2_mbus_mipi_csi2 mipi_csi2;
>> +			struct v4l2_mbus_parallel parallel;
>> +		};
>> +	} mbus;

...and "bus".

>> +};
>> +
>> +#ifdef CONFIG_OF
>> +int v4l2_of_parse_csi_bus(const struct device_node *node,
>> +				struct v4l2_of_endpoint *endpoint);
>> +void v4l2_of_parse_parallel_bus(const struct device_node *node,
>> +				struct v4l2_of_endpoint *endpoint);
>
> You really need to export these two functions? Then you'd also have to
> provide non-OF stubs for them?

Yes. I'm not entirely convinced we need stubs for all functions,
probably we do.

--

Regards,
Sylwester
