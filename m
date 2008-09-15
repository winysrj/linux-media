Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FL1DdX010822
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 17:01:14 -0400
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FL0iXI027152
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 17:00:57 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: tom.leiming@gmail.com
Date: Mon, 15 Sep 2008 23:00:50 +0200
References: <1221488311-4861-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1221488311-4861-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809152300.50993.laurent.pinchart@skynet.be>
Cc: linx-uvc-devel@lists.berlios.de, video4linux-list@redhat.com,
	mchehab@infradead.org
Subject: Re: [RESEND/PATCH] V4L/DVB:usbvideo:don't use part of buffer for
	USB transfer #3
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

Hi,

sorry for the late reply, I was on holidays.

On Monday 15 September 2008, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
>
> The status[] is part of  uvc_device structure. We can't make sure
> the address of status is at a cache-line boundary in all archs,so
> status[] might share a cache-line with some fields in uvc_structure.
> This can lead to some cache coherence
> issues(http://lwn.net/Articles/2265/). Use dynamically allocated buffer
> instead.

Thanks for catching this. Comments below.

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/media/video/uvc/uvc_driver.c |    7 +++++++
>  drivers/media/video/uvc/uvc_status.c |    2 +-
>  drivers/media/video/uvc/uvcvideo.h   |    4 +++-
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 7e10203..fbb6bfb 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1529,6 +1529,7 @@ void uvc_delete(struct kref *kref)
>  		kfree(streaming);
>  	}
>
> +	kfree(dev->status);
>  	kfree(dev);
>  }
>
> @@ -1555,6 +1556,12 @@ static int uvc_probe(struct usb_interface *intf,
>  	INIT_LIST_HEAD(&dev->streaming);
>  	kref_init(&dev->kref);
>
> +	dev->status = kzalloc(UVC_MAX_STATUS_SIZE, GFP_KERNEL);
> +	if (dev->status == NULL) {
> +		kfree(dev);
> +		return -ENOMEM;
> +	}
> +

To keep all status-related code in a single place, please allocate the status 
buffer in uvc_status_init (and free it in uvc_status_cleanup).

>  	dev->udev = usb_get_dev(udev);
>  	dev->intf = usb_get_intf(intf);
>  	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
> diff --git a/drivers/media/video/uvc/uvc_status.c
> b/drivers/media/video/uvc/uvc_status.c index 75e678a..9f4f987 100644
> --- a/drivers/media/video/uvc/uvc_status.c
> +++ b/drivers/media/video/uvc/uvc_status.c
> @@ -192,7 +192,7 @@ int uvc_status_init(struct uvc_device *dev)
>  		interval = fls(interval) - 1;
>
>  	usb_fill_int_urb(dev->int_urb, dev->udev, pipe,
> -		dev->status, sizeof dev->status, uvc_status_complete,
> +		dev->status, UVC_MAX_STATUS_SIZE, uvc_status_complete,
>  		dev, interval);
>
>  	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
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

Otherwise the patch looks good.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
