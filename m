Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935913Ab3DHNzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 09:55:38 -0400
Date: Mon, 8 Apr 2013 15:55:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v7 2/7] media: V4L2: support asynchronous subdevice
 registration
In-Reply-To: <5162C934.90808@samsung.com>
Message-ID: <Pine.LNX.4.64.1304081548360.29945@axis700.grange>
References: <1365419231-14830-1-git-send-email-g.liakhovetski@gmx.de>
 <1365419231-14830-3-git-send-email-g.liakhovetski@gmx.de> <5162C934.90808@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Mon, 8 Apr 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 04/08/2013 01:07 PM, Guennadi Liakhovetski wrote:
> > Currently bridge device drivers register devices for all subdevices
> > synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> > is attached to a video bridge device, the bridge driver will create an I2C
> > device and wait for the respective I2C driver to probe. This makes linking
> > of devices straight forward, but this approach cannot be used with
> > intrinsically asynchronous and unordered device registration systems like
> > the Flattened Device Tree. To support such systems this patch adds an
> > asynchronous subdevice registration framework to V4L2. To use it respective
> > (e.g. I2C) subdevice drivers must register themselves with the framework.
> > A bridge driver on the other hand must register notification callbacks,
> > that will be called upon various related events.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > v7:
> > 1. Removed bogus device reprobing from v4l2_async_unregister_subdev()
> > 2. Renamed V4L2_ASYNC_BUS_SPECIAL to V4L2_ASYNC_BUS_CUSTOM
> 
> This change seems to be missing.

Indeed :-(

> > 3. Renamed v4l2_async_subdev_(un)register() to v4l2_async_(un)register_subdev()

[snip]

> > +static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
> > +						    struct v4l2_async_subdev_list *asdl)
> > +{
> > +	struct v4l2_async_subdev *asd = NULL;
> > +	bool (*match)(struct device *,
> > +		      struct v4l2_async_hw_device *);
> > +
> > +	list_for_each_entry (asd, &notifier->waiting, list) {
> > +		struct v4l2_async_hw_device *hw = &asd->hw;
> > +		switch (hw->bus_type) {
> > +		case V4L2_ASYNC_BUS_SPECIAL:
> > +			match = hw->match.special.match;
> > +			if (!match)
> > +				/* Match always */
> > +				return asd;
> > +			break;
> > +		case V4L2_ASYNC_BUS_PLATFORM:
> > +			match = match_platform;
> > +			break;
> > +		case V4L2_ASYNC_BUS_I2C:
> > +			match = match_i2c;
> > +			break;
> > +		default:
> > +			/* Oops */
> > +			match = NULL;
> > +			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
> > +				"Invalid bus-type %u on %p\n", hw->bus_type, asd);
> > +		}
> > +
> > +		if (match && match(asdl->dev, hw))
> > +			break;
> 
> Since we maintain various lists of sub-devices, couldn't we match them e.g. by
> name instead ? What would be preventing this ?

Do you have a specific case where your proposal would work, whereas mine 
wouldn't? This can be changed at any time, we can leave it until there's a 
real use-case, for which this implementation wouldn't work.

> And additionally provide an API to override the matching method?

Override - that's what the "SPECIAL" (CUSTOM) is for.

> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > new file mode 100644
> > index 0000000..c0470c6
> > --- /dev/null
> > +++ b/include/media/v4l2-async.h
> > @@ -0,0 +1,105 @@
> > +/*
> > + * V4L2 asynchronous subdevice registration API
> > + *
> > + * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> s/2012/2013 ?
> 
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef V4L2_ASYNC_H
> > +#define V4L2_ASYNC_H
> > +
> > +#include <linux/list.h>
> > +#include <linux/mutex.h>
> > +#include <linux/notifier.h>
> 
> Is there anything used from this header ?

Don't think so, I'll remove it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
