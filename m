Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3318 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1BNMpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:45:30 -0500
Message-ID: <83d190442695d204416e4bc6dc593711.squirrel@webmail.xs4all.nl>
In-Reply-To: <1297686059-9622-4-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1297686059-9622-4-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Mon, 14 Feb 2011 13:45:23 +0100
Subject: Re: [PATCH v7 3/6] v4l: subdev: Add device node support
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent!

Just one one small thing:

> Create a device node named subdevX for every registered subdev.
>
> As the device node is registered before the subdev core::s_config
> function is called, return -EGAIN on open until initialization
> completes.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |   16 +++++++
>  drivers/media/video/Makefile                 |    2 +-
>  drivers/media/video/v4l2-dev.c               |   27 +++++-------
>  drivers/media/video/v4l2-device.c            |   37 ++++++++++++++++
>  drivers/media/video/v4l2-ioctl.c             |    2 +-
>  drivers/media/video/v4l2-subdev.c            |   60
> ++++++++++++++++++++++++++
>  include/media/v4l2-dev.h                     |   18 ++++++-
>  include/media/v4l2-device.h                  |    6 +++
>  include/media/v4l2-ioctl.h                   |    3 +
>  include/media/v4l2-subdev.h                  |   14 +++++-
>  10 files changed, 162 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-subdev.c
>
> diff --git a/Documentation/video4linux/v4l2-framework.txt
> b/Documentation/video4linux/v4l2-framework.txt
> index f22f35c..8b35871 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -319,6 +319,22 @@ controlled through GPIO pins. This distinction is
> only relevant when setting
>  up the device, but once the subdev is registered it is completely
> transparent.
>
>
> +V4L2 sub-device userspace API
> +-----------------------------
> +
> +Beside exposing a kernel API through the v4l2_subdev_ops structure, V4L2
> +sub-devices can also be controlled directly by userspace applications.
> +
> +Device nodes named v4l-subdevX can be created in /dev to access
> sub-devices
> +directly. If a sub-device supports direct userspace configuration it must
> set
> +the V4L2_SUBDEV_FL_HAS_DEVNODE flag before being registered.
> +
> +After registering sub-devices, the v4l2_device driver can create device
> nodes
> +for all registered sub-devices marked with V4L2_SUBDEV_FL_HAS_DEVNODE by
> calling
> +v4l2_device_register_subdev_nodes(). Those device nodes will be
> automatically
> +removed when sub-devices are unregistered.
> +
> +
>  I2C sub-device drivers
>  ----------------------
>
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a509d31..35c774d 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> -			v4l2-event.o v4l2-ctrls.o
> +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
>
>  # V4L2 core modules
>
> diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c
> index 341764a..abe04ef 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -408,13 +408,14 @@ static int get_index(struct video_device *vdev)
>  }
>
>  /**
> - *	video_register_device - register video4linux devices
> + *	__video_register_device - register video4linux devices
>   *	@vdev: video device structure we want to register
>   *	@type: type of device to register
>   *	@nr:   which device node number (0 == /dev/video0, 1 == /dev/video1,
> ...
>   *             -1 == first free)
>   *	@warn_if_nr_in_use: warn if the desired device node number
>   *	       was already in use and another number was chosen instead.
> + *	@owner: module that owns the video device node
>   *
>   *	The registration code assigns minor numbers and device node numbers
>   *	based on the requested type and registers the new device node with
> @@ -435,9 +436,11 @@ static int get_index(struct video_device *vdev)
>   *	%VFL_TYPE_VBI - Vertical blank data (undecoded)
>   *
>   *	%VFL_TYPE_RADIO - A radio card
> + *
> + *	%VFL_TYPE_SUBDEV - A subdevice
>   */
> -static int __video_register_device(struct video_device *vdev, int type,
> int nr,
> -		int warn_if_nr_in_use)
> +int __video_register_device(struct video_device *vdev, int type, int nr,
> +		int warn_if_nr_in_use, struct module *owner)
>  {
>  	int i = 0;
>  	int ret;
> @@ -469,6 +472,9 @@ static int __video_register_device(struct video_device
> *vdev, int type, int nr,
>  	case VFL_TYPE_RADIO:
>  		name_base = "radio";
>  		break;
> +	case VFL_TYPE_SUBDEV:
> +		name_base = "v4l-subdev";
> +		break;
>  	default:
>  		printk(KERN_ERR "%s called with unknown type: %d\n",
>  		       __func__, type);
> @@ -552,7 +558,7 @@ static int __video_register_device(struct video_device
> *vdev, int type, int nr,
>  		goto cleanup;
>  	}
>  	vdev->cdev->ops = &v4l2_fops;
> -	vdev->cdev->owner = vdev->fops->owner;
> +	vdev->cdev->owner = owner;
>  	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
>  	if (ret < 0) {
>  		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
> @@ -597,18 +603,7 @@ cleanup:
>  	vdev->minor = -1;
>  	return ret;
>  }
> -
> -int video_register_device(struct video_device *vdev, int type, int nr)
> -{
> -	return __video_register_device(vdev, type, nr, 1);
> -}
> -EXPORT_SYMBOL(video_register_device);
> -
> -int video_register_device_no_warn(struct video_device *vdev, int type,
> int nr)
> -{
> -	return __video_register_device(vdev, type, nr, 0);
> -}
> -EXPORT_SYMBOL(video_register_device_no_warn);
> +EXPORT_SYMBOL(__video_register_device);
>
>  /**
>   *	video_unregister_device - unregister a video4linux device
> diff --git a/drivers/media/video/v4l2-device.c
> b/drivers/media/video/v4l2-device.c
> index ce64fe1..f0c77dd 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -124,16 +124,20 @@ int v4l2_device_register_subdev(struct v4l2_device
> *v4l2_dev,
>  	/* Check for valid input */
>  	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
>  		return -EINVAL;
> +
>  	/* Warn if we apparently re-register a subdev */
>  	WARN_ON(sd->v4l2_dev != NULL);
> +
>  	if (!try_module_get(sd->owner))
>  		return -ENODEV;
> +
>  	sd->v4l2_dev = v4l2_dev;
>  	if (sd->internal_ops && sd->internal_ops->registered) {
>  		err = sd->internal_ops->registered(sd);
>  		if (err)
>  			return err;
>  	}
> +
>  	/* This just returns 0 if either of the two args is NULL */
>  	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
>  	if (err) {
> @@ -141,24 +145,57 @@ int v4l2_device_register_subdev(struct v4l2_device
> *v4l2_dev,
>  			sd->internal_ops->unregistered(sd);
>  		return err;
>  	}
> +
>  	spin_lock(&v4l2_dev->lock);
>  	list_add_tail(&sd->list, &v4l2_dev->subdevs);
>  	spin_unlock(&v4l2_dev->lock);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>
> +int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
> +{
> +	struct video_device *vdev;
> +	struct v4l2_subdev *sd;
> +	int err;
> +
> +	/* Register a device node for every subdev marked with the
> +	 * V4L2_SUBDEV_FL_HAS_DEVNODE flag.
> +	 */
> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> +		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
> +			continue;
> +
> +		vdev = &sd->devnode;
> +		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
> +		vdev->parent = v4l2_dev->dev;

Use this instead:

vdev->v4l2_dev = v4l2_dev;

Once all drivers use v4l2_device I intend to remove the parent field. So
it is better to start using v4l2_dev right from the beginning.

> +		vdev->fops = &v4l2_subdev_fops;
> +		vdev->release = video_device_release_empty;
> +		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
> +					      sd->owner);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);

Once this is modified you can add my ack for this patch series since the
other 5 patches are fine.

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

