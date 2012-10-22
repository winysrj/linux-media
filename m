Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1909 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2JVKTc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 06:19:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
Date: Mon, 22 Oct 2012 12:18:51 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <Pine.LNX.4.64.1210200007580.28993@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210200007580.28993@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210221218.51221.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I've reviewed this patch and I have a few questions:

On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
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

What is the purpose of allowing multiple groups? I can't think of any reason
why you would want to have more than one group. If you have just one group
you can simplify this code quite a bit: most of the v4l2_async_group fields
can just become part of struct v4l2_device, you don't need the 'list' and
'v4l2_dev' fields anymore and the 'bind' and 'complete' callbacks can be
implemented using the v4l2_device notify callback which we already have.

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> One more thing to note about this patch. Subdevice drivers, supporting 
> asynchronous probing, and using this framework, need a unified way to 
> detect, whether their probing should succeed or they should request 
> deferred probing. I implement this using device platform data. This means, 
> that all subdevice drivers, wishing to use this API will have to use the 
> same platform data struct. I don't think this is a major inconvenience, 
> but if we decide against this, we'll have to add a V4L2 function to verify 
> "are you ready for me or not." The latter would be inconvenient, because 
> then we would have to look through all registered subdevice descriptor 
> groups for this specific subdevice.

I have to admit that I don't quite follow this. I guess I would need to see
this being used in an actual driver.

