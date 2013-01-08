Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46583 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3AHIJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 03:09:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
Date: Tue, 08 Jan 2013 09:10:44 +0100
Message-ID: <2418280.Sa45Lqe0AC@avalon>
In-Reply-To: <Pine.LNX.4.64.1301071121280.23972@axis700.grange>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <1356544151-6313-2-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1301071121280.23972@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Monday 07 January 2013 11:23:55 Guennadi Liakhovetski wrote:
> >From 0e1eae338ba898dc25ec60e3dba99e5581edc199 Mon Sep 17 00:00:00 2001
> 
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date: Fri, 19 Oct 2012 23:40:44 +0200
> Subject: [PATCH] media: V4L2: support asynchronous subdevice registration
> 
> Currently bridge device drivers register devices for all subdevices
> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> is attached to a video bridge device, the bridge driver will create an I2C
> device and wait for the respective I2C driver to probe. This makes linking
> of devices straight forward, but this approach cannot be used with
> intrinsically asynchronous and unordered device registration systems like
> the Flattened Device Tree. To support such systems this patch adds an
> asynchronous subdevice registration framework to V4L2. To use it respective
> (e.g. I2C) subdevice drivers must request deferred probing as long as their
> bridge driver hasn't probed. The bridge driver during its probing submits a
> an arbitrary number of subdevice descriptor groups to the framework to
> manage. After that it can add callbacks to each of those groups to be
> called at various stages during subdevice probing, e.g. after completion.
> Then the bridge driver can request single groups to be probed, finish its
> own probing and continue its video subsystem configuration from its
> callbacks.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v4: Fixed v4l2_async_notifier_register() for the case, when subdevices
> probe successfully before the bridge, thanks to Prabhakar for reporting
> 
>  drivers/media/v4l2-core/Makefile     |    3 +-
>  drivers/media/v4l2-core/v4l2-async.c |  284 +++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h           |  113 ++++++++++++++
>  3 files changed, 399 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
>  create mode 100644 include/media/v4l2-async.h

[snip]

> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> new file mode 100644
> index 0000000..91d436d
> --- /dev/null
> +++ b/include/media/v4l2-async.h
> @@ -0,0 +1,113 @@
> +/*
> + * V4L2 asynchronous subdevice registration API
> + *
> + * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef V4L2_ASYNC_H
> +#define V4L2_ASYNC_H
> +
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +
> +#include <media/v4l2-subdev.h>
> +
> +struct device;
> +struct v4l2_device;
> +struct v4l2_async_notifier;
> +
> +enum v4l2_async_bus_type {
> +	V4L2_ASYNC_BUS_SPECIAL,
> +	V4L2_ASYNC_BUS_PLATFORM,
> +	V4L2_ASYNC_BUS_I2C,
> +};
> +
> +struct v4l2_async_hw_device {
> +	enum v4l2_async_bus_type bus_type;
> +	union {
> +		struct {
> +			const char *name;
> +		} platform;
> +		struct {
> +			int adapter_id;
> +			unsigned short address;
> +		} i2c;
> +		struct {
> +			bool (*match)(struct device *,
> +				      struct v4l2_async_hw_device *);
> +			void *priv;
> +		} special;
> +	} match;
> +};
> +
> +/**
> + * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
> + * @hw:		this device descriptor
> + * @list:	member in a list of subdevices
> + */
> +struct v4l2_async_subdev {
> +	struct v4l2_async_hw_device hw;
> +	struct list_head list;
> +};
> +
> +/**
> + * v4l2_async_subdev_list - provided by subdevices
> + * @list:	member in a list of subdevices
> + * @dev:	hardware device
> + * @subdev:	V4L2 subdevice
> + * @asd:	pointer to respective struct v4l2_async_subdev
> + * @notifier:	pointer to managing notifier
> + */
> +struct v4l2_async_subdev_list {
> +	struct list_head list;
> +	struct device *dev;
> +	struct v4l2_subdev *subdev;
> +	struct v4l2_async_subdev *asd;
> +	struct v4l2_async_notifier *notifier;
> +};
> +
> +/**
> + * v4l2_async_notifier - provided by bridges
> + * @subdev_num:	number of subdevices
> + * @subdev:	array of pointers to subdevices
> + * @v4l2_dev:	pointer to sruct v4l2_device
> + * @waiting:	list of subdevices, waiting for their drivers
> + * @done:	list of subdevices, already probed
> + * @list:	member in a global list of notifiers
> + * @bind:	a subdevice driver is about to probe one of your subdevices
> + * @bound:	a subdevice driver has successfully probed one of your
> subdevices + * @complete:	all your subdevices have been probed successfully
> + * @unbind:	a subdevice is leaving
> + */
> +struct v4l2_async_notifier {
> +	int subdev_num;
> +	struct v4l2_async_subdev **subdev;
> +	struct v4l2_device *v4l2_dev;
> +	struct list_head waiting;
> +	struct list_head done;
> +	struct list_head list;
> +	int (*bind)(struct v4l2_async_notifier *notifier,
> +		    struct v4l2_async_subdev_list *asdl);
> +	int (*bound)(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_async_subdev_list *asdl);
> +	int (*complete)(struct v4l2_async_notifier *notifier);
> +	void (*unbind)(struct v4l2_async_notifier *notifier,
> +		       struct v4l2_async_subdev_list *asdl);
> +};
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier);
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
> +/*
> + * If subdevice probing fails any time after v4l2_async_subdev_bind(), no
> + * clean up must be called. This function is only a message of intention.
> + */
> +int v4l2_async_subdev_bind(struct v4l2_async_subdev_list *asdl);
> +int v4l2_async_subdev_bound(struct v4l2_async_subdev_list *asdl);

Could you please explain why you need both a bind notifier and a bound 
notifier ? I was expecting a single v4l2_async_subdev_register() call in 
subdev drivers (and, thinking about it, I would probably name it 
v4l2_subdev_register()).

> +void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list *asdl);
> +#endif
-- 
Regards,

Laurent Pinchart

