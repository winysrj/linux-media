Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB7LbUiE026102
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 16:37:31 -0500
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB7LbIu7003286
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 16:37:18 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 7 Dec 2008 22:37:23 +0100
References: <200812071314.17267.laurent.pinchart@skynet.be>
	<200812071634.46842.hverkuil@xs4all.nl>
In-Reply-To: <200812071634.46842.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072237.23769.laurent.pinchart@skynet.be>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: [BUG] Race condition between open and disconnect
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

On Sunday 07 December 2008, Hans Verkuil wrote:
> Hi Laurent,
>
> On Sunday 07 December 2008 13:14:17 Laurent Pinchart wrote:
> > Hi everybody,
> >
> > I'm afraid to report that the move to the cdev interface in 2.6.28
> > has introduced a race condition between open and disconnect.
> >
> > To avoid the need of a reference count in every v4l2 driver, v4l2
> > moved to cdev which includes its own reference counting
> > infrastructure based on kobject.
>
> It actually seems to be a cdev race condition that can happen with other
> char devices as well. However, there is also a bug in v4l2-dev that
> makes it worse.
>
> Please try attached patch. You will still get the kref WARN, but
> otherwise it should work OK.
>
> diff -r 1dc46cdcf365 linux/drivers/media/video/v4l2-dev.c
> --- a/linux/drivers/media/video/v4l2-dev.c	Sat Dec 06 11:29:33 2008 +0100
> +++ b/linux/drivers/media/video/v4l2-dev.c	Sun Dec 07 16:28:47 2008 +0100
> @@ -110,11 +110,23 @@
>  static void v4l2_chardev_release(struct kobject *kobj)
>  {
>  	struct video_device *vfd = container_of(kobj, struct video_device,
> cdev.kobj); +
> +	/* Release the character device, ensures that afterwards this
> +	   chardev cannot be opened again. */
> +	vfd->cdev_release(kobj);
> +
> +	/* If someone tried to open this chardev while we are still in the
> +	   process of deleting it then the refcount will be non-zero. */
> +	if (atomic_read(&kobj->kref.refcount)) {
> +		/* Do nothing, the next time the refcount goes to zero
> +		   we will be called again. */
> +		return;
> +	}

This works, but the workaround is quite ugly. We need a proper solution to get 
rid of the kref WARN.

>
>  	mutex_lock(&videodev_lock);
>  	if (video_device[vfd->minor] != vfd) {
>  		mutex_unlock(&videodev_lock);
> -		BUG();
> +		WARN(1, "Inconsistent vfd on minor %d!\n", vfd->minor);

WARN is indeed much better than BUG here.

>  		return;
>  	}
>
> @@ -123,8 +135,6 @@
>  	clear_bit(vfd->num, video_nums[vfd->vfl_type]);
>  	mutex_unlock(&videodev_lock);
>
> -	/* Release the character device */
> -	vfd->cdev_release(kobj);
>  	/* Release video_device and perform other
>  	   cleanups as needed. */
>  	if (vfd->release)
>
>
> Did you get these WARN and BUG messages in a 'real-life' situation as
> well, or only when you put in an msleep?

msleep doesn't turn real-life situations into virtual situations :-) 
Reproducing the bug without the delay is much harder as the race window is 
narrow. The bug can happen without msleep, I just didn't bother trying to 
reproduce it.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
