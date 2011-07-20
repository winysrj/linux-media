Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55801 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GTIWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 04:22:23 -0400
Date: Wed, 20 Jul 2011 11:22:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	m.szyprowski@samsung.com, g.liakhovetski@gmx.de
Subject: Re: [RFC] Media devices, V4L2 subdevs and Linux device model
Message-ID: <20110720082217.GD29320@valkosipuli.localdomain>
References: <20110711161535.GI22072@valkosipuli.localdomain>
 <201107151334.55408.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107151334.55408.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 15, 2011 at 01:34:55PM +0200, Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

Many thanks for the comments!

> On Monday 11 July 2011 18:17:10 Sakari Ailus wrote:
> > 
> > The way devices, V4L2 subdevs and media devices are currently being handled
> > does not make efficient use of the Linux device model. We have dependencies
> > which we are handling in a way or another, usually not in a very generic
> > way.
> > 
> > I came to think of sub-subdevs recently, and implementing them, but
> > before that Laurent suggested that V4L2 should be better aligned with
> > the Linux device model, which I can't deny.
> > 
> > I don't know the Linux device model very well, so what I did was that I
> > collected a summary of the current situation. That may be found below.
> > 
> > Comments are very, very welcome.
> > 
> > 
> > struct video_device
> > ===================
> > 
> > struct video_device represents the character device, either a V4L2
> > device node or a V4L2 subdev device node. entity is the entity in the
> > subdev graph, and for V4L2 this is the device node.
> 
> I assume you're talking about video_device::entity. To be exact, that field 
> represents the entity in the media device graph associated with the V4L2 
> device node, and isn't used for subdevice devnodes.
> 
> The usage of video_device to create subdevice devnodes leads to confusion in 
> my opinion. I've initially proposed to split video_device into a v4l2_devnode 
> and a video_device structure, but that was rejected.

I agree this is confusing. It's not self-evident which of the fields in
video_device are being used and which are not.

> > A new struct device, dev, is created and it is given a name which
> > corresponds to the type of the device, e.g. video0 or v4l-subdev0, and
> > it's registered using device_register().
> > 
> > OMAP3ISP driver uses the same v4l2_dev for every struct video_device it
> > has to represent video nodes, so parent is NULL. It assigns
> > video_device_release_empty() as the release function pointer.
> > 
> > struct video_device {
> > #ifdef CONFIG_MEDIA_CONTROLLER
> > 	struct media_entity entity;
> > #endif
> > 	struct device dev;
> > 
> > 	/* Either one of these two may be set. */
> > 	struct device *parent;
> > 	struct v4l2_device *v4l2_dev;
> > 
> > 	int (*release)(struct video_device *);
> > };
> > 
> > struct v4l2_device
> > ==================
> > 
> > struct v4l2_device is a V4L2 equivalent to more generic media_device.
> > There's one per each driver that implements a media device (or in case
> > of absence of one, a device which implements V4L2 video devices).
> > 
> > struct v4l2_device {
> > 	struct device *dev;
> > #ifdef CONFIG_MEDIA_CONTROLLER
> > 	struct media_device *mdev;
> > #endif
> > 	struct list_head subdevs;
> > };
> > 
> > struct v4l2_subdev
> > ==================
> > 
> > struct v4l2_subdev {
> > #ifdef CONFIG_MEDIA_CONTROLLER
> > 	struct media_entity entity;
> > #endif
> > 	struct video_device devnode;
> > 	struct module *owner;
> > };
> > 
> > struct media_device
> > ===================
> > 
> > struct media_device {
> > 	struct media_devnode devnode;
> > 	struct list_head entities;
> > };
> > 
> > struct media_entity
> > ===================
> > 
> > struct media_entity {
> > 	struct media_device *parent;
> > };
> > 
> > struct media_devnode
> > ====================
> > 
> > struct media_devnode {
> > 	struct device dev;              /* media device */
> > 	struct cdev cdev;               /* character device */
> > 	struct device *parent;          /* device parent */
> > };
> > 
> > 
> > Lifecycle of a media device
> > ===========================
> > 
> > The media device contains entities, which further, in V4L2, depend on V4L2
> > subdev or V4L2 video nodes. The media device, subdevs and video nodes have
> > a corresponding interface to user space. There is a v4l2_device which
> > corresponds to media device but is V4L2 specific.
> > 
> > 
> >                            media device
> >                           /            \
> >                     media_entity...  media_entity...
> > 
> >                      v4l2_subdev     video_device
> > 
> > 
> >                             v4l2_device
> >                            /           \
> >                  v4l2_subdev...    video_device...
> > 
> > 
> > 	Dots in the diagram means "zero or more" instead of "one".
> > 
> > 
> > The subdevs are initialised by their proper drivers using
> > v4l2_i2c_subdev_init() (for I2C subdevs) or v4l2_spi_subdev_init() (for
> > SPI subdevs). These functions will call v4l2_subdev_init(), set the
> > owner of the subdev to the owner of the I2C client (or SPI device)
> > driver's owner and make both subdev reachable from I2C client and the
> > other way around by setting private pointers point to the other one.
> > 
> > If the subdevs are part of the driver which implements the
> > media_device, the initialisation is slightly different. Instead of being
> > able to rely on either of the current bus specific subdev_init() functions,
> > the driver directly calls v4l2_subdev_init() and does the rest of the
> > required setup. The owner field will be left to NULL.
> > 
> > The media entity for the subdev will be initialised at this point by
> > media_entity_init().
> > 
> > Entities in video nodes are initialised by the driver using
> > media_entity_init() before being registered using video_register_device().
> > 
> > Then, the subdev is ready to be registered by
> > v4l2_device_register_subdev(), which calls try_module_get() on the subdev
> > owner. This is typically done by the media device when all the subdevs are
> > available. On subdevs which are owned by the media device the owner may be
> > null since for the media device use count is incremented in
> > media_entity_get(), called by v4l2_open(). v4l2_device_register_subdev()
> > will also register the media entity to the media device.
> > 
> > This means that while no nodes are open, the use counts of the modules are
> > 0 for the module which implements the media device and 1 for the rest.
> > 
> > Now the subdev nodes can be created using
> > v4l2_device_register_subdev_nodes() for the subdevs which implement them.
> > v4l2_device_register_subdev_nodes() calls __video_register_device() to
> > create the actual device nodes.
> > 
> > Subdevs are de-registered when the module which implements the media_device
> > is unloaded. At this point, the device must have no users. The cleanup
> > starts with media entities, when their links data structures are freed.
> > Next, the subdevs are unregistered by v4l2_device_unregister_subdev(): the
> > subdev's media entity is disconnected from the media device by setting
> > media_entity->parent to NULL, its device node is released and the owner
> > module use count is decremented. Finally the v4l2_device and media device
> > are unregistered.
> > 
> > 
> > Issues
> > ======
> > 
> > What issues do we have currently? There are hints that not everything is as
> > it should be, such as this one:
> > 
> > <URL:http://www.spinics.net/lists/linux-media/msg34085.html>
> > 
> > The media entity is disconnected from the media device before the last
> > media_entity_put() called. This causes a null pointer dereference in
> > media_entity_put() since entity->parent == NULL.
> > 
> > Add support for subdevs to the aforementioned uvcvideo driver, and we
> > should have back the same situation which the patch was addressing.
> 
> The uvcvideo driver already has subdevs. It has no subdev devnodes though.

