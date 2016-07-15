Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46726
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbcGOTmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 15:42:42 -0400
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <57893C98.6040804@osg.samsung.com>
Date: Fri, 15 Jul 2016 13:42:16 -0600
MIME-Version: 1.0
In-Reply-To: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2016 10:26 AM, Javier Martinez Canillas wrote:
> The buffer planes' dma-buf are currently mapped when buffers are queued
> from userspace but it's more appropriate to do the mapping when buffers
> are queued in the driver since that's when the actual DMA operation are
> going to happen.
> 
> Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
> Hello,
> 
> A side effect of this change is that if the dmabuf map fails for some
> reasons (i.e: a driver using the DMA contig memory allocator but CMA
> not being enabled), the fail will no longer happen on VIDIOC_QBUF but
> later (i.e: in VIDIOC_STREAMON).
> 
> I don't know if that's an issue though but I think is worth mentioning.

How does this change impact the user applications.? This changes
the behavior and user applications now get dmabuf map error at a
later stage in the call sequence.

The change itself looks consistent with the change described.

-- Shuah

> 
> Best regards,
> Javier
> 
>  drivers/media/v4l2-core/videobuf2-core.c | 88 ++++++++++++++++++++------------
>  1 file changed, 54 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index ca8ffeb56d72..3fdf882bf279 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -186,7 +186,7 @@ module_param(debug, int, 0644);
>  })
>  
>  static void __vb2_queue_cancel(struct vb2_queue *q);
> -static void __enqueue_in_driver(struct vb2_buffer *vb);
> +static int __enqueue_in_driver(struct vb2_buffer *vb);
>  
>  /**
>   * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
> @@ -1271,20 +1271,6 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  		vb->planes[plane].mem_priv = mem_priv;
>  	}
>  
> -	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
> -	 * really we want to do this just before the DMA, not while queueing
> -	 * the buffer(s)..
> -	 */
> -	for (plane = 0; plane < vb->num_planes; ++plane) {
> -		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
> -		if (ret) {
> -			dprintk(1, "failed to map dmabuf for plane %d\n",
> -				plane);
> -			goto err;
> -		}
> -		vb->planes[plane].dbuf_mapped = 1;
> -	}
> -
>  	/*
>  	 * Now that everything is in order, copy relevant information
>  	 * provided by userspace.
> @@ -1296,51 +1282,79 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  		vb->planes[plane].data_offset = planes[plane].data_offset;
>  	}
>  
> -	if (reacquired) {
> -		/*
> -		 * Call driver-specific initialization on the newly acquired buffer,
> -		 * if provided.
> -		 */
> -		ret = call_vb_qop(vb, buf_init, vb);
> +	return 0;
> +err:
> +	/* In case of errors, release planes that were already acquired */
> +	__vb2_buf_dmabuf_put(vb);
> +
> +	return ret;
> +}
> +
> +/**
> + * __buf_map_dmabuf() - map dmabuf for buffer planes
> + */
> +static int __buf_map_dmabuf(struct vb2_buffer *vb)
> +{
> +	int ret;
> +	unsigned int plane;
> +
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
>  		if (ret) {
> -			dprintk(1, "buffer initialization failed\n");
> -			goto err;
> +			dprintk(1, "failed to map dmabuf for plane %d\n",
> +				plane);
> +			return ret;
>  		}
> +		vb->planes[plane].dbuf_mapped = 1;
> +	}
> +
> +	/*
> +	 * Call driver-specific initialization on the newly
> +	 * acquired buffer, if provided.
> +	 */
> +	ret = call_vb_qop(vb, buf_init, vb);
> +	if (ret) {
> +		dprintk(1, "buffer initialization failed\n");
> +		return ret;
>  	}
>  
>  	ret = call_vb_qop(vb, buf_prepare, vb);
>  	if (ret) {
>  		dprintk(1, "buffer preparation failed\n");
>  		call_void_vb_qop(vb, buf_cleanup, vb);
> -		goto err;
> +		return ret;
>  	}
>  
>  	return 0;
> -err:
> -	/* In case of errors, release planes that were already acquired */
> -	__vb2_buf_dmabuf_put(vb);
> -
> -	return ret;
>  }
>  
>  /**
>   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>   */
> -static void __enqueue_in_driver(struct vb2_buffer *vb)
> +static int __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned int plane;
> +	int ret;
>  
>  	vb->state = VB2_BUF_STATE_ACTIVE;
>  	atomic_inc(&q->owned_by_drv_count);
>  
>  	trace_vb2_buf_queue(q, vb);
>  
> +	if (q->memory == VB2_MEMORY_DMABUF) {
> +		ret = __buf_map_dmabuf(vb);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* sync buffers */
>  	for (plane = 0; plane < vb->num_planes; ++plane)
>  		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
>  
>  	call_void_vb_qop(vb, buf_queue, vb);
> +
> +	return 0;
>  }
>  
>  static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> @@ -1438,8 +1452,11 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	 * If any buffers were queued before streamon,
>  	 * we can now pass them to driver for processing.
>  	 */
> -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> -		__enqueue_in_driver(vb);
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		ret = __enqueue_in_driver(vb);
> +		if (ret < 0)
> +			return ret;
> +	}
>  
>  	/* Tell the driver to start streaming */
>  	q->start_streaming_called = 1;
> @@ -1540,8 +1557,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  	 * If already streaming, give the buffer to driver for processing.
>  	 * If not, the buffer will be given to driver on next streamon.
>  	 */
> -	if (q->start_streaming_called)
> -		__enqueue_in_driver(vb);
> +	if (q->start_streaming_called) {
> +		ret = __enqueue_in_driver(vb);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	/* Fill buffer information for the userspace */
>  	if (pb)
> 

