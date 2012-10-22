Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2JVMu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 08:50:27 -0400
Date: Mon, 22 Oct 2012 14:50:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
In-Reply-To: <201210221354.44944.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1210221421020.26216@axis700.grange>
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange>
 <201210221218.51221.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210221240210.26216@axis700.grange>
 <201210221354.44944.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Oct 2012, Hans Verkuil wrote:

> On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:
> > Hi Hans
> > 
> > Thanks for reviewing the patch.
> > 
> > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > I've reviewed this patch and I have a few questions:
> > > 
> > > On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
> > > > Currently bridge device drivers register devices for all subdevices
> > > > synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> > > > is attached to a video bridge device, the bridge driver will create an I2C
> > > > device and wait for the respective I2C driver to probe. This makes linking
> > > > of devices straight forward, but this approach cannot be used with
> > > > intrinsically asynchronous and unordered device registration systems like
> > > > the Flattened Device Tree. To support such systems this patch adds an
> > > > asynchronous subdevice registration framework to V4L2. To use it respective
> > > > (e.g. I2C) subdevice drivers must request deferred probing as long as their
> > > > bridge driver hasn't probed. The bridge driver during its probing submits a
> > > > an arbitrary number of subdevice descriptor groups to the framework to
> > > > manage. After that it can add callbacks to each of those groups to be
> > > > called at various stages during subdevice probing, e.g. after completion.
> > > > Then the bridge driver can request single groups to be probed, finish its
> > > > own probing and continue its video subsystem configuration from its
> > > > callbacks.
> > > 
> > > What is the purpose of allowing multiple groups?
> > 
> > To support, e.g. multiple sensors connected to a single bridge.
> 
> So, isn't that one group with two sensor subdevs?

No, one group consists of all subdevices, necessary to operate a single 
video pipeline. A simple group only contains a sensor. More complex groups 
can contain a CSI-2 interface, a line shifter, or anything else.

> A bridge driver has a list of subdevs. There is no concept of 'groups'. Perhaps
> I misunderstand?

Well, we have a group ID, which can be used for what I'm proposing groups 
for. At least on soc-camera we use the group ID exactly for this purpose. 
We attach all subdevices to a V4L2 device, but assign group IDs according 
to pipelines. Then subdevice operations only act on members of one 
pipeline. I know that we currently don't specify precisely what that group 
ID should be used for in general. So, this my group concept is an 
extension of what we currently have in V4L2.

> > > I can't think of any reason
> > > why you would want to have more than one group. If you have just one group
> > > you can simplify this code quite a bit: most of the v4l2_async_group fields
> > > can just become part of struct v4l2_device, you don't need the 'list' and
> > > 'v4l2_dev' fields anymore and the 'bind' and 'complete' callbacks can be
> > > implemented using the v4l2_device notify callback which we already have.
> > > 
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > ---
> > > > 
> > > > One more thing to note about this patch. Subdevice drivers, supporting 
> > > > asynchronous probing, and using this framework, need a unified way to 
> > > > detect, whether their probing should succeed or they should request 
> > > > deferred probing. I implement this using device platform data. This means, 
> > > > that all subdevice drivers, wishing to use this API will have to use the 
> > > > same platform data struct. I don't think this is a major inconvenience, 
> > > > but if we decide against this, we'll have to add a V4L2 function to verify 
> > > > "are you ready for me or not." The latter would be inconvenient, because 
> > > > then we would have to look through all registered subdevice descriptor 
> > > > groups for this specific subdevice.
> > > 
> > > I have to admit that I don't quite follow this. I guess I would need to see
> > > this being used in an actual driver.
> > 
> > The issue is simple: subdevice drivers have to recognise, when it's still 
> > too early to probe and return -EPROBE_DEFER. If you have a sensor, whose 
> > master clock is supplied from an external oscillator. You load its driver, 
> > it will happily get a clock reference and find no reason to fail probe(). 
> > It will initialise its subdevice and return from probing. Then, when your 
> > bridge driver probes, it will have no way to find that subdevice.
> 
> This problem is specific to platform subdev drivers, right? Since for i2c
> subdevs you can use i2c_get_clientdata().

But how do you get the client? With DT you can follow our "remote" 
phandle, and without DT?

> I wonder whether it isn't a better idea to have platform_data embed a standard
> struct containing a v4l2_subdev pointer. Subdevs can use container_of to get
> from the address of that struct to the full platform_data, and you don't have
> that extra dereference (i.e. a pointer to the new struct which has a pointer
> to the actual platform_data). The impact of that change is much smaller for
> existing subdevs.

