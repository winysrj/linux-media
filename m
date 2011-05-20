Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33280 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab1ETH3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 03:29:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev
 =?iso-8859-1?q?registration=09function?=
Date: Fri, 20 May 2011 09:29:32 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com> <4DD614DC.3070905@samsung.com>
In-Reply-To: <4DD614DC.3070905@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105200929.33226.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Friday 20 May 2011 09:14:36 Sylwester Nawrocki wrote:
> On 05/19/2011 08:34 PM, Laurent Pinchart wrote:
> > The new v4l2_new_subdev_board() function creates and register a subdev
> > based on generic board information. The board information structure
> > includes a bus type and bus type-specific information.
> > 
> > Only I2C and SPI busses are currently supported.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/v4l2-common.c |   70
> >  +++++++++++++++++++++++++++++++++++++ drivers/media/video/v4l2-device.c
> >  |    8 ++++
> >  include/media/v4l2-common.h       |   28 +++++++++++++++
> >  include/media/v4l2-subdev.h       |    3 ++
> >  4 files changed, 109 insertions(+), 0 deletions(-)
> > 
> > Hi everybody,
> > 
> > This approach has been briefly discussed during the Warsaw V4L meeting.
> > Now that support for platform subdevs has been requested, I'd like to
> > move bus type handling to the V4L2 core instead of duplicating the logic
> > in every driver. As usual, comments will be appreciated.
> 
> Thanks for taking care of this.

You're welcome. Thanks for the review.

> > diff --git a/drivers/media/video/v4l2-common.c
> > b/drivers/media/video/v4l2-common.c index 06b9f9f..46aee94 100644
> > --- a/drivers/media/video/v4l2-common.c
> > +++ b/drivers/media/video/v4l2-common.c
> > @@ -474,6 +474,76 @@ EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
> > 
> >  #endif /* defined(CONFIG_SPI) */
> > 
> > +/*
> > + * v4l2_new_subdev_board - Register a subdevice based on board
> > information + * @v4l2_dev: Parent V4L2 device
> > + * @info: I2C subdevs board information array
> 
> "info" doesn't appear to be a (I2C subdevs) array.

Oops, I'll fix it.

> > + *
> > + * Register a subdevice identified by a geenric board information
> > structure. The
> 
> s/geenric/generic ?

Ditto.

> > + * structure contains the bus type and bus type-specific information.
> > + *
> > + * Return a pointer to the subdevice if registration was successful, or
> > NULL + * otherwise.
> > + */
> > +struct v4l2_subdev *v4l2_new_subdev_board(struct v4l2_device *v4l2_dev,
> > +		struct v4l2_subdev_board_info *info)
> > +{
> > +	struct v4l2_subdev *subdev;
> > +
> > +	switch (info->type) {
> > +#if defined(CONFIG_I2C)
> > +	case V4L2_SUBDEV_BUS_TYPE_I2C: {
> > +		struct i2c_adapter *adapter;
> > +
> > +		adapter = i2c_get_adapter(info->info.i2c.i2c_adapter_id);
> > +		if (adapter == NULL) {
> > +			printk(KERN_ERR "%s: Unable to get I2C adapter %d for "
> > +				"device %s/%u\n", __func__,
> > +				info->info.i2c.i2c_adapter_id,
> > +				info->info.i2c.board_info->type,
> > +				info->info.i2c.board_info->addr);
> > +			return NULL;
> > +		}
> > +
> > +		subdev = v4l2_i2c_new_subdev_board(v4l2_dev, adapter,
> > +					info->info.i2c.board_info, NULL);
> > +		if (subdev == NULL) {
> > +			i2c_put_adapter(adapter);
> > +			return NULL;
> > +		}
> > +
> > +		subdev->flags |= V4L2_SUBDEV_FL_RELEASE_ADAPTER;
> > +		break;
> > +	}
> > +#endif /* defined(CONFIG_I2C) */
> > +#if defined(CONFIG_SPI)
> > +	case V4L2_SUBDEV_BUS_TYPE_SPI: {
> > +		struct spi_master *master;
> > +
> > +		master = spi_busnum_to_master(info->info.spi->bus_num);
> > +		if (master == NULL) {
> > +			printk(KERN_ERR "%s: Unable to get SPI master %u for "
> > +				"device %s/%u\n", __func__,
> > +				info->info.spi->bus_num,
> > +				info->info.spi->modalias,
> > +				info->info.spi->chip_select);
> > +			return NULL;
> > +		}
> > +
> > +		subdev = v4l2_spi_new_subdev(v4l2_dev, master, info->info.spi);
> > +		spi_master_put(master);
> > +		break;
> > +	}
> > +#endif /* defined(CONFIG_SPI) */
> > +	default:
> > +		subdev = NULL;
> > +		break;
> > +	}
> > +
> > +	return subdev;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_new_subdev_board);
> 
> I'm just wondering, while we are at it, if it would be worth to try to make
> v4l2_i2c_new_subdev_board() and v4l2_spi_new_subdev() race-free. There has
> been an attempt from Guennadi side to solve this issue,
> http://thread.gmane.org/gmane.linux.kernel/1069603
> After request_module there is nothing preventing subdev's driver module to
> be unloaded and thus it is not safe to dereference dev->driver->owner.

