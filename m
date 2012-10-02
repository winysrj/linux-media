Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2JBJtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 05:49:49 -0400
Date: Tue, 2 Oct 2012 11:49:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
In-Reply-To: <506A0D28.10505@gmail.com>
Message-ID: <Pine.LNX.4.64.1210021142210.15778@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-6-git-send-email-g.liakhovetski@gmx.de> <506A0D28.10505@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Mon, 1 Oct 2012, Sylwester Nawrocki wrote:

> On 09/27/2012 04:07 PM, Guennadi Liakhovetski wrote:
> > Add a V4L2 OF parser, implementing bindings, documented in
> > Documentation/devicetree/bindings/media/v4l2.txt.
> > 
> > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > ---
> >   drivers/media/v4l2-core/Makefile  |    3 +
> >   drivers/media/v4l2-core/v4l2-of.c |  190 +++++++++++++++++++++++++++++++++++++
> >   include/media/v4l2-of.h           |   62 ++++++++++++
> >   3 files changed, 255 insertions(+), 0 deletions(-)
> >   create mode 100644 drivers/media/v4l2-core/v4l2-of.c
> >   create mode 100644 include/media/v4l2-of.h
> > 
> > diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> > index c2d61d4..00f64d6 100644
> > --- a/drivers/media/v4l2-core/Makefile
> > +++ b/drivers/media/v4l2-core/Makefile
> > @@ -9,6 +9,9 @@ videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> >   ifeq ($(CONFIG_COMPAT),y)
> >     videodev-objs += v4l2-compat-ioctl32.o
> >   endif
> > +ifeq ($(CONFIG_OF),y)
> > +  videodev-objs += v4l2-of.o
> > +endif
> > 
> >   obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
> >   obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
> > diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> > new file mode 100644
> > index 0000000..f45d64b
> > --- /dev/null
> > +++ b/drivers/media/v4l2-core/v4l2-of.c
> > @@ -0,0 +1,190 @@
> > +/*
> > + * V4L2 OF binding parsing library
> > + *
> > + * Copyright (C) 2012 Renesas Electronics Corp.
> > + * Author: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of version 2 of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + */
> > +#include<linux/kernel.h>
> > +#include<linux/module.h>
> > +#include<linux/of.h>
> > +#include<linux/types.h>
> > +
> > +#include<media/v4l2-of.h>
> > +
> > +/*
> > + * All properties are optional. If none are found, we don't set any flags. This
> > + * means, the port has a static configuration and no properties have to be
> > + * specified explicitly.
> > + * If any properties are found, that identify the bus as parallel, and
> > + * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we recognise the
> > + * bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
> > + * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
> > + * The caller should hold a reference to "node."
> > + */
> > +void v4l2_of_parse_link(const struct device_node *node,
> > +			struct v4l2_of_link *link)
> > +{
> > +	const struct device_node *port_node = of_get_parent(node);
> > +	int size;
> > +	unsigned int v;
> > +	u32 data_lanes[ARRAY_SIZE(link->mipi_csi_2.data_lanes)];
> > +	bool data_lanes_present;
> > +
> > +	memset(link, 0, sizeof(*link));
> > +
> > +	link->local_node = node;
> > +
> > +	/* Doesn't matter, whether the below two calls succeed */
> > +	of_property_read_u32(port_node, "reg",&link->port);
> > +	of_property_read_u32(node, "reg",&link->addr);
> > +
> > +	if (!of_property_read_u32(node, "bus-width",&v))
> > +		link->parallel.bus_width = v;
> > +
> > +	if (!of_property_read_u32(node, "data-shift",&v))
> > +		link->parallel.data_shift = v;
> > +
> > +	if (!of_property_read_u32(node, "hsync-active",&v))
> > +		link->mbus_flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
> > +			V4L2_MBUS_HSYNC_ACTIVE_LOW;
> > +
> > +	if (!of_property_read_u32(node, "vsync-active",&v))
> > +		link->mbus_flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
> > +			V4L2_MBUS_VSYNC_ACTIVE_LOW;
> > +
> > +	if (!of_property_read_u32(node, "data-active",&v))
> > +		link->mbus_flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
> > +			V4L2_MBUS_DATA_ACTIVE_LOW;
> > +
> > +	if (!of_property_read_u32(node, "pclk-sample",&v))
> > +		link->mbus_flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
> > +			V4L2_MBUS_PCLK_SAMPLE_FALLING;
> > +
> > +	if (!of_property_read_u32(node, "field-even-active",&v))
> > +		link->mbus_flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
> > +			V4L2_MBUS_FIELD_EVEN_LOW;
> > +
> > +	if (of_get_property(node, "slave-mode",&size))
> > +		link->mbus_flags |= V4L2_MBUS_SLAVE;
> > +
> > +	/* If any parallel-bus properties have been found, skip serial ones */
> > +	if (link->parallel.bus_width || link->parallel.data_shift ||
> > +	    link->mbus_flags) {
> > +		/* Default parallel bus-master */
> > +		if (!(link->mbus_flags&  V4L2_MBUS_SLAVE))
> > +			link->mbus_flags |= V4L2_MBUS_MASTER;
> > +		return;
> > +	}
> > +
> > +	if (!of_property_read_u32(node, "clock-lanes",&v))
> > +		link->mipi_csi_2.clock_lane = v;
> > +
> > +	if (!of_property_read_u32_array(node, "data-lanes", data_lanes,
> > +					ARRAY_SIZE(data_lanes))) {
> > +		int i;
> > +		for (i = 0; i<  ARRAY_SIZE(data_lanes); i++)
> > +			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> 
> It doesn't look like what we aimed for. The data-lanes array is supposed
> to be of variable length, thus I don't think it can be parsed like that. 
> Or am I missing something ? I think we need more something like below 
> (based on of_property_read_u32_array(), not tested):

Ok, you're right, that my version only was suitable for fixed-size arrays, 
which wasn't our goal. But I don't think we should go down to manually 
parsing property data. How about (tested;-))

	data = of_find_property(node, "data-lanes", NULL);
	if (data) {
		int i = 0;
		const __be32 *lane = NULL;
		do {
			lane = of_prop_next_u32(data, lane, &data_lanes[i]);
		} while (lane && i++ < ARRAY_SIZE(data_lanes));
		link->mipi_csi_2.num_data_lanes = i;
		while (i--)
			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
	}

> void v4l2_of_parse_mipi_csi2(const struct device_node *node,
> 				struct mipi_csi2 *mipi_csi2)
> {
> 	struct property *prop = of_find_property(node, "data-lanes", NULL);
> 	u8 *out_data_lanes = mipi_csi_2->data_lanes;
> 	int num_lanes;
> 	const __be32 *val;
> 
> 	if (!prop)
> 		return;
> 
> 	mipi_csi2->num_lanes = 0;
> 
> 	if (WARN (!prop->value, "Empty data-lanes property\n"))
> 		return;
> 
> 	num_lanes = prop->length / sizeof(u32);
> 	if (WARN_ON(num_lanes > ARRAY_SIZE(mipi_csi_2->data_lanes))
> 		num_lanes = ARRAY_SIZE(mipi_csi_2->data_lanes);
> 
> 	val = prop->value;
> 	while (num_lanes--)
> 		*out_data_lanes++ = be32_to_cpup(val++);
> 
> 	mipi_csi2->num_lanes = num_lanes;
> }
> 
> 	v4l2_of_parse_mipi_csi2(node, &link->mipi_csi2);

[snip]

> > +struct v4l2_of_link {
> > +	unsigned int port;
> > +	unsigned int addr;
> > +	struct list_head head;
> > +	const struct device_node *local_node;
> > +	const __be32 *remote;
> > +	unsigned int mbus_flags;
> > +	union {
> > +		struct {
> > +			unsigned char bus_width;
> > +			unsigned char data_shift;
> > +		} parallel;
> > +		struct {
> > +			unsigned char data_lanes[4];
> 
> Some devices are interested only in absolute number of lanes.
> I can't see how we could specify the number of data lanes here.
> Shouldn't something like 'unsigned char num_data_lanes;' be
> added to this structure ?

Yes, good point. As you see above, I've added it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
