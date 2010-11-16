Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4837 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0KPOuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 09:50:40 -0500
Message-ID: <b8ec38c9574d2b83b5e9bf9fd0bb45c1.squirrel@webmail.xs4all.nl>
In-Reply-To: <201011161522.19758.arnd@arndb.de>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
    <4CE281E8.3040705@redhat.com>
    <7d7108eaf1260587bbe2cacf8f5d2db9.squirrel@webmail.xs4all.nl>
    <201011161522.19758.arnd@arndb.de>
Date: Tue, 16 Nov 2010 15:50:21 +0100
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> On Tuesday 16 November 2010, Hans Verkuil wrote:
>> No, it will also affect e.g. two bttv cards that you capture from in
>> parallel. Or two webcams, or...
>
> Would it be safe to turn the global mutex into a per-driver or per-device
> mutex? That would largely mitigate the impact as far as I can tell.

What would work better is to add a mutex to struct v4l2_device (which is
the top-level struct for v4l devices) and have the core lock that.

A pointer to this struct is available in vdev->v4l2_dev. However, not all
drivers implement struct v4l2_device. But on the other hand, most relevant
drivers do. So as a fallback we would still need a static mutex.

What would be best is to add an #ifdef CONFIG_LOCK_KERNEL and use the BKL
there. In the #else we can use a v4l2_device mutex, or (if not set) a
static mutex.

Hardly elegant, but it'll have to do.

>> We can't just ditch the BKL yet for 2.6.37 IMHO. Perhaps for 2.6.38 if
>> we
>> all work really hard to convert everything.
>
> Linus was pretty clear in that he wanted to make the default for the BKL
> disabled for 2.6.37. That may of course change if there are significant
> problems with this, but as long as there is an easier way, we could do
> that instead.
>
> I have not tested the patch below, but maybe that would solve the
> immediate problem without reverting v4l2-dev back to use the BKL.
>
> It would not work if we have drivers that need to serialize access
> to multiple v4l2 devices in their ioctl functions because they access
> global data, which is unlikely but possible.

It's very likely, I'm afraid :-(

Regards,

       Hans

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c
> index 03f7f46..5873d12 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -246,12 +246,11 @@ static long v4l2_ioctl(struct file *filp, unsigned
> int cmd, unsigned long arg)
>  			mutex_unlock(vdev->lock);
>  	} else if (vdev->fops->ioctl) {
>  		/* TODO: convert all drivers to unlocked_ioctl */
> -		static DEFINE_MUTEX(v4l2_ioctl_mutex);
> -
> -		mutex_lock(&v4l2_ioctl_mutex);
> -		if (video_is_registered(vdev))
> +		if (video_is_registered(vdev)) {
> +			mutex_lock(&vdev->ioctl_lock);
>  			ret = vdev->fops->ioctl(filp, cmd, arg);
> -		mutex_unlock(&v4l2_ioctl_mutex);
> +			mutex_unlock(&vdev->ioctl_lock);
> +		}
>  	} else
>  		ret = -ENOTTY;
>
> @@ -507,6 +506,7 @@ static int __video_register_device(struct video_device
> *vdev, int type, int nr,
>  #endif
>  	vdev->minor = i + minor_offset;
>  	vdev->num = nr;
> +	mutex_init(&vdev->ioctl_lock);
>  	devnode_set(vdev);
>
>  	/* Should not happen since we thought this minor was free */
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 15802a0..e8a8485 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -97,6 +97,9 @@ struct video_device
>
>  	/* serialization lock */
>  	struct mutex *lock;
> +
> +	/* used for the legacy locked ioctl */
> +	struct mutex ioctl_lock;
>  };
>
>  /* dev to video-device */
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

