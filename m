Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3718 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1BDKJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 05:09:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v6 4/7] v4l: subdev: Add device node support
Date: Fri, 4 Feb 2011 11:09:03 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131338-29892-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131338-29892-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041109.03183.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, January 27, 2011 13:28:55 Laurent Pinchart wrote:
> Create a device node named subdevX for every registered subdev.
> 
> As the device node is registered before the subdev core::s_config
> function is called, return -EGAIN on open until initialization
> completes.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |   18 +++++++
>  drivers/media/radio/radio-si4713.c           |    2 +-
>  drivers/media/video/Makefile                 |    2 +-
>  drivers/media/video/cafe_ccic.c              |    2 +-
>  drivers/media/video/davinci/vpfe_capture.c   |    2 +-
>  drivers/media/video/davinci/vpif_capture.c   |    2 +-
>  drivers/media/video/davinci/vpif_display.c   |    2 +-
>  drivers/media/video/ivtv/ivtv-i2c.c          |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c  |    2 +-
>  drivers/media/video/sh_vou.c                 |    2 +-
>  drivers/media/video/soc_camera.c             |    2 +-
>  drivers/media/video/v4l2-common.c            |   15 +++++-
>  drivers/media/video/v4l2-dev.c               |   27 ++++------
>  drivers/media/video/v4l2-device.c            |   24 +++++++++-
>  drivers/media/video/v4l2-ioctl.c             |    2 +-
>  drivers/media/video/v4l2-subdev.c            |   66 ++++++++++++++++++++++++++
>  include/media/v4l2-common.h                  |    5 +-
>  include/media/v4l2-dev.h                     |   18 ++++++-
>  include/media/v4l2-ioctl.h                   |    3 +
>  include/media/v4l2-subdev.h                  |   16 ++++++-
>  20 files changed, 176 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-subdev.c
> 

<snip>

> diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
> index 7fe6f92..97e84df 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -117,24 +117,43 @@ EXPORT_SYMBOL_GPL(v4l2_device_unregister);
>  int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>  						struct v4l2_subdev *sd)
>  {
> +	struct video_device *vdev;
>  	int err;
>  
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
>  	/* This just returns 0 if either of the two args is NULL */
>  	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
>  	if (err)
>  		return err;
> +
>  	sd->v4l2_dev = v4l2_dev;
>  	spin_lock(&v4l2_dev->lock);
>  	list_add_tail(&sd->list, &v4l2_dev->subdevs);
>  	spin_unlock(&v4l2_dev->lock);
> -	return 0;
> +
> +	/* Register the device node. */
> +	vdev = &sd->devnode;
> +	strlcpy(vdev->name, sd->name, sizeof(vdev->name));
> +	vdev->parent = v4l2_dev->dev;
> +	vdev->fops = &v4l2_subdev_fops;
> +	vdev->release = video_device_release_empty;
> +	if (sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE) {
> +		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
> +					      sd->owner);
> +		if (err < 0)
> +			v4l2_device_unregister_subdev(sd);
> +	}
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>  
> @@ -143,10 +162,13 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>  	/* return if it isn't registered */
>  	if (sd == NULL || sd->v4l2_dev == NULL)
>  		return;
> +
>  	spin_lock(&sd->v4l2_dev->lock);
>  	list_del(&sd->list);
>  	spin_unlock(&sd->v4l2_dev->lock);
>  	sd->v4l2_dev = NULL;
> +
>  	module_put(sd->owner);
> +	video_unregister_device(&sd->devnode);

I'm pretty sure that the video_unregister_device should be called before the
module_put. And I think it is cleaner to test the V4L2_SUBDEV_FL_HAS_DEVNODE
flag as well. It may not be strictly necessary, but it is less confusing.

