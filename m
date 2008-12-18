Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIMueci022381
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 17:56:40 -0500
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIMuQTN030473
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 17:56:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Thu, 18 Dec 2008 23:56:24 +0100
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200812182356.24739.hverkuil@xs4all.nl>
Cc: 
Subject: [PATCH] Please review V3 of v4l2-dev.c
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

OK, I think I finally got it right.

The latest version is in my usual ~hverkuil/v4l-dvb hg tree. The diff is not 
useful, I recommend looking at the source itself.

One big difference between this and the previous version is that v4l2-dev 
now overrides all file_operations (at least the ones used by the v4l2 
drivers) rather than only open and release. It turned out that you cannot 
embed a file_operations struct inside video_device since after video_device 
is released and freed the kernel __fput function still uses a reference to 
it.

So now v4l2-dev has two const static file_operations structs: one for 
drivers using unlocked_ioctl and one for drivers using the normal ioctl. 
The kernel assumes only one of these is set, so I can't merge it.

One useful property of using the release() callback of the device struct is 
that once the device is unregistered it is not possible to obtain a new 
reference to it since it is removed from all the internal data structs. So 
when the refcount finally goes to 0 there is no race condition anymore 
(like with cdev) where someone else can obtain a new reference while the 
kref's release() is called.

For the same reason we do not need to lock when refcounting. The only tricky 
bit is to ensure that open() will fail if the device is unregistered. 
Marking or testing the 'unregistered' flag and using or changing the global 
video_device array must all be done under the videodev_lock mutex, 
otherwise we cannot rely on a consistent state.

Note that the file_operations overrides look a bit odd since each op uses a 
different return value when the driver doesn't support that op. I carefully 
checked which value the kernel uses in case a driver doesn't support the op 
and used that here as well.

The cdev field in video_device is now a pointer since after the video_device 
is freed the cdev might still be in use. By allocating it dynamically cdev 
will automatically free itself when its refcount goes to 0.

I haven't been able to break it and I think it is now really correct.

Some notes on future work:

An obvious change to the drivers would be to create our own file_operations 
(v4l2_operations) that only contains the subset that is currently 
overridden. It allows us to pass the vfd pointer directly to the driver (no 
need to look it up in the driver). In addition we can remove the 
compat_ioctl op altogether since that can be handled directly in v4l2-dev. 
We also need this so that we can catch new drivers that try to use a new op 
that's not yet overridden in v4l2-dev.

Please test and review!

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
