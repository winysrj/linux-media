Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35744 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753246AbdDGKyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 06:54:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/8] v4l: fwnode: Support generic fwnode for parsing standardised properties
Date: Fri, 07 Apr 2017 13:54:58 +0300
Message-ID: <1761689.CzVR5YAybi@avalon>
In-Reply-To: <20170407103633.GD4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com> <2366571.B7YdK6QUO2@avalon> <20170407103633.GD4192@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 07 Apr 2017 13:36:34 Sakari Ailus wrote:
> On Fri, Apr 07, 2017 at 12:44:27PM +0300, Laurent Pinchart wrote:
> > On Thursday 06 Apr 2017 16:12:04 Sakari Ailus wrote:
> > > The fwnode_handle is a more generic way than OF device_node to describe
> > > firmware nodes. Instead of the OF API, use more generic fwnode API to
> > > obtain the same information.
> > 
> > I would mention that this is a copy of v4l2-of.c with the OF API replaced
> > with the fwnode API.
> 
> I'll add that to the description.
> 
> > > As the V4L2 fwnode support will be required by a small minority of e.g.
> > > ACPI based systems (the same might actually go for OF), make this a
> > > module instead of embedding it in the videodev module.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > > 
> > >  drivers/media/v4l2-core/Kconfig       |   3 +
> > >  drivers/media/v4l2-core/Makefile      |   1 +
> > >  drivers/media/v4l2-core/v4l2-fwnode.c | 353 +++++++++++++++++++++++++++
> > >  include/media/v4l2-fwnode.h           | 104 ++++++++++
> > >  4 files changed, 461 insertions(+)
> > >  create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
> > >  create mode 100644 include/media/v4l2-fwnode.h

[snip]

> > > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> > > b/drivers/media/v4l2-core/v4l2-fwnode.c new file mode 100644
> > > index 0000000..4f69b11
> > > --- /dev/null
> > > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > > @@ -0,0 +1,353 @@
> > > +/*
> > > + * V4L2 fwnode binding parsing library
> > > + *
> > > + * Copyright (c) 2016 Intel Corporation.
> > > + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > + *
> > > + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> > > + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > + *
> > > + * Copyright (C) 2012 Renesas Electronics Corp.
> > > + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of version 2 of the GNU General Public License as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +#include <linux/acpi.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > > +#include <linux/property.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/string.h>
> > > +#include <linux/types.h>
> > > +
> > > +#include <media/v4l2-fwnode.h>
> > > +
> > > +static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle
> > > *fwn,
> > > +					      struct v4l2_fwnode_endpoint
> > > *vfwn)
> > > +{
> > > +	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vfwn->bus.mipi_csi2;
> > > +	bool have_clk_lane = false;
> > > +	unsigned int flags = 0, lanes_used = 0;
> > > +	unsigned int i;
> > > +	u32 v;
> > > +	int rval;
> > 
> > I would have used "ret" instead of "rval" ;-)
> 
> I know. But
> 
> 1) there's no established convention in the file and
> 
> 2) "rval" has the benefit is easier to look up; one doesn't find a plethora
> of "return something". Therefore it is better than "ret" for the purpose.

The solution to that is

/ret\>

(and, of course, switching to vim :-D)

[snip]

> > > +/*
> > > + * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
> > > + * v4l2_fwnode_endpoint_alloc_parse()
> > > + * @fwn - the V4L2 fwnode the resources of which are to be released
> > 
> > Mayeb "the V4L2 fwnode whose resources are to be released" ?
> > 
> > > + *
> > > + * It is safe to call this function with NULL argument or on an
> > 
> > s/on an/on a/
> 
> Yes.
> 
> > > + * V4L2 fwnode the parsing of which failed.
> > 
> > "whose parsing failed" ?
> 
> Any particular reason? Do you like "whose"? :-)

"of which" sounds dubious in this context, but please consult a native English 
speaker in case of doubt.

[snip]

> > > +/**
> > > + * v4l2_fwnode_endpoint_parse_link() - parse a link between two
> > > endpoints
> > > + * @node: pointer to the fwnode at the local end of the link
> > 
> > The parameter is called __fwn. I believe you should rename it to fwn,
> > otherwise the documentation will look weird.
> > 
> > As explained before, you should mention that this is an endpoint fwnode
> > handle.
> 
> Agreed.
> 
> > > + * @link: pointer to the V4L2 fwnode link data structure
> > > + *
> > > + * Fill the link structure with the local and remote nodes and port
> > > numbers.
> > > + * The local_node and remote_node fields are set to point to the local
> > > and
> > > + * remote port's parent nodes respectively (the port parent node being
> > > the
> > > + * parent node of the port node if that node isn't a 'ports' node, or
> > > the
> > > + * grand-parent node of the port node otherwise).
> > > + *
> > > + * A reference is taken to both the local and remote nodes, the caller
> > > + * must use v4l2_fwnode_endpoint_put_link() to drop the references
> > > + * when done with the link.
> > 
> > Just curious, is there a reason to wrap earlier than the 80 columns limit
> > ?
> > 
> >  * A reference is taken to both the local and remote nodes, the caller
> >  must use
> >  * v4l2_fwnode_endpoint_put_link() to drop the references when done with
> >  the
> >  * link.
> > 
> > would work.
> 
> It is like a speed limit, you can perfectly legally drive slower than 80
> characters per line, right? :-)

That reminds me of a particular road trip in California that should probably 
not be mentioned here, but whose participants certainly remember :-)

> Albeit the conditions seem pretty good in this file, I can try pushing it
> closer to the limit.
> 
> > > + * Return: 0 on success, or -ENOLINK if the remote fwnode can't be
> > > found.
> > 
> > Here too you should mention remote endpoint.
> 
> Oh yes.
> 
> > > + */

-- 
Regards,

Laurent Pinchart
