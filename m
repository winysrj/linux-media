Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASNZxjo030957
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 18:35:59 -0500
Received: from mailrelay008.isp.belgacom.be (mailrelay008.isp.belgacom.be
	[195.238.6.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASNYc76005705
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 18:34:39 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sat, 29 Nov 2008 00:34:44 +0100
References: <200811242309.37489.hverkuil@xs4all.nl>
	<5d5443650811242327gc204050lf232dfac48ae4f1@mail.gmail.com>
	<200811251848.09593.hverkuil@xs4all.nl>
In-Reply-To: <200811251848.09593.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811290034.44340.laurent.pinchart@skynet.be>
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 1/3)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Hans,

On Tuesday 25 November 2008, Hans Verkuil wrote:
> As requested, the patches as separate posts for review.
>
> 	Hans
>
> # HG changeset patch
> # User Hans Verkuil <hverkuil@xs4all.nl>
> # Date 1227560990 -3600
> # Node ID d9ec70c0b0c55e18813f91218c6da6212ca9b7e6
> # Parent b63737bf9eef1ff8494cb7fbc2e818e6aff7a34f
> v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
>
> From: Hans Verkuil <hverkuil@xs4all.nl>
>
> Start implementing a proper v4l2 framework as discussed during the
> Linux Plumbers Conference 2008.
>
> Introduces v4l2_device (for device instances) and v4l2_subdev (representing
> sub-device instances).
>
> Priority: normal
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Comments inlined. I've reviewed the general approach only, so there might be 
some small issues at the code level that I haven't noticed.

Would you mind holding the push request until we're done discussing the points 
I mention throughout this e-mail ?

> --- a/linux/drivers/media/video/Makefile	Mon Nov 24 10:51:20 2008 -0200
> +++ b/linux/drivers/media/video/Makefile	Mon Nov 24 22:09:50 2008 +0100
> @@ -8,7 +8,7 @@ msp3400-objs	:=	msp3400-driver.o msp3400
>
>  stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>
> -videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o
> +videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o
>
>  obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-compat-ioctl32.o
> v4l2-int-device.o
>
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/Documentation/video4linux/v4l2-framework.txt	Mon Nov 24
> 22:09:50 2008 +0100 @@ -0,0 +1,360 @@
> +Overview of the V4L2 driver framework
> +=====================================
> +
> +This text documents the various structures provided by the V4L2 framework
> and +their relationships.
> +
> +
> +Introduction
> +------------
> +
> +The V4L2 drivers tend to be very complex due to the complexity of the
> +hardware: most devices have multiple ICs, export multiple device nodes in
> +/dev, and create also non-V4L2 devices such as DVB, ALSA, FB, I2C and
> input +(IR) devices.
> +
> +Especially the fact that V4L2 drivers have to setup supporting ICs to
> +do audio/video muxing/encoding/decoding makes it more complex than most.
> +Usually these ICs are connected to the main bridge driver through one or
> +more I2C busses, but other busses can also be used. Such devices are
> +called 'sub-devices'.

Do you know of other busses being used in (Linux supported) real video 
hardware, or is it currently theoretical only ?

> +For a long time the framework was limited to the video_device struct for
> +creating V4L device nodes and video_buf for handling the video buffers
> +(note that this document does not discuss the video_buf framework).
> +
> +This meant that all drivers had to do the setup of device instances and
> +connecting to sub-devices themselves. Some of this is quite complicated
> +to do right and many drivers never did do it correctly.
> +
> +There is also a lot of common code that could never be refactored due to
> +the lack of a framework.
> +
> +So this framework sets up the basic building blocks that all drivers
> +need and this same framework should make it much easier to refactor
> +common code into utility functions shared by all drivers.
> +
> +
> +Structure of a driver
> +---------------------
> +
> +All drivers have the following structure:
> +
> +1) A struct for each device instance containing the device state.
> +
> +2) A way of initializing and commanding sub-devices.

This only applies to drivers handling "composite devices" (systems including 
sub-devices). Let's make sure the proposed framework doesn't make "simple 
devices" more complex to handle that they are now.

> +3) Creating V4L2 device nodes (/dev/videoX, /dev/vbiX, /dev/radioX and
> +   /dev/vtxX) and keeping track of device-node specific data.
> +
> +4) Filehandle-specific structs containing per-filehandle data.
> +
> +This is a rough schematic of how it all relates:
> +
> +    device instances
> +      |
> +      +-sub-device instances
> +      |
> +      \-V4L2 device nodes
> +	  |
> +	  \-filehandle instances
> +
> +
> +Structure of the framework
> +--------------------------
> +
> +The framework closely resembles the driver structure: it has a v4l2_device
> +struct for the device instance data, a v4l2_subdev struct to refer to
> +sub-device instances, the video_device struct stores V4L2 device node data
> +and a v4l2_fh struct keeps track of filehandle instances (TODO: not yet
> +implemented).
> +
> +
> +struct v4l2_device
> +------------------
> +
> +Each device instance is represented by a struct v4l2_device
> (v4l2-device.h). +Very simple devices can just allocate this struct, but
> most of the time you +would embed this struct inside a larger struct.
> +
> +You must register the device instance:
> +
> +	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
> +
> +Registration will initialize the v4l2_device struct and link
> dev->platform_data +to v4l2_dev.

