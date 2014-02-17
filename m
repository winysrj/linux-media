Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58535 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaBQAul (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 19:50:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH v5 4/7] uvcvideo: Tell the user space we're using start-of-exposure timestamps
Date: Mon, 17 Feb 2014 01:51:47 +0100
Message-ID: <10394831.kaUQ4S9NO6@avalon>
In-Reply-To: <1392497585-5084-5-git-send-email-sakari.ailus@iki.fi>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi> <1392497585-5084-5-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 15 February 2014 22:53:02 Sakari Ailus wrote:
> The UVC device provided timestamps are taken from the clock once the
> exposure of the frame has begun, not when the reception of the frame would
> have been finished as almost anywhere else. Show this to the user space by
> using V4L2_BUF_FLAG_TSTAMP_SRC_SOE buffer flag.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Strictly speaking that's not entirely true, as some devices don't bother 
reporting a hardware timestamp. However, in practice, most devices should 
behave correctly, so that flag is definitely better.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/usb/uvc/uvc_queue.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index cd962be..a9292d2 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -149,7 +149,8 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum
> v4l2_buf_type type, queue->queue.buf_struct_size = sizeof(struct
> uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> -	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;

-- 
Regards,

Laurent Pinchart