Please see below.

> > +
> > 
> >  /* Clamp x to be between min and max, aligned to a multiple of 2^align. 
> >  min
> >  
> >   * and max don't have to be aligned, but there must be at least one
> >   valid * value.  E.g., min=17,max=31,align=4 is not allowed as there
> >   are no multiples
> > 
> > diff --git a/drivers/media/video/v4l2-device.c
> > b/drivers/media/video/v4l2-device.c index 4aae501..cfd9caf 100644
> > --- a/drivers/media/video/v4l2-device.c
> > +++ b/drivers/media/video/v4l2-device.c
> > @@ -246,5 +246,13 @@ void v4l2_device_unregister_subdev(struct
> > v4l2_subdev *sd)
> > 
> >  #endif
> >  
> >  	video_unregister_device(&sd->devnode);
> >  	module_put(sd->owner);
> > 
> > +
> > +#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) &&
> > defined(MODULE)) +	if ((sd->flags & V4L2_SUBDEV_FL_IS_I2C) &&
> > +	    (sd->flags & V4L2_SUBDEV_FL_RELEASE_ADAPTER)) {
> > +		struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +		i2c_put_adapter(client->adapter);
> > +	}
> > +#endif
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> > 
> > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> > index a298ec4..88c38d9 100644
> > --- a/include/media/v4l2-common.h
> > +++ b/include/media/v4l2-common.h
> > @@ -171,6 +171,34 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd,
> > struct spi_device *spi,
> > 
> >  		const struct v4l2_subdev_ops *ops);
> >  
> >  #endif
> > 
> > +/*
> > ------------------------------------------------------------------------
> > -- */ +
> > +/* Generic helper functions */
> > +
> > +struct v4l2_subdev_i2c_board_info {
> > +	struct i2c_board_info *board_info;
> > +	int i2c_adapter_id;
> > +};
> > +
> > +enum v4l2_subdev_bus_type {
> > +	V4L2_SUBDEV_BUS_TYPE_NONE,
> > +	V4L2_SUBDEV_BUS_TYPE_I2C,
> > +	V4L2_SUBDEV_BUS_TYPE_SPI,
> > +};
> 
> I had an issue when tried to call request_module, to register subdev of
> platform device type, in probe() of other platform device. Driver's
> probe() for devices belonging same bus type cannot be nested as the bus
> lock is taken by the driver core before entering probe(), so this would
> lead to a deadlock.
> That exactly happens in __driver_attach().
> 
> For the same reason v4l2_new_subdev_board could not be called from probe()
> of devices belonging to I2C or SPI bus, as request_module is called inside
> of it. I'm not sure how to solve it, yet:)

Ouch. I wasn't aware of that issue. Looks like it's indeed time to fix the 
subdev registration issue, including the module load race condition. Michael, 
you said you have a patch to add platform subdev support, how have you avoided 
the race condition ?

I've been thinking for some time now about removing the module load code 
completely. I2C, SPI and platform subdevs would be registered either by board 
code (possibly through the device tree on platforms that suppport it) for 
embedded platforms, and by host drivers for pluggable hardware (PCI and USB). 
Module loading would be handled automatically by the kernel module auto 
loader, but asynchronously instead of synchronously. Bus notifiers would then 
be used by host drivers to wait for all subdevs to be registered.

I'm not sure yet if this approach is viable. Hans, I think we've briefly 
discussed this (possible quite a long time ago), do you have any opinion ? 
Guennadi, based on your previous experience trying to use bus notifiers to 
solve the module load race, what do you think about the idea ? Others, please 
comment as well :-)
 
> > +
> > +struct v4l2_subdev_board_info {
> > +	enum v4l2_subdev_bus_type type;
> > +	union {
> > +		struct v4l2_subdev_i2c_board_info i2c;
> > +		struct spi_board_info *spi;
> > +	} info;
> > +};
> > +
> > +/* Create a subdevice and load its module. The info argumentidentifies
> > the + * subdev bus type and the bus type-specific information. */
> > +struct v4l2_subdev *v4l2_new_subdev_board(struct v4l2_device *v4l2_dev,
> > +		struct v4l2_subdev_board_info *info);
> > +
> > 
> >  /*
> >  -----------------------------------------------------------------------
> >  -- */
> >  
> >  /* Note: these remaining ioctls/structs should be removed as well, but
> >  they are
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 1562c4f..bc1c4d8 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -483,6 +483,9 @@ struct v4l2_subdev_internal_ops {
> > 
> >  #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
> >  /* Set this flag if this subdev generates events. */
> >  #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
> > 
> > +/* Set by the core if the bus adapter needs to be released. Do NOT use
> > in + * drivers. */
> > +#define V4L2_SUBDEV_FL_RELEASE_ADAPTER		(1U << 4)
> > 
> >  /* Each instance of a subdev driver should create this struct, either
> >  
> >     stand-alone or embedded in a larger struct.
-
-- 
Regards,

Laurent Pinchart