That's an abuse of platform_data, I don't think it was ever meant that way.

> Registration will also set v4l2_dev->name 
> to a value derived from +dev (driver name followed by the bus_id, to be
> precise). You may change the +name after registration if you want.
> +
> +You unregister with:
> +
> +	v4l2_device_unregister(struct v4l2_device *v4l2_dev);
> +
> +Unregistering will also automatically unregister all subdevs from the
> device. +
> +Sometimes you need to iterate over all devices registered by a specific
> +driver. This is usually the case if multiple device drivers use the same
> +hardware. E.g. the ivtvfb driver is a framebuffer driver that uses the
> ivtv +hardware. The same is true for alsa drivers for example.
> +
> +You can iterate over all registered devices as follows:
> +
> +static int callback(struct device *dev, void *p)
> +{
> +	struct v4l2_device *v4l2_dev = dev->platform_data;
> +
> +	/* test if this device was inited */
> +	if (v4l2_dev == NULL)
> +		return 0;
> +	...
> +	return 0;
> +}
> +
> +int iterate(void *p)
> +{
> +	struct device_driver *drv;
> +	int err;
> +
> +	/* Find driver 'ivtv' on the PCI bus.
> +	   pci_bus_type is a global. For USB busses use usb_bus_type. */
> +	drv = driver_find("ivtv", &pci_bus_type);
> +	/* iterate over all ivtv device instances */
> +	err = driver_for_each_device(drv, NULL, p, callback);
> +	put_driver(drv);
> +	return err;
> +}

I'm not sure to really see what use cases you're talking about. The above code 
looks good, but iterating over device bound to specific drivers should be 
done with care as it might be the sign of badly designed code. Every new 
instance of the above code should be reviewed with care.

> +Sometimes you need to keep a running counter of the device instance. This
> is +commonly used to map a device instance to an index of a module option
> array. +
> +The recommended approach is as follows:
> +
> +static atomic_t drv_instance = ATOMIC_INIT(0);
> +
> +static int __devinit drv_probe(struct pci_dev *dev,
> +				const struct pci_device_id *pci_id)
> +{
> +	...
> +	state->instance = atomic_inc_return(&drv_instance) - 1;
> +}
> +
> +
> +struct v4l2_subdev
> +------------------
> +
> +Many drivers need to communicate with sub-devices. These devices can do
> all +sort of tasks, but most commonly they handle audio and/or video
> muxing, +encoding or decoding. For webcams common sub-devices are sensors
> and camera +controllers.
> +
> +Usually these are I2C devices, but not necessarily. In order to provide
> the +driver with a consistent interface to these sub-devices the
> v4l2_subdev struct +(v4l2-subdev.h) was created.
> +
> +Each sub-device driver must have a v4l2_subdev struct. This struct can be
> +stand-alone for simple sub-devices or it might be embedded in a larger
> struct +if more state information needs to be stored. Usually there is a
> low-level +device struct (e.g. i2c_client) that contains the device data as
> setup +by the kernel. It is recommended to store that pointer in the
> private +data of v4l2_subdev using v4l2_set_subdevdata(). That makes it
> easy to go +from a v4l2_subdev to the actual low-level bus-specific device
> data. +
> +You also need a way to go from the low-level struct to v4l2_subdev. For
> the +common i2c_client struct the i2c_set_clientdata() call is used to
> store a +v4l2_subdev pointer, for other busses you may have to use other
> methods. +
> +From the bridge driver perspective you load the sub-device module and
> somehow +obtain the v4l2_subdev pointer. For i2c devices this is easy: you
> call +i2c_get_clientdata(). For other busses something similar needs to be
> done. +Helper functions exists for sub-devices on an I2C bus that do most
> of this +tricky work for you.
> +
> +Each v4l2_subdev contains function pointers that sub-device drivers can
> +implement (or leave NULL if it is not applicable). Since sub-devices can
> do +so many different things and you do not want to end up with a huge ops
> struct +of which only a handful of ops are commonly implemented, the
> function pointers +are sorted according to category and each category has
> its own ops struct. +

I like that.