This standard platform data object is allocated by the bridge driver, so, 
it will not know where it is embedded in the subdevice specific platform 
data.

> And if it isn't necessary for i2c subdev drivers, then I think we should do
> this only for platform drivers.

See above, and I don't think we should implement 2 different methods. 
Besides, the change is very small. You anyway have to adapt sensor drivers 
to return -EPROBE_DEFER. This takes 2 lines of code:

+	if (!client->dev.platform_data)
+		return -EPROBE_DEFER;

If the driver isn't using platform data, that's it. If it is, you add two 
more lines:

-	struct my_platform_data *pdata = client->dev.platform_data;
+	struct v4l2_subdev_platform_data *sdpd = client->dev.platform_data;
+	struct my_platform_data *pdata = sdpd->platform_data;

That's it. Of course, you have to do this everywhere, where the driver 
dereferences client->dev.platform_data, but even that shouldn't be too 
difficult.

> > > >  drivers/media/v4l2-core/Makefile      |    3 +-
> > > >  drivers/media/v4l2-core/v4l2-async.c  |  249 +++++++++++++++++++++++++++++++++
> > > >  drivers/media/v4l2-core/v4l2-device.c |    2 +
> > > >  include/media/v4l2-async.h            |   88 ++++++++++++
> > > >  include/media/v4l2-device.h           |    6 +
> > > >  include/media/v4l2-subdev.h           |   16 ++
> > > >  6 files changed, 363 insertions(+), 1 deletions(-)
> > > >  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
> > > >  create mode 100644 include/media/v4l2-async.h
> > > > 
> > > > diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> > > > index cb5fede..074e01c 100644
> > > > --- a/drivers/media/v4l2-core/Makefile
> > > > +++ b/drivers/media/v4l2-core/Makefile
> > > > @@ -5,7 +5,8 @@
> > > >  tuner-objs	:=	tuner-core.o
> > > >  
> > > >  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> > > > -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
> > > > +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> > > > +			v4l2-async.o
> > > >  ifeq ($(CONFIG_COMPAT),y)
> > > >    videodev-objs += v4l2-compat-ioctl32.o
> > > >  endif
> > > > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > > > new file mode 100644
> > > > index 0000000..871f116
> > > > --- /dev/null
> > > > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > > > @@ -0,0 +1,249 @@
> > > > +/*
> > > > + * V4L2 asynchronous subdevice registration API
> > > > + *
> > > > + * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the GNU General Public License version 2 as
> > > > + * published by the Free Software Foundation.
> > > > + */
> > > > +
> > > > +#include <linux/device.h>
> > > > +#include <linux/err.h>
> > > > +#include <linux/i2c.h>
> > > > +#include <linux/list.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/mutex.h>
> > > > +#include <linux/notifier.h>
> > > > +#include <linux/platform_device.h>
> > > > +#include <linux/slab.h>
> > > > +#include <linux/types.h>
> > > > +
> > > > +#include <media/v4l2-async.h>
> > > > +#include <media/v4l2-device.h>
> > > > +#include <media/v4l2-subdev.h>
> > > > +
> > > > +static bool match_i2c(struct device *dev, struct v4l2_async_hw_device *hw_dev)
> > > > +{
> > > > +	struct i2c_client *client = to_i2c_client(dev);
> > > > +	return hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
> > > > +		hw_dev->match.i2c.adapter_id == client->adapter->nr &&
> > > > +		hw_dev->match.i2c.address == client->addr;
> > > > +}
> > > > +
> > > > +static bool match_platform(struct device *dev, struct v4l2_async_hw_device *hw_dev)
> > > > +{
> > > > +	return hw_dev->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
> > > > +		!strcmp(hw_dev->match.platform.name, dev_name(dev));
> > > > +}
> > > > +
> > > > +/*
> > > > + * I think, notifiers on different busses can run concurrently, so, we have to
> > > > + * protect common data, e.g. sub-device lists.
> > > > + */
> > > > +static int async_notifier_cb(struct v4l2_async_group *group,
> > > > +		unsigned long action, struct device *dev,
> > > > +		bool (*match)(struct device *, struct v4l2_async_hw_device *))
> > > > +{
> > > > +	struct v4l2_device *v4l2_dev = group->v4l2_dev;
> > > > +	struct v4l2_async_subdev *asd;
> > > > +	bool done;
> > > > +	int ret;
> > > > +
> > > > +	if (action != BUS_NOTIFY_BOUND_DRIVER &&
> > > > +	    action != BUS_NOTIFY_BIND_DRIVER)
> > > > +		return NOTIFY_DONE;
> > > > +
> > > > +	/* Asynchronous: have to lock */
> > > > +	mutex_lock(&v4l2_dev->group_lock);
> > > > +
> > > > +	list_for_each_entry(asd, &group->group, list) {
> > > > +		if (match(dev, &asd->hw))
> > > > +			break;
> > > > +	}
> > > > +
> > > > +	if (&asd->list == &group->group) {
> > > > +		/* Not our device */
> > > > +		mutex_unlock(&v4l2_dev->group_lock);
> > > > +		return NOTIFY_DONE;
> > > > +	}
> > > > +
> > > > +	asd->dev = dev;
> > > > +
> > > > +	if (action == BUS_NOTIFY_BIND_DRIVER) {
> > > > +		/*
> > > > +		 * Provide platform data to the driver: it can complete probing
> > > > +		 * now.
> > > > +		 */
> > > > +		dev->platform_data = &asd->sdpd;
> > > > +		mutex_unlock(&v4l2_dev->group_lock);
> > > > +		if (group->bind_cb)
> > > > +			group->bind_cb(group, asd);
> > > > +		return NOTIFY_OK;
> > > > +	}
> > > > +
> > > > +	/* BUS_NOTIFY_BOUND_DRIVER */
> > > > +	if (asd->hw.bus_type == V4L2_ASYNC_BUS_I2C)
> > > > +		asd->sdpd.subdev = i2c_get_clientdata(to_i2c_client(dev));
> > > > +	/*
> > > > +	 * Non-I2C subdevice drivers should take care to assign their subdevice
> > > > +	 * pointers
> > > 
> > > Can they? Isn't it the bridge driver that instantiates the subdev structs and
> > > calls v4l2_device_register_subdev() in the case of platform subdev drivers?
> > > I don't think a subdev platform driver knows its subdev pointer.
> > 
> > Not in case of sh_mobile_csi2. There I've used the same notification 
> > procedure, that we want to use now, to get to the subdevice, initialised 
> > by the csi2 driver itself.
> 
> Ah, OK.
>  
> > > For that matter, is async probing needed at all for platform subdev drivers? It
> > > is for i2c subdevs, no doubt about that, but does it make sense for platform
> > > subdev drivers as well?
> > 
> > I think it does. E.g. on sh-mobile CSI2 is a separate hardware unit with 
> > an own subdevice driver. It will get an own DT node, so, it will probe 
> > asynchronously.
> > 
> > > > +	 */
> > > > +	ret = v4l2_device_register_subdev(v4l2_dev,
> > > > +					  asd->sdpd.subdev);
> > > > +	if (ret < 0) {
> > > > +		mutex_unlock(&v4l2_dev->group_lock);
> > > > +		/* FIXME: error, clean up world? */
> > > > +		dev_err(dev, "Failed registering a subdev: %d\n", ret);
> > > > +		return NOTIFY_OK;
> > > > +	}
> > > > +	list_move(&asd->list, &group->done);
> > > > +
> > > > +	/* Client probed & all subdev drivers collected */
> > > > +	done = list_empty(&group->group);
> > > > +
> > > > +	mutex_unlock(&v4l2_dev->group_lock);
> > > > +
> > > > +	if (group->bound_cb)
> > > > +		group->bound_cb(group, asd);
> > > > +
> > > > +	if (done && group->complete_cb)
> > > > +		group->complete_cb(group);
> > > > +
> > > > +	return NOTIFY_OK;
> > > > +}
> > > > +
> > > > +static int platform_cb(struct notifier_block *nb,
> > > > +		       unsigned long action, void *data)
> > > > +{
> > > > +	struct device *dev = data;
> > > > +	struct v4l2_async_group *group = container_of(nb, struct v4l2_async_group,
> > > > +						     platform_notifier);
> > > > +
> > > > +	return async_notifier_cb(group, action, dev, match_platform);
> > > > +}
> > > > +
> > > > +static int i2c_cb(struct notifier_block *nb,
> > > > +		  unsigned long action, void *data)
> > > > +{
> > > > +	struct device *dev = data;
> > > > +	struct v4l2_async_group *group = container_of(nb, struct v4l2_async_group,
> > > > +						     i2c_notifier);
> > > > +
> > > > +	return async_notifier_cb(group, action, dev, match_i2c);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Typically this function will be called during bridge driver probing. It
> > > > + * installs bus notifiers to handle asynchronously probing subdevice drivers.
> > > > + * Once the bridge driver probing completes, subdevice drivers, waiting in
> > > > + * EPROBE_DEFER state are re-probed, at which point they get their platform
> > > > + * data, which allows them to complete probing.
> > > > + */
> > > > +int v4l2_async_group_probe(struct v4l2_async_group *group)
> > > > +{
> > > > +	struct v4l2_async_subdev *asd, *tmp;
> > > > +	bool i2c_used = false, platform_used = false;
> > > > +	int ret;
> > > > +
> > > > +	/* This group is inactive so far - no notifiers yet */
> > > > +	list_for_each_entry_safe(asd, tmp, &group->group, list) {
> > > > +		if (asd->sdpd.subdev) {
> > > > +			/* Simulate a BIND event */
> > > > +			if (group->bind_cb)
> > > > +				group->bind_cb(group, asd);
> > > > +
> > > > +			/* Already probed, don't wait for it */
> > > > +			ret = v4l2_device_register_subdev(group->v4l2_dev,
> > > > +							  asd->sdpd.subdev);
> > > > +
> > > > +			if (ret < 0)
> > > > +				return ret;
> > > > +
> > > > +			list_move(&asd->list, &group->done);
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		switch (asd->hw.bus_type) {
> > > > +		case V4L2_ASYNC_BUS_PLATFORM:
> > > > +			platform_used = true;
> > > > +			break;
> > > > +		case V4L2_ASYNC_BUS_I2C:
> > > > +			i2c_used = true;
> > > 
> > > Add 'break;'
> > > 
> > > > +		}
> > > > +	}
> > > > +
> > > > +	if (list_empty(&group->group)) {
> > > > +		if (group->complete_cb)
> > > > +			group->complete_cb(group);
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	/* TODO: so far bus_register_notifier() never fails */
> > > > +	if (platform_used) {
> > > > +		group->platform_notifier.notifier_call = platform_cb;
> > > > +		bus_register_notifier(&platform_bus_type,
> > > > +				      &group->platform_notifier);
> > > > +	}
> > > > +
> > > > +	if (i2c_used) {
> > > > +		group->i2c_notifier.notifier_call = i2c_cb;
> > > > +		bus_register_notifier(&i2c_bus_type,
> > > > +				      &group->i2c_notifier);
> > > > +	}
> > > > +
> > > 
> > > Hmm. I would expect that this probe function would sleep here and wait until
> > > all subdev drivers are probed. Or is that not possible?
> > 
> > Why would it be async probing then? :-) The whole concept is built around 
> > deferred probing. A typical sequence will look like this:
> > 
> > sensor_probe() {
> > 	return -EPROBE_DEFER;
> > }
> > 
> > bridge_probe() {
> > 	v4l2_async_group_init();
> > 	v4l2_async_group_probe();
> > 	return 0;
> > }
> > 
> > /* The bridge driver completed its probing, _THIS_ triggers re-probing of 
> > all drivers in deferred-probe state */	
> > 
> > sensor_probe() {
> > 	v4l2_subdev_init();
> > 	return 0;
> > }
> > 
> > async_notifier_cb() {
> > 	v4l2_device_register_subdev();
> > 	group->complete_cb();
> > }
> > 
> > bridge_complete_cb() {
> > 	video_register_device();
> > }
> > 
> > So, the bridge driver has to complete its probe() for sensor's probe() to 
> > be called again.
> 
> True. Sorry, it can be confusing :-)
> 
> That said, how does this new framework take care of timeouts if one of the
> subdevs is never bound?

It doesn't.

> You don't want to have this wait indefinitely, I think.

There's no waiting:-) The bridge and other subdev drivers just remain 
loaded and inactive.

Thanks
Guennadi

> > > If this function could just sleep (with a timeout, probably), then you don't
> > > need the 'complete_cb' and bridge drivers don't have to set up their own
> > > completion mechanism.
> > > 
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL(v4l2_async_group_probe);
> > > > +
> > > > +int v4l2_async_group_init(struct v4l2_device *v4l2_dev,
> > > > +			  struct v4l2_async_group *group,
> > > > +			  struct v4l2_async_subdev *asd, int cnt)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	if (!group)
> > > > +		return -EINVAL;
> > > > +
> > > > +	INIT_LIST_HEAD(&group->group);
> > > > +	INIT_LIST_HEAD(&group->done);
> > > > +	group->v4l2_dev = v4l2_dev;
> > > > +
> > > > +	for (i = 0; i < cnt; i++)
> > > > +		list_add_tail(&asd[i].list, &group->group);
> > > > +
> > > > +	/* Protect the global V4L2 device group list */
> > > > +	mutex_lock(&v4l2_dev->group_lock);
> > > > +	list_add_tail(&group->list, &v4l2_dev->group_head);
> > > > +	mutex_unlock(&v4l2_dev->group_lock);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL(v4l2_async_group_init);
> > > > +
> > > > +void v4l2_async_group_release(struct v4l2_async_group *group)
> > > > +{
> > > > +	struct v4l2_async_subdev *asd, *tmp;
> > > > +
> > > > +	/* Also no problem, if notifiers haven't been registered */
> > > > +	bus_unregister_notifier(&platform_bus_type,
> > > > +				&group->platform_notifier);
> > > > +	bus_unregister_notifier(&i2c_bus_type,
> > > > +				&group->i2c_notifier);
> > > > +
> > > > +	mutex_lock(&group->v4l2_dev->group_lock);
> > > > +	list_del(&group->list);
> > > > +	mutex_unlock(&group->v4l2_dev->group_lock);
> > > > +
> > > > +	list_for_each_entry_safe(asd, tmp, &group->done, list) {
> > > > +		v4l2_device_unregister_subdev(asd->sdpd.subdev);
> > > > +		/* If we handled USB devices, we'd have to lock the parent too */
> > > > +		device_release_driver(asd->dev);
> > > > +		asd->dev->platform_data = NULL;
> > > > +		if (device_attach(asd->dev) <= 0)
> > > > +			dev_dbg(asd->dev, "Failed to re-probe to %s\n", asd->dev->driver ?
> > > > +				asd->dev->driver->name : "(none)");
> > > > +		list_del(&asd->list);
> > > > +	}
> > > > +}
> > > > +EXPORT_SYMBOL(v4l2_async_group_release);
> > > > diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> > > > index 513969f..52faf2f 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-device.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > > > @@ -40,6 +40,8 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
> > > >  	mutex_init(&v4l2_dev->ioctl_lock);
> > > >  	v4l2_prio_init(&v4l2_dev->prio);
> > > >  	kref_init(&v4l2_dev->ref);
> > > > +	INIT_LIST_HEAD(&v4l2_dev->group_head);
> > > > +	mutex_init(&v4l2_dev->group_lock);
> > > >  	get_device(dev);
> > > >  	v4l2_dev->dev = dev;
> > > >  	if (dev == NULL) {
> > > > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > > > new file mode 100644
> > > > index 0000000..8f7bc06
> > > > --- /dev/null
> > > > +++ b/include/media/v4l2-async.h
> > > > @@ -0,0 +1,88 @@
> > > > +/*
> > > > + * V4L2 asynchronous subdevice registration API
> > > > + *
> > > > + * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the GNU General Public License version 2 as
> > > > + * published by the Free Software Foundation.
> > > > + */
> > > > +
> > > > +#ifndef V4L2_ASYNC_H
> > > > +#define V4L2_ASYNC_H
> > > > +
> > > > +#include <linux/list.h>
> > > > +#include <linux/mutex.h>
> > > > +#include <linux/notifier.h>
> > > > +
> > > > +#include <media/v4l2-subdev.h>
> > > > +
> > > > +struct device;
> > > > +struct v4l2_device;
> > > > +
> > > > +enum v4l2_async_bus_type {
> > > > +	V4L2_ASYNC_BUS_PLATFORM,
> > > > +	V4L2_ASYNC_BUS_I2C,
> > > > +};
> > > > +
> > > > +struct v4l2_async_hw_device {
> > > > +	enum v4l2_async_bus_type bus_type;
> > > > +	union {
> > > > +		struct {
> > > > +			const char *name;
> > > > +		} platform;
> > > > +		struct {
> > > > +			int adapter_id;
> > > > +			unsigned short address;
> > > > +		} i2c;
> > > > +	} match;
> > > > +};
> > > > +
> > > > +/**
> > > > + * struct v4l2_async_subdev - device descriptor
> > > > + * @hw:		this device descriptor
> > > > + * @list:	member in the group
> > > > + * @dev:	corresponding hardware device (I2C, platform,...)
> > > > + * @sdpd:	embedded subdevice platform data
> > > > + * @role:	this subdevice role in the video pipeline
> > > > + */
> > > > +struct v4l2_async_subdev {
> > > > +	struct v4l2_async_hw_device hw;
> > > > +	struct list_head list;
> > > > +	struct device *dev;
> > > > +	struct v4l2_subdev_platform_data sdpd;
> > > > +	enum v4l2_subdev_role role;
> > > 
> > > What's the purpose of 'role'? I don't see what this has to do with async
> > > subdev registration.
> > 
> > Right, looks like it's not used by the generic code, I'll try to make it 
> > soc-camera local in the next version
> 
> OK.
> 
> Regards,
> 
> 	Hans
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