Thanks for the clarification.

> > The existence of subdevs naturally depends on the modules which implement
> > them, but this isn't the whole truth. Subdevs often depend on the
> > associated ISP (or bridge) which implements the media_device for their
> > functionality. This is why the media_entity_get() increments the use count
> > of the media device owner module.
> > 
> > For example, the ISP may provide a clock signal to the sensor. This is
> > very common in embedded devices. In the end, such clocks should be usable
> > through the clock framework. On e.g. OMAP 3 two clocks are produced by the
> > ISP rather than the PRCM block, but only the clocks derived from the PRCM
> > are supported (AFAIK).
> 
> Some of our subdevs currently call to the bridge through board code. 
> Configuring the OMAP3 ISP clocks is one such use case. This leads to complex 
> dependencies and lots of race conditions.

This is very true.

> > Next steps
> > ==========
> > 
> > What would be the right way to fix these issues?
> > 
> > kref reference counting could be introduced in relevant structures with the
> > addition of a proper release callback. At least media_entity should likely
> > get one. An actual data structure might be struct device instead of struct
> > kref or struct kobject, which would make the entities also visible in
> > sysfs.
> 
> Entities are not devices. I'm strongly opposed to that.

To get media_entity, one should device_get() the underlying device then,
right?

> > This would allow tearing down the data structures at a time when they no
> > longer are required.
> > 
> > Also, device_get() should be called on media device and media entity in
> > media_entity_get().
> 
> media_entity_get() is a hack. I would much rather see it die than being 
> extended.

Code which is dealing with media entities must have a way to pin them down
when it finds them in the media device graph. That's what media_entity_get()
is for. The implementation may be something different in the future, though.

It's true that an actual device which implements the media entity may
disappear, and for this purpose the data structures should be only freed
when the last user is gone.

> > Currently the function only increments the module use count of the
> > associated media device.
> 
> We should get rid of that. This would require disallowing all callbacks to the 
> bridge through board code, but I'm not sure if that would be enough. Clocks 
> could be handled using the clock framework, once it will be generic enough 
> (this is being worked on). I'm not sure what other requirements we have (or 
> might have in the future) that would make this difficult.

This might not be a small task.

The clock framework implementations across different ARM sub-archs are
different even if the interface is the same, if I remember correctly.

> > Final tearing of the connection between a media device and a media entity
> > would only happen when the last reference to the media device has gone away.
> > 
> > The module use cound handling could be just good as it is right now.
> 
> To (try to) answer the question we need a much better understanding of the 
> current situation, including all dependencies between modules and detailed 
> lifetime information of all actors involved (in response to open/close calls, 
> module load/unload and device connect/disconnect events).

Agreed. Due to the dependencies from e.g. sensors to bridge functionality
which do not use proper generic interfaces, the actual implementation may
happen in several steps. I think removing dependencies handled through the
board code between e.g. sensors and bridge should still be the goal. There
are still subtle hardware oddities on some boards which may make this
difficult in a general case.

-- 
Sakari Ailus
sakari.ailus@iki.fi