> +The top-level ops struct contains pointers to the category ops structs,
> which +may be NULL if the subdev driver does not support anything from that
> category. +
> +It looks like this:
> +
> +struct v4l2_subdev_core_ops {
> +	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_chip_ident
> *chip); +	int (*log_status)(struct v4l2_subdev *sd);
> +	int (*init)(struct v4l2_subdev *sd, u32 val);
> +	...
> +};
> +
> +struct v4l2_subdev_tuner_ops {
> +	...
> +};
> +
> +struct v4l2_subdev_audio_ops {
> +	...
> +};
> +
> +struct v4l2_subdev_video_ops {
> +	...
> +};
> +
> +struct v4l2_subdev_ops {
> +	const struct v4l2_subdev_core_ops  *core;
> +	const struct v4l2_subdev_tuner_ops *tuner;
> +	const struct v4l2_subdev_audio_ops *audio;
> +	const struct v4l2_subdev_video_ops *video;
> +};
> +
> +The core ops are common to all subdevs, the other categories are
> implemented +depending on the sub-device. E.g. a video device is unlikely
> to support the +audio ops and vice versa.
> +
> +This setup limits the number of function pointers while still making it
> easy +to add new ops and categories.
> +
> +A sub-device driver initializes the v4l2_subdev struct using:
> +
> +	v4l2_subdev_init(subdev, &ops);
> +
> +Afterwards you need to initialize subdev->name with a unique name and set
> the +module owner. This is done for you if you use the i2c helper
> functions. +
> +A device (bridge) driver needs to register the v4l2_subdev with the
> +v4l2_device:
> +
> +	int err = v4l2_device_register_subdev(device, subdev);
> +
> +This can fail if the subdev module disappeared before it could be
> registered. +After this function was called successfully the subdev->dev
> field points to +the v4l2_device.
> +
> +You can unregister a sub-device using:
> +
> +	v4l2_device_unregister_subdev(subdev);
> +
> +Afterwards the subdev module can be unloaded and subdev->dev == NULL.
> +
> +You can call an ops function either directly:
> +
> +	err = subdev->ops->core->g_chip_ident(subdev, &chip);
> +
> +but it is better and easier to use this macro:
> +
> +	err = v4l2_subdev_call(subdev, core, g_chip_ident, &chip);
> +
> +The macro will to the right NULL pointer checks and returns -ENODEV if
> subdev +is NULL,

This should probably be checked when registering the sub-device instead of at 
all calls to sub-device operations.

> -ENOIOCTLCMD if either subdev->core or 
> subdev->core->g_chip_ident is +NULL, or the actual result of the
> subdev->ops->core->g_chip_ident ops. +
> +It is also possible to call all or a subset of the sub-devices:
> +
> +	v4l2_device_call_all(dev, 0, core, g_chip_ident, &chip);
> +
> +Any subdev that does not support this ops is skipped and error results are
> +ignored. If you want to check for errors use this:
> +
> +	err = v4l2_device_call_until_err(dev, 0, core, g_chip_ident, &chip);
> +
> +Any error except -ENOIOCTLCMD will exit the loop with that error. If no
> +errors (except -ENOIOCTLCMD) occured, then 0 is returned.
> +
> +The second argument to both calls is a group ID. If 0, then all subdevs
> are +called. If non-zero, then only those whose group ID match that value
> will +be called. Before a bridge driver registers a subdev it can set
> subdev->grp_id +to whatever value it wants (it's 0 by default). This value
> is owned by the +bridge driver and the sub-device driver will never modify
> or use it. +
> +The group ID gives the bridge driver more control how callbacks are
> called. +For example, there may be multiple audio chips on a board, each
> capable of +changing the volume. But usually only one will actually be used
> when the +user want to change the volume. You can set the group ID for that
> subdev to +e.g. AUDIO_CONTROLLER and specify that as the group ID value
> when calling +v4l2_device_call_all(). That ensures that it will only go to
> the subdev +that needs it.

This is interesting as well.

> +The advantage of using v4l2_subdev is that it is a generic struct and does
> +not contain any knowledge about the underlying hardware. So a driver might
> +contain several subdevs that use an I2C bus, but also a subdev that is
> +controlled through GPIO pins. This distinction is only relevant when
> setting +up the device, but once the subdev is registered it is completely
> transparent. +

The bridge driver won't have to care about how sub-devices are accessed, but 
sub-devices drivers will have to be written specifically for the V4L2 
subsystem. Do we have I2C devices shared between V4L(2) and DVB (and possible 
other subsystems) ? How would those be handled ? If your goal is to share 
v4l2_subdev drivers between V4L(2) and DVB I don't think the v4l2_ prefix is 
right.

> +I2C sub-device drivers
> +----------------------
> +
> +Since these drivers are so common, special helper functions are available
> to +ease the use of these drivers (v4l2-common.h).
> +
> +The recommended method of adding v4l2_subdev support to an I2C driver is
> to +embed the v4l2_subdev struct into the state struct that is created for
> each +I2C device instance. Very simple devices have no state struct and in
> that case +you can just create a v4l2_subdev directly.

The only I2C video-related chips I've dealt with were the ones used by 
DC10/DC10+ boards and those have no state struct. What is the state struct in 
your description ? Is it the driver-specific data allocated when the device 
is probed ?

> +Initialize the v4l2_subdev struct as follows:
> +
> +	v4l2_i2c_subdev_init(&state->sd, client, subdev_ops);
> +
> +This function will fill in all the fields of v4l2_subdev and ensure that
> the +v4l2_subdev and i2c_client both point to one another.
> +
> +You should also add a helper inline function to go from a v4l2_subdev
> pointer +to the state struct:
> +
> +static inline struct subdev_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct subdev_state, sd);
> +}

