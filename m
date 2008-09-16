Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8GKTNDp015858
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 16:29:23 -0400
Received: from mailrelay008.isp.belgacom.be (mailrelay008.isp.belgacom.be
	[195.238.6.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8GKSwTE012584
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 16:29:09 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: tom.leiming@gmail.com
Date: Tue, 16 Sep 2008 22:29:04 +0200
References: <3a6992f8ffa62f7d20c751a01093daf5b3312eab.1221532628.git.tom.leiming@gmail.com>
In-Reply-To: <3a6992f8ffa62f7d20c751a01093daf5b3312eab.1221532628.git.tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809162229.04520.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de,
	mchehab@infradead.org
Subject: Re: [PATCH] V4L/DVB:usbvideo:don't use part of buffer for USB
	transfer #4
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

On Tuesday 16 September 2008, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
>
> The status[] is part of  uvc_device structure. We can't make sure
> the address of status is at a cache-line boundary in all archs,so
> status[] might share a cache-line with some fields in uvc_structure.
> This can lead to some cache coherence
> issues(http://lwn.net/Articles/2265/). Use dynamically allocated buffer
> instead.

Thanks for fixing this.

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

Mauro, can you please apply the patch ?

> ---
>  drivers/media/video/uvc/uvc_status.c |   11 +++++++++--
>  drivers/media/video/uvc/uvcvideo.h   |    4 +++-
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_status.c
> b/drivers/media/video/uvc/uvc_status.c index 75e678a..5d60b26 100644
> --- a/drivers/media/video/uvc/uvc_status.c
> +++ b/drivers/media/video/uvc/uvc_status.c
> @@ -177,9 +177,15 @@ int uvc_status_init(struct uvc_device *dev)
>
>  	uvc_input_init(dev);
>
> +	dev->status = kzalloc(UVC_MAX_STATUS_SIZE, GFP_KERNEL);
> +	if (dev->status == NULL)
> +		return -ENOMEM;
> +
>  	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
> -	if (dev->int_urb == NULL)
> +	if (dev->int_urb == NULL) {
> +		kfree(dev->status);
>  		return -ENOMEM;
> +	}
>
>  	pipe = usb_rcvintpipe(dev->udev, ep->desc.bEndpointAddress);
>
> @@ -192,7 +198,7 @@ int uvc_status_init(struct uvc_device *dev)
>  		interval = fls(interval) - 1;
>
>  	usb_fill_int_urb(dev->int_urb, dev->udev, pipe,
> -		dev->status, sizeof dev->status, uvc_status_complete,
> +		dev->status, UVC_MAX_STATUS_SIZE, uvc_status_complete,
>  		dev, interval);
>
>  	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
> @@ -202,6 +208,7 @@ void uvc_status_cleanup(struct uvc_device *dev)
>  {
>  	usb_kill_urb(dev->int_urb);
>  	usb_free_urb(dev->int_urb);
> +	kfree(dev->status);
>  	uvc_input_cleanup(dev);
>  }
>
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index bafe340..9a6bc1a 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -303,6 +303,8 @@ struct uvc_xu_control {
>  #define UVC_MAX_FRAME_SIZE	(16*1024*1024)
>  /* Maximum number of video buffers. */
>  #define UVC_MAX_VIDEO_BUFFERS	32
> +/* Maximum status buffer size in bytes of interrupt URB. */
> +#define UVC_MAX_STATUS_SIZE	16
>
>  #define UVC_CTRL_CONTROL_TIMEOUT	300
>  #define UVC_CTRL_STREAMING_TIMEOUT	1000
> @@ -634,7 +636,7 @@ struct uvc_device {
>  	/* Status Interrupt Endpoint */
>  	struct usb_host_endpoint *int_ep;
>  	struct urb *int_urb;
> -	__u8 status[16];
> +	__u8 *status;
>  	struct input_dev *input;
>
>  	/* Video Streaming interfaces */


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
