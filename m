Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3036 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0H1K0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 06:26:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v4 02/11] media: Media device
Date: Sat, 28 Aug 2010 12:26:15 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1282318153-18885-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008281226.15619.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Friday, August 20, 2010 17:29:04 Laurent Pinchart wrote:
> The media_device structure abstracts functions common to all kind of
> media devices (v4l2, dvb, alsa, ...). It manages media entities and
> offers a userspace API to discover and configure the media device
> internal topology.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/media-framework.txt |   91 ++++++++++++++++++++++++++++++++++
>  drivers/media/Makefile            |    2 +-
>  drivers/media/media-device.c      |   98 +++++++++++++++++++++++++++++++++++++
>  include/media/media-device.h      |   64 ++++++++++++++++++++++++
>  4 files changed, 254 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/media-framework.txt
>  create mode 100644 drivers/media/media-device.c
>  create mode 100644 include/media/media-device.h
> 
> diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
> new file mode 100644
> index 0000000..89dc7ad
> --- /dev/null
> +++ b/Documentation/media-framework.txt
> @@ -0,0 +1,91 @@
> +Linux kernel media framework
> +============================
> +
> +This document describes the Linux kernel media framework, its data structures,
> +functions and their usage.
> +
> +
> +Introduction
> +------------
> +
> +Media devices increasingly handle multiple related functions. Many USB cameras
> +include microphones, video capture hardware can also output video, or SoC
> +camera interfaces also perform memory-to-memory operations similar to video
> +codecs.
> +
> +Independent functions, even when implemented in the same hardware, can be
> +modeled by separate devices. A USB camera with a microphone will be presented
> +to userspace applications as V4L2 and ALSA capture devices. The devices
> +relationships (when using a webcam, end-users shouldn't have to manually
> +select the associated USB microphone), while not made available directly to
> +applications by the drivers, can usually be retrieved from sysfs.
> +
> +With more and more advanced SoC devices being introduced, the current approach
> +will not scale. Device topologies are getting increasingly complex and can't
> +always be represented by a tree structure. Hardware blocks are shared between
> +different functions, creating dependencies between seemingly unrelated
> +devices.
> +
> +Kernel abstraction APIs such as V4L2 and ALSA provide means for applications
> +to access hardware parameters. As newer hardware expose an increasingly high
> +number of those parameters, drivers need to guess what applications really
> +require based on limited information, thereby implementing policies that
> +belong to userspace.
> +
> +The media kernel API aims at solving those problems.
> +
> +
> +Media device
> +------------
> +
> +A media device is represented by a struct media_device instance, defined in
> +include/media/media-device.h. Allocation of the structure is handled by the
> +media device driver, usually by embedding the media_device instance in a
> +larger driver-specific structure.
> +
> +Drivers register media device instances by calling
> +
> +	media_device_register(struct media_device *mdev);
> +
> +The caller is responsible for initializing the media_device structure before
> +registration. The following fields must be set:
> +
> + - dev must point to the parent device (usually a pci_dev, usb_interface or
> +   platform_device instance).
> +
> + - model must be filled with the device model name as a NUL-terminated UTF-8
> +   string. The device/model revision must not be stored in this field.
> +
> +The following fields are optional:
> +
> + - serial is a unique serial number stored as an ASCII string. The string must
> +   be NUL-terminated unless exactly 32 characters long. This allows storing
> +   GUIDs in a text form. If the hardware doesn't provide a unique serial
> +   number this field must be left empty.
> +
> + - bus_info represents the location of the device in the system as a
> +   NUL-terminated ASCII string. For PCI/PCIe devices bus_info must be set to
> +   "PCI:" (or "PCIe:") followed by the value of pci_name(). For USB devices,
> +   the usb_make_path() function must be used. This field is used by
> +   applications to distinguish between otherwise identical devices that don't
> +   provide a serial number.
> +
> + - device_version is the hardware device version number in a driver-specific
> +   format. When possible the version should be formatted with the
> +   KERNEL_VERSION macro.
> +
> + - driver_version is formatted with the KERNEL_VERSION macro. The version
> +   minor must be incremented when new features are added to the userspace API
> +   without breaking binary compatibility. The version major must be
> +   incremented when binary compatibility is broken.
> +
> +Upon successful registration a character device named media[0-9]+ is created.
> +The device major and minor numbers are dynamic. The model name is exported as
> +a sysfs attribute.
> +
> +Drivers unregister media device instances by calling
> +
> +	media_device_unregister(struct media_device *mdev);
> +
> +Unregistering a media device that hasn't been registered is *NOT* safe.
> +
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index c1b5938..f8d8dcb 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> -media-objs	:= media-devnode.o
> +media-objs	:= media-device.o media-devnode.o
>  
>  obj-$(CONFIG_MEDIA_SUPPORT)	+= media.o
>  
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> new file mode 100644
> index 0000000..781c641
> --- /dev/null
> +++ b/drivers/media/media-device.c
> @@ -0,0 +1,98 @@
> +/*
> + *  Media device support.
> + *
> + *  Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#include <media/media-device.h>
> +#include <media/media-devnode.h>
> +
> +static const struct media_file_operations media_device_fops = {
> +	.owner = THIS_MODULE,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * sysfs
> + */
> +
> +static ssize_t show_model(struct device *cd,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	struct media_device *mdev = to_media_device(to_media_devnode(cd));
> +
> +	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
> +}
> +
> +static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
> +
> +/* -----------------------------------------------------------------------------
> + * Registration/unregistration
> + */
> +
> +static void media_device_release(struct media_devnode *mdev)
> +{
> +}
> +
> +/**
> + * media_device_register - register a media device
> + * @mdev:	The media device
> + *
> + * The caller is responsible for initializing the media device before
> + * registration. The following fields must be set:
> + *
> + * - dev must point to the parent device
> + * - model must be filled with the device model name
> + */
> +int __must_check media_device_register(struct media_device *mdev)
> +{
> +	int ret;
> +
> +	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
> +		return 0;
> +
> +	/* Register the device node. */
> +	mdev->devnode.fops = &media_device_fops;
> +	mdev->devnode.parent = mdev->dev;
> +	mdev->devnode.release = media_device_release;
> +	ret = media_devnode_register(&mdev->devnode);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
> +	if (ret < 0) {
> +		media_devnode_unregister(&mdev->devnode);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_device_register);
> +
> +/**
> + * media_device_unregister - unregister a media device
> + * @mdev:	The media device
> + *
> + */
> +void media_device_unregister(struct media_device *mdev)
> +{
> +	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> +	media_devnode_unregister(&mdev->devnode);
> +}
> +EXPORT_SYMBOL_GPL(media_device_unregister);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> new file mode 100644
> index 0000000..4fe949e
> --- /dev/null
> +++ b/include/media/media-device.h
> @@ -0,0 +1,64 @@
> +/*
> + *  Media device support header.
> + *
> + *  Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef _MEDIA_DEVICE_H
> +#define _MEDIA_DEVICE_H
> +
> +#include <linux/device.h>
> +#include <linux/list.h>
> +
> +#include <media/media-devnode.h>
> +
> +/**
> + * struct media_device - Media device
> + * @dev:	Parent device
> + * @devnode:	Media device node
> + * @model:	Device model name
> + * @serial:	Device serial number (optional)
> + * @bus_info:	Unique and stable device location identifier
> + * @device_version: Hardware device version
> + * @driver_version: Device driver version
> + *
> + * This structure represents an abstract high-level media device. It allows easy
> + * access to entities and provides basic media device-level support. The
> + * structure can be allocated directly or embedded in a larger structure.
> + *
> + * The parent @dev is a physical device. It must be set before registering the
> + * media device.
> + *
> + * @model is a descriptive model name exported through sysfs. It doesn't have to
> + * be unique.
> + */
> +struct media_device {
> +	/* dev->driver_data points to this struct. */
> +	struct device *dev;
> +	struct media_devnode devnode;
> +
> +	u8 model[32];
> +	u8 serial[32];
> +	u8 bus_info[32];
> +	u32 device_version;

I prefer hw_revision or possibly hw_device_revision. 'device' is too ambiguous.
And 'revision' is more applicable to hardware than 'version' IMHO.


Regards,

	Hans

> +	u32 driver_version;
> +};
> +
> +int __must_check media_device_register(struct media_device *mdev);
> +void media_device_unregister(struct media_device *mdev);
> +
> +#endif
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
