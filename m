Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41369 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdHUJ3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 05:29:25 -0400
Subject: Re: [PATCH 1/7 v2] media: vb2: add bidirectional flag in vb2_queue
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <de7f1b28-378d-8f4e-17d4-0526f77bd1c9@samsung.com>
Date: Mon, 21 Aug 2017 11:29:19 +0200
MIME-version: 1.0
In-reply-to: <20170821090909.32614-1-stanimir.varbanov@linaro.org>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <20170818141606.4835-2-stanimir.varbanov@linaro.org>
        <CGME20170821090953epcas3p1121178ff7dbd3125a423a807c79ee33b@epcas3p1.samsung.com>
        <20170821090909.32614-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2017-08-21 11:09, Stanimir Varbanov wrote:
> This change is intended to give to the v4l2 drivers a choice to
> change the default behavior of the v4l2-core DMA mapping direction
> from DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or
> OUTPUT) to DMA_BIDIRECTIONAL during queue_init time.
>
> Initially the issue with DMA mapping direction has been found in
> Venus encoder driver where the hardware (firmware side) adds few
> lines padding on bottom of the image buffer, and the consequence
> is triggering of IOMMU protection faults.
>
> This will help supporting venus encoder (and probably other drivers
> in the future) which wants to map output type of buffers as
> read/write.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

This has been already discussed about a year ago, but it got lost in
meantime, probably due to lack of users. I hope that this time it
finally will get into vb2.

For the reference, see https://patchwork.kernel.org/patch/9388163/

> ---
> v2: move dma_dir into private section.
>
>   drivers/media/v4l2-core/videobuf2-core.c | 17 ++++++++---------
>   include/media/videobuf2-core.h           | 13 +++++++++++++
>   2 files changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 0924594989b4..cb115ba6a1d2 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
>   static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>   {
>   	struct vb2_queue *q = vb->vb2_queue;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>   	void *mem_priv;
>   	int plane;
>   	int ret = -ENOMEM;
> @@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>   
>   		mem_priv = call_ptr_memop(vb, alloc,
>   				q->alloc_devs[plane] ? : q->dev,
> -				q->dma_attrs, size, dma_dir, q->gfp_flags);
> +				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
>   		if (IS_ERR_OR_NULL(mem_priv)) {
>   			if (mem_priv)
>   				ret = PTR_ERR(mem_priv);
> @@ -978,8 +976,6 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>   	void *mem_priv;
>   	unsigned int plane;
>   	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>   	bool reacquired = vb->planes[0].mem_priv == NULL;
>   
>   	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1030,7 +1026,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>   		mem_priv = call_ptr_memop(vb, get_userptr,
>   				q->alloc_devs[plane] ? : q->dev,
>   				planes[plane].m.userptr,
> -				planes[plane].length, dma_dir);
> +				planes[plane].length, q->dma_dir);
>   		if (IS_ERR(mem_priv)) {
>   			dprintk(1, "failed acquiring userspace memory for plane %d\n",
>   				plane);
> @@ -1096,8 +1092,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>   	void *mem_priv;
>   	unsigned int plane;
>   	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>   	bool reacquired = vb->planes[0].mem_priv == NULL;
>   
>   	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1156,7 +1150,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>   		/* Acquire each plane's memory */
>   		mem_priv = call_ptr_memop(vb, attach_dmabuf,
>   				q->alloc_devs[plane] ? : q->dev,
> -				dbuf, planes[plane].length, dma_dir);
> +				dbuf, planes[plane].length, q->dma_dir);
>   		if (IS_ERR(mem_priv)) {
>   			dprintk(1, "failed to attach dmabuf\n");
>   			ret = PTR_ERR(mem_priv);
> @@ -2003,6 +1997,11 @@ int vb2_core_queue_init(struct vb2_queue *q)
>   	if (q->buf_struct_size == 0)
>   		q->buf_struct_size = sizeof(struct vb2_buffer);
>   
> +	if (q->bidirectional)
> +		q->dma_dir = DMA_BIDIRECTIONAL;
> +	else
> +		q->dma_dir = q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_queue_init);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index cb97c224be73..ef9b64398c8c 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -427,6 +427,16 @@ struct vb2_buf_ops {
>    * @dev:	device to use for the default allocation context if the driver
>    *		doesn't fill in the @alloc_devs array.
>    * @dma_attrs:	DMA attributes to use for the DMA.
> + * @bidirectional: when this flag is set the DMA direction for the buffers of
> + *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
> + *		This is useful in cases where the hardware (firmware) writes to
> + *		a buffer which is mapped as read (DMA_TO_DEVICE), or reads from
> + *		buffer which is mapped for write (DMA_FROM_DEVICE) in order
> + *		to satisfy some internal hardware restrictions or adds a padding
> + *		needed by the processing algorithm. In case the DMA mapping is
> + *		not bidirectional but the hardware (firmware) trying to access
> + *		the buffer (in the opposite direction) this could lead to an
> + *		IOMMU protection faults.
>    * @fileio_read_once:		report EOF after reading the first buffer
>    * @fileio_write_immediately:	queue buffer after each write() call
>    * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
> @@ -465,6 +475,7 @@ struct vb2_buf_ops {
>    * Private elements (won't appear at the uAPI book):
>    * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
>    * @memory:	current memory type used
> + * @dma_dir:	DMA mapping direction.
>    * @bufs:	videobuf buffer structures
>    * @num_buffers: number of allocated/used buffers
>    * @queued_list: list of buffers currently queued from userspace
> @@ -495,6 +506,7 @@ struct vb2_queue {
>   	unsigned int			io_modes;
>   	struct device			*dev;
>   	unsigned long			dma_attrs;
> +	unsigned			bidirectional:1;
>   	unsigned			fileio_read_once:1;
>   	unsigned			fileio_write_immediately:1;
>   	unsigned			allow_zero_bytesused:1;
> @@ -516,6 +528,7 @@ struct vb2_queue {
>   	/* private: internal use only */
>   	struct mutex			mmap_lock;
>   	unsigned int			memory;
> +	enum dma_data_direction		dma_dir;
>   	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
>   	unsigned int			num_buffers;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
