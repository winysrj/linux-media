Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42740 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbdGaOji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 10:39:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: Re: [PATCH 3/6 v5]  uvcvideo: convert from using an atomic variable to a reference count
Date: Mon, 31 Jul 2017 17:39:48 +0300
Message-ID: <2765734.lWY1onvbeB@avalon>
In-Reply-To: <1501245205-15802-4-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-4-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

As commented on patch 1/6, please capitalize the first word after the prefix 
in the subject line (you're using the correct prefix this time ;-)). The 
comment holds for the other patches in this series.

On Friday 28 Jul 2017 14:33:22 Guennadi Liakhovetski wrote:
> When adding support for metadata nodes, we'll have to keep video
> devices registered until all metadata nodes are closed too. Since
> this has nothing to do with stream counting, replace the nstreams
> atomic variable with a reference counter.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 31 +++++++++++++++++--------------
>  drivers/media/usb/uvc/uvcvideo.h   |  2 +-
>  2 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 70842c5..cfe33bf 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1849,16 +1849,20 @@ static void uvc_delete(struct uvc_device *dev)
>  	kfree(dev);
>  }
> 
> +static void uvc_kref_release(struct kref *kref)
> +{
> +	struct uvc_device *dev = container_of(kref, struct uvc_device, ref);
> +
> +	uvc_delete(dev);

uvc_delete() is now called from kref_put() only, so I'd merge the two 
functions. I think I'd call the resulting function uvc_delete() to 
differentiate it from uvc_release(), but if you prefer uvc_kref_release() I'm 
OK with that too.

> +}
> +
>  static void uvc_release(struct video_device *vdev)
>  {
>  	struct uvc_streaming *stream = video_get_drvdata(vdev);
>  	struct uvc_device *dev = stream->dev;
> 
> -	/* Decrement the registered streams count and delete the device when
> it
> -	 * reaches zero.
> -	 */
> -	if (atomic_dec_and_test(&dev->nstreams))
> -		uvc_delete(dev);
> +	/* Decrement the refcount and delete the device when it reaches zero
> */

s/zero/zero./

Or you could remove the comment altogether, I don't think it adds much 
anymore.

> +	kref_put(&dev->ref, uvc_kref_release);
>  }
> 
>  /*
> @@ -1870,10 +1874,10 @@ static void uvc_unregister_video(struct uvc_device
> *dev)
> 
>  	/* Unregistering all video devices might result in uvc_delete() being
>  	 * called from inside the loop if there's no open file handle. To
> avoid
> -	 * that, increment the stream count before iterating over the streams
> -	 * and decrement it when done.
> +	 * that, increment the refcount before iterating over the streams and
> +	 * decrement it when done.
>  	 */
> -	atomic_inc(&dev->nstreams);
> +	kref_get(&dev->ref);
> 
>  	list_for_each_entry(stream, &dev->streams, list) {
>  		if (!video_is_registered(&stream->vdev))
> @@ -1884,11 +1888,10 @@ static void uvc_unregister_video(struct uvc_device
> *dev) uvc_debugfs_cleanup_stream(stream);
>  	}
> 
> -	/* Decrement the stream count and call uvc_delete explicitly if there
> -	 * are no stream left.
> +	/* Decrement the refcount and call uvc_delete explicitly if there are 
> no
> +	 * stream left.
>  	 */

Similarly we could drop this comment. Otherwise you should update it to not 
mention streams anymore.

The rest of the patch looks good. With those small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> -	if (atomic_dec_and_test(&dev->nstreams))
> -		uvc_delete(dev);
> +	kref_put(&dev->ref, uvc_kref_release);
>  }
> 
>  static int uvc_register_video(struct uvc_device *dev,
> @@ -1946,7 +1949,7 @@ static int uvc_register_video(struct uvc_device *dev,
>  	else
>  		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
> 
> -	atomic_inc(&dev->nstreams);
> +	kref_get(&dev->ref);
>  	return 0;
>  }
> 
> @@ -2031,7 +2034,7 @@ static int uvc_probe(struct usb_interface *intf,
>  	INIT_LIST_HEAD(&dev->entities);
>  	INIT_LIST_HEAD(&dev->chains);
>  	INIT_LIST_HEAD(&dev->streams);
> -	atomic_set(&dev->nstreams, 0);
> +	kref_init(&dev->ref);
>  	atomic_set(&dev->nmappings, 0);
>  	mutex_init(&dev->lock);
> 
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 15e415e..f157cf7 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -575,7 +575,7 @@ struct uvc_device {
> 
>  	/* Video Streaming interfaces */
>  	struct list_head streams;
> -	atomic_t nstreams;
> +	struct kref ref;
> 
>  	/* Status Interrupt Endpoint */
>  	struct usb_host_endpoint *int_ep;

-- 
Regards,

Laurent Pinchart
