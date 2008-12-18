Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIEUOvf019521
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 09:30:24 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIETYCl016395
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 09:29:34 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 18 Dec 2008 15:29:35 +0100
References: <200812180109.51813.hverkuil@xs4all.nl> <494A2492.2050106@hhs.nl>
	<200812181231.41885.hverkuil@xs4all.nl>
In-Reply-To: <200812181231.41885.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181529.35986.laurent.pinchart@skynet.be>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Please test: using the device release() callback instead of the
	cdev release
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

On Thursday 18 December 2008, Hans Verkuil wrote:
> On Thursday 18 December 2008 11:23:14 Hans de Goede wrote:
> > <resend with reply to all>
> >
> > Hans Verkuil wrote:
> > > Hi all,
> > >
> > > My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev release
> > > code in favor of using the refcounting and release callback from the
> > > device struct. Based on the discussion on the kernel list regarding the
> > > use of cdev refcounting it became clear that that was not the right
> > > solution, hence this change.
> >
> > I haven't tested it, but I have reviewed it. In general it looks ok, but:

Ditto.

Could you use a V4L2_FLAG_ prefix instead of VFL_FL_ ?

$ find include/ -type f -exec grep VFL_ {} \; | wc
     12      36     413
$ find include/ -type f -exec grep V4L_ {} \; | wc
      2       4      58
$ find include/ -type f -exec grep V4L2_ {} \; | wc
   1178    5096   59839

> > I do not like the VFL_FL_REGISTERED trickery. Why not just hold the
> > videodev_lock in video_register_device_index until completely done? It is
> > not like these are functions which will get called many times a second.
> > This will also lead to cleaner code.
>
> This flag is meant to handle the case where a USB device is disconnected
> while an application is still using the video device. In that case the
> disconnect routine unregisters the video device, but it is still possible
> to open the device if the device node was made with mknod instead of
> handled by udev. So it is still possible to call open. Currently drivers
> need to check for this, but it is much easier to catch this in the v4l core
> directly.

The flag is indeed needed, but I'd use a V4L2_FLAG_UNREGISTERED (or 
V4L2_FLAG_UNREGISTER_PENDING) instead. You wouldn't have to explicitly clear 
it when registering the device.

> Note that eventually all the file_operations that v4l drivers use will go
> through similar code as is now done for open and release. So all those
> operations will do the same test and hopefully drivers don't need to be
> bothered about it.

I don't completely agree with that. While an open() calls should obviously 
fails when the device has been or is being unregistered, ioctls might make 
sense, for instance to dequeue remaining buffers.

> There are some other neat things you can do if all ops 
> go through some standard function first (e.g. proper priority handling),
> but that's for the future.
>
> > last, device_* seem to have the same problem as cdev_*, when
> > video_unregister_device and v4l2_release race, we can still end up with a
> > kref_put race. I see you've fixed this by taking videodev_lock around
> > device_unregister() and device_put(), but IMHO this really should happen
> > in drivers/base/core.c, other drivers might vary well hit the same issue.
> > Seems you need to hit gkh a bit more with that clue stick of yours :)
> > (note this last one is not a blocker, but would be nice to get fixed
> > eventually).
>
> It seems that the rule is that drivers need to take care of their own
> locking. Personally I suspect that there are no doubt a lot of drivers that
> don't do that properly. I don't think it is a terribly good idea to start
> messing with this, though. I prefer to concentrate on doing the right thing
> in the v4l framework, that's already difficult enough.
>
> One change I made is that the video_device release() callback is now called
> without holding the global mutex. Since the release() can take some time
> depending on what it is doing it's much better not to hold that lock. It
> takes a bit of extra code, but it's well worth it.

This will only work if put_device() is never called from outside of v4l2-dev. 
Is that guaranteed ? Could something else take a reference to the device ? In 
case of doubt we should probably remove the optimisation for now and call 
vfd->release with the lock held.

[Patch inlined for easier review]

> diff -r 7ec490a64a56 linux/drivers/media/video/v4l2-dev.c
> --- a/linux/drivers/media/video/v4l2-dev.c	Tue Dec 16 14:41:57 2008 +0100
> +++ b/linux/drivers/media/video/v4l2-dev.c	Thu Dec 18 13:28:00 2008 +0100
> @@ -106,58 +106,40 @@
>  }
>  EXPORT_SYMBOL(video_device_release_empty);
>
> -/* Called when the last user of the character device is gone. */
> -static void v4l2_chardev_release(struct kobject *kobj)
> +
> +/* Called when the last user of the video device exits.
> +   Note that the videodev_lock mutex is locked when this
> +   function is called. */

