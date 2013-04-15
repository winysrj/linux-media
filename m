Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54849 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3DOL5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 07:57:22 -0400
Message-id: <516BEB1D.80105@samsung.com>
Date: Mon, 15 Apr 2013 13:57:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice registration
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
 <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
In-reply-to: <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 04/12/2013 05:40 PM, Guennadi Liakhovetski wrote:
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
> v9: addressed Laurent's comments (thanks)
> 1. moved valid hw->bus_type check
> 2. made v4l2_async_unregister() void
> 3. renamed struct v4l2_async_hw_device to struct v4l2_async_hw_info
> 4. merged struct v4l2_async_subdev_list into struct v4l2_subdev
> 5. fixed a typo
> 6. made subdev_num unsigned
> 
>  drivers/media/v4l2-core/Makefile     |    3 +-
>  drivers/media/v4l2-core/v4l2-async.c |  284 ++++++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h           |   99 ++++++++++++
>  include/media/v4l2-subdev.h          |   10 ++
>  4 files changed, 395 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
>  create mode 100644 include/media/v4l2-async.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 628c630..4c33b8d6 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -5,7 +5,8 @@
>  tuner-objs	:=	tuner-core.o
>  
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
> +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> +			v4l2-async.o
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> new file mode 100644
> index 0000000..98db2e0
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -0,0 +1,284 @@
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
[...]
> +static void v4l2_async_cleanup(struct v4l2_async_subdev_list *asdl)
> +{
> +	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	/* Subdevice driver will reprobe and put asdl back onto the list */
> +	list_del_init(&asdl->list);
> +	asdl->asd = NULL;
> +	sd->dev = NULL;
> +}
> +
> +static void v4l2_async_unregister(struct v4l2_async_subdev_list *asdl)
> +{
> +	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
> +
> +	v4l2_async_cleanup(asdl);
> +
> +	/* If we handled USB devices, we'd have to lock the parent too */
> +	device_release_driver(sd->dev);
> +}
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_async_subdev_list *asdl, *tmp;
> +	struct v4l2_async_subdev *asd;
> +	int i;
> +
> +	notifier->v4l2_dev = v4l2_dev;
> +	INIT_LIST_HEAD(&notifier->waiting);
> +	INIT_LIST_HEAD(&notifier->done);
> +
> +	for (i = 0; i < notifier->subdev_num; i++) {
> +		asd = notifier->subdev[i];
> +
> +		switch (asd->hw.bus_type) {
> +		case V4L2_ASYNC_BUS_CUSTOM:
> +		case V4L2_ASYNC_BUS_PLATFORM:
> +		case V4L2_ASYNC_BUS_I2C:
> +			break;
> +		default:
> +			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
> +				"Invalid bus-type %u on %p\n",
> +				asd->hw.bus_type, asd);
> +			return -EINVAL;
> +		}
> +		list_add_tail(&asd->list, &notifier->waiting);
> +	}
> +
> +	mutex_lock(&list_lock);
> +
> +	/* Keep also completed notifiers on the list */
> +	list_add(&notifier->list, &notifier_list);
> +
> +	list_for_each_entry_safe(asdl, tmp, &subdev_list, list) {
> +		int ret;
> +
> +		asd = v4l2_async_belongs(notifier, asdl);
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
> +		if (dev) {
> +			struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
> +			dev[i++] = get_device(sd->dev);
> +		}
> +		v4l2_async_unregister(asdl);

Hmm, couldn't we do without the **dev array ? Now when struct v42_subdev has
struct device * embedded in it ?

And if we can't get hold off struct device object is it safe to call 
v4l2_async_unregister(), which references it ?

Why is get_device() optional ? Some comment might be useful here.

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
> +				dev_err(dev[i], "Failed to re-probe to %s\n",
> +					dev[i]->driver ? dev[i]->driver->name : "(none)");

Is it safe to reference dev->driver without holding struct device::mutex ?		

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
> +int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_subdev_list *asdl = &sd->asdl;
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
> +void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_subdev_list *asdl = &sd->asdl;
> +	struct v4l2_async_notifier *notifier = asdl->notifier;
> +	struct device *dev;

This variable appears unused, except a single assignment below.

> +	if (!asdl->asd) {
> +		if (!list_empty(&asdl->list))
> +			v4l2_async_cleanup(asdl);
> +		return;
> +	}
> +
> +	mutex_lock(&list_lock);
> +
> +	dev = sd->dev;

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
> index 0000000..c638f5c
> --- /dev/null
> +++ b/include/media/v4l2-async.h
> @@ -0,0 +1,99 @@
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
> +struct device;
> +struct v4l2_device;
> +struct v4l2_subdev;
> +struct v4l2_async_notifier;
> +
> +enum v4l2_async_bus_type {
> +	V4L2_ASYNC_BUS_CUSTOM,
> +	V4L2_ASYNC_BUS_PLATFORM,
> +	V4L2_ASYNC_BUS_I2C,
> +};
> +
> +struct v4l2_async_hw_info {
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
> +				      struct v4l2_async_hw_info *);
> +			void *priv;
> +		} custom;
> +	} match;
> +};
> +
> +/**
> + * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
> + * @hw:		this device descriptor
> + * @list:	member in a list of subdevices
> + */
> +struct v4l2_async_subdev {
> +	struct v4l2_async_hw_info hw;
> +	struct list_head list;
> +};
> +
> +/**
> + * v4l2_async_subdev_list - provided by subdevices
> + * @list:	member in a list of subdevices
> + * @asd:	pointer to respective struct v4l2_async_subdev
> + * @notifier:	pointer to managing notifier
> + */
> +struct v4l2_async_subdev_list {
> +	struct list_head list;
> +	struct v4l2_async_subdev *asd;
> +	struct v4l2_async_notifier *notifier;
> +};
> +
> +/**
> + * v4l2_async_notifier - provided by bridges

It probably makes sense to just say e.g.

 v4l2_async_notifier - v4l2_device notifier data structure

I mean at least "bridge" to me doesn't sound generic enough.

> + * @subdev_num:	number of subdevices
> + * @subdev:	array of pointers to subdevices
> + * @v4l2_dev:	pointer to struct v4l2_device
> + * @waiting:	list of subdevices, waiting for their drivers
> + * @done:	list of subdevices, already probed
> + * @list:	member in a global list of notifiers
> + * @bound:	a subdevice driver has successfully probed one of subdevices
> + * @complete:	all subdevices have been probed successfully
> + * @unbind:	a subdevice is leaving
> + */
> +struct v4l2_async_notifier {
> +	unsigned int subdev_num;
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

I would preffer to simply pass struct v4l2_subdev * to bound/unbind.
Since it is about just one subdevice's status change, why do we need 
struct v4l2_async_subdev_list ?

> +};
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier);
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);

