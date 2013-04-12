Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42444 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3DLMJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 08:09:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 2/7] media: V4L2: support asynchronous subdevice registration
Date: Fri, 12 Apr 2013 14:09:41 +0200
Message-ID: <1618829.uxRCXGb1BB@avalon>
In-Reply-To: <1365433538-15975-3-git-send-email-g.liakhovetski@gmx.de>
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de> <1365433538-15975-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Monday 08 April 2013 17:05:33 Guennadi Liakhovetski wrote:
> Currently bridge device drivers register devices for all subdevices
> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> is attached to a video bridge device, the bridge driver will create an I2C
> device and wait for the respective I2C driver to probe. This makes linking
> of devices straight forward, but this approach cannot be used with
> intrinsically asynchronous and unordered device registration systems like
> the Flattened Device Tree. To support such systems this patch adds an
> asynchronous subdevice registration framework to V4L2. To use it respective
> (e.g. I2C) subdevice drivers must register themselves with the framework.
> A bridge driver on the other hand must register notification callbacks,
> that will be called upon various related events.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v8: Really renamed V4L2_ASYNC_BUS_SPECIAL to V4L2_ASYNC_BUS_CUSTOM

Each iteration gets better :-)

>  drivers/media/v4l2-core/Makefile     |    3 +-
>  drivers/media/v4l2-core/v4l2-async.c |  262 +++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h           |  104 ++++++++++++++
>  3 files changed, 368 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
>  create mode 100644 include/media/v4l2-async.h

[snip]

> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c new file mode 100644
> index 0000000..4cc56ad
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -0,0 +1,262 @@
> +/*
> + * V4L2 asynchronous subdevice registration API
> + *
> + * Copyright (C) 2012-2013, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +static bool match_i2c(struct device *dev, struct v4l2_async_hw_device
> *hw_dev)
> +{
> +	struct i2c_client *client = i2c_verify_client(dev);
> +	return client &&
> +		hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
> +		hw_dev->match.i2c.adapter_id == client->adapter->nr &&
> +		hw_dev->match.i2c.address == client->addr;
> +}
> +
> +static bool match_platform(struct device *dev, struct v4l2_async_hw_device
> *hw_dev)
> +{
> +	return hw_dev->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
> +		!strcmp(hw_dev->match.platform.name, dev_name(dev));
> +}
> +
> +static LIST_HEAD(subdev_list);
> +static LIST_HEAD(notifier_list);
> +static DEFINE_MUTEX(list_lock);
> +
> +static struct v4l2_async_subdev *v4l2_async_belongs(struct
> v4l2_async_notifier *notifier,
> +						    struct v4l2_async_subdev_list *asdl)
> +{
> +	struct v4l2_async_subdev *asd = NULL;
> +	bool (*match)(struct device *,
> +		      struct v4l2_async_hw_device *);
> +
> +	list_for_each_entry (asd, &notifier->waiting, list) {
> +		struct v4l2_async_hw_device *hw = &asd->hw;
> +		switch (hw->bus_type) {
> +		case V4L2_ASYNC_BUS_CUSTOM:
> +			match = hw->match.special.match;
> +			if (!match)
> +				/* Match always */
> +				return asd;
> +			break;
> +		case V4L2_ASYNC_BUS_PLATFORM:
> +			match = match_platform;
> +			break;
> +		case V4L2_ASYNC_BUS_I2C:
> +			match = match_i2c;
> +			break;
> +		default:
> +			/* Oops */
> +			match = NULL;
> +			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
> +				"Invalid bus-type %u on %p\n", hw->bus_type, asd);

An invalid hw->bus_type value is a driver (or board code) bug. Could you move 
this check to v4l2_async_notifier_register() when building the subdev list and 
return an error ?

