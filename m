Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2938 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0ISK3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 06:29:38 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8JATaJs029630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 12:29:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: BKL, locking and ioctls
Date: Sun, 19 Sep 2010 12:29:35 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009191229.35800.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We need to work on getting rid of the BKL, but to do that safely we need a
simple way to convert the many drivers that do not use unlocked_ioctl.

Typically you want to serialize using a mutex. This is trivial to do in the
driver itself for the normal open/read/write/poll/mmap and release fops.

But for unlocked_ioctl it is a bit harder since we like drivers to use
video_ioctl2 directly. And you don't want drivers to put mutex_lock/unlock
calls in every v4l2_ioctl_ops function.

One solution is to add a mutex pointer to struct video_device that
v4l2_unlocked_ioctl can use to do locking:

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 30461cf..44c37e5 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -236,12 +236,18 @@ static long v4l2_unlocked_ioctl(struct file *filp,
                unsigned int cmd, unsigned long arg)
 {
        struct video_device *vdev = video_devdata(filp);
+       int ret;
 
        if (!vdev->fops->unlocked_ioctl)
                return -ENOTTY;
+       if (vdev->ioctl_lock)
+               mutex_lock(vdev->ioctl_lock);
        /* Allow ioctl to continue even if the device was unregistered.
           Things like dequeueing buffers might still be useful. */
-       return vdev->fops->unlocked_ioctl(filp, cmd, arg);
+       ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
+       if (vdev->ioctl_lock)
+               mutex_unlock(vdev->ioctl_lock);
+       return ret;
 }
 
 #ifdef CONFIG_MMU
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 1efcacb..e1ad38a 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -97,6 +97,8 @@ struct video_device
 
        /* ioctl callbacks */
        const struct v4l2_ioctl_ops *ioctl_ops;
+
+       struct mutex *ioctl_lock;
 };
 
 /* dev to video-device */


One area where this may run into problems is with videobuf. The videobuf
subsystem has its own vb_lock, so that will give multiple levels of locking.
More importantly, videobuf can sleep and you don't want to have the global
lock preventing access to the device node.

One option is to let videobuf use the same mutex. However, I don't believe
that is feasible with the current videobuf. Although I hope that this can
be implemented for vb2.

That leaves one other option: the driver has to unlock the global lock before
calling videobuf functions and take the lock again afterwards. I think this is
actually only limited to qbuf and dqbuf so the impact will be small.

Another place where a wait occurs is in v4l2_event_dequeue. But that's part
of the core, so we can unlock ioctl_lock there and lock it afterwards. No
driver changes required.

One other thing that I do not like is this:

        /* Allow ioctl to continue even if the device was unregistered.
           Things like dequeueing buffers might still be useful. */
        return vdev->fops->unlocked_ioctl(filp, cmd, arg);

I do not believe drivers can do anything useful once the device is unregistered
except just close the file handle. There are two exceptions to this: poll()
and VIDIOC_DQEVENT.

Right now drivers have no way of detecting that a disconnect happened. It would
be easy to add a disconnect event and let the core issue it automatically. The
only thing needed is that VIDIOC_DQEVENT ioctls are passed on and that poll
raises an exception. Since all the information regarding events is available in
the core framework it is easy to do this transparently.

So effectively, once a driver unregistered a device node it will never get
called again on that device node except for the release call. That is very
useful for a driver.

And since we can do this in the core, it will also be consistent for all
drivers.

Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
