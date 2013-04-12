Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3DLO3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 10:29:41 -0400
Date: Fri, 12 Apr 2013 16:29:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 2/7] media: V4L2: support asynchronous subdevice
 registration
In-Reply-To: <1618829.uxRCXGb1BB@avalon>
Message-ID: <Pine.LNX.4.64.1304121605260.1727@axis700.grange>
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de>
 <1365433538-15975-3-git-send-email-g.liakhovetski@gmx.de> <1618829.uxRCXGb1BB@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thanks for the review.

On Fri, 12 Apr 2013, Laurent Pinchart wrote:

[snip]

> > +		switch (hw->bus_type) {
> > +		case V4L2_ASYNC_BUS_CUSTOM:
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
> 
> An invalid hw->bus_type value is a driver (or board code) bug. Could you move 
> this check to v4l2_async_notifier_register() when building the subdev list and 
> return an error ?

agree.

> > +static struct device *v4l2_async_unregister(struct v4l2_async_subdev_list
> > *asdl)
> > +{
> > +	struct device *dev = asdl->dev;
> > +
> > +	v4l2_async_cleanup(asdl);
> > +
> > +	/* If we handled USB devices, we'd have to lock the parent too */
> > +	device_release_driver(dev);
> > +	return dev;
> 
> This function is called from a single location and the return value is unused, 
> it could just return void.

will be changed

> > +}
> > +
> > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > +				 struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_async_subdev_list *asdl, *tmp;
> > +	int i;
> 
> Could this be unsigned (please see below for a similar comment about notifier-
> >subdev_num as well) ?

I like it how clearly we can separate in our reviews suggestions for 
technical quality improvements from personal opinions and preferences ;-)

> > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_async_subdev_list *asdl, *tmp;
> > +	int i = 0;
> 
> i can't be negative, could it then be unsiged ?

Ditto :)

> > +	struct device **dev = kcalloc(notifier->subdev_num,
> > +				      sizeof(*dev), GFP_KERNEL);
> > +	if (!dev)
> > +		dev_err(notifier->v4l2_dev->dev,
> > +			"Failed to allocate device cache!\n");
> > +
> > +	mutex_lock(&list_lock);
> > +
> > +	list_del(&notifier->list);
> > +
> > +	list_for_each_entry_safe(asdl, tmp, &notifier->done, list) {
> > +		if (dev)
> > +			dev[i++] = get_device(asdl->dev);
> > +		v4l2_async_unregister(asdl);
> > +
> > +		if (notifier->unbind)
> > +			notifier->unbind(notifier, asdl);
> > +	}
> > +
> > +	mutex_unlock(&list_lock);
> > +
> > +	if (dev) {
> > +		while (i--) {
> > +			if (dev[i] && device_attach(dev[i]) < 0)
> 
> I'm still pretty uneasy about the device_attach() and device_release_driver() 
> calls, I'll read your reply to Sylwester's comments and I'll answer there.

Maybe the following will help: we also discussed this with Greg K-H, he 
also initially was of the opinion, that these calls shouldn't be needed in 
_device_ drivers. They are to be used by bus drivers. Then I explained, 
that we are indeed dealing with a media bus here. He didn't reply any 
more :-)

> > +struct v4l2_async_hw_device {
> > +	enum v4l2_async_bus_type bus_type;
> > +	union {
> > +		struct {
> > +			const char *name;
> > +		} platform;
> > +		struct {
> > +			int adapter_id;
> > +			unsigned short address;
> > +		} i2c;
> 
> Do you think it would make sense to match I2C devices by name as well (using 
> dev_name(dev)) ?

not necessarily... it would make it uniform, yes, but code authors would 
have to hard-code device names, that are otherwise created by the I2C core. 
Are we sure those never change? Don't think we're supposed to rely on them.

> > +		struct {
> > +			bool (*match)(struct device *,
> > +				      struct v4l2_async_hw_device *);
> > +			void *priv;
> > +		} special;
> > +	} match;
> > +};
> 
> This isn't really a device, what about renaming it to v4l2_async_device_info, 
> v4l2_async_hw_info, v4l2_async_dev_info, ... (or s/info/desc/) ?

ok

> > +/**
> > + * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
> > + * @hw:		this device descriptor
> > + * @list:	member in a list of subdevices
> > + */
> > +struct v4l2_async_subdev {
> > +	struct v4l2_async_hw_device hw;
> > +	struct list_head list;
> > +};
> 
> I was wondering whether this structure couldn't be made private (and thus 
> dynamically allocated), but that might be overkill.