> +		}
> +
> +		if (match && match(asdl->dev, hw))
> +			break;
> +	}
> +
> +	return asd;
> +}
> +
> +static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> +				  struct v4l2_async_subdev_list *asdl,
> +				  struct v4l2_async_subdev *asd)
> +{
> +	int ret;
> +
> +	/* Remove from the waiting list */
> +	list_del(&asd->list);
> +	asdl->asd = asd;
> +	asdl->notifier = notifier;
> +
> +	if (notifier->bound) {
> +		ret = notifier->bound(notifier, asdl);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	/* Move from the global subdevice list to notifier's done */
> +	list_move(&asdl->list, &notifier->done);
> +
> +	ret = v4l2_device_register_subdev(notifier->v4l2_dev,
> +					  asdl->subdev);
> +	if (ret < 0) {
> +		if (notifier->unbind)
> +			notifier->unbind(notifier, asdl);
> +		return ret;
> +	}
> +
> +	if (list_empty(&notifier->waiting) && notifier->complete)
> +		return notifier->complete(notifier);
> +
> +	return 0;
> +}
> +
> +static void v4l2_async_cleanup(struct v4l2_async_subdev_list *asdl)
> +{
> +	v4l2_device_unregister_subdev(asdl->subdev);
> +	/* Subdevice driver will reprobe and put asdl back onto the list */
> +	list_del_init(&asdl->list);
> +	asdl->asd = NULL;
> +	asdl->dev = NULL;
> +}
> +
> +static struct device *v4l2_async_unregister(struct v4l2_async_subdev_list
> *asdl)
> +{
> +	struct device *dev = asdl->dev;
> +
> +	v4l2_async_cleanup(asdl);
> +
> +	/* If we handled USB devices, we'd have to lock the parent too */
> +	device_release_driver(dev);
> +	return dev;

This function is called from a single location and the return value is unused, 
it could just return void.

> +}
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_async_subdev_list *asdl, *tmp;
> +	int i;

Could this be unsigned (please see below for a similar comment about notifier-
>subdev_num as well) ?

> +	notifier->v4l2_dev = v4l2_dev;
> +	INIT_LIST_HEAD(&notifier->waiting);
> +	INIT_LIST_HEAD(&notifier->done);
> +
> +	for (i = 0; i < notifier->subdev_num; i++)
> +		list_add_tail(&notifier->subdev[i]->list, &notifier->waiting);
> +
> +	mutex_lock(&list_lock);
> +
> +	/* Keep also completed notifiers on the list */
> +	list_add(&notifier->list, &notifier_list);
> +
> +	list_for_each_entry_safe(asdl, tmp, &subdev_list, list) {
> +		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, asdl);
> +		int ret;
> +
> +		if (!asd)
> +			continue;
> +
> +		ret = v4l2_async_test_notify(notifier, asdl, asd);
> +		if (ret < 0) {
> +			mutex_unlock(&list_lock);
> +			return ret;
> +		}
> +	}
> +
> +	mutex_unlock(&list_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_async_notifier_register);
> +
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_async_subdev_list *asdl, *tmp;
> +	int i = 0;

i can't be negative, could it then be unsiged ?

> +	struct device **dev = kcalloc(notifier->subdev_num,
> +				      sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		dev_err(notifier->v4l2_dev->dev,
> +			"Failed to allocate device cache!\n");
> +
> +	mutex_lock(&list_lock);
> +
> +	list_del(&notifier->list);
> +
> +	list_for_each_entry_safe(asdl, tmp, &notifier->done, list) {
> +		if (dev)
> +			dev[i++] = get_device(asdl->dev);
> +		v4l2_async_unregister(asdl);
> +
> +		if (notifier->unbind)
> +			notifier->unbind(notifier, asdl);
> +	}
> +
> +	mutex_unlock(&list_lock);
> +
> +	if (dev) {
> +		while (i--) {
> +			if (dev[i] && device_attach(dev[i]) < 0)

I'm still pretty uneasy about the device_attach() and device_release_driver() 
calls, I'll read your reply to Sylwester's comments and I'll answer there.

> +				dev_err(dev[i], "Failed to re-probe to %s\n",
> +					dev[i]->driver ? dev[i]->driver->name : "(none)");
> +			put_device(dev[i]);
> +		}
> +		kfree(dev);
> +	}
> +	/*
> +	 * Don't care about the waiting list, it is initialised and populated
> +	 * upon notifier registration.
> +	 */
> +}
> +EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> +
> +int v4l2_async_register_subdev(struct v4l2_async_subdev_list *asdl)
> +{
> +	struct v4l2_async_notifier *notifier;
> +
> +	mutex_lock(&list_lock);
> +
> +	INIT_LIST_HEAD(&asdl->list);
> +
> +	list_for_each_entry(notifier, &notifier_list, list) {
> +		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, asdl);
> +		if (asd) {
> +			int ret = v4l2_async_test_notify(notifier, asdl, asd);
> +			mutex_unlock(&list_lock);
> +			return ret;
> +		}
> +	}
> +
> +	/* None matched, wait for hot-plugging */
> +	list_add(&asdl->list, &subdev_list);
> +
> +	mutex_unlock(&list_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_async_register_subdev);
> +
> +void v4l2_async_unregister_subdev(struct v4l2_async_subdev_list *asdl)
> +{
> +	struct v4l2_async_notifier *notifier = asdl->notifier;
> +	struct device *dev;
> +
> +	if (!asdl->asd) {
> +		if (!list_empty(&asdl->list))
> +			v4l2_async_cleanup(asdl);
> +		return;
> +	}
> +
> +	mutex_lock(&list_lock);
> +
> +	dev = asdl->dev;
> +
> +	list_add(&asdl->asd->list, &notifier->waiting);
> +
> +	v4l2_async_cleanup(asdl);
> +
> +	if (notifier->unbind)
> +		notifier->unbind(notifier, asdl);
> +
> +	mutex_unlock(&list_lock);
> +}
> +EXPORT_SYMBOL(v4l2_async_unregister_subdev);
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> new file mode 100644
> index 0000000..c0470c6
> --- /dev/null
> +++ b/include/media/v4l2-async.h
> @@ -0,0 +1,104 @@
> +/*
> + * V4L2 asynchronous subdevice registration API
> + *
> + * Copyright (C) 2012-2013, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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
> +
> +#include <media/v4l2-subdev.h>
> +
> +struct device;
> +struct v4l2_device;
> +struct v4l2_async_notifier;
> +
> +enum v4l2_async_bus_type {
> +	V4L2_ASYNC_BUS_CUSTOM,
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

Do you think it would make sense to match I2C devices by name as well (using 
dev_name(dev)) ?

> +		struct {
> +			bool (*match)(struct device *,
> +				      struct v4l2_async_hw_device *);
> +			void *priv;
> +		} special;
> +	} match;
> +};

This isn't really a device, what about renaming it to v4l2_async_device_info, 
v4l2_async_hw_info, v4l2_async_dev_info, ... (or s/info/desc/) ?

> +/**
> + * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
> + * @hw:		this device descriptor
> + * @list:	member in a list of subdevices
> + */
> +struct v4l2_async_subdev {
> +	struct v4l2_async_hw_device hw;
> +	struct list_head list;
> +};

