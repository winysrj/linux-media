Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJE38KA003336
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 09:03:08 -0500
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJE31vE021332
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 09:03:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 19 Dec 2008 15:02:58 +0100
References: <200812182356.24739.hverkuil@xs4all.nl>
In-Reply-To: <200812182356.24739.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812191502.59040.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH] Please review V3 of v4l2-dev.c
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

I've taken your comments from the other thread and appended them below. That 
way it is clear that it relates to V3 of my patch.

On Friday 19 December 2008 14:24:42 Hans de Goede wrote:
> On Thursday 18 December 2008 23:56:24 Hans Verkuil wrote:
> > OK, I think I finally got it right.
> >
> > The latest version is in my usual ~hverkuil/v4l-dvb hg tree. The diff
> > is not useful, I recommend looking at the source itself.
> >
> > One big difference between this and the previous version is that
> > v4l2-dev now overrides all file_operations (at least the ones used by
> > the v4l2 drivers) rather than only open and release. It turned out that
> > you cannot embed a file_operations struct inside video_device since
> > after video_device is released and freed the kernel __fput function
> > still uses a reference to it.
> >
> > So now v4l2-dev has two const static file_operations structs: one for
> > drivers using unlocked_ioctl and one for drivers using the normal
> > ioctl. The kernel assumes only one of these is set, so I can't merge
> > it.
> >
> > One useful property of using the release() callback of the device
> > struct is that once the device is unregistered it is not possible to
> > obtain a new reference to it since it is removed from all the internal
> > data structs. So when the refcount finally goes to 0 there is no race
> > condition anymore (like with cdev) where someone else can obtain a new
> > reference while the kref's release() is called.
> >
> > For the same reason we do not need to lock when refcounting. The only
> > tricky bit is to ensure that open() will fail if the device is
> > unregistered. Marking or testing the 'unregistered' flag and using or
> > changing the global video_device array must all be done under the
> > videodev_lock mutex, otherwise we cannot rely on a consistent state.
> >
> > Note that the file_operations overrides look a bit odd since each op
> > uses a different return value when the driver doesn't support that op.
> > I carefully checked which value the kernel uses in case a driver
> > doesn't support the op and used that here as well.
> >
> > The cdev field in video_device is now a pointer since after the
> > video_device is freed the cdev might still be in use. By allocating it
> > dynamically cdev will automatically free itself when its refcount goes
> > to 0.
> >
> > I haven't been able to break it and I think it is now really correct.
> >
> > Some notes on future work:
> >
> > An obvious change to the drivers would be to create our own
> > file_operations (v4l2_operations) that only contains the subset that is
> > currently overridden. It allows us to pass the vfd pointer directly to
> > the driver (no need to look it up in the driver). In addition we can
> > remove the compat_ioctl op altogether since that can be handled
> > directly in v4l2-dev. We also need this so that we can catch new
> > drivers that try to use a new op that's not yet overridden in v4l2-dev.
> >
> > Please test and review!
> >
> > Thanks,
> >
> > 	Hans
>
> I do still have one issue with your new code, there still is a open /
> release(through unregister) race.
>
> Take the following:
>
> (the device is open 0 times)
> unregister gets called
> release gets called
> release gets done till the "mutex_unlock(&videodev_lock);"
> register gets called (camera replugged, usb glitch), problem:
> This new device will get the same minor as the just unregistered one!
> So cdev_add will get called for already used minor, cdev_add does not
> check for this! Then cdev_del will get called on the minor used for the
> new device.
>
> I believe this can be fixed by calling cdev_del inside the piece which
> has the videodev_lock.

You are absolutely right. I've been going back-and-forth about this a few 
times, but I should indeed put it inside the critical block.

I've just committed this change.

Thanks!

	Hans (the other one :)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
