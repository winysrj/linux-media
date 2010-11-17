Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:60167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab0KQIXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 03:23:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 14/15] V4L: improve the BKL replacement heuristic
Date: Wed, 17 Nov 2010 09:23:05 +0100
Cc: linux-media@vger.kernel.org
References: <cover.1289944159.git.hverkuil@xs4all.nl> <ce95783505f7de21e3ed43f277c764afad2d8262.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <ce95783505f7de21e3ed43f277c764afad2d8262.1289944160.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170923.06467.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010 22:56:45 Hans Verkuil wrote:
> The BKL replacement mutex had some serious performance side-effects on
> V4L drivers. It is replaced by a better heuristic that works around the
> worst of the side-effects.
> 
> Read the v4l2-dev.c comments for the whole sorry story. This is a
> temporary measure only until we can convert all v4l drivers to use
> unlocked_ioctl.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  drivers/media/video/v4l2-dev.c    |   37 ++++++++++++++++++++++++++++++++++---
>  drivers/media/video/v4l2-device.c |    1 +
>  include/media/v4l2-dev.h          |    2 +-
>  include/media/v4l2-device.h       |    2 ++
>  4 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 8eb0756..59ef642 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -258,11 +258,42 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		if (vdev->lock)
>  			mutex_unlock(vdev->lock);
>  	} else if (vdev->fops->ioctl) {
> -		/* TODO: convert all drivers to unlocked_ioctl */
> -		lock_kernel();
> +		/* This code path is a replacement for the BKL. It is a major
> +		 * hack but it will have to do for those drivers that are not
> +		 * yet converted to use unlocked_ioctl.
> +		 *
> +		 * There are two options: if the driver implements struct
> +		 * v4l2_device, then the lock defined there is used to
> +		 * serialize the ioctls. Otherwise the v4l2 core lock defined
> +		 * below is used. This lock is really bad since it serializes
> +		 * completely independent devices.
> +		 *
> +		 * Both variants suffer from the same problem: if the driver
> +		 * sleeps, then it blocks all ioctls since the lock is still
> +		 * held. This is very common for VIDIOC_DQBUF since that
> +		 * normally waits for a frame to arrive. As a result any other
> +		 * ioctl calls will proceed very, very slowly since each call
> +		 * will have to wait for the VIDIOC_QBUF to finish. Things that
> +		 * should take 0.01s may now take 10-20 seconds.
> +		 *
> +		 * The workaround is to *not* take the lock for VIDIOC_DQBUF.
> +		 * This actually works OK for videobuf-based drivers, since
> +		 * videobuf will take its own internal lock.
> +		 */
> +		static DEFINE_MUTEX(v4l2_ioctl_mutex);
> +		struct mutex *m = vdev->v4l2_dev ?
> +			&vdev->v4l2_dev->ioctl_lock : &v4l2_ioctl_mutex;
> +
> +		if (cmd != VIDIOC_DQBUF) {
> +			int res = mutex_lock_interruptible(m);
> +
> +			if (res)
> +				return res;
> +		}
>  		if (video_is_registered(vdev))
>  			ret = vdev->fops->ioctl(filp, cmd, arg);
> -		unlock_kernel();
> +		if (cmd != VIDIOC_DQBUF)
> +			mutex_unlock(m);
>  	} else
>  		ret = -ENOTTY;
>  
> diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
> index 0b08f96..7fe6f92 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -35,6 +35,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
>  
>  	INIT_LIST_HEAD(&v4l2_dev->subdevs);
>  	spin_lock_init(&v4l2_dev->lock);
> +	mutex_init(&v4l2_dev->ioctl_lock);
>  	v4l2_dev->dev = dev;
>  	if (dev == NULL) {
>  		/* If dev == NULL, then name must be filled in by the caller */
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 15802a0..59dec5a 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -39,7 +39,7 @@ struct v4l2_file_operations {
>  	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
>  	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
>  	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> -	long (*ioctl) (struct file *, unsigned int, unsigned long);
> +	long (*ioctl __deprecated) (struct file *, unsigned int, unsigned long);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
>  	int (*open) (struct file *);
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 6648036..b16f307 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -51,6 +51,8 @@ struct v4l2_device {
>  			unsigned int notification, void *arg);
>  	/* The control handler. May be NULL. */
>  	struct v4l2_ctrl_handler *ctrl_handler;
> +	/* BKL replacement mutex. Temporary solution only. */
> +	struct mutex ioctl_lock;
>  };
>  
>  /* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.
> 