I was wondering whether this structure couldn't be made private (and thus 
dynamically allocated), but that might be overkill.

The structure isn't not part of the public API, except to access the hw field. 
Maybe the bound and unbind notifiers could get a pointer to the hw field 
directly to avoid going through v4l2_async_subdev ? We could then add a 
comment to the structure definition to warn that the structure must not be 
touched by subdev drivers at any time, and by bridge drivers in the notifier 
callbacks (bridge drivers will still need to create and initialize the 
v4l2_async_subdev instances passed to v4l2_async_notifier_register()). 
v4l2_async_subdev could even be merged with struct v4l2_async_hw_device.

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

I don't think this structure is needed, at least not in a public header file. 
Its fields could be moved to struct v4l2_subdev (which would also get rid of 
the subdev field) or, alternatively, a pointer to v4l2_async_subdev_list could 
be added to struct v4l2_subdev and allocated dynamically.

This would simplify the registration process for subdev drivers. They would 
only need to call v4l2_async_register_subdev() with a pointer to the subdev, 
without being required to instantiate a struct v4l2_async_subdev_list.

Obviously the dev pointer will still be needed. It could be passed to 
v4l2_async_register_subdev(), but my personal preference for now would be to 
add the struct device pointer to struct v4l2_subdev and let subdev drivers set 
it before registering the subdev.

> +/**
> + * v4l2_async_notifier - provided by bridges
> + * @subdev_num:	number of subdevices
> + * @subdev:	array of pointers to subdevices
> + * @v4l2_dev:	pointer to sruct v4l2_device

Typo, s/sruct/struct/

> + * @waiting:	list of subdevices, waiting for their drivers
> + * @done:	list of subdevices, already probed
> + * @list:	member in a global list of notifiers
> + * @bound:	a subdevice driver has successfully probed one of subdevices
> + * @complete:	all subdevices have been probed successfully
> + * @unbind:	a subdevice is leaving
> + */
> +struct v4l2_async_notifier {
> +	int subdev_num;

The number of subdevs can't be negative, could this be unsigned ?

> +	struct v4l2_async_subdev **subdev;
> +	struct v4l2_device *v4l2_dev;
> +	struct list_head waiting;
> +	struct list_head done;
> +	struct list_head list;
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
> +int v4l2_async_register_subdev(struct v4l2_async_subdev_list *asdl);
> +void v4l2_async_unregister_subdev(struct v4l2_async_subdev_list *asdl);

Renaming v4l2_async_(un)register_subdev to v4l2_(un)register_subdev might be a 
good idea at some point, we can fix that later.

> +#endif
-- 
Regards,

Laurent Pinchart

