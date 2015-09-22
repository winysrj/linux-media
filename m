Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37841 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbbIVOsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:48:52 -0400
Subject: Re: [RFC PATCH v5 7/8] media: videobuf2: Prepare to divide videobuf2
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-8-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56016A4E.50804@xs4all.nl>
Date: Tue, 22 Sep 2015 16:48:46 +0200
MIME-Version: 1.0
In-Reply-To: <1442928636-3589-8-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

This looks pretty good!

I have a few small comments below, but overall it is much improved.

On 22-09-15 15:30, Junghak Sung wrote:
> Prepare to divide videobuf2
> - Separate vb2 trace events from v4l2 trace event.
> - Make wrapper functions that will move to v4l2-side
> - Make vb2_core_* functions that remain in vb2 core side
> - Rename internal functions as vb2_*
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>  drivers/media/v4l2-core/Makefile         |    2 +-
>  drivers/media/v4l2-core/v4l2-trace.c     |    8 +-
>  drivers/media/v4l2-core/vb2-trace.c      |    9 +
>  drivers/media/v4l2-core/videobuf2-core.c |  556 ++++++++++++++++++++----------
>  include/trace/events/v4l2.h              |   28 +-
>  include/trace/events/vb2.h               |   65 ++++
>  6 files changed, 457 insertions(+), 211 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/vb2-trace.c
>  create mode 100644 include/trace/events/vb2.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index ad07401..1dc8bba 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -14,7 +14,7 @@ ifeq ($(CONFIG_OF),y)
>    videodev-objs += v4l2-of.o
>  endif
>  ifeq ($(CONFIG_TRACEPOINTS),y)
> -  videodev-objs += v4l2-trace.o
> +  videodev-objs += vb2-trace.o v4l2-trace.o
>  endif
>  
>  obj-$(CONFIG_VIDEO_V4L2) += videodev.o
> diff --git a/drivers/media/v4l2-core/v4l2-trace.c b/drivers/media/v4l2-core/v4l2-trace.c
> index 4004814..7416010 100644
> --- a/drivers/media/v4l2-core/v4l2-trace.c
> +++ b/drivers/media/v4l2-core/v4l2-trace.c
> @@ -5,7 +5,7 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/v4l2.h>
>  
> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_buf_done);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_buf_queue);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_dqbuf);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_qbuf);
> diff --git a/drivers/media/v4l2-core/vb2-trace.c b/drivers/media/v4l2-core/vb2-trace.c
> new file mode 100644
> index 0000000..61e74f5
> --- /dev/null
> +++ b/drivers/media/v4l2-core/vb2-trace.c
> @@ -0,0 +1,9 @@
> +#include <media/videobuf2-core.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/vb2.h>
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 32fa425..380536d 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -30,7 +30,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/videobuf2-v4l2.h>
>  
> -#include <trace/events/v4l2.h>
> +#include <trace/events/vb2.h>
>  
>  static int debug;
>  module_param(debug, int, 0644);
> @@ -612,10 +612,10 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  }
>  
>  /**
> - * __buffer_in_use() - return true if the buffer is in use and
> + * vb2_buffer_in_use() - return true if the buffer is in use and
>   * the queue cannot be freed (by the means of REQBUFS(0)) call
>   */
> -static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
> +static bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>  {
>  	unsigned int plane;
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> @@ -640,7 +640,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
>  {
>  	unsigned int buffer;
>  	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> -		if (__buffer_in_use(q, q->bufs[buffer]))
> +		if (vb2_buffer_in_use(q, q->bufs[buffer]))
>  			return true;
>  	}
>  	return false;
> @@ -650,8 +650,9 @@ static bool __buffers_in_use(struct vb2_queue *q)
>   * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
>   * returned to userspace
>   */
> -static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
> +static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)

Why use a void * here? Wouldn't a struct vb2_buffer pointer be better? That way it all
remains type-safe. Ditto elsewhere in this patch, of course.

>  {
> +	struct v4l2_buffer *b = pb;
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned int plane;
> @@ -742,8 +743,28 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  		break;
>  	}
>  
> -	if (__buffer_in_use(q, vb))
> +	if (vb2_buffer_in_use(q, vb))
>  		b->flags |= V4L2_BUF_FLAG_MAPPED;
> +
> +	return 0;
> +}
> +
> +/**
> + * vb2_core_querybuf() - query video buffer information
> + * @q:		videobuf queue
> + * @index:	id number of the buffer
> + * @pb:		buffer struct passed from userspace
> + *
> + * Should be called from vidioc_querybuf ioctl handler in driver.
> + * The passed buffer should have been verified.
> + * This function fills the relevant information for the userspace.
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_querybuf handler in driver.
> + */
> +static int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
> +{
> +	return __fill_v4l2_buffer(q->bufs[index], pb);
>  }
>  
>  /**
> @@ -775,11 +796,10 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	}
>  	vb = q->bufs[b->index];
>  	ret = __verify_planes_array(vb, b);
> -	if (!ret)
> -		__fill_v4l2_buffer(vb, b);
> -	return ret;
> +
> +	return ret ? ret : vb2_core_querybuf(q, b->index, b);
>  }
> -EXPORT_SYMBOL(vb2_querybuf);
> +EXPORT_SYMBOL_GPL(vb2_querybuf);

I prefer that such license changes are done in a separate patch. Now it is hidden
in a large patch, and others might want to jump in whether or not this is a
good thing.

>  
>  /**
>   * __verify_userptr_ops() - verify that all memory operations required for

<snip>

> @@ -2121,7 +2211,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>   * Will sleep if required for nonblocking == false.
>   */
>  static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
> -				struct v4l2_buffer *b, int nonblocking)
> +				int nonblocking)
>  {
>  	unsigned long flags;
>  	int ret;
> @@ -2142,10 +2232,10 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
>  	/*
>  	 * Only remove the buffer from done_list if v4l2_buffer can handle all
>  	 * the planes.
> +	 * Verifing planes is NOT necessary since it aleady has been checked

s/Verifing/Verifying/
s/aleady/already/

> +	 * before the buffer is queued/prepared. So it can never fails

s/fails/fail./

>  	 */
> -	ret = __verify_planes_array(*vb, b);
> -	if (!ret)
> -		list_del(&(*vb)->done_entry);
> +	list_del(&(*vb)->done_entry);
>  	spin_unlock_irqrestore(&q->done_lock, flags);
>  
>  	return ret;

<snip>

Regards,

	Hans
