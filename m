Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34939 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753313AbdKQLJY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:09:24 -0500
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect
 device unplug race
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171116003349.19235-2-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8942419d-fc0e-7a82-cc35-a7960cd22800@xs4all.nl>
Date: Fri, 17 Nov 2017 12:09:20 +0100
MIME-Version: 1.0
In-Reply-To: <20171116003349.19235-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 16/11/17 01:33, Laurent Pinchart wrote:
> Device unplug being asynchronous, it naturally races with operations
> performed by userspace through ioctls or other file operations on video
> device nodes.
> 
> This leads to potential access to freed memory or to other resources
> during device access if unplug occurs during device access. To solve
> this, we need to wait until all device access completes when unplugging
> the device, and block all further access when the device is being
> unplugged.
> 
> Three new functions are introduced. The video_device_enter() and
> video_device_exit() functions must be used to mark entry and exit from
> all code sections where the device can be accessed. The
> video_device_unplug() function is then used in the unplug handler to
> mark the device as being unplugged and wait for all access to complete.
> 
> As an example mark the ioctl handler as a device access section. Other
> file operations need to be protected too, and blocking ioctls (such as
> VIDIOC_DQBUF) need to be handled as well.

As long as the queue field in struct video_device is filled in properly
this shouldn't be a problem.

This looks pretty good, simple and straightforward.

Do we need something similar for media_device? Other devices?

Regards,

	Hans

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 57 ++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-dev.h           | 47 +++++++++++++++++++++++++++++++
>  2 files changed, 104 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index c647ba648805..c73c6d49e7cf 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -156,6 +156,52 @@ void video_device_release_empty(struct video_device *vdev)
>  }
>  EXPORT_SYMBOL(video_device_release_empty);
>  
> +int video_device_enter(struct video_device *vdev)
> +{
> +	bool unplugged;
> +
> +	spin_lock(&vdev->unplug_lock);
> +	unplugged = vdev->unplugged;
> +	if (!unplugged)
> +		vdev->access_refcount++;
> +	spin_unlock(&vdev->unplug_lock);
> +
> +	return unplugged ? -ENODEV : 0;
> +}
> +EXPORT_SYMBOL_GPL(video_device_enter);
> +
> +void video_device_exit(struct video_device *vdev)
> +{
> +	bool wake_up;
> +
> +	spin_lock(&vdev->unplug_lock);
> +	WARN_ON(--vdev->access_refcount < 0);
> +	wake_up = vdev->access_refcount == 0;
> +	spin_unlock(&vdev->unplug_lock);
> +
> +	if (wake_up)
> +		wake_up(&vdev->unplug_wait);
> +}
> +EXPORT_SYMBOL_GPL(video_device_exit);
> +
> +void video_device_unplug(struct video_device *vdev)
> +{
> +	bool unplug_blocked;
> +
> +	spin_lock(&vdev->unplug_lock);
> +	unplug_blocked = vdev->access_refcount > 0;
> +	vdev->unplugged = true;
> +	spin_unlock(&vdev->unplug_lock);
> +
> +	if (!unplug_blocked)
> +		return;
> +
> +	if (!wait_event_timeout(vdev->unplug_wait, !vdev->access_refcount,
> +				msecs_to_jiffies(150000)))
> +		WARN(1, "Timeout waiting for device access to complete\n");
> +}
> +EXPORT_SYMBOL_GPL(video_device_unplug);
> +
>  static inline void video_get(struct video_device *vdev)
>  {
>  	get_device(&vdev->dev);
> @@ -351,6 +397,10 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	struct video_device *vdev = video_devdata(filp);
>  	int ret = -ENODEV;
>  
> +	ret = video_device_enter(vdev);
> +	if (ret < 0)
> +		return ret;
> +
>  	if (vdev->fops->unlocked_ioctl) {
>  		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
>  
> @@ -358,11 +408,14 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  			return -ERESTARTSYS;
>  		if (video_is_registered(vdev))
>  			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +		else
> +			ret = -ENODEV;
>  		if (lock)
>  			mutex_unlock(lock);
>  	} else
>  		ret = -ENOTTY;
>  
> +	video_device_exit(vdev);
>  	return ret;
>  }
>  
> @@ -841,6 +894,10 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	if (WARN_ON(!vdev->v4l2_dev))
>  		return -EINVAL;
>  
> +	/* unplug support */
> +	spin_lock_init(&vdev->unplug_lock);
> +	init_waitqueue_head(&vdev->unplug_wait);
> +
>  	/* v4l2_fh support */
>  	spin_lock_init(&vdev->fh_lock);
>  	INIT_LIST_HEAD(&vdev->fh_list);
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index e657614521e3..365a94f91dc9 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -15,6 +15,7 @@
>  #include <linux/cdev.h>
>  #include <linux/mutex.h>
>  #include <linux/videodev2.h>
> +#include <linux/wait.h>
>  
>  #include <media/media-entity.h>
>  
> @@ -178,6 +179,12 @@ struct v4l2_file_operations {
>   * @pipe: &struct media_pipeline
>   * @fops: pointer to &struct v4l2_file_operations for the video device
>   * @device_caps: device capabilities as used in v4l2_capabilities
> + * @unplugged: when set the device has been unplugged and no device access
> + *	section can be entered
> + * @access_refcount: number of device access section currently running for the
> + *	device
> + * @unplug_lock: protects unplugged and access_refcount
> + * @unplug_wait: wait queue to wait for device access sections to complete
>   * @dev: &struct device for the video device
>   * @cdev: character device
>   * @v4l2_dev: pointer to &struct v4l2_device parent
> @@ -221,6 +228,12 @@ struct video_device
>  
>  	u32 device_caps;
>  
> +	/* unplug handling */
> +	bool unplugged;
> +	int access_refcount;
> +	spinlock_t unplug_lock;
> +	wait_queue_head_t unplug_wait;
> +
>  	/* sysfs */
>  	struct device dev;
>  	struct cdev *cdev;
> @@ -506,4 +519,38 @@ static inline int video_is_registered(struct video_device *vdev)
>  	return test_bit(V4L2_FL_REGISTERED, &vdev->flags);
>  }
>  
> +/**
> + * video_device_enter - enter a device access section
> + * @vdev: the video device
> + *
> + * This function marks and protects the beginning of a section that should not
> + * be entered after the device has been unplugged. The section end is marked
> + * with a call to video_device_exit(). Calls to this function can be nested.
> + *
> + * Returns:
> + * 0 on success or a negative error code if the device has been unplugged.
> + */
> +int video_device_enter(struct video_device *vdev);
> +
> +/**
> + * video_device_exit - exit a device access section
> + * @vdev: the video device
> + *
> + * This function marks the end of a section entered with video_device_enter().
> + * It wakes up all tasks waiting on video_device_unplug() for device access
> + * sections to be exited.
> + */
> +void video_device_exit(struct video_device *vdev);
> +
> +/**
> + * video_device_unplug - mark a device as unplugged
> + * @vdev: the video device
> + *
> + * Mark a device as unplugged, causing all subsequent calls to
> + * video_device_enter() to return an error. If a device access section is
> + * currently being executed the function waits until the section is exited as
> + * marked by a call to video_device_exit().
> + */
> +void video_device_unplug(struct video_device *vdev);
> +
>  #endif /* _V4L2_DEV_H */
> 
