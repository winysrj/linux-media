Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58600 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3CEJ2n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 04:28:43 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJ600HGWKXTUM60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Mar 2013 09:28:41 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MJ60053YKZRI090@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Mar 2013 09:28:41 +0000 (GMT)
Message-id: <5135BAC6.5050703@samsung.com>
Date: Tue, 05 Mar 2013 10:28:38 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Federico Vaga <federico.vaga@gmail.com>,
	Pawel Osciak <p.osciak@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] Adding additional flags when allocating buffer memory
References: <201303011944.00532.hverkuil@xs4all.nl>
In-reply-to: <201303011944.00532.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 3/1/2013 7:44 PM, Hans Verkuil wrote:
> Hi all,
>
> This patch is based on an idea from Federico:
>
> http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg24669.html
>
> While working on converting the solo6x10 driver to vb2 I realized that the
> same thing was needed for the dma-sg case: the solo6x10 has 32-bit PCI DMA,
> so you want to specify __GFP_DMA32 to prevent bounce buffers from being created.
>
> Rather than patching all drivers as the patch above does (error prone IMHO),
> I've decided to just add a gfp_flags field to vb2_queue and pass that to the
> alloc mem_op. The various alloc implementations will just OR it in.

I agree that the gfp_flags is needed. It should be there from the 
beginning,
but there is not DMA zone on our hardware and we missed that point. Our 
fault.
However IMHO the better place for gfp_flags is the allocator context 
structure
instead of vb2_queue. vb2_dma_contig_init_ctx() would need to be 
extended and
similar function should be added for dma sg.

This reminds me that dma sg allocator needs to be seriously cleaned up 
to match
the changes done in dma contig allocator from the beginning of its life. 
I have
some work-in-progress patches, but I didn't manage to finish them due to 
lack
of time...

> This is urgently needed for any driver with DMA32 restrictions (which are most
> PCI drivers).
>
> Comments?
>
> Regards,
>
> 	Hans
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index db1235d..adde3e6 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -57,7 +57,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>   	/* Allocate memory for all planes in this buffer */
>   	for (plane = 0; plane < vb->num_planes; ++plane) {
>   		mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
> -				      q->plane_sizes[plane]);
> +				      q->plane_sizes[plane], q->gfp_flags);
>   		if (IS_ERR_OR_NULL(mem_priv))
>   			goto free;
>   
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 10beaee..ae35d25 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -152,7 +152,7 @@ static void vb2_dc_put(void *buf_priv)
>   	kfree(buf);
>   }
>   
> -static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
> +static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
>   {
>   	struct vb2_dc_conf *conf = alloc_ctx;
>   	struct device *dev = conf->dev;
> @@ -165,7 +165,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
>   	/* align image size to PAGE_SIZE */
>   	size = PAGE_ALIGN(size);
>   
> -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
> +	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> +						GFP_KERNEL | gfp_flags);
>   	if (!buf->vaddr) {
>   		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>   		kfree(buf);
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 25c3b36..952776f 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -33,7 +33,7 @@ struct vb2_dma_sg_buf {
>   
>   static void vb2_dma_sg_put(void *buf_priv);
>   
> -static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
> +static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
>   {
>   	struct vb2_dma_sg_buf *buf;
>   	int i;
> @@ -60,7 +60,8 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
>   		goto fail_pages_array_alloc;
>   
>   	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
> -		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
> +		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
> +					   __GFP_NOWARN | gfp_flags);
>   		if (NULL == buf->pages[i])
>   			goto fail_pages_alloc;
>   		sg_set_page(&buf->sg_desc.sglist[i],
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index a47fd4f..313d977 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -35,11 +35,11 @@ struct vb2_vmalloc_buf {
>   
>   static void vb2_vmalloc_put(void *buf_priv);
>   
> -static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size)
> +static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
>   {
>   	struct vb2_vmalloc_buf *buf;
>   
> -	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL | gfp_flags);
>   	if (!buf)
>   		return NULL;
>   
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 9cfd4ee..251d66b 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -27,7 +27,9 @@ struct vb2_fileio_data;
>    *		return NULL on failure or a pointer to allocator private,
>    *		per-buffer data on success; the returned private structure
>    *		will then be passed as buf_priv argument to other ops in this
> - *		structure
> + *		structure. Additional gfp_flags to use when allocating the
> + *		are also passed to this operation. These flags are from the
> + *		gfp_flags field of vb2_queue.
>    * @put:	inform the allocator that the buffer will no longer be used;
>    *		usually will result in the allocator freeing the buffer (if
>    *		no other users of this buffer are present); the buf_priv
> @@ -79,7 +81,7 @@ struct vb2_fileio_data;
>    *				  unmap_dmabuf.
>    */
>   struct vb2_mem_ops {
> -	void		*(*alloc)(void *alloc_ctx, unsigned long size);
> +	void		*(*alloc)(void *alloc_ctx, unsigned long size, gfp_t gfp_flags);
>   	void		(*put)(void *buf_priv);
>   	struct dma_buf *(*get_dmabuf)(void *buf_priv);
>   
> @@ -302,6 +304,9 @@ struct v4l2_fh;
>    * @buf_struct_size: size of the driver-specific buffer structure;
>    *		"0" indicates the driver doesn't want to use a custom buffer
>    *		structure type, so sizeof(struct vb2_buffer) will is used
> + * @gfp_flags:	additional gfp flags used when allocating the buffers.
> + *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
> + *		to force the buffer allocation to a specific memory zone.
>    *
>    * @memory:	current memory type used
>    * @bufs:	videobuf buffer structures
> @@ -326,6 +331,7 @@ struct vb2_queue {
>   	const struct vb2_mem_ops	*mem_ops;
>   	void				*drv_priv;
>   	unsigned int			buf_struct_size;
> +	gfp_t				gfp_flags;
>   
>   /* private: internal use only */
>   	enum v4l2_memory		memory;
>

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


