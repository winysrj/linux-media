Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50086 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2IZLre (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 07:47:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] uvc: Add return code check at vb2_queue_init()
Date: Wed, 26 Sep 2012 13:48:10 +0200
Message-ID: <2093441.dEigvJOvHo@avalon>
In-Reply-To: <1348659034-10880-1-git-send-email-elezegarcia@gmail.com>
References: <1348659034-10880-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 26 September 2012 08:30:34 Ezequiel Garcia wrote:
> This function returns an integer and it's mandatory
> to check the return code.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree, thank you.

> ---
> Changes from v1:
>  * Change variable name rc -> ret
>  * Add return 0 on successful uvc_queue_init
> 
>  drivers/media/usb/uvc/uvc_queue.c |   10 ++++++++--
>  drivers/media/usb/uvc/uvc_video.c |    4 +++-
>  drivers/media/usb/uvc/uvcvideo.h  |    2 +-
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index 5577381..18a91fa 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -122,21 +122,27 @@ static struct vb2_ops uvc_queue_qops = {
>  	.buf_finish = uvc_buffer_finish,
>  };
> 
> -void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
> +int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
> int drop_corrupted)
>  {
> +	int ret;
> +
>  	queue->queue.type = type;
>  	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
>  	queue->queue.drv_priv = queue;
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> -	vb2_queue_init(&queue->queue);
> +	ret = vb2_queue_init(&queue->queue);
> +	if (ret)
> +		return ret;
> 
>  	mutex_init(&queue->mutex);
>  	spin_lock_init(&queue->irqlock);
>  	INIT_LIST_HEAD(&queue->irqqueue);
>  	queue->flags = drop_corrupted ? UVC_QUEUE_DROP_CORRUPTED : 0;
> +
> +	return 0;
>  }
> 
>  /*
> ---------------------------------------------------------------------------
> -- diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 1c15b42..57c3076 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1755,7 +1755,9 @@ int uvc_video_init(struct uvc_streaming *stream)
>  	atomic_set(&stream->active, 0);
> 
>  	/* Initialize the video buffers queue. */
> -	uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
> +	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
> +	if (ret)
> +		return ret;
> 
>  	/* Alternate setting 0 should be the default, yet the XBox Live Vision
>  	 * Cam (and possibly other devices) crash or otherwise misbehave if
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 3764040..af216ec 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -600,7 +600,7 @@ extern struct uvc_driver uvc_driver;
>  extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
> 
>  /* Video buffers queue management. */
> -extern void uvc_queue_init(struct uvc_video_queue *queue,
> +extern int uvc_queue_init(struct uvc_video_queue *queue,
>  		enum v4l2_buf_type type, int drop_corrupted);
>  extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
>  		struct v4l2_requestbuffers *rb);
-- 
Regards,

Laurent Pinchart