<chipname>_state might be a better name, it would avoid namespace clashes (I'm 
aware the state structure is supposed to be private to the I2C device driver, 
but we never know what might happen).

> +Use this to go from the v4l2_subdev struct to the i2c_client struct:
> +
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +And this to go from an i2c_client to a v4l2_subdev struct:
> +
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +Finally you need to make a command function to make driver->command()
> +call the right subdev_ops functions:
> +
> +static int subdev_command(struct i2c_client *client, unsigned cmd, void
> *arg) +{
> +	return v4l2_subdev_command(i2c_get_clientdata(client), cmd, arg);
> +}
> +
> +If driver->command is never used then you can leave this out. Eventually
> the +driver->command usage should be removed from v4l.

Should it then be added to the list of features scheduled for removal ?

> +Make sure to call v4l2_device_unregister_subdev(sd) when the remove()
> callback +is called. This will unregister the sub-device from the bridge
> driver. It is +safe to call this even if the sub-device was never
> registered.
> +
> +
> +The bridge driver also has some helper functions it can use:
> +
> +struct v4l2_subdev *sd = v4l2_i2c_new_subdev(adapter, "module_foo",
> "chipid", 0x36); +
> +This loads the given module (can be NULL if no module needs to be loaded)
> and +calls i2c_new_device() with the given i2c_adapter and chip/address
> arguments. +If all goes well, then it registers the subdev with the
> v4l2_device. It gets +the v4l2_device by calling i2c_get_adapdata(adapter),
> so you should make sure +that adapdata is set to v4l2_device when you setup
> the i2c_adapter in your +driver.
> +
> +You can also use v4l2_i2c_new_probed_subdev() which is very similar to
> +v4l2_i2c_new_subdev(), except that it has an array of possible I2C
> addresses +that it should probe. Internally it calls
> i2c_new_probed_device(). +
> +Both functions return NULL if something went wrong.
> +
> +
> +struct video_device
> +-------------------
> +
> +TODO: document.

Do you plan to change the video_device structure ?

> +
> +struct v4l2_fh
> +--------------
> +
> +TODO: document.

I can't find that structure anywhere in your patches. Shouldn't it be removed 
from the document and added back when you introduce it ?

> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/v4l2-device.c	Mon Nov 24 22:09:50 2008
> +0100 @@ -0,0 +1,80 @@
> +/*
> +    V4L2 device support.
> +
> +    Copyright (C) 2008  Hans Verkuil <hverkuil@xs4all.nl>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +
> +void v4l2_device_register(struct device *dev, struct v4l2_device
> *v4l2_dev) +{
> +	BUG_ON(!dev || !v4l2_dev || dev->platform_data);
> +	INIT_LIST_HEAD(&v4l2_dev->subdevs);
> +	mutex_init(&v4l2_dev->lock);
> +	v4l2_dev->dev = dev;
> +	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %s",
> +			dev->driver->name, dev->bus_id);
> +	dev->platform_data = v4l2_dev;
> +}
> +EXPORT_SYMBOL(v4l2_device_register);
> +
> +void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
> +{
> +	struct v4l2_subdev *sd, *next;
> +
> +	BUG_ON(!v4l2_dev || !v4l2_dev->dev || !v4l2_dev->dev->platform_data);
> +	v4l2_dev->dev->platform_data = NULL;
> +	/* unregister subdevs */
> +	list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list)
> +		v4l2_device_unregister_subdev(sd);
> +
> +	v4l2_dev->dev = NULL;
> +}
> +EXPORT_SYMBOL(v4l2_device_unregister);
> +
> +int v4l2_device_register_subdev(struct v4l2_device *dev, struct
> v4l2_subdev *sd) +{
> +	/* Check that sd->dev is not set and that the subdev's name is
> +	   filled in. */
> +	BUG_ON(!dev || !sd || sd->dev || !sd->name[0]);
> +	if (!try_module_get(sd->owner))
> +		return -ENODEV;
> +	sd->dev = dev;
> +	mutex_lock(&dev->lock);
> +	list_add_tail(&sd->list, &dev->subdevs);
> +	mutex_unlock(&dev->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_device_register_subdev);
> +
> +void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
> +{
> +	BUG_ON(!sd);
> +	/* return if it isn't registered */
> +	if (sd->dev == NULL)
> +		return;
> +	mutex_lock(&sd->dev->lock);
> +	list_del(&sd->list);
> +	mutex_unlock(&sd->dev->lock);
> +	sd->dev = NULL;
> +	module_put(sd->owner);
> +}
> +EXPORT_SYMBOL(v4l2_device_unregister_subdev);
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/v4l2-subdev.c	Mon Nov 24 22:09:50 2008
> +0100 @@ -0,0 +1,108 @@
> +/*
> +    V4L2 sub-device support.
> +
> +    Copyright (C) 2008  Hans Verkuil <hverkuil@xs4all.nl>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-subdev.h>
> +
> +int v4l2_subdev_command(struct v4l2_subdev *sd, unsigned cmd, void *arg)
> +{
> +	switch (cmd) {
> +	case VIDIOC_QUERYCTRL:
> +		return v4l2_subdev_call(sd, core, querymenu, arg);
> +	case VIDIOC_G_CTRL:
> +		return v4l2_subdev_call(sd, core, g_ctrl, arg);
> +	case VIDIOC_S_CTRL:
> +		return v4l2_subdev_call(sd, core, s_ctrl, arg);
> +	case VIDIOC_QUERYMENU:
> +		return v4l2_subdev_call(sd, core, queryctrl, arg);
> +	case VIDIOC_LOG_STATUS:
> +		return v4l2_subdev_call(sd, core, log_status);
> +	case VIDIOC_G_CHIP_IDENT:
> +		return v4l2_subdev_call(sd, core, g_chip_ident, arg);
> +	case VIDIOC_INT_S_STANDBY:
> +		return v4l2_subdev_call(sd, core, s_standby, *(u32 *)arg);
> +	case VIDIOC_INT_RESET:
> +		return v4l2_subdev_call(sd, core, reset, *(u32 *)arg);
> +	case VIDIOC_INT_S_GPIO:
> +		return v4l2_subdev_call(sd, core, s_gpio, *(u32 *)arg);
> +	case VIDIOC_INT_INIT:
> +		return v4l2_subdev_call(sd, core, init, *(u32 *)arg);
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	case VIDIOC_DBG_G_REGISTER:
> +		return v4l2_subdev_call(sd, core, g_register, arg);
> +	case VIDIOC_DBG_S_REGISTER:
> +		return v4l2_subdev_call(sd, core, s_register, arg);
> +#endif
> +
> +	case VIDIOC_INT_S_TUNER_MODE:
> +		return v4l2_subdev_call(sd, tuner, s_mode, *(enum v4l2_tuner_type
> *)arg); +	case AUDC_SET_RADIO:
> +		return v4l2_subdev_call(sd, tuner, s_radio);
> +	case VIDIOC_S_TUNER:
> +		return v4l2_subdev_call(sd, tuner, s_tuner, arg);
> +	case VIDIOC_G_TUNER:
> +		return v4l2_subdev_call(sd, tuner, g_tuner, arg);
> +	case VIDIOC_S_STD:
> +		return v4l2_subdev_call(sd, tuner, s_std, *(v4l2_std_id *)arg);
> +	case VIDIOC_S_FREQUENCY:
> +		return v4l2_subdev_call(sd, tuner, s_frequency, arg);
> +	case VIDIOC_G_FREQUENCY:
> +		return v4l2_subdev_call(sd, tuner, g_frequency, arg);
> +	case TUNER_SET_TYPE_ADDR:
> +		return v4l2_subdev_call(sd, tuner, s_type_addr, arg);
> +	case TUNER_SET_CONFIG:
> +		return v4l2_subdev_call(sd, tuner, s_config, arg);
> +
> +	case VIDIOC_INT_AUDIO_CLOCK_FREQ:
> +		return v4l2_subdev_call(sd, audio, s_clock_freq, *(u32 *)arg);
> +	case VIDIOC_INT_S_AUDIO_ROUTING:
> +		return v4l2_subdev_call(sd, audio, s_routing, arg);
> +	case VIDIOC_INT_I2S_CLOCK_FREQ:
> +		return v4l2_subdev_call(sd, audio, s_i2s_clock_freq, *(u32 *)arg);
> +
> +	case VIDIOC_INT_S_VIDEO_ROUTING:
> +		return v4l2_subdev_call(sd, video, s_routing, arg);
> +	case VIDIOC_INT_S_CRYSTAL_FREQ:
> +		return v4l2_subdev_call(sd, video, s_crystal_freq, arg);
> +	case VIDIOC_INT_DECODE_VBI_LINE:
> +		return v4l2_subdev_call(sd, video, decode_vbi_line, arg);
> +	case VIDIOC_INT_S_VBI_DATA:
> +		return v4l2_subdev_call(sd, video, s_vbi_data, arg);
> +	case VIDIOC_INT_G_VBI_DATA:
> +		return v4l2_subdev_call(sd, video, g_vbi_data, arg);
> +	case VIDIOC_S_FMT:
> +		return v4l2_subdev_call(sd, video, s_fmt, arg);
> +	case VIDIOC_G_FMT:
> +		return v4l2_subdev_call(sd, video, g_fmt, arg);
> +	case VIDIOC_INT_S_STD_OUTPUT:
> +		return v4l2_subdev_call(sd, video, s_std_output, *(v4l2_std_id *)arg);
> +	case VIDIOC_STREAMON:
> +		return v4l2_subdev_call(sd, video, s_stream, 1);
> +	case VIDIOC_STREAMOFF:
> +		return v4l2_subdev_call(sd, video, s_stream, 0);
> +
> +	default:
> +		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> +	}
> +}
> +EXPORT_SYMBOL(v4l2_subdev_command);
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/include/media/v4l2-device.h	Mon Nov 24 22:09:50 2008 +0100
> @@ -0,0 +1,124 @@
> +/*
> +    V4L2 device support header.
> +
> +    Copyright (C) 2008  Hans Verkuil <hverkuil@xs4all.nl>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +
> +#ifndef _V4L2_DEVICE_H
> +#define _V4L2_DEVICE_H
> +
> +#include <media/v4l2-subdev.h>
> +
> +/* Each instance of a V4L2 device should create the v4l2_device struct,
> +   either stand-alone or embedded in a larger struct.

Is it required for all V4L2 devices, or only those that use subdevices ? 
What's the added value of v4l2_device for "simple" devices such as UVC 
webcams ?

> +   It allows easy access to sub-devices (see v4l2-subdev.h) and provides
> +   basic V4L2 device-level support.
> +
> +   Each driver should set a unique driver ID and instance number (usually
> +   0 for the first instance and counting upwards from there).
> +
> +   It is recommended to set the name as follows:
> +
> +   <drivername> + instance number
> +
> +   If the driver name ends with a digit, then put a '-' between the driver
> +   name and the instance number.

The name field is automatically filled by v4l2_device_register. I think the 
comment is outdated.

> + */
> +
> +#define V4L2_DEVICE_NAME_SIZE 32

The device name is made of the driver name and the bus id. The driver name has 
no upper bound, but the bus id is limited to BUS_ID_SIZE (currently 20) 
bytes. Shouldn't V4L2_DEVICE_NAME_SIZE be defined as (BUS_ID_SIZE + 
reasonable constant for the driver name) ?

