Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38843 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753938AbcL3NaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 08:30:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 2/4] uvcvideo: (cosmetic) remove a superfluous assignment
Date: Fri, 30 Dec 2016 15:30:37 +0200
Message-ID: <3876000.H63uYd8Bae@avalon>
In-Reply-To: <1481541412-1186-3-git-send-email-guennadi.liakhovetski@intel.com>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com> <1481541412-1186-3-git-send-email-guennadi.liakhovetski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Monday 12 Dec 2016 12:16:50 Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Remove a superfluous assignment to a local variable at the end of a
> function.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree for v4.11.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index b5589d5..51b5ae5 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1262,8 +1262,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream, uvc_video_decode_end(stream, buf,
> stream->bulk.header,
>  				stream->bulk.payload_size);
>  			if (buf->state == UVC_BUF_STATE_READY)
> -				buf = uvc_queue_next_buffer(&stream->queue,
> -							    buf);
> +				uvc_queue_next_buffer(&stream->queue, buf);
>  		}
> 
>  		stream->bulk.header_size = 0;

-- 
Regards,

Laurent Pinchart

