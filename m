Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BK7YOj027541
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 16:07:34 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6BK6qQs028517
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 16:06:54 -0400
Received: by fg-out-1718.google.com with SMTP id e21so2188923fga.7
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 13:06:51 -0700 (PDT)
Message-ID: <30353c3d0807111306t1a6cca59k63f6a204ffc2f4fc@mail.gmail.com>
Date: Fri, 11 Jul 2008 16:06:51 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <200807112132.16345.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807112132.16345.laurent.pinchart@skynet.be>
Cc: Romano Giannetti <romano@dea.icai.upcomillas.es>,
	video4linux-list@redhat.com, Roland Dreier <roland@digitalvampire.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] uvcvideo: Fix possible AB-BA deadlock with
	videodev_lock and open_mutex
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

On Fri, Jul 11, 2008 at 3:32 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> The uvcvideo driver's uvc_v4l2_open() method is called from videodev's
> video_open() function, which means it is called with the videodev_lock
> mutex held.  uvc_v4l2_open() then takes uvc_driver.open_mutex to check
> dev->state and avoid racing against a device disconnect, which means
> that open_mutex must nest inside videodev_lock.
>
> However uvc_disconnect() takes the open_mutex around setting
> dev->state and also around putting its device reference.  However, if
> uvc_disconnect() ends up dropping the last reference, it will call
> uvc_delete(), which calls into the videodev code to unregister its
> device, and this will end up taking videodev_lock.  This opens a
> (unlikely in practice) window for an AB-BA deadlock and also causes a
> lockdep warning because of the lock misordering.
>
> Fortunately there is no apparent reason to hold open_mutex when doing
> kref_put() in uvc_disconnect(): if uvc_v4l2_open() runs before the
> state is set to UVC_DEV_DISCONNECTED, then it will take another
> reference to the device and kref_put() won't call uvc_delete; if
> uvc_v4l2_open() runs after the state is set, it will run before
> uvc_delete(), see the state, and return immediately -- uvc_delete()
> does uvc_unregister_video() (and hence video_unregister_device(),
> which is synchronized with videodev_lock) as its first thing, so there
> is no risk of use-after-free in uvc_v4l2_open().
>
> Bug diagnosed based on a lockdep warning reported by Romano Giannetti
> <romano@dea.icai.upcomillas.es>.
>
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> ---
>  drivers/media/video/uvc/uvc_driver.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c
> index 14b3839..d29d28d 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1633,13 +1633,16 @@ static void uvc_disconnect(struct usb_interface *intf)
>         * reference to the uvc_device instance after uvc_v4l2_open() received
>         * the pointer to the device (video_devdata) but before it got the
>         * chance to increase the reference count (kref_get).
> +        *
> +        * Note that the reference can't be released with the lock held,
> +        * otherwise a AB-BA deadlock can occur with videodev_lock that
> +        * videodev acquires in videodev_open() and video_unregister_device().
>         */
>        mutex_lock(&uvc_driver.open_mutex);
> -
>        dev->state |= UVC_DEV_DISCONNECTED;
> -       kref_put(&dev->kref, uvc_delete);
> -
>        mutex_unlock(&uvc_driver.open_mutex);
> +
> +       kref_put(&dev->kref, uvc_delete);
>  }
>
I haven't really examined the uvc driver, but I suspect the above
reference counting may be unnecessary once videodev has been corrected
to properly increment and decrement the kobject reference count during
open and close respectively. I suspect the uvc_delete method could be
called from the video_device release callback once this happens.

Regards,

David Ellingsworth

>  static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
> --
> 1.5.4.5
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
