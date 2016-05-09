Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60679 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbcEIPDj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 11:03:39 -0400
Date: Mon, 9 May 2016 12:03:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH 2/2] [media] media-device: dynamically allocate struct
 media_devnode
Message-ID: <20160509120333.523a6397@recife.lan>
In-Reply-To: <1507164.DlvJMNf1dF@avalon>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
	<83247b8a21c292a08949b3fe619cc56dc4709896.1462633500.git.mchehab@osg.samsung.com>
	<1507164.DlvJMNf1dF@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 May 2016 14:40:02 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Saturday 07 May 2016 12:12:09 Mauro Carvalho Chehab wrote:
> > struct media_devnode is currently embedded at struct media_device.  
> 
> s/at/in/
> 
> > While this works fine during normal usage, it leads to a race
> > condition during devnode unregister.  
> 
> Strictly speaking the race condition isn't cause by embedding struct 
> media_devnode inside struct media_device. The race condition is unavoidable as 
> we have two asynchronous operations (unregistration and userspace access) that 
> affect the same structures. This isn't a problem as such, this kind of race 
> conditions is handled in the kernel through release callbacks to implement 
> proper lifetime management of data structures. The problem here is that the 
> release callbacks are not propagated all the way up to the drivers.

We should not mix the description of the problem with its solution.

See more below.
> 
> > the problem is that drivers  
> 
> s/the/The/
> 
> > assume that, after calling media_device_unregister(), the struct
> > that contains media_device can be freed. This is not true, as it
> > can't be freed until userspace closes all opened /dev/media devnodes.  
> 
> Not all the open devnodes, just the one related to the struct media_devnode 
> instance.

Sure. That's what I meant to say.