> 
>  drivers/media/v4l2-core/Makefile      |    3 +-
>  drivers/media/v4l2-core/v4l2-async.c  |  249 +++++++++++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-device.c |    2 +
>  include/media/v4l2-async.h            |   88 ++++++++++++
>  include/media/v4l2-device.h           |    6 +
>  include/media/v4l2-subdev.h           |   16 ++
>  6 files changed, 363 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
>  create mode 100644 include/media/v4l2-async.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index cb5fede..074e01c 100644
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
> index 0000000..871f116
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -0,0 +1,249 @@
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
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +static bool match_i2c(struct device *dev, struct v4l2_async_hw_device *hw_dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	return hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
> +		hw_dev->match.i2c.adapter_id == client->adapter->nr &&
> +		hw_dev->match.i2c.address == client->addr;
> +}
> +
> +static bool match_platform(struct device *dev, struct v4l2_async_hw_device *hw_dev)
> +{
> +	return hw_dev->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
> +		!strcmp(hw_dev->match.platform.name, dev_name(dev));
> +}
> +
> +/*
> + * I think, notifiers on different busses can run concurrently, so, we have to
> + * protect common data, e.g. sub-device lists.
> + */
> +static int async_notifier_cb(struct v4l2_async_group *group,
> +		unsigned long action, struct device *dev,
> +		bool (*match)(struct device *, struct v4l2_async_hw_device *))
> +{
> +	struct v4l2_device *v4l2_dev = group->v4l2_dev;
> +	struct v4l2_async_subdev *asd;
> +	bool done;
> +	int ret;
> +
> +	if (action != BUS_NOTIFY_BOUND_DRIVER &&
> +	    action != BUS_NOTIFY_BIND_DRIVER)
> +		return NOTIFY_DONE;
> +
> +	/* Asynchronous: have to lock */
> +	mutex_lock(&v4l2_dev->group_lock);
> +
> +	list_for_each_entry(asd, &group->group, list) {
> +		if (match(dev, &asd->hw))
> +			break;
> +	}
> +
> +	if (&asd->list == &group->group) {
> +		/* Not our device */
> +		mutex_unlock(&v4l2_dev->group_lock);
> +		return NOTIFY_DONE;
> +	}
> +
> +	asd->dev = dev;
> +
> +	if (action == BUS_NOTIFY_BIND_DRIVER) {
> +		/*
> +		 * Provide platform data to the driver: it can complete probing
> +		 * now.
> +		 */
> +		dev->platform_data = &asd->sdpd;
> +		mutex_unlock(&v4l2_dev->group_lock);
> +		if (group->bind_cb)
> +			group->bind_cb(group, asd);
> +		return NOTIFY_OK;
> +	}
> +
> +	/* BUS_NOTIFY_BOUND_DRIVER */
> +	if (asd->hw.bus_type == V4L2_ASYNC_BUS_I2C)
> +		asd->sdpd.subdev = i2c_get_clientdata(to_i2c_client(dev));
> +	/*
> +	 * Non-I2C subdevice drivers should take care to assign their subdevice
> +	 * pointers

Can they? Isn't it the bridge driver that instantiates the subdev structs and
calls v4l2_device_register_subdev() in the case of platform subdev drivers?
I don't think a subdev platform driver knows its subdev pointer.

For that matter, is async probing needed at all for platform subdev drivers? It
is for i2c subdevs, no doubt about that, but does it make sense for platform
subdev drivers as well?

> +	 */
> +	ret = v4l2_device_register_subdev(v4l2_dev,
> +					  asd->sdpd.subdev);
> +	if (ret < 0) {
> +		mutex_unlock(&v4l2_dev->group_lock);
> +		/* FIXME: error, clean up world? */
> +		dev_err(dev, "Failed registering a subdev: %d\n", ret);
> +		return NOTIFY_OK;
> +	}
> +	list_move(&asd->list, &group->done);
> +
> +	/* Client probed & all subdev drivers collected */
> +	done = list_empty(&group->group);
> +
> +	mutex_unlock(&v4l2_dev->group_lock);
> +
> +	if (group->bound_cb)
> +		group->bound_cb(group, asd);
> +
> +	if (done && group->complete_cb)
> +		group->complete_cb(group);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int platform_cb(struct notifier_block *nb,
> +		       unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	struct v4l2_async_group *group = container_of(nb, struct v4l2_async_group,
> +						     platform_notifier);
> +
> +	return async_notifier_cb(group, action, dev, match_platform);
> +}
> +
> +static int i2c_cb(struct notifier_block *nb,
> +		  unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	struct v4l2_async_group *group = container_of(nb, struct v4l2_async_group,
> +						     i2c_notifier);
> +
> +	return async_notifier_cb(group, action, dev, match_i2c);
> +}
> +
> +/*
> + * Typically this function will be called during bridge driver probing. It
> + * installs bus notifiers to handle asynchronously probing subdevice drivers.
> + * Once the bridge driver probing completes, subdevice drivers, waiting in
> + * EPROBE_DEFER state are re-probed, at which point they get their platform
> + * data, which allows them to complete probing.
> + */
> +int v4l2_async_group_probe(struct v4l2_async_group *group)
> +{
> +	struct v4l2_async_subdev *asd, *tmp;
> +	bool i2c_used = false, platform_used = false;
> +	int ret;
> +
> +	/* This group is inactive so far - no notifiers yet */
> +	list_for_each_entry_safe(asd, tmp, &group->group, list) {
> +		if (asd->sdpd.subdev) {
> +			/* Simulate a BIND event */
> +			if (group->bind_cb)
> +				group->bind_cb(group, asd);
> +
> +			/* Already probed, don't wait for it */
> +			ret = v4l2_device_register_subdev(group->v4l2_dev,
> +							  asd->sdpd.subdev);
> +
> +			if (ret < 0)
> +				return ret;
> +
> +			list_move(&asd->list, &group->done);
> +			continue;
> +		}
> +
> +		switch (asd->hw.bus_type) {
> +		case V4L2_ASYNC_BUS_PLATFORM:
> +			platform_used = true;
> +			break;
> +		case V4L2_ASYNC_BUS_I2C:
> +			i2c_used = true;

Add 'break;'

> +		}
> +	}
> +
> +	if (list_empty(&group->group)) {
> +		if (group->complete_cb)
> +			group->complete_cb(group);
> +		return 0;
> +	}
> +
> +	/* TODO: so far bus_register_notifier() never fails */
> +	if (platform_used) {
> +		group->platform_notifier.notifier_call = platform_cb;
> +		bus_register_notifier(&platform_bus_type,
> +				      &group->platform_notifier);
> +	}
> +
> +	if (i2c_used) {
> +		group->i2c_notifier.notifier_call = i2c_cb;
> +		bus_register_notifier(&i2c_bus_type,
> +				      &group->i2c_notifier);
> +	}
> +

Hmm. I would expect that this probe function would sleep here and wait until
all subdev drivers are probed. Or is that not possible?

If this function could just sleep (with a timeout, probably), then you don't
need the 'complete_cb' and bridge drivers don't have to set up their own
completion mechanism.

> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_async_group_probe);
> +
> +int v4l2_async_group_init(struct v4l2_device *v4l2_dev,
> +			  struct v4l2_async_group *group,
> +			  struct v4l2_async_subdev *asd, int cnt)
> +{
> +	int i;
> +
> +	if (!group)
> +		return -EINVAL;
> +
> +	INIT_LIST_HEAD(&group->group);
> +	INIT_LIST_HEAD(&group->done);
> +	group->v4l2_dev = v4l2_dev;
> +
> +	for (i = 0; i < cnt; i++)
> +		list_add_tail(&asd[i].list, &group->group);
> +
> +	/* Protect the global V4L2 device group list */
> +	mutex_lock(&v4l2_dev->group_lock);
> +	list_add_tail(&group->list, &v4l2_dev->group_head);
> +	mutex_unlock(&v4l2_dev->group_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_async_group_init);
> +
> +void v4l2_async_group_release(struct v4l2_async_group *group)
> +{
> +	struct v4l2_async_subdev *asd, *tmp;
> +
> +	/* Also no problem, if notifiers haven't been registered */
> +	bus_unregister_notifier(&platform_bus_type,
> +				&group->platform_notifier);
> +	bus_unregister_notifier(&i2c_bus_type,
> +				&group->i2c_notifier);
> +
> +	mutex_lock(&group->v4l2_dev->group_lock);
> +	list_del(&group->list);
> +	mutex_unlock(&group->v4l2_dev->group_lock);
> +
> +	list_for_each_entry_safe(asd, tmp, &group->done, list) {
> +		v4l2_device_unregister_subdev(asd->sdpd.subdev);
> +		/* If we handled USB devices, we'd have to lock the parent too */
> +		device_release_driver(asd->dev);
> +		asd->dev->platform_data = NULL;
> +		if (device_attach(asd->dev) <= 0)
> +			dev_dbg(asd->dev, "Failed to re-probe to %s\n", asd->dev->driver ?
> +				asd->dev->driver->name : "(none)");
> +		list_del(&asd->list);
> +	}
> +}
> +EXPORT_SYMBOL(v4l2_async_group_release);
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 513969f..52faf2f 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -40,6 +40,8 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
>  	mutex_init(&v4l2_dev->ioctl_lock);
>  	v4l2_prio_init(&v4l2_dev->prio);
>  	kref_init(&v4l2_dev->ref);
> +	INIT_LIST_HEAD(&v4l2_dev->group_head);
> +	mutex_init(&v4l2_dev->group_lock);
>  	get_device(dev);
>  	v4l2_dev->dev = dev;
>  	if (dev == NULL) {
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> new file mode 100644
> index 0000000..8f7bc06
> --- /dev/null
> +++ b/include/media/v4l2-async.h
> @@ -0,0 +1,88 @@
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
> +
> +enum v4l2_async_bus_type {
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
> +	} match;
> +};
> +
> +/**
> + * struct v4l2_async_subdev - device descriptor
> + * @hw:		this device descriptor
> + * @list:	member in the group
> + * @dev:	corresponding hardware device (I2C, platform,...)
> + * @sdpd:	embedded subdevice platform data
> + * @role:	this subdevice role in the video pipeline
> + */
> +struct v4l2_async_subdev {
> +	struct v4l2_async_hw_device hw;
> +	struct list_head list;
> +	struct device *dev;
> +	struct v4l2_subdev_platform_data sdpd;
> +	enum v4l2_subdev_role role;

What's the purpose of 'role'? I don't see what this has to do with async
subdev registration.

> +};
> +
> +/**
> + * struct v4l2_async_group - list of device descriptors
> + * @list:		member in the v4l2 group list
> + * @group:		head of device list
> + * @done:		head of probed device list
> + * @platform_notifier:	platform bus notifier block
> + * @i2c_notifier:	I2C bus notifier block
> + * @v4l2_dev:		link to the respective struct v4l2_device
> + * @bind:		callback, called upon BUS_NOTIFY_BIND_DRIVER for each
> + *			subdevice
> + * @complete:		callback, called once after all subdevices in the group
> + *			have been bound
> + */
> +struct v4l2_async_group {
> +	struct list_head list;
> +	struct list_head group;
> +	struct list_head done;
> +	struct notifier_block platform_notifier;
> +	struct notifier_block i2c_notifier;
> +	struct v4l2_device *v4l2_dev;
> +	int (*bind)(struct v4l2_async_group *group,
> +		    struct v4l2_async_subdev *asd);
> +	int (*complete)(struct v4l2_async_group *group);
> +};
> +
> +int v4l2_async_group_init(struct v4l2_device *v4l2_dev,
> +			  struct v4l2_async_group *group,
> +			  struct v4l2_async_subdev *asd, int cnt);
> +int v4l2_async_group_probe(struct v4l2_async_group *group);
> +void v4l2_async_group_release(struct v4l2_async_group *group);
> +
> +#endif
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index d61febf..84b18c9 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -21,6 +21,9 @@
>  #ifndef _V4L2_DEVICE_H
>  #define _V4L2_DEVICE_H
>  
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +
>  #include <media/media-device.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-dev.h>
> @@ -60,6 +63,9 @@ struct v4l2_device {
>  	struct v4l2_prio_state prio;
>  	/* BKL replacement mutex. Temporary solution only. */
>  	struct mutex ioctl_lock;
> +	/* Subdevice group handling */
> +	struct mutex group_lock;
> +	struct list_head group_head;
>  	/* Keep track of the references to this struct. */
>  	struct kref ref;
>  	/* Release function that is called when the ref count goes to 0. */
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 2ecd737..1756c6c 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -574,6 +574,22 @@ struct v4l2_subdev_fh {
>  #endif
>  };
>  
> +enum v4l2_subdev_role {
> +	V4L2_SUBDEV_DATA_SOURCE = 1,
> +	V4L2_SUBDEV_DATA_SINK,
> +	V4L2_SUBDEV_DATA_PROCESSOR,
> +};
> +
> +/**
> + * struct v4l2_subdev_platform_data - subdev platform data
> + * @subdev:		subdevice
> + * @platform_data:	subdevice driver platform data
> + */
> +struct v4l2_subdev_platform_data {
> +	struct v4l2_subdev *subdev;
> +	void *platform_data;
> +};
> +
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
> 

Regards,

	Hans
