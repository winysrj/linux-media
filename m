Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab2ENLa4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 07:30:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	linux-uvc-devel@lists.berlios.de,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] drivers:media:video:uvc: fix uvc_v4l2_get_unmapped_area for NOMMU
Date: Mon, 14 May 2012 13:31:03 +0200
Message-ID: <1463663.qyvIXF66SU@avalon>
In-Reply-To: <1336991039-15970-1-git-send-email-lliubbo@gmail.com>
References: <1336991039-15970-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bob,

On Monday 14 May 2012 18:23:59 Bob Liu wrote:
> Fix uvc_v4l2_get_unmapped_area() for NOMMU arch like blackfin after
> framework updated to use videobuf2.

Thank you for the patch, but I'm afraid you're too late. The fix is already 
queued for v3.5 :-)

> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> ---
>  drivers/media/video/uvc/uvc_queue.c |   30 ------------------------------
>  drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
>  2 files changed, 1 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_queue.c
> b/drivers/media/video/uvc/uvc_queue.c index 518f77d..30be060 100644
> --- a/drivers/media/video/uvc/uvc_queue.c
> +++ b/drivers/media/video/uvc/uvc_queue.c
> @@ -237,36 +237,6 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
>  	return allocated;
>  }
> 
> -#ifndef CONFIG_MMU
> -/*
> - * Get unmapped area.
> - *
> - * NO-MMU arch need this function to make mmap() work correctly.
> - */
> -unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
> -		unsigned long pgoff)
> -{
> -	struct uvc_buffer *buffer;
> -	unsigned int i;
> -	unsigned long ret;
> -
> -	mutex_lock(&queue->mutex);
> -	for (i = 0; i < queue->count; ++i) {
> -		buffer = &queue->buffer[i];
> -		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
> -			break;
> -	}
> -	if (i == queue->count) {
> -		ret = -EINVAL;
> -		goto done;
> -	}
> -	ret = (unsigned long)buf->mem;
> -done:
> -	mutex_unlock(&queue->mutex);
> -	return ret;
> -}
> -#endif
> -
>  /*
>   * Enable or disable the video buffers queue.
>   *
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 2ae4f88..506d3d6 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1067,7 +1067,7 @@ static unsigned long uvc_v4l2_get_unmapped_area(struct
> file *file,
> 
>  	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
> 
> -	return uvc_queue_get_unmapped_area(&stream->queue, pgoff);
> +	return vb2_get_unmapped_area(&stream->queue, addr, len, pgoff, flags);

Just for the record you would have needed to take the queue->mutex around the 
vb2_get_unmapped_area() call here.

>  }
>  #endif

-- 
Regards,

Laurent Pinchart

