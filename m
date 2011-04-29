Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35930 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1D2IKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 04:10:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCH v4] media:uvc_driver: add uvc support on no-mmu arch
Date: Fri, 29 Apr 2011 10:10:34 +0200
Cc: linux-media@vger.kernel.org, dhowells@redhat.com,
	linux-uvc-devel@lists.berlios.de, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@maxwell.research.nokia.com,
	martin_rubli@logitech.com, jarod@redhat.com, tj@kernel.org,
	arnd@arndb.de, fweisbec@gmail.com, agust@denx.de, gregkh@suse.de,
	vapier@gentoo.org, daniel-gl@gmx.net
References: <1303463331-5024-1-git-send-email-lliubbo@gmail.com>
In-Reply-To: <1303463331-5024-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104291010.34858.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bob,

Thanks for the patch.

On Friday 22 April 2011 11:08:51 Bob Liu wrote:
> UVC driver used to have partial no-mmu arch support, but it's removed by
> commit c29fcff3daafbf46d64a543c1950bbd206ad8c1c.
> 
> This patch added them back and expanded to fully support no-mmu arch, so
> that uvc cameras can be used on no-mmu platforms like Blackfin.
> 
> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> ---
>  drivers/media/video/uvc/uvc_queue.c |   26 +++++++++++++++++++++++++-
>  drivers/media/video/uvc/uvc_v4l2.c  |   13 +++++++++++++
>  drivers/media/video/uvc/uvcvideo.h  |    6 ++++++
>  drivers/media/video/v4l2-dev.c      |   18 ++++++++++++++++++
>  include/media/v4l2-dev.h            |    2 ++
>  5 files changed, 64 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_queue.c
> b/drivers/media/video/uvc/uvc_queue.c index f14581b..caf8f6f 100644
> --- a/drivers/media/video/uvc/uvc_queue.c
> +++ b/drivers/media/video/uvc/uvc_queue.c
> @@ -424,7 +424,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue,
> struct vm_area_struct *vma) break;
>  	}
> 
> -	if (i == queue->count || size != queue->buf_size) {
> +	if (i == queue->count || PAGE_ALIGN(size) != queue->buf_size) {
>  		ret = -EINVAL;
>  		goto done;
>  	}
> @@ -436,6 +436,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue,
> struct vm_area_struct *vma) vma->vm_flags |= VM_IO;
> 
>  	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +#ifdef CONFIG_MMU
>  	while (size > 0) {
>  		page = vmalloc_to_page((void *)addr);
>  		if ((ret = vm_insert_page(vma, start, page)) < 0)
> @@ -445,6 +446,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue,
> struct vm_area_struct *vma) addr += PAGE_SIZE;
>  		size -= PAGE_SIZE;
>  	}
> +#endif
> 
>  	vma->vm_ops = &uvc_vm_ops;
>  	vma->vm_private_data = buffer;
> @@ -489,6 +491,28 @@ done:
>  }
> 
>  /*
> + * Get unmapped area.
> + *
> + * NO-MMU arch need this function to make mmap() work correctly.
> + */
> +unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
> +		unsigned long addr, unsigned long len, unsigned long pgoff)

Please guard this function with

#ifndef CONFIG_MMU

> +{
> +	struct uvc_buffer *buffer;
> +	unsigned int i;
> +
> +	mutex_lock(&queue->mutex);
> +	for (i = 0; i < queue->count; ++i) {
> +		buffer = &queue->buffer[i];
> +		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
> +			break;
> +	}

If pgoff doesn't correspond to any existing buffer, you will end up returning 
the address of the last buffer. Shouldn't you return an error instead ?

> +	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +	mutex_unlock(&queue->mutex);
> +	return addr;
> +}
> +
> +/*
>   * Enable or disable the video buffers queue.
>   *
>   * The queue must be enabled before starting video acquisition and must be
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 9005a8d..9efab61 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1081,6 +1081,18 @@ static unsigned int uvc_v4l2_poll(struct file *file,
> poll_table *wait) return uvc_queue_poll(&stream->queue, file, wait);
>  }

#ifndef CONFIG_MMU
> +static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
> +		unsigned long addr, unsigned long len, unsigned long pgoff,
> +		unsigned long flags)
> +{
> +	struct uvc_fh *handle = file->private_data;
> +	struct uvc_streaming *stream = handle->stream;
> +
> +	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
> +
> +	return uvc_queue_get_unmapped_area(&stream->queue, addr, len, pgoff);
> +}
#endif

>  const struct v4l2_file_operations uvc_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= uvc_v4l2_open,
> @@ -1089,5 +1101,6 @@ const struct v4l2_file_operations uvc_fops = {
>  	.read		= uvc_v4l2_read,
>  	.mmap		= uvc_v4l2_mmap,
>  	.poll		= uvc_v4l2_poll,
#ifndef CONFIG_MMU
> +	.get_unmapped_area = uvc_v4l2_get_unmapped_area,
#endif
>  };
> 
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 45f01e7..48a2378 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -580,6 +580,12 @@ extern int uvc_queue_mmap(struct uvc_video_queue
> *queue, struct vm_area_struct *vma);
>  extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
>  		struct file *file, poll_table *wait);
> +#ifdef CONFIG_MMU
> +#define uvc_queue_get_unmapped_area NULL
> +#else

And remove the CONFIG_MMU guard here.

> +extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue
> *queue, +		unsigned long addr, unsigned long len, unsigned long pgoff);
> +#endif
>  extern int uvc_queue_allocated(struct uvc_video_queue *queue);
>  static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
>  {
> diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c index 498e674..221e73f 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c

Please split the patch in two. The first part should be a revert of 
c29fcff3daafbf46d64a543c1950bbd206ad8c1c, the second one should be the 
uvcvideo code.

-- 
Regards,

Laurent Pinchart
