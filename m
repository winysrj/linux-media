Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:47413 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbZI3XuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 19:50:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: tom.leiming@gmail.com
Subject: Re: [PATCH] V4L/DVB:uvcvideo:fix uvc_alloc_urb_buffers()
Date: Thu, 1 Oct 2009 01:51:58 +0200
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
References: <1254040234-11230-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1254040234-11230-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910010151.58362.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sunday 27 September 2009 10:30:34 tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch sets stream->urb_size as psize*npackets
> before calling uvc_alloc_urb_buffers, which may fix
> a possible failure of usb_buffer_free in case usb_buffer_alloc
> returns NULL. The patch is based on the ideas below:
> 
> 1,If usb_buffer_alloc can't allocate a buffer sucessfully,
> uvc_free_urb_buffers will be called to free the allocated
> buffers, and stream->urb_size is required to be passed to
> usb_buffer_free;
> 
> 2,uvc_free_urb_buffers can reset stream->urb_size.
> 
> This patch is against linux-v2.6.31-next-20090926.

Good catch, thanks.
 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patch to my tree and I'll send a pull request.

> ---
>  drivers/media/video/uvc/uvc_video.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_video.c
>  b/drivers/media/video/uvc/uvc_video.c index f960e8e..31dba66 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -768,9 +768,10 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming
>  *stream,
> 
>  	/* Retry allocations until one succeed. */
>  	for (; npackets > 1; npackets /= 2) {
> +		stream->urb_size = psize * npackets;
>  		for (i = 0; i < UVC_URBS; ++i) {
>  			stream->urb_buffer[i] = usb_buffer_alloc(
> -				stream->dev->udev, psize * npackets,
> +				stream->dev->udev, stream->urb_size,
>  				gfp_flags | __GFP_NOWARN, &stream->urb_dma[i]);
>  			if (!stream->urb_buffer[i]) {
>  				uvc_free_urb_buffers(stream);
> @@ -779,7 +780,6 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming
>  *stream, }
> 
>  		if (i == UVC_URBS) {
> -			stream->urb_size = psize * npackets;
>  			return npackets;
>  		}
>  	}
> 

-- 
Regards,

Laurent Pinchart