Is this always true ? put_device() is called by v4l2-dev with the video_lock 
mutex held, but could it be called through other code paths ? sysfs maybe ?

[snip]

> @@ -170,6 +152,66 @@
>  #endif
>  }
>  EXPORT_SYMBOL(video_devdata);
> +
> +/* Override for the open function */
> +static int v4l2_open(struct inode *inode, struct file *filp)
> +{
> +	struct video_device *vfd;
> +	int ret;
> +
> +	/* Check if the video device is available */
> +	mutex_lock(&videodev_lock);
> +	vfd = video_devdata(filp);
> +	/* return ENODEV if the video device has been removed
> +	   already or if it is not registered. */
> +	if (vfd == NULL || !test_bit(VFL_FL_REGISTERED, &vfd->flags)) {
> +		mutex_unlock(&videodev_lock);
> +		return -ENODEV;
> +	}
> +	/* and increase the device refcount */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> +	class_device_get(&vfd->dev);
> +#else
> +	get_device(&vfd->dev);
> +#endif
> +	mutex_unlock(&videodev_lock);
> +	ret = vfd->fops->open(inode, filp);
> +	if (ret) {
> +		mutex_lock(&videodev_lock);
> +		/* decrease the refcount in case of an error */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> +		class_device_put(&vfd->dev);
> +#else
> +		put_device(&vfd->dev);
> +#endif
> +		mutex_unlock(&videodev_lock);
> +		/* Check if the video_device can be released */
> +		if (test_bit(VFL_FL_RELEASE, &vfd->flags) && vfd->release)

Can vfd->release be NULL ? There's a BUG_ON in video_register_device_index. 
The check should be removed here.

> +			vfd->release(vfd);
> +	}
> +	return ret;
> +}
> +
> +/* Override for the release function */
> +static int v4l2_release(struct inode *inode, struct file *filp)
> +{
> +	struct video_device *vfd = video_devdata(filp);
> +	int ret = vfd->fops->release(inode, filp);
> +
> +	mutex_lock(&videodev_lock);
> +	/* decrease the refcount unconditionally since the release()
> +	   return value is ignored. */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> +	class_device_put(&vfd->dev);
> +#else
> +	put_device(&vfd->dev);
> +#endif
> +	mutex_unlock(&videodev_lock);
> +	/* Check if the video_device can be released */
> +	if (test_bit(VFL_FL_RELEASE, &vfd->flags) && vfd->release)

Same as above, vfd->release shouldn't be NULL.

> +		vfd->release(vfd);
> +	return ret;
> +}
>
>  /**
>   * get_index - assign stream number based on parent device
> @@ -212,8 +254,6 @@
>  	return i > max_index ? -ENFILE : i;
>  }
>
> -static const struct file_operations video_fops;
> -
>  int video_register_device(struct video_device *vfd, int type, int nr)
>  {
>  	return video_register_device_index(vfd, type, nr, -1);
> @@ -246,7 +286,6 @@
>   *
>   *	%VFL_TYPE_RADIO - A radio card
>   */
> -
>  int video_register_device_index(struct video_device *vfd, int type, int
> nr, int index)
>  {
> @@ -314,13 +353,12 @@
>  	}
>  #endif
>
> -	/* Initialize the character device */
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 17)
> -	cdev_init(&vfd->cdev, vfd->fops);
> -#else
> -	cdev_init(&vfd->cdev, (struct file_operations *)vfd->fops);
> -#endif
> -	vfd->cdev.owner = vfd->fops->owner;
> +	/* Make a copy of the fops and override open and release.
> +	   We take care of proper refcounting. */
> +	vfd->video_fops = *vfd->fops;
> +	vfd->video_fops.open = v4l2_open;
> +	vfd->video_fops.release = v4l2_release;
> +
>  	/* pick a minor number */
>  	mutex_lock(&videodev_lock);
>  	nr = find_next_zero_bit(video_nums[type], minor_cnt, nr == -1 ? 0 : nr);
> @@ -348,7 +386,7 @@
>  	vfd->minor = i + minor_offset;
>  	vfd->num = nr;
>  	set_bit(nr, video_nums[type]);
> -	BUG_ON(video_device[vfd->minor]);
> +	WARN_ON(video_device[vfd->minor] != NULL);
>  	video_device[vfd->minor] = vfd;
>
>  	ret = get_index(vfd, index);
> @@ -361,9 +399,18 @@
>  		goto fail_minor;
>  	}
>
> -	ret = cdev_add(&vfd->cdev, MKDEV(VIDEO_MAJOR, vfd->minor), 1);
> +	/* Initialize the character device */
> +	vfd->cdev = cdev_alloc();
> +	if (vfd->cdev == NULL) {
> +		ret = -ENOMEM;
> +		goto fail_minor;
> +	}
> +	vfd->cdev->ops = &vfd->video_fops;
> +	vfd->cdev->owner = vfd->fops->owner;
> +	ret = cdev_add(vfd->cdev, MKDEV(VIDEO_MAJOR, vfd->minor), 1);
>  	if (ret < 0) {
>  		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
> +		kfree(vfd->cdev);
>  		goto fail_minor;
>  	}
>  	/* sysfs class */
> @@ -404,14 +451,14 @@
>  		goto del_cdev;
>  	}
>  #endif
> -	/* Remember the cdev's release function */
> -	vfd->cdev_release = vfd->cdev.kobj.ktype->release;
> -	/* Install our own */
> -	vfd->cdev.kobj.ktype = &v4l2_ktype_cdev_default;
> +	/* Register the release callback that will be called when the last
> +	   reference to the device goes away. */
> +	vfd->dev.release = v4l2_device_release;
> +	set_bit(VFL_FL_REGISTERED, &vfd->flags);
>  	return 0;
>
>  del_cdev:
> -	cdev_del(&vfd->cdev);
> +	cdev_del(vfd->cdev);
>
>  fail_minor:
>  	mutex_lock(&videodev_lock);
> @@ -427,17 +474,22 @@
>   *	video_unregister_device - unregister a video4linux device
>   *	@vfd: the device to unregister
>   *
> - *	This unregisters the passed device and deassigns the minor
> - *	number. Future open calls will be met with errors.
> + *	This unregisters the passed device. Future open calls will
> + *	be met with errors.
>   */
> -
>  void video_unregister_device(struct video_device *vfd)
>  {
> +	mutex_lock(&videodev_lock);
> +	clear_bit(VFL_FL_REGISTERED, &vfd->flags);
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
>  	class_device_unregister(&vfd->dev);
>  #else
>  	device_unregister(&vfd->dev);
>  #endif
> +	mutex_unlock(&videodev_lock);
> +	/* Check if the video_device can be released */
> +	if (test_bit(VFL_FL_RELEASE, &vfd->flags) && vfd->release)
> +		vfd->release(vfd);
>  }
>  EXPORT_SYMBOL(video_unregister_device);
>
> diff -r 7ec490a64a56 linux/include/media/v4l2-dev.h
> --- a/linux/include/media/v4l2-dev.h	Tue Dec 16 14:41:57 2008 +0100
> +++ b/linux/include/media/v4l2-dev.h	Thu Dec 18 13:28:00 2008 +0100
> @@ -26,6 +26,17 @@
>
>  struct v4l2_ioctl_callbacks;
>
> +/* Flag to mark the video_device struct as registered.
> +   Drivers can clear this flag if they want to block all future
> +   device access. It is set by video_register_device and
> +   video_register_device_index on success and cleared by
> +   video_unregister_device. */
> +#define VFL_FL_REGISTERED	(0)
> +/* Flag to mark that this video device needs to be released.
> +   It is set when refcount of the device went to 0.
> +   Used internally only, drivers should never touch it. */
> +#define VFL_FL_RELEASE		(1)

See my comment above about flag names.

> +
>  /*
>   * Newer version of video_device, handled by videodev2.c
>   * 	This version moves redundant code from video device code to
> @@ -36,6 +47,7 @@
>  {
>  	/* device ops */
>  	const struct file_operations *fops;
> +	struct file_operations video_fops;
>
>  	/* sysfs */
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
> @@ -43,8 +55,7 @@
>  #else
>  	struct class_device dev;
>  #endif
> -	struct cdev cdev;		/* character device */
> -	void (*cdev_release)(struct kobject *kobj);
> +	struct cdev *cdev;		/* character device */
>  	struct device *parent;		/* device parent */
>
>  	/* device info */
> @@ -52,6 +63,8 @@
>  	int vfl_type;
>  	int minor;
>  	u16 num;
> +	/* use bitops to set/clear/test flags */
> +	u16 flags;

clear_bit/set_bit/ macros use unsigned long pointers.

>  	/* attribute to differentiate multiple indices on one physical device */
>  	int index;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