How about naming it v4l2_device_notifier_(un)register() ?

> +int v4l2_async_register_subdev(struct v4l2_subdev *sd);
> +void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);

Hopefully, one day it just becomes v4l2_(un)register_subdev() :-)

> +#endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5298d67..21174af 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -24,6 +24,7 @@
>  #include <linux/types.h>
>  #include <linux/v4l2-subdev.h>
>  #include <media/media-entity.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> @@ -585,8 +586,17 @@ struct v4l2_subdev {
>  	void *host_priv;
>  	/* subdev device node */
>  	struct video_device *devnode;
> +	/* pointer to the physical device */
> +	struct device *dev;
> +	struct v4l2_async_subdev_list asdl;

Why not embed respective fields directly in struct v4l2_subdev, rather
than adding this new data structure ? I find this all code pretty much
convoluted, probably one of the reason is that there are multiple
list_head objects at various levels.

>  };
>  
> +static inline struct v4l2_subdev *v4l2_async_to_subdev(
> +			struct v4l2_async_subdev_list *asdl)
> +{
> +	return container_of(asdl, struct v4l2_subdev, asdl);
> +}
> +
>  #define media_entity_to_v4l2_subdev(ent) \
>  	container_of(ent, struct v4l2_subdev, entity)
>  #define vdev_to_v4l2_subdev(vdev) \
> 

Thanks,
Sylwester