seems an overkill to me too.

> The structure isn't not part of the public API, except to access the hw field. 
> Maybe the bound and unbind notifiers could get a pointer to the hw field 
> directly to avoid going through v4l2_async_subdev ? We could then add a 
> comment to the structure definition to warn that the structure must not be 
> touched by subdev drivers at any time, and by bridge drivers in the notifier 
> callbacks (bridge drivers will still need to create and initialize the 
> v4l2_async_subdev instances passed to v4l2_async_notifier_register()). 
> v4l2_async_subdev could even be merged with struct v4l2_async_hw_device.
> 
> > +/**
> > + * v4l2_async_subdev_list - provided by subdevices
> > + * @list:	member in a list of subdevices
> > + * @dev:	hardware device
> > + * @subdev:	V4L2 subdevice
> > + * @asd:	pointer to respective struct v4l2_async_subdev
> > + * @notifier:	pointer to managing notifier
> > + */
> > +struct v4l2_async_subdev_list {
> > +	struct list_head list;
> > +	struct device *dev;
> > +	struct v4l2_subdev *subdev;
> > +	struct v4l2_async_subdev *asd;
> > +	struct v4l2_async_notifier *notifier;
> > +};
> 
> I don't think this structure is needed, at least not in a public header file. 
> Its fields could be moved to struct v4l2_subdev (which would also get rid of 
> the subdev field) or, alternatively, a pointer to v4l2_async_subdev_list could 
> be added to struct v4l2_subdev and allocated dynamically.

I'll merge it into v4l2_dubdev

> This would simplify the registration process for subdev drivers. They would 
> only need to call v4l2_async_register_subdev() with a pointer to the subdev, 
> without being required to instantiate a struct v4l2_async_subdev_list.
> 
> Obviously the dev pointer will still be needed. It could be passed to 
> v4l2_async_register_subdev(), but my personal preference for now would be to 
> add the struct device pointer to struct v4l2_subdev and let subdev drivers set 
> it before registering the subdev.
> 
> > +/**
> > + * v4l2_async_notifier - provided by bridges
> > + * @subdev_num:	number of subdevices
> > + * @subdev:	array of pointers to subdevices
> > + * @v4l2_dev:	pointer to sruct v4l2_device
> 
> Typo, s/sruct/struct/

thanks

> > + * @waiting:	list of subdevices, waiting for their drivers
> > + * @done:	list of subdevices, already probed
> > + * @list:	member in a global list of notifiers
> > + * @bound:	a subdevice driver has successfully probed one of subdevices
> > + * @complete:	all subdevices have been probed successfully
> > + * @unbind:	a subdevice is leaving
> > + */
> > +struct v4l2_async_notifier {
> > +	int subdev_num;
> 
> The number of subdevs can't be negative, could this be unsigned ?

yes, here it makes sense. a simple

	int i;
	for (i = 0; i < N; i++)
		...

is just not worth it imho :)

> > +	struct v4l2_async_subdev **subdev;
> > +	struct v4l2_device *v4l2_dev;
> > +	struct list_head waiting;
> > +	struct list_head done;
> > +	struct list_head list;
> > +	int (*bound)(struct v4l2_async_notifier *notifier,
> > +		     struct v4l2_async_subdev_list *asdl);
> > +	int (*complete)(struct v4l2_async_notifier *notifier);
> > +	void (*unbind)(struct v4l2_async_notifier *notifier,
> > +		       struct v4l2_async_subdev_list *asdl);
> > +};
> > +
> > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > +				 struct v4l2_async_notifier *notifier);
> > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
> > +int v4l2_async_register_subdev(struct v4l2_async_subdev_list *asdl);
> > +void v4l2_async_unregister_subdev(struct v4l2_async_subdev_list *asdl);
> 
> Renaming v4l2_async_(un)register_subdev to v4l2_(un)register_subdev might be a 
> good idea at some point, we can fix that later.

maybe

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
