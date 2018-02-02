Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59728 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeBBLb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 06:31:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@s-opensource.com, arnd@arndb.de
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
Date: Fri, 02 Feb 2018 13:32:19 +0200
Message-ID: <1778442.ouJt2D3mk7@avalon>
In-Reply-To: <1515925303-5160-1-git-send-email-jasmin@anw.at>
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

Thank you for the patch.

On Sunday, 14 January 2018 12:21:43 EET Jasmin J. wrote:
> From: Jasmin Jessich <jasmin@anw.at>
> 
> Commit 828ee8c71950 ("media: uvcvideo: Use ktime_t for timestamps")
> changed to use ktime_t for timestamps. Older Kernels use a struct for
> ktime_t, which requires the conversion function ktime_to_ns to be used on
> some places. With this patch it will compile now also for older Kernel
> versions.
> 
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken into my tree for v4.17.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 5441553..1670aeb 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1009,7 +1009,7 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream,
> 
>  		buf->buf.field = V4L2_FIELD_NONE;
>  		buf->buf.sequence = stream->sequence;
> -		buf->buf.vb2_buf.timestamp = uvc_video_get_time();
> +		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
> 
>  		/* TODO: Handle PTS and SCR. */
>  		buf->state = UVC_BUF_STATE_ACTIVE;
> @@ -1191,7 +1191,8 @@ static void uvc_video_decode_meta(struct uvc_streaming
> *stream,
> 
>  	uvc_trace(UVC_TRACE_FRAME,
>  		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame
> SOF %u\n", -		  __func__, time, meta->sof, meta->length, meta->flags,
> +		  __func__, ktime_to_ns(time), meta->sof, meta->length,
> +		  meta->flags,
>  		  has_pts ? *(u32 *)meta->buf : 0,
>  		  has_scr ? *(u32 *)scr : 0,
>  		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);


-- 
Regards,

Laurent Pinchart
