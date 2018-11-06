Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59762 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbeKGIk7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 03:40:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v5 8/9] media: uvcvideo: Rename uvc_{un,}init_video()
Date: Wed, 07 Nov 2018 01:13:31 +0200
Message-ID: <1648340.AJeOYgVR3M@avalon>
In-Reply-To: <0b2eb102e4d0c4f746469b6aa0528ace9345ddde.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com> <0b2eb102e4d0c4f746469b6aa0528ace9345ddde.1541534872.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 6 November 2018 23:27:19 EET Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> We have both uvc_init_video() and uvc_video_init() calls which can be
> quite confusing to determine the process for each. Now that video
> uvc_video_enable() has been renamed to uvc_video_start_streaming(),
> adapt these calls to suit the new flow.
> 
> Rename uvc_init_video() to uvc_video_start() and uvc_uninit_video() to
> uvc_video_stop().

I agree that these functions are badly named and should be renamed. We are 
however entering the nitpicking territory :-) The two functions do more that 
starting and stopping, they also allocate and free URBs and the associated 
buffers. It could also be argued that they don't actually start and stop 
anything, as beyond URB management, they just queue the URBs initially and 
kill them. I thus wonder if we could come up with better names.

> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 0d35e933856a..020022e6ade4 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1641,7 +1641,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming
> *stream, /*
>   * Uninitialize isochronous/bulk URBs and free transfer buffers.
>   */
> -static void uvc_uninit_video(struct uvc_streaming *stream, int
> free_buffers) +static void uvc_video_stop(struct uvc_streaming *stream, int
> free_buffers) {
>  	struct uvc_urb *uvc_urb;
> 
> @@ -1718,7 +1718,7 @@ static int uvc_init_video_isoc(struct uvc_streaming
> *stream,
> 
>  		urb = usb_alloc_urb(npackets, gfp_flags);
>  		if (urb == NULL) {
> -			uvc_uninit_video(stream, 1);
> +			uvc_video_stop(stream, 1);
>  			return -ENOMEM;
>  		}
> 
> @@ -1786,7 +1786,7 @@ static int uvc_init_video_bulk(struct uvc_streaming
> *stream,
> 
>  		urb = usb_alloc_urb(0, gfp_flags);
>  		if (urb == NULL) {
> -			uvc_uninit_video(stream, 1);
> +			uvc_video_stop(stream, 1);
>  			return -ENOMEM;
>  		}
> 
> @@ -1806,7 +1806,7 @@ static int uvc_init_video_bulk(struct uvc_streaming
> *stream, /*
>   * Initialize isochronous/bulk URBs and allocate transfer buffers.
>   */
> -static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
> +static int uvc_video_start(struct uvc_streaming *stream, gfp_t gfp_flags)
>  {
>  	struct usb_interface *intf = stream->intf;
>  	struct usb_host_endpoint *ep;
> @@ -1894,7 +1894,7 @@ static int uvc_init_video(struct uvc_streaming
> *stream, gfp_t gfp_flags) if (ret < 0) {
>  			uvc_printk(KERN_ERR, "Failed to submit URB %u "
>  					"(%d).\n", i, ret);
> -			uvc_uninit_video(stream, 1);
> +			uvc_video_stop(stream, 1);
>  			return ret;
>  		}
>  	}
> @@ -1925,7 +1925,7 @@ int uvc_video_suspend(struct uvc_streaming *stream)
>  		return 0;
> 
>  	stream->frozen = 1;
> -	uvc_uninit_video(stream, 0);
> +	uvc_video_stop(stream, 0);
>  	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
>  	return 0;
>  }
> @@ -1961,7 +1961,7 @@ int uvc_video_resume(struct uvc_streaming *stream, int
> reset) if (ret < 0)
>  		return ret;
> 
> -	return uvc_init_video(stream, GFP_NOIO);
> +	return uvc_video_start(stream, GFP_NOIO);
>  }
> 
>  /* ------------------------------------------------------------------------
> @@ -2095,7 +2095,7 @@ int uvc_video_start_streaming(struct uvc_streaming
> *stream) if (ret < 0)
>  		goto error_commit;
> 
> -	ret = uvc_init_video(stream, GFP_KERNEL);
> +	ret = uvc_video_start(stream, GFP_KERNEL);
>  	if (ret < 0)
>  		goto error_video;
> 
> @@ -2111,7 +2111,7 @@ int uvc_video_start_streaming(struct uvc_streaming
> *stream)
> 
>  int uvc_video_stop_streaming(struct uvc_streaming *stream)
>  {
> -	uvc_uninit_video(stream, 1);
> +	uvc_video_stop(stream, 1);
>  	if (stream->intf->num_altsetting > 1) {
>  		usb_set_interface(stream->dev->udev,
>  				  stream->intfnum, 0);


-- 
Regards,

Laurent Pinchart
