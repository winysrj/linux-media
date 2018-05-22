Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34872 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbeEVT3c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 15:29:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: Fix driver reference counting
Date: Tue, 22 May 2018 22:29:28 +0300
Message-ID: <5922100.gx7hV9CoLn@avalon>
In-Reply-To: <20180521102458.3288-1-philipp.zabel@gmail.com>
References: <20180521102458.3288-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Monday, 21 May 2018 13:24:58 EEST Philipp Zabel wrote:
> kref_init initializes the reference count to 1, not 0. This additional
> reference is never released since the conversion to reference counters.
> As a result, uvc_delete is not called anymore when UVC cameras are
> disconnected.
> Fix this by adding an additional kref_put in uvc_disconnect and in the
> probe error path. This also allows to remove the temporary additional
> reference in uvc_unregister_video.

Good catch !

> Fixes: 9d15cd958c17 ("media: uvcvideo: Convert from using an atomic variable
> to a reference count")
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This is a serious issue so I'd like to get the patch merged in v4.18, but it 
could be argued that it's getting late for that, especially given that the bug 
has been there since v4.14.

Mauro, would you be OK merging this in v4.18 ? If so could you pick it up, or 
would you like me to send a pull request ?

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 2469b49b2b30..8e138201330f
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1871,13 +1871,6 @@ static void uvc_unregister_video(struct uvc_device
> *dev) {
>  	struct uvc_streaming *stream;
> 
> -	/* Unregistering all video devices might result in uvc_delete() being
> -	 * called from inside the loop if there's no open file handle. To avoid
> -	 * that, increment the refcount before iterating over the streams and
> -	 * decrement it when done.
> -	 */
> -	kref_get(&dev->ref);
> -
>  	list_for_each_entry(stream, &dev->streams, list) {
>  		if (!video_is_registered(&stream->vdev))
>  			continue;
> @@ -1887,8 +1880,6 @@ static void uvc_unregister_video(struct uvc_device
> *dev)
> 
>  		uvc_debugfs_cleanup_stream(stream);
>  	}
> -
> -	kref_put(&dev->ref, uvc_delete);
>  }
> 
>  int uvc_register_video_device(struct uvc_device *dev,
> @@ -2184,6 +2175,7 @@ static int uvc_probe(struct usb_interface *intf,
> 
>  error:
>  	uvc_unregister_video(dev);
> +	kref_put(&dev->ref, uvc_delete);
>  	return -ENODEV;
>  }
> 
> @@ -2201,6 +2193,7 @@ static void uvc_disconnect(struct usb_interface *intf)
> return;
> 
>  	uvc_unregister_video(dev);
> +	kref_put(&dev->ref, uvc_delete);
>  }
> 
>  static int uvc_suspend(struct usb_interface *intf, pm_message_t message)

-- 
Regards,

Laurent Pinchart
