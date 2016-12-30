Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38862 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754035AbcL3NdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 08:33:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] uvcvideo: fix a wrong macro
Date: Fri, 30 Dec 2016 15:33:45 +0200
Message-ID: <1673828.sWRG4sRj5r@avalon>
In-Reply-To: <1481541412-1186-4-git-send-email-guennadi.liakhovetski@intel.com>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com> <1481541412-1186-4-git-send-email-guennadi.liakhovetski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Monday 12 Dec 2016 12:16:51 Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Don't mix up UVC_BUF_STATE_* and VB2_BUF_STATE_* codes.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree for v4.11.

> ---
>  drivers/media/usb/uvc/uvc_queue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index c119551..b9ef31c 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -412,7 +412,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct
> uvc_video_queue *queue, nextbuf = NULL;
>  	spin_unlock_irqrestore(&queue->irqlock, flags);
> 
> -	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
> +	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
>  	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
>  	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);

-- 
Regards,

Laurent Pinchart

