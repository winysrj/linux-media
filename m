Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIHtAgP010926
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 12:55:10 -0500
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIHstKB008639
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 12:54:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Thu, 18 Dec 2008 18:54:49 +0100
References: <200812180109.51813.hverkuil@xs4all.nl>
	<200812181231.41885.hverkuil@xs4all.nl>
	<200812181529.35986.laurent.pinchart@skynet.be>
In-Reply-To: <200812181529.35986.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181854.49633.hverkuil@xs4all.nl>
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

On Thursday 18 December 2008 15:29:35 Laurent Pinchart wrote:
> Hi Hans,
>
> On Thursday 18 December 2008, Hans Verkuil wrote:
> > On Thursday 18 December 2008 11:23:14 Hans de Goede wrote:
> > > <resend with reply to all>
> > >
> > > Hans Verkuil wrote:
> > > > Hi all,
> > > >
> > > > My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev
> > > > release code in favor of using the refcounting and release callback
> > > > from the device struct. Based on the discussion on the kernel list
> > > > regarding the use of cdev refcounting it became clear that that was
> > > > not the right solution, hence this change.
> > >
> > > I haven't tested it, but I have reviewed it. In general it looks ok,
> > > but:
>
> Ditto.
>
> Could you use a V4L2_FLAG_ prefix instead of VFL_FL_ ?
>
> $ find include/ -type f -exec grep VFL_ {} \; | wc
>      12      36     413
> $ find include/ -type f -exec grep V4L_ {} \; | wc
>       2       4      58
> $ find include/ -type f -exec grep V4L2_ {} \; | wc
>    1178    5096   59839

I've switched to V4L2_FL_.

> > > I do not like the VFL_FL_REGISTERED trickery. Why not just hold the
> > > videodev_lock in video_register_device_index until completely done?
> > > It is not like these are functions which will get called many times a
> > > second. This will also lead to cleaner code.
> >
> > This flag is meant to handle the case where a USB device is
> > disconnected while an application is still using the video device. In
> > that case the disconnect routine unregisters the video device, but it
> > is still possible to open the device if the device node was made with
> > mknod instead of handled by udev. So it is still possible to call open.
> > Currently drivers need to check for this, but it is much easier to
> > catch this in the v4l core directly.
>
> The flag is indeed needed, but I'd use a V4L2_FLAG_UNREGISTERED (or
> V4L2_FLAG_UNREGISTER_PENDING) instead. You wouldn't have to explicitly
> clear it when registering the device.

Done.

> > Note that eventually all the file_operations that v4l drivers use will
> > go through similar code as is now done for open and release. So all
> > those operations will do the same test and hopefully drivers don't need
> > to be bothered about it.
>
> I don't completely agree with that. While an open() calls should
> obviously fails when the device has been or is being unregistered, ioctls
> might make sense, for instance to dequeue remaining buffers.

True. Something to keep in mind.

> > There are some other neat things you can do if all ops
> > go through some standard function first (e.g. proper priority
> > handling), but that's for the future.
> >
> > > last, device_* seem to have the same problem as cdev_*, when
> > > video_unregister_device and v4l2_release race, we can still end up
> > > with a kref_put race. I see you've fixed this by taking videodev_lock
> > > around device_unregister() and device_put(), but IMHO this really
> > > should happen in drivers/base/core.c, other drivers might vary well
> > > hit the same issue. Seems you need to hit gkh a bit more with that
> > > clue stick of yours :) (note this last one is not a blocker, but
> > > would be nice to get fixed eventually).
> >
> > It seems that the rule is that drivers need to take care of their own
> > locking. Personally I suspect that there are no doubt a lot of drivers
> > that don't do that properly. I don't think it is a terribly good idea
> > to start messing with this, though. I prefer to concentrate on doing
> > the right thing in the v4l framework, that's already difficult enough.
> >
> > One change I made is that the video_device release() callback is now
> > called without holding the global mutex. Since the release() can take
> > some time depending on what it is doing it's much better not to hold
> > that lock. It takes a bit of extra code, but it's well worth it.
>
> This will only work if put_device() is never called from outside of
> v4l2-dev. Is that guaranteed ? Could something else take a reference to
> the device ? In case of doubt we should probably remove the optimisation
> for now and call vfd->release with the lock held.

Good point. I've reverted that part of the patch. I need to dig deeper into 
the device code in the kernel to figure out what the best approach is.

> [Patch inlined for easier review]
>
> > diff -r 7ec490a64a56 linux/drivers/media/video/v4l2-dev.c
> > --- a/linux/drivers/media/video/v4l2-dev.c	Tue Dec 16 14:41:57 2008
> > +0100 +++ b/linux/drivers/media/video/v4l2-dev.c	Thu Dec 18 13:28:00
> > 2008 +0100 @@ -106,58 +106,40 @@
> >  }
> >  EXPORT_SYMBOL(video_device_release_empty);
> >
> > -/* Called when the last user of the character device is gone. */
> > -static void v4l2_chardev_release(struct kobject *kobj)
> > +
> > +/* Called when the last user of the video device exits.
> > +   Note that the videodev_lock mutex is locked when this
> > +   function is called. */
>
> Is this always true ? put_device() is called by v4l2-dev with the
> video_lock mutex held, but could it be called through other code paths ?
> sysfs maybe ?

I think you are right again. Grr, why is this so hard to do?

>
> [snip]
>
> > @@ -170,6 +152,66 @@
> >  #endif
> >  }
> >  EXPORT_SYMBOL(video_devdata);
> > +
> > +/* Override for the open function */
> > +static int v4l2_open(struct inode *inode, struct file *filp)
> > +{
> > +	struct video_device *vfd;
> > +	int ret;
> > +
> > +	/* Check if the video device is available */
> > +	mutex_lock(&videodev_lock);
> > +	vfd = video_devdata(filp);
> > +	/* return ENODEV if the video device has been removed
> > +	   already or if it is not registered. */
> > +	if (vfd == NULL || !test_bit(VFL_FL_REGISTERED, &vfd->flags)) {
> > +		mutex_unlock(&videodev_lock);
> > +		return -ENODEV;
> > +	}
> > +	/* and increase the device refcount */
> > +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> > +	class_device_get(&vfd->dev);
> > +#else
> > +	get_device(&vfd->dev);
> > +#endif
> > +	mutex_unlock(&videodev_lock);
> > +	ret = vfd->fops->open(inode, filp);
> > +	if (ret) {
> > +		mutex_lock(&videodev_lock);
> > +		/* decrease the refcount in case of an error */
> > +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> > +		class_device_put(&vfd->dev);
> > +#else
> > +		put_device(&vfd->dev);
> > +#endif
> > +		mutex_unlock(&videodev_lock);
> > +		/* Check if the video_device can be released */
> > +		if (test_bit(VFL_FL_RELEASE, &vfd->flags) && vfd->release)
>
> Can vfd->release be NULL ? There's a BUG_ON in
> video_register_device_index. The check should be removed here.

Correct.

...

> > +	/* use bitops to set/clear/test flags */
> > +	u16 flags;
>
> clear_bit/set_bit/ macros use unsigned long pointers.

Correct.

I've fixed all the smaller points in my tree. Tonight or tomorrow I'll look 
closer on how to safely find the moment that vfd->release can be called.

Thanks for the good review!

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
