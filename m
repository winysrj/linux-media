Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3128 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3HBNAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 09:00:54 -0400
Message-ID: <51FBAD74.6060603@xs4all.nl>
Date: Fri, 02 Aug 2013 15:00:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

The patch is good, but I have some issues with the commit message itself.

On 08/02/2013 02:27 PM, Sylwester Nawrocki wrote:
> As it currently stands this code doesn't protect against any races
> between video device open() and its unregistration. Races could be
> avoided by doing the video_is_registered() check protected by the
> core mutex, while the video device unregistration is also done with
> this mutex held.

The video_unregister_device() is called completely asynchronously,
particularly in the case of usb drivers. So it was never the goal of
the video_is_registered() to be fool proof, since that isn't possible,
nor is that necessary.

The goal was that the v4l2 core would use it for the various file
operations and ioctls as a quick check whether the device was unregistered
and to return the correct error. This prevents drivers from having to do
the same thing.

> The history of this code is that the second video_is_registered()
> call has been added in commit ee6869afc922a9849979e49bb3bbcad7948
> "V4L/DVB: v4l2: add core serialization lock" together with addition
> of the core mutex support in fops:
> 
>         mutex_unlock(&videodev_lock);
> -       if (vdev->fops->open)
> -               ret = vdev->fops->open(filp);
> +       if (vdev->fops->open) {
> +               if (vdev->lock)
> +                       mutex_lock(vdev->lock);
> +               if (video_is_registered(vdev))
> +                       ret = vdev->fops->open(filp);
> +               else
> +                       ret = -ENODEV;
> +               if (vdev->lock)
> +                       mutex_unlock(vdev->lock);
> +       }

The history is slightly more complicated: this commit moved the video_is_registered
call from before the mutex_unlock(&videodev_lock); to just before the fops->open
call.

Commit ca9afe6f87b569cdf8e797395381f18ae23a2905 "v4l2-dev: fix race condition"
added the video_is_registered() call to where it was originally (inside the
videodev_lock critical section), but it didn't bother to remove the duplicate
second video_is_registered call.

So that's how v4l2_open ended up with two calls to video_is_registered.

> 
> While commit cf5337358548b813479b58478539fc20ee86556c
> "[media] v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS"
> removed only code touching the mutex:
> 
>         mutex_unlock(&videodev_lock);
>         if (vdev->fops->open) {
> -               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
> -                   mutex_lock_interruptible(vdev->lock)) {
> -                       ret = -ERESTARTSYS;
> -                       goto err;
> -               }
>                 if (video_is_registered(vdev))
>                         ret = vdev->fops->open(filp);
>                 else
>                         ret = -ENODEV;
> -               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
> -                       mutex_unlock(vdev->lock);
>         }
> 
> Remove the remaining video_is_registered() call as it doesn't provide
> any real protection and just adds unnecessary overhead.

True.

> The drivers need to perform the unregistration check themselves inside
> their file operation handlers, while holding respective mutex.

No, drivers do not need to do the unregistration check. Since unregistration
is asynchronous it can happen at any time, so there really is no point in
checking for it other than in the core. If the device is unregistered while
in the middle of a file operation, then that means that any USB activity will
return an error, and that any future file operations other than release() will
be met by an error as well from the v4l2 core.

> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index c8859d6..1743119 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -444,13 +444,9 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>  	/* and increase the device refcount */
>  	video_get(vdev);
>  	mutex_unlock(&videodev_lock);
> -	if (vdev->fops->open) {
> -		if (video_is_registered(vdev))
> -			ret = vdev->fops->open(filp);
> -		else
> -			ret = -ENODEV;
> -	}
> 
> +	if (vdev->fops->open)
> +		ret = vdev->fops->open(filp);
>  	if (vdev->debug)
>  		printk(KERN_DEBUG "%s: open (%d)\n",
>  			video_device_node_name(vdev), ret);
> --
> 1.7.9.5
> 

A long story, but the patch is good, although the commit message needs work :-)

Regards,

	Hans