> +struct v4l2_device {
> +	/* dev->platform_data points to this struct */
> +	struct device *dev;
> +	/* used to keep track of the registered subdevs */
> +	struct list_head subdevs;
> +	/* lock this struct; can be used by the driver as well if this
> +	   struct is embedded into a larger struct. */
> +	struct mutex lock;
> +	/* unique device name */
> +	char name[V4L2_DEVICE_NAME_SIZE];
> +};
> +
> +/* Initialize v4l2_dev and make dev->platform_data point to v4l2_dev */
> +void v4l2_device_register(struct device *dev, struct v4l2_device
> *v4l2_dev); +/* Set v4l2_dev->dev->platform_data to NULL and unregister all
> sub-devices */ +void v4l2_device_unregister(struct v4l2_device *v4l2_dev);
> +
> +/* Register a subdev with a v4l2 device. While registered the subdev
> module +   is marked as in-use. An error is returned if the module is no
> longer +   loaded when you attempt to register it. */
> +int v4l2_device_register_subdev(struct v4l2_device *dev, struct
> v4l2_subdev *sd); +/* Unregister a subdev with a v4l2 device. Can also be
> called if the subdev +   wasn't registered. In that case it will do
> nothing. */
> +void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
> +
> +/* Iterate over all subdevs. Warn if you iterate over the subdevs without
> +   the device struct being locked. The next item is prefetched, so you can
> +   delete the current item if necessary. */
> +#define v4l2_device_for_each_subdev(sd, dev)				\
> +	for (sd = list_entry((dev)->subdevs.next, typeof(*sd), list), 	\
> +	     ({ WARN_ON(!mutex_is_locked(&(dev)->lock)); 0; });		\
> +		prefetch(sd->list.next), &sd->list != &(dev)->subdevs; 	\
> +	     sd = list_entry(sd->list.next, typeof(*sd), list))
> +
> +/* Call the specified callback for all subdevs matching the condition.
> +   Ignore any errors. */
> +#define __v4l2_device_call_subdevs(dev, cond, o, f, args...) 		\
> +	do { 								\
> +		struct v4l2_subdev *sd; 				\
> +									\
> +		mutex_lock(&(dev)->lock); 				\
> +		list_for_each_entry(sd, &(dev)->subdevs, list)   	\
> +			if ((cond) && sd->ops->o && sd->ops->o->f) 	\
> +				sd->ops->o->f(sd , ##args); 		\
> +		mutex_unlock(&(dev)->lock); 				\
> +	} while (0)
> +
> +/* Call the specified callback for all subdevs matching the condition.
> +   If the callback returns an error other than 0 or -ENOIOCTLCMD, then
> +   return with that error code. */
> +#define __v4l2_device_call_subdevs_until_err(dev, cond, o, f, args...)  \
> +({ 									\
> +	struct v4l2_subdev *sd; 					\
> +	int err = 0; 							\
> +									\
> +	mutex_lock(&(dev)->lock); 					\
> +	list_for_each_entry(sd, &(dev)->subdevs, list) { 		\
> +		if ((cond) && sd->ops->o && sd->ops->o->f) 		\
> +			err = sd->ops->o->f(sd , ##args); 		\
> +		if (err && err != -ENOIOCTLCMD)				\
> +			break; 						\
> +	} 								\
> +	mutex_unlock(&(dev)->lock); 					\
> +	(err == -ENOIOCTLCMD) ? 0 : err; 				\
> +})
> +
> +/* Call the specified callback for all subdevs matching grp_id (if 0, then
> +   match them all). Ignore any errors. */
> +#define v4l2_device_call_all(dev, grp_id, o, f, args...) 		\
> +	__v4l2_device_call_subdevs(dev, 				\
> +			!(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
> +
> +/* Call the specified callback for all subdevs matching grp_id (if 0, then
> +   match them all). If the callback returns an error other than 0 or
> +   -ENOIOCTLCMD, then return with that error code. */
> +#define v4l2_device_call_until_err(dev, grp_id, o, f, args...) 		\
> +	__v4l2_device_call_subdevs_until_err(dev,			\
> +		       !(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
> +
> +#endif
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/include/media/v4l2-subdev.h	Mon Nov 24 22:09:50 2008 +0100
> @@ -0,0 +1,188 @@
> +/*
> +    V4L2 sub-device support header.
> +
> +    Copyright (C) 2008  Hans Verkuil <hverkuil@xs4all.nl>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +
> +#ifndef _V4L2_SUBDEV_H
> +#define _V4L2_SUBDEV_H
> +
> +#include <media/v4l2-common.h>
> +
> +struct v4l2_device;
> +struct v4l2_subdev;
> +struct tuner_setup;
> +
> +/* Sub-devices are devices that are connected somehow to the main bridge
> +   device. These devices are usually audio/video muxers/encoders/decoders
> or +   sensors and webcam controllers.
> +
> +   Usually these devices are controlled through an i2c bus, but other
> busses +   may also be used.
> +
> +   The v4l2_subdev struct provides a way of accessing these devices in a
> +   generic manner. Most operations that these sub-devices support fall in
> +   a few categories: core ops, audio ops, video ops and tuner ops.
> +
> +   More categories can be added if needed, although this should remain a
> +   limited set (no more than approx. 8 categories).
> +
> +   Each category has its own set of ops that subdev drivers can implement.
> +
> +   A subdev driver can leave the pointer to the category ops NULL if
> +   it does not implement them (e.g. an audio subdev will generally not
> +   implement the video category ops). The exception is the core category:
> +   this must always be present.
> +
> +   These ops are all used internally so it is no problem to change, remove
> +   or add ops or move ops from one to another category. Currently these
> +   ops are based on the original ioctls, but since ops are not limited to
> +   one argument there is room for improvement here once all i2c subdev
> +   drivers are converted to use these ops.
> + */
> +
> +/* Core ops: it is highly recommended to implement at least these ops:
> +
> +   g_chip_ident
> +   log_status
> +   g_register
> +   s_register
> +
> +   This provides basic debugging support.
> +
> +   The ioctl ops is meant for generic ioctl-like commands. Depending on
> +   the use-case it might be better to use subdev-specific ops (currently
> +   not yet implemented) since ops provide proper type-checking.
> + */
> +struct v4l2_subdev_core_ops {
> +	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_chip_ident
> *chip); +	int (*log_status)(struct v4l2_subdev *sd);
> +	int (*init)(struct v4l2_subdev *sd, u32 val);
> +	int (*s_standby)(struct v4l2_subdev *sd, u32 standby);
> +	int (*reset)(struct v4l2_subdev *sd, u32 val);
> +	int (*s_gpio)(struct v4l2_subdev *sd, u32 val);
> +	int (*queryctrl)(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
> +	int (*g_ctrl)(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
> +	int (*s_ctrl)(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
> +	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
> +	int (*ioctl)(struct v4l2_subdev *sd, int cmd, void *arg);
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_register *reg);
> +	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_register *reg);
> +#endif
> +};
> +
> +struct v4l2_subdev_tuner_ops {
> +	int (*s_mode)(struct v4l2_subdev *sd, enum v4l2_tuner_type);
> +	int (*s_radio)(struct v4l2_subdev *sd);
> +	int (*s_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
> +	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
> +	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
> +	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
> +	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
> +	int (*s_type_addr)(struct v4l2_subdev *sd, struct tuner_setup *type);
> +	int (*s_config)(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config
> *config); +};
> +
> +struct v4l2_subdev_audio_ops {
> +	int (*s_clock_freq)(struct v4l2_subdev *sd, u32 freq);
> +	int (*s_i2s_clock_freq)(struct v4l2_subdev *sd, u32 freq);
> +	int (*s_routing)(struct v4l2_subdev *sd, const struct v4l2_routing
> *route); +};
> +
> +struct v4l2_subdev_video_ops {
> +	int (*s_routing)(struct v4l2_subdev *sd, const struct v4l2_routing
> *route); +	int (*s_crystal_freq)(struct v4l2_subdev *sd, struct
> v4l2_crystal_freq *freq); +	int (*decode_vbi_line)(struct v4l2_subdev *sd,
> struct v4l2_decode_vbi_line *vbi_line); +	int (*s_vbi_data)(struct
> v4l2_subdev *sd, const struct v4l2_sliced_vbi_data *vbi_data); +	int
> (*g_vbi_data)(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_data
> *vbi_data); +	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
> +	int (*s_stream)(struct v4l2_subdev *sd, int enable);
> +	int (*s_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
> +	int (*g_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
> +};
> +
> +struct v4l2_subdev_ops {
> +	const struct v4l2_subdev_core_ops  *core;
> +	const struct v4l2_subdev_tuner_ops *tuner;
> +	const struct v4l2_subdev_audio_ops *audio;
> +	const struct v4l2_subdev_video_ops *video;
> +};
> +
> +#define V4L2_SUBDEV_NAME_SIZE 32
> +
> +/* Each instance of a subdev driver should create this struct, either
> +   stand-alone or embedded in a larger struct.
> + */
> +struct v4l2_subdev {
> +	struct list_head list;
> +	struct module *owner;
> +	struct v4l2_device *dev;
> +	const struct v4l2_subdev_ops *ops;
> +	/* name must be unique */
> +	char name[V4L2_SUBDEV_NAME_SIZE];
> +	/* can be used to group similar subdevs, value is driver-specific */
> +	u32 grp_id;
> +	/* pointer to private data */
> +	void *priv;
> +};
> +
> +static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
> +{
> +	sd->priv = p;
> +}
> +
> +static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
> +{
> +	return sd->priv;
> +}
> +
> +/* Convert an ioctl-type command to the proper v4l2_subdev_ops function
> call. +   This is used by subdev modules that can be called by both
> old-style ioctl +   commands and through the v4l2_subdev_ops.
> +
> +   The ioctl API of the subdev driver can call this function to call the
> +   right ops based on the ioctl cmd and arg.
> +
> +   Once all subdev drivers have been converted and all drivers no longer
> +   use the ioctl interface, then this function can be removed.
> + */
> +int v4l2_subdev_command(struct v4l2_subdev *sd, unsigned cmd, void *arg);
> +
> +static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
> +					const struct v4l2_subdev_ops *ops)
> +{
> +	INIT_LIST_HEAD(&sd->list);
> +	/* ops->core MUST be set */
> +	BUG_ON(!ops || !ops->core);
> +	sd->ops = ops;
> +	sd->dev = NULL;
> +	sd->name[0] = '\0';
> +	sd->grp_id = 0;
> +	sd->priv = NULL;
> +}
> +
> +/* Call an ops of a v4l2_subdev, doing the right checks against
> +   NULL pointers.
> +
> +   Example: err = v4l2_subdev_call(sd, core, g_chip_ident, &chip);
> + */
> +#define v4l2_subdev_call(sd, o, f, args...)				\
> +	(!(sd) ? -ENODEV : (((sd) && (sd)->ops->o && (sd)->ops->o->f) ?	\
> +		(sd)->ops->o->f((sd) , ##args) : -ENOIOCTLCMD))
> +
> +#endif
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
