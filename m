Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34431 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2ABUSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 15:18:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 2/2] uvcvideo: Allow userptr IO mode.
Date: Mon, 2 Jan 2012 21:18:57 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1325513543-17299-1-git-send-email-javier.martin@vista-silicon.com> <1325513543-17299-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1325513543-17299-2-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201022118.59206.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thanks for the patch.

On Monday 02 January 2012 15:12:23 Javier Martin wrote:
> Userptr can be very useful if a UVC camera
> is requested to use video buffers allocated
> by another processing device. So that
> buffers don't need to be copied.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll push the patch through my tree when 1/2 will be acked.

> ---
>  drivers/media/video/uvc/uvc_queue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_queue.c
> b/drivers/media/video/uvc/uvc_queue.c index 518f77d..8f54e24 100644
> --- a/drivers/media/video/uvc/uvc_queue.c
> +++ b/drivers/media/video/uvc/uvc_queue.c
> @@ -126,7 +126,7 @@ void uvc_queue_init(struct uvc_video_queue *queue, enum
> v4l2_buf_type type, int drop_corrupted)
>  {
>  	queue->queue.type = type;
> -	queue->queue.io_modes = VB2_MMAP;
> +	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
>  	queue->queue.drv_priv = queue;
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;

-- 
Regards,

Laurent Pinchart