>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 1e01554..4137e4c 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -413,7 +413,7 @@ static unsigned long cmd_input_size(unsigned int cmd)
>  	}
>  }
>  
> -static long
> +long
>  __video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  		v4l2_kioctl func)
>  {
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> new file mode 100644
> index 0000000..00bd4b1
> --- /dev/null
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -0,0 +1,66 @@
> +/*
> + *  V4L2 subdevice support.
> + *
> + *  Copyright (C) 2010 Nokia Corporation
> + *
> + *  Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation.
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
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +
> +static int subdev_open(struct file *file)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> +
> +	if (!sd->initialized)
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> +
> +static int subdev_close(struct file *file)
> +{
> +	return 0;
> +}
> +
> +static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> +{
> +	switch (cmd) {
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +
> +	return 0;
> +}
> +
> +static long subdev_ioctl(struct file *file, unsigned int cmd,
> +	unsigned long arg)
> +{
> +	return __video_usercopy(file, cmd, arg, subdev_do_ioctl);
> +}
> +
> +const struct v4l2_file_operations v4l2_subdev_fops = {
> +	.owner = THIS_MODULE,
> +	.open = subdev_open,
> +	.unlocked_ioctl = subdev_ioctl,
> +	.release = subdev_close,
> +};
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 565fb32..ef8965d 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -146,7 +146,7 @@ struct i2c_board_info;
>  
>  struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
>  		struct i2c_adapter *adapter, struct i2c_board_info *info,
> -		const unsigned short *probe_addrs);
> +		const unsigned short *probe_addrs, int enable_devnode);
>  
>  /* Initialize an v4l2_subdev with data from an i2c_client struct */
>  void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> @@ -179,7 +179,8 @@ struct spi_device;
>  /* Load an spi module and return an initialized v4l2_subdev struct.
>     The client_type argument is the name of the chip that's on the adapter. */
>  struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
> -		struct spi_master *master, struct spi_board_info *info);
> +		struct spi_master *master, struct spi_board_info *info,
> +		int enable_devnode);
>  
>  /* Initialize an v4l2_subdev with data from an spi_device struct */
>  void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 15802a0..4fe6831 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -21,7 +21,8 @@
>  #define VFL_TYPE_GRABBER	0
>  #define VFL_TYPE_VBI		1
>  #define VFL_TYPE_RADIO		2
> -#define VFL_TYPE_MAX		3
> +#define VFL_TYPE_SUBDEV		3
> +#define VFL_TYPE_MAX		4
>  
>  struct v4l2_ioctl_callbacks;
>  struct video_device;
> @@ -102,15 +103,26 @@ struct video_device
>  /* dev to video-device */
>  #define to_video_device(cd) container_of(cd, struct video_device, dev)
>  
> +int __must_check __video_register_device(struct video_device *vdev, int type,
> +		int nr, int warn_if_nr_in_use, struct module *owner);
> +
>  /* Register video devices. Note that if video_register_device fails,
>     the release() callback of the video_device structure is *not* called, so
>     the caller is responsible for freeing any data. Usually that means that
>     you call video_device_release() on failure. */
> -int __must_check video_register_device(struct video_device *vdev, int type, int nr);
> +static inline int __must_check video_register_device(struct video_device *vdev,
> +		int type, int nr)
> +{
> +	return __video_register_device(vdev, type, nr, 1, vdev->fops->owner);
> +}
>  
>  /* Same as video_register_device, but no warning is issued if the desired
>     device node number was already in use. */
> -int __must_check video_register_device_no_warn(struct video_device *vdev, int type, int nr);
> +static inline int __must_check video_register_device_no_warn(
> +		struct video_device *vdev, int type, int nr)
> +{
> +	return __video_register_device(vdev, type, nr, 0, vdev->fops->owner);
> +}
>  
>  /* Unregister video devices. Will do nothing if vdev == NULL or
>     video_is_registered() returns false. */
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 06daa6e..abb64d0 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -316,6 +316,9 @@ extern long v4l2_compat_ioctl32(struct file *file, unsigned int cmd,
>  				unsigned long arg);
>  #endif
>  
> +extern long __video_usercopy(struct file *file, unsigned int cmd,
> +				unsigned long arg, v4l2_kioctl func);
> +
>  /* Include support for obsoleted stuff */
>  extern long video_usercopy(struct file *file, unsigned int cmd,
>  				unsigned long arg, v4l2_kioctl func);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index b636444..de181db 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -22,6 +22,7 @@
>  #define _V4L2_SUBDEV_H
>  
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-dev.h>
>  #include <media/v4l2-mediabus.h>
>  
>  /* generic v4l2_device notify callback notification values */
> @@ -418,9 +419,11 @@ struct v4l2_subdev_ops {
>  #define V4L2_SUBDEV_NAME_SIZE 32
>  
>  /* Set this flag if this subdev is a i2c device. */
> -#define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
> +#define V4L2_SUBDEV_FL_IS_I2C			(1U << 0)
>  /* Set this flag if this subdev is a spi device. */
> -#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
> +#define V4L2_SUBDEV_FL_IS_SPI			(1U << 1)
> +/* Set this flag if this subdev needs a device node. */
> +#define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
>  
>  /* Each instance of a subdev driver should create this struct, either
>     stand-alone or embedded in a larger struct.
> @@ -440,8 +443,16 @@ struct v4l2_subdev {
>  	/* pointer to private data */
>  	void *dev_priv;
>  	void *host_priv;
> +	/* subdev device node */
> +	struct video_device devnode;
> +	unsigned int initialized;

This can be a bool. Actually, thinking about this some more, is this really
necessary? The device node should be created as the very last thing anyway.
Looking at the patches it seems to be set only when creating an i2c subdev,
and not when creating a spi subdev (let alone the fact that this has to be
set manually for internal subdevs).

I think it is more hassle than anything else.

There may be situations where you don't want to create a device node when
calling v4l2_device_register_subdev(): should that happen, then it is
better to add the capability of registering a subdev without creating a
device node, and add a new function that just creates the device node at
a later (safe) stage.

The easiest way to do this is to add a new flag: V4L2_SUBDEV_FL_ALLOW_DEVNODE

The HAS_DEVNODE flag is set by the subdev driver, the ALLOW_DEVNODE flag is
set by the master driver. If both are set, then the device node is created.

So by splitting off the device node creation in a public function, the master
driver can control this nicely.

Thinking about this, we can actually implement it like this from the beginning.
I never really liked the fact that the master driver clears the HAS_DEVNODE
flag. Creating two separate flags is cleaner.

>  };
>  
> +#define vdev_to_v4l2_subdev(vdev) \
> +	container_of(vdev, struct v4l2_subdev, devnode)
> +
> +extern const struct v4l2_file_operations v4l2_subdev_fops;
> +
>  static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
>  {
>  	sd->dev_priv = p;
> @@ -474,6 +485,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
>  	sd->grp_id = 0;
>  	sd->dev_priv = NULL;
>  	sd->host_priv = NULL;
> +	sd->initialized = 1;
>  }
>  
>  /* Call an ops of a v4l2_subdev, doing the right checks against
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