> 
> > In other words, if the media devnode is still open, and media_device
> > gets freed, any call to an ioctl will make the core to try to access
> > struct media_device, with will cause an use-after-free and even GPF.
> > 
> > Fix this by dynamically allocating the struct media_devnode and only
> > freeing it when it is safe.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  drivers/media/media-device.c           | 44 ++++++++++++++++++++-----------
> >  drivers/media/media-devnode.c          |  7 +++++-
> >  drivers/media/usb/au0828/au0828-core.c |  4 ++--
> >  drivers/media/usb/uvc/uvc_driver.c     |  2 +-
> >  include/media/media-device.h           |  5 +---
> >  include/media/media-devnode.h          | 13 +++++++++-
> >  6 files changed, 52 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 47a99af5525e..8c520e064c34 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -423,7 +423,7 @@ static long media_device_ioctl(struct file *filp,
> > unsigned int cmd, unsigned long arg)
> >  {
> >  	struct media_devnode *devnode = media_devnode_data(filp);
> > -	struct media_device *dev = to_media_device(devnode);
> > +	struct media_device *dev = devnode->media_dev;
> >  	long ret;
> > 
> >  	mutex_lock(&dev->graph_mutex);
> > @@ -495,7 +495,7 @@ static long media_device_compat_ioctl(struct file *filp,
> > unsigned int cmd, unsigned long arg)
> >  {
> >  	struct media_devnode *devnode = media_devnode_data(filp);
> > -	struct media_device *dev = to_media_device(devnode);
> > +	struct media_device *dev = devnode->media_dev;
> >  	long ret;
> > 
> >  	switch (cmd) {
> > @@ -531,7 +531,8 @@ static const struct media_file_operations
> > media_device_fops = { static ssize_t show_model(struct device *cd,
> >  			  struct device_attribute *attr, char *buf)
> >  {
> > -	struct media_device *mdev = to_media_device(to_media_devnode(cd));
> > +	struct media_devnode *devnode = to_media_devnode(cd);
> > +	struct media_device *mdev = devnode->media_dev;
> > 
> >  	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
> >  }
> > @@ -704,23 +705,34 @@ EXPORT_SYMBOL_GPL(media_device_cleanup);
> >  int __must_check __media_device_register(struct media_device *mdev,
> >  					 struct module *owner)
> >  {
> > +	struct media_devnode *devnode;
> >  	int ret;
> > 
> > +	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
> > +	if (!devnode)
> > +		return -ENOMEM;
> > +
> >  	/* Register the device node. */
> > -	mdev->devnode.fops = &media_device_fops;
> > -	mdev->devnode.parent = mdev->dev;
> > -	mdev->devnode.release = media_device_release;
> > +	mdev->devnode = devnode;
> > +	devnode->fops = &media_device_fops;
> > +	devnode->parent = mdev->dev;
> > +	devnode->release = media_device_release;
> > 
> >  	/* Set version 0 to indicate user-space that the graph is static */
> >  	mdev->topology_version = 0;
> > 
> > -	ret = media_devnode_register(&mdev->devnode, owner);
> > -	if (ret < 0)
> > +	ret = media_devnode_register(mdev, devnode, owner);
> > +	if (ret < 0) {
> > +		mdev->devnode = NULL;
> > +		kfree(devnode);
> >  		return ret;
> > +	}
> > 
> > -	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
> > +	ret = device_create_file(&devnode->dev, &dev_attr_model);
> >  	if (ret < 0) {
> > -		media_devnode_unregister(&mdev->devnode);
> > +		mdev->devnode = NULL;
> > +		media_devnode_unregister(devnode);
> > +		kfree(devnode);
> >  		return ret;
> >  	}
> > 
> > @@ -771,7 +783,7 @@ void media_device_unregister(struct media_device *mdev)
> >  	mutex_lock(&mdev->graph_mutex);
> > 
> >  	/* Check if mdev was ever registered at all */
> > -	if (!media_devnode_is_registered(&mdev->devnode)) {
> > +	if (!media_devnode_is_registered(mdev->devnode)) {
> >  		mutex_unlock(&mdev->graph_mutex);
> >  		return;
> >  	}
> > @@ -794,9 +806,13 @@ void media_device_unregister(struct media_device *mdev)
> > 
> >  	mutex_unlock(&mdev->graph_mutex);
> > 
> > -	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> > -	dev_dbg(mdev->dev, "Media device unregistering\n");
> > -	media_devnode_unregister(&mdev->devnode);
> > +	dev_dbg(mdev->dev, "Media device unregistered\n");
> > +
> > +	/* Check if mdev devnode was registered */
> > +	if (media_devnode_is_registered(mdev->devnode)) {
> > +		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> > +		media_devnode_unregister(mdev->devnode);
> > +	}
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_unregister);
> > 
> > diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> > index 7481c9610945..ecdc02d6ed83 100644
> > --- a/drivers/media/media-devnode.c
> > +++ b/drivers/media/media-devnode.c
> > @@ -44,6 +44,7 @@
> >  #include <linux/uaccess.h>
> > 
> >  #include <media/media-devnode.h>
> > +#include <media/media-device.h>
> > 
> >  #define MEDIA_NUM_DEVICES	256
> >  #define MEDIA_NAME		"media"
> > @@ -74,6 +75,8 @@ static void media_devnode_release(struct device *cd)
> >  	/* Release media_devnode and perform other cleanups as needed. */
> >  	if (devnode->release)
> >  		devnode->release(devnode);
> > +
> > +	kfree(devnode);
> >  }
> > 
> >  static struct bus_type media_bus_type = {
> > @@ -219,7 +222,8 @@ static const struct file_operations media_devnode_fops =
> > { .llseek = no_llseek,
> >  };
> > 
> > -int __must_check media_devnode_register(struct media_devnode *devnode,
> > +int __must_check media_devnode_register(struct media_device *mdev,
> > +					struct media_devnode *devnode,
> >  					struct module *owner)
> >  {
> >  	int minor;
> > @@ -238,6 +242,7 @@ int __must_check media_devnode_register(struct
> > media_devnode *devnode, mutex_unlock(&media_devnode_lock);
> > 
> >  	devnode->minor = minor;
> > +	devnode->media_dev = mdev;
> > 
> >  	/* Part 2: Initialize and register the character device */
> >  	cdev_init(&devnode->cdev, &media_devnode_fops);
> > diff --git a/drivers/media/usb/au0828/au0828-core.c
> > b/drivers/media/usb/au0828/au0828-core.c index 321ea5cf1329..bf53553d2624
> > 100644
> > --- a/drivers/media/usb/au0828/au0828-core.c
> > +++ b/drivers/media/usb/au0828/au0828-core.c
> > @@ -142,7 +142,7 @@ static void au0828_unregister_media_device(struct
> > au0828_dev *dev) struct media_device *mdev = dev->media_dev;
> >  	struct media_entity_notify *notify, *nextp;
> > 
> > -	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
> > +	if (!mdev || !media_devnode_is_registered(mdev->devnode))
> >  		return;
> > 
> >  	/* Remove au0828 entity_notify callbacks */
> > @@ -482,7 +482,7 @@ static int au0828_media_device_register(struct
> > au0828_dev *dev, if (!dev->media_dev)
> >  		return 0;
> > 
> > -	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
> > +	if (!media_devnode_is_registered(dev->media_dev->devnode)) {
> > 
> >  		/* register media device */
> >  		ret = media_device_register(dev->media_dev);
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index 451e84e962e2..302e284a95eb
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1674,7 +1674,7 @@ static void uvc_delete(struct uvc_device *dev)
> >  	if (dev->vdev.dev)
> >  		v4l2_device_unregister(&dev->vdev);
> >  #ifdef CONFIG_MEDIA_CONTROLLER
> > -	if (media_devnode_is_registered(&dev->mdev.devnode))
> > +	if (media_devnode_is_registered(dev->mdev.devnode))
> >  		media_device_unregister(&dev->mdev);
> >  	media_device_cleanup(&dev->mdev);
> >  #endif
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index a9b33c47310d..f743ae2210ee 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -347,7 +347,7 @@ struct media_entity_notify {
> >  struct media_device {
> >  	/* dev->driver_data points to this struct. */
> >  	struct device *dev;
> > -	struct media_devnode devnode;
> > +	struct media_devnode *devnode;
> > 
> >  	char model[32];
> >  	char driver_name[32];
> > @@ -393,9 +393,6 @@ struct usb_device;
> >  #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
> >  #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
> > 
> > -/* media_devnode to media_device */
> > -#define to_media_device(node) container_of(node, struct media_device,
> > devnode) -
> >  /**
> >   * media_entity_enum_init - Initialise an entity enumeration
> >   *
> > diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> > index e1d5af077adb..5bb3b0e86d73 100644
> > --- a/include/media/media-devnode.h
> > +++ b/include/media/media-devnode.h
> > @@ -33,6 +33,8 @@
> >  #include <linux/device.h>
> >  #include <linux/cdev.h>
> > 
> > +struct media_device;
> > +
> >  /*
> >   * Flag to mark the media_devnode struct as registered. Drivers must not
> > touch
> > * this flag directly, it will be set and cleared by media_devnode_register
> > and
> > @@ -81,6 +83,8 @@ struct media_file_operations {
> >   * before registering the node.
> >   */
> >  struct media_devnode {
> > +	struct media_device *media_dev;
> > +  
> 
> The rationale behind struct media_devnode was to decouple devnode handling 
> from media device handling. The initial implementation reused struct 
> media_devnode in struct video_device, to share devnode handling code between 
> media device and video device. This was rejected, but struct media_devnode was 
> still kept separate instead of merged into struct media_device (I don't 
> remember why though).
> 
> There are two possible fixes for this problem:
> 
> 1. Handling structure lifetime in drivers with propagation of the release 
> callback from media device to drivers. This is the most common strategy used 
> in the kernel, and we implement it for video devices. Some drivers handle that 
> properly (the best example that comes to my mind, albeit a bit self-centered, 
> is the uvcvideo driver) but most don't. It took me a while to handle the race 
> condition properly in uvcvideo, the implementation is certainly not trivial.

I think you're actually referring just to the V4L2 part of uvcvideo, as the
media controller part of uvcvideo is also broken, causing use after free
if the MC is in use while the device going unbind.

The problem with release callbacks and kref is that it has one limit:
it has to have *just one* kref per struct (embedded or not). It means that
a struct that has both V4L2 and MC devnode data on it cannot use this
strategy.

Also, as you mentioned, even for you that wrote the uvcvideo driver,
it took you a while to get it right, for the V4L2 part.

So, a change like that can be disruptive at drivers level, as it may
require additional changes at the drivers data structures.

As the patches fixing cdev and use after free need to be backported
to stable Kernels (as all kernels since the addition of MC to
uvcvideo are broken), the aim is to have something that would require
minimal changes at the drivers.

> 2. Handling structure lifetime in the core through dynamic allocation of 
> structures. This is easier on the driver side, but requires drivers to stop 
> embedding data structures.

It only needs to de-embed the struct that embeds cdev.

> I believe we all want to give the second option a try, but I don't think 
> media_devnode is the structure that needs to be dynamically allocated. 
> media_devnode has a release callback that we propagate to the media_device 
> implementation, with a currently empty implementation.

Having the release callback empty for so long time it is a strong
indication that there's something wrong with that, and it can't be used
as-is.

I played with the release callback in order to solve the problems caused
by Shuah's devres patches. It worked there, but only because those
patches were dynamically allocating media_device too. Again, the changes
on existing drivers are disruptive, and would likely require extra
hard work to backport to stable. Among other changes, it required to
remove the media_device_cleanup() callback from the drivers, as, after the
change, such cleanup should be done by the release callback.

> That's where the 
> problem is, we need to make media_device dynamically allocated, and refcount 
> it using the release callback.
> 
> Another variant of the second option would be to merge the media_device and 
> media_devnode structures, as media_devnode is only used by media_device. I 
> still believe that media_devnode could be useful in video_device, but I'm 
> willing to consider merging the two structures.

Those variants could be tried *after* we fix the bug in a way that it
can be backported to -stable, but for now we need a solution that it is
not disruptive and can easily be backported to old Kernels.

Regards,
Mauro
