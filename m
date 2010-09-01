Return-path: <mchehab@localhost>
Received: from perceval.irobotique.be ([92.243.18.41]:47690 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0IAN6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Sep 2010 09:58:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v4 06/11] media: Media device information query
Date: Wed, 1 Sep 2010 15:58:44 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-7-git-send-email-laurent.pinchart@ideasonboard.com> <201008281244.15380.hverkuil@xs4all.nl>
In-Reply-To: <201008281244.15380.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009011558.44383.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Hans,

On Saturday 28 August 2010 12:44:15 Hans Verkuil wrote:
> On Friday, August 20, 2010 17:29:08 Laurent Pinchart wrote:

[snip]

> > diff --git a/Documentation/media-framework.txt
> > b/Documentation/media-framework.txt index 59649e9..66f7f6c 100644
> > --- a/Documentation/media-framework.txt
> > +++ b/Documentation/media-framework.txt
> > @@ -315,3 +315,45 @@ required, drivers don't need to provide a set_power
> > operation. The operation
> > 
> >  is allowed to fail when turning power on, in which case the
> >  media_entity_get function will return NULL.
> > 
> > +
> > +Userspace application API
> > +-------------------------
> > +
> > +Media devices offer an API to userspace application to query device
> > information +through ioctls.
> > +
> > +	MEDIA_IOC_DEVICE_INFO - Get device information
> > +	----------------------------------------------
> > +
> > +	ioctl(int fd, int request, struct media_device_info *argp);
> > +
> > +To query device information, call the MEDIA_IOC_ENUM_ENTITIES ioctl with
> > a +pointer to a media_device_info structure. The driver fills the
> > structure and +returns the information to the application. The ioctl
> > never fails. +
> > +The media_device_info structure is defined as
> > +
> > +- struct media_device_info
> > +
> > +__u8	driver[16]	Driver name as a NUL-terminated ASCII string. The
> > +			driver version is stored in the driver_version field.
> 
> Proposed improvement: "Name of the driver implementing the media API
> as a NUL-terminated ASCII string."
> 
> The media API overarches multiple drivers, so it's probably useful to say
> which driver name should be filled in here.

OK I'll change this.

> > +__u8	model[32]	Device model name as a NUL-terminated UTF-8 string. The
> > +			device version is stored in the device_version field and
> > +			is not be appended to the model name.
> 
> Why UTF-8 instead of ASCII?

Because the model name could contain non-ASCII characters.

> > +__u8	serial[32]	Serial number as an ASCII string. The string is
> > +			NUL-terminated unless the serial number is exactly 32
> > +			characters long.
> > +__u8	bus_info[32]	Location of the device in the system as a
> > NUL-terminated
> > +			ASCII string. This includes the bus type name (PCI, USB,
> > +			...) and a bus-specific identifier.
> > +__u32	media_version	Media API version, formatted with the
> > KERNEL_VERSION
> > +			macro.
> > +__u32	device_version	Media device driver version in a driver-specific
> > format.
> > +__u32	driver_version	Media device driver version, formatted with the
> > +			KERNEL_VERSION macro.
> 
> These last two are very confusing. Does device_version actually refer to
> the hardware revision? In that case the description next to it is really
> wrong. And I also think it should be renamed to hw_revision.

My bad. I'll rename device_version to hw_revision.

[snip]

> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index c309d3c..1415ebd 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -20,13 +20,70 @@

[snip]

> > +static int media_device_get_info(struct media_device *dev,
> > +				 struct media_device_info __user *__info)
> > +{
> > +	struct media_device_info info;
> > +
> > +	memset(&info, 0, sizeof(info));
> 
> No need to zero the whole struct. info.reserved would be enough.

The strings should be zeroed, otherwise we could leak information to userspace 
by copying uninitialized stack data.

> > +
> > +	strlcpy(info.driver, dev->dev->driver->name, sizeof(info.driver));
> > +	strlcpy(info.model, dev->model, sizeof(info.model));
> > +	strncpy(info.serial, dev->serial, sizeof(info.serial));
> 
> Why not strlcpy?

Because the serial number can be 32 bytes long, and thus not NULL-terminated.

> > +	strlcpy(info.bus_info, dev->bus_info, sizeof(info.bus_info));
> > +
> > +	info.media_version = MEDIA_API_VERSION;
> > +	info.device_version = dev->device_version;
> > +	info.driver_version = dev->driver_version;
> > +
> > +	return copy_to_user(__info, &info, sizeof(*__info));
> > +}
> > +
> > +static long media_device_ioctl(struct file *filp, unsigned int cmd,
> > +			       unsigned long arg)
> > +{
> > +	struct media_devnode *devnode = media_devnode_data(filp);
> > +	struct media_device *dev = to_media_device(devnode);
> > +	long ret;
> > +
> > +	switch (cmd) {
> > +	case MEDIA_IOC_DEVICE_INFO:
> > +		ret = media_device_get_info(dev,
> > +				(struct media_device_info __user *)arg);
> > +		break;
> > +
> > +	default:
> > +		ret = -ENOIOCTLCMD;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > 
> >  static const struct media_file_operations media_device_fops = {
> >  
> >  	.owner = THIS_MODULE,
> > 
> > +	.open = media_device_open,
> > +	.unlocked_ioctl = media_device_ioctl,
> > +	.release = media_device_close,
> > 
> >  };
> >  
> >  /*
> >  -----------------------------------------------------------------------
> >  ------
> > 
> > diff --git a/include/linux/media.h b/include/linux/media.h
> > new file mode 100644
> > index 0000000..bca08a7
> > --- /dev/null
> > +++ b/include/linux/media.h
> > @@ -0,0 +1,23 @@
> > +#ifndef __LINUX_MEDIA_H
> > +#define __LINUX_MEDIA_H
> > +
> > +#include <linux/ioctl.h>
> > +#include <linux/types.h>
> > +#include <linux/version.h>
> > +
> > +#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
> > +
> > +struct media_device_info {
> > +	__u8 driver[16];
> > +	__u8 model[32];
> > +	__u8 serial[32];
> > +	__u8 bus_info[32];
> > +	__u32 media_version;
> > +	__u32 device_version;
> > +	__u32 driver_version;
> > +	__u32 reserved[5];
> 
> I'd increase this to reserved[33] as [5] seems very low to me.
> Total struct size is then 256 bytes.

OK.

[snip]

-- 
Regards,

Laurent Pinchart
