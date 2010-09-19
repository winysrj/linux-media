Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0ISLnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 07:43:52 -0400
Message-ID: <4C95F76F.9090103@redhat.com>
Date: Sun, 19 Sep 2010 08:43:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <201009191229.35800.hverkuil@xs4all.nl>
In-Reply-To: <201009191229.35800.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Em 19-09-2010 07:29, Hans Verkuil escreveu:
> We need to work on getting rid of the BKL, but to do that safely we need a
> simple way to convert the many drivers that do not use unlocked_ioctl.
> 
> Typically you want to serialize using a mutex. This is trivial to do in the
> driver itself for the normal open/read/write/poll/mmap and release fops.
> 
> But for unlocked_ioctl it is a bit harder since we like drivers to use
> video_ioctl2 directly. And you don't want drivers to put mutex_lock/unlock
> calls in every v4l2_ioctl_ops function.
> 
> One solution is to add a mutex pointer to struct video_device that
> v4l2_unlocked_ioctl can use to do locking:
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 30461cf..44c37e5 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -236,12 +236,18 @@ static long v4l2_unlocked_ioctl(struct file *filp,
>                 unsigned int cmd, unsigned long arg)
>  {
>         struct video_device *vdev = video_devdata(filp);
> +       int ret;
>  
>         if (!vdev->fops->unlocked_ioctl)
>                 return -ENOTTY;
> +       if (vdev->ioctl_lock)
> +               mutex_lock(vdev->ioctl_lock);
>         /* Allow ioctl to continue even if the device was unregistered.
>            Things like dequeueing buffers might still be useful. */
> -       return vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +       ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +       if (vdev->ioctl_lock)
> +               mutex_unlock(vdev->ioctl_lock);
> +       return ret;
>  }
>  
>  #ifdef CONFIG_MMU
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 1efcacb..e1ad38a 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -97,6 +97,8 @@ struct video_device
>  
>         /* ioctl callbacks */
>         const struct v4l2_ioctl_ops *ioctl_ops;
> +
> +       struct mutex *ioctl_lock;
>  };
>  
>  /* dev to video-device */

As I comment with you on IRC, I'm working on it during this weekend. 

A per-dev lock may not be good on devices where you have lots of interfaces, and that allows
more than one stream per interface.

So, I did a different implementation, implementing the mutex pointer per file handler.
On devices that a simple lock is possible, all you need to do is to use the same locking
for all file handles, but if drivers want a finer control, they can use a per-file handler
lock.

I'm adding the patches I did at media-tree.git. I've created a separate branch there (devel/bkl):
	http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/devel/bkl

I've already applied there the other BKL-lock removal patches I've sent before, plus one new
one, fixing a lock unbalance at bttv poll function (changeset 32d1c90c85).

The v4l2 core patches are at:

http://git.linuxtv.org/media_tree.git?a=commit;h=285267378581fbf852f24f3f99d2e937cd200fd5
http://git.linuxtv.org/media_tree.git?a=commit;h=5f7b2159c87b08d4f0961c233a2d1d1b87c8b38d

The approach I took serializes open, close, ioctl, mmap, read and poll, e. g. all file operations
done by the V4L devices.

> One area where this may run into problems is with videobuf. The videobuf
> subsystem has its own vb_lock, so that will give multiple levels of locking.
> More importantly, videobuf can sleep and you don't want to have the global
> lock preventing access to the device node.
> 
> One option is to let videobuf use the same mutex. However, I don't believe
> that is feasible with the current videobuf. Although I hope that this can
> be implemented for vb2.
> 
> That leaves one other option: the driver has to unlock the global lock before
> calling videobuf functions and take the lock again afterwards. I think this is
> actually only limited to qbuf and dqbuf so the impact will be small.
>
> Another place where a wait occurs is in v4l2_event_dequeue. But that's part
> of the core, so we can unlock ioctl_lock there and lock it afterwards. No
> driver changes required.

I did a similar patch to videobuf, allowing an optional lock at videobuf:

http://git.linuxtv.org/media_tree.git?a=commit;h=5f7b2159c87b08d4f0961c233a2d1d1b87c8b38d
http://git.linuxtv.org/media_tree.git?a=commit;h=d14bb839803b662604de627451fe19daa697d1dc

As all mutex-dependent videobuf operations happen during the call of one of the fops, there's
no need of an explicit call inside videobuf.

In order to test it, I've ported two drivers: vivi and em28xx:

http://git.linuxtv.org/media_tree.git?a=commit;h=7ddc1b6ef803014f6ed297c391e774d044d72f9d
http://git.linuxtv.org/media_tree.git?a=commit;h=b59117ed27706bf6059eeabf2698d1d33e2e67d0

On both cases, the lock seems to be enough. I even removed em28xx while streaming, with 
mplayer reproducing the stream and with qv4l2 running. I didn't notice a single issue.

We could need to do some changes there to cover the case where videobuf sleeps, maybe using
mutex_lock_interruptible at core, in order to allow abort userspace, if the driver fails
to fill the buffers (tests are needed).

> One other thing that I do not like is this:
> 
>         /* Allow ioctl to continue even if the device was unregistered.
>            Things like dequeueing buffers might still be useful. */
>         return vdev->fops->unlocked_ioctl(filp, cmd, arg);
> 
> I do not believe drivers can do anything useful once the device is unregistered
> except just close the file handle. There are two exceptions to this: poll()
> and VIDIOC_DQEVENT.
> 
> Right now drivers have no way of detecting that a disconnect happened. It would
> be easy to add a disconnect event and let the core issue it automatically. The
> only thing needed is that VIDIOC_DQEVENT ioctls are passed on and that poll
> raises an exception. Since all the information regarding events is available in
> the core framework it is easy to do this transparently.
> 
> So effectively, once a driver unregistered a device node it will never get
> called again on that device node except for the release call. That is very
> useful for a driver.
> 
> And since we can do this in the core, it will also be consistent for all
> drivers.

I think we should implement a way to detect disconnections. This will allow simplifying the
code at the drivers. Yet, I don't think that the solution is (only) to create an
event. Instead, we need to see how this information could be retrieved from the bus.
As the normal case for disconnections is for USB devices, we basically need to implement
a callback when a diconnection happens. The USB core knows about that, but I don't know
if it provides a callback for it. If it provides, drivers may just implement the callback,
calling buffer_release, and saying to V4L2 core that the device is disconnected. V4L2 core
can then properly handle any new fops to that device, passing to the device just the
close() events, returning -ENODEV and POLLERR for userspace.

Cheers,
Mauro

PS.: I'll review your BKL removal patches and apply there, for us to have a common place for the
BKL patches, before being ready to merge all of them at the staging branch.
