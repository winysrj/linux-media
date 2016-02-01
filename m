Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38464 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbcBAN33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 08:29:29 -0500
Subject: Re: [PATCH v6 4/5] videobuf2-dc: Let drivers specify DMA attrs
To: Douglas Anderson <dianders@chromium.org>, linux@arm.linux.org.uk,
	mchehab@osg.samsung.com, robin.murphy@arm.com, tfiga@chromium.org
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
 <1452533428-12762-5-git-send-email-dianders@chromium.org>
Cc: pawel@osciak.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hch@infradead.org, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <56AF5DB5.6000402@samsung.com>
Date: Mon, 01 Feb 2016 14:29:25 +0100
MIME-version: 1.0
In-reply-to: <1452533428-12762-5-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2016-01-11 18:30, Douglas Anderson wrote:
> From: Tomasz Figa <tfiga@chromium.org>
>
> DMA allocations might be subject to certain reqiurements specific to the
> hardware using the buffers, such as availability of kernel mapping (for
> contents fix-ups in the driver). The only entity that knows them is the
> driver, so it must share this knowledge with vb2-dc.
>
> This patch extends the alloc_ctx initialization interface to let the
> driver specify DMA attrs, which are then stored inside the allocation
> context and will be used for all allocations with that context.
>
> As a side effect, all dma_*_coherent() calls are turned into
> dma_*_attrs() calls, because the attributes need to be carried over
> through all DMA operations.
>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> Changes in v6: None
> Changes in v5:
> - Let drivers specify DMA attrs new for v5
>
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 33 +++++++++++++++++---------
>   include/media/videobuf2-dma-contig.h           | 11 ++++++++-
>   2 files changed, 32 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index c33127284cfe..5361197f3e57 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -23,13 +23,16 @@
>   
>   struct vb2_dc_conf {
>   	struct device		*dev;
> +	struct dma_attrs	attrs;
>   };
>   
>   struct vb2_dc_buf {
>   	struct device			*dev;
>   	void				*vaddr;
>   	unsigned long			size;
> +	void				*cookie;
>   	dma_addr_t			dma_addr;
> +	struct dma_attrs		attrs;
>   	enum dma_data_direction		dma_dir;
>   	struct sg_table			*dma_sgt;
>   	struct frame_vector		*vec;
> @@ -131,7 +134,8 @@ static void vb2_dc_put(void *buf_priv)
>   		sg_free_table(buf->sgt_base);
>   		kfree(buf->sgt_base);
>   	}
> -	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
> +	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
> +			&buf->attrs);
>   	put_device(buf->dev);
>   	kfree(buf);
>   }
> @@ -147,14 +151,18 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
>   	if (!buf)
>   		return ERR_PTR(-ENOMEM);
>   
> -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> -						GFP_KERNEL | gfp_flags);
> -	if (!buf->vaddr) {
> +	buf->attrs = conf->attrs;
> +	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
> +					GFP_KERNEL | gfp_flags, &buf->attrs);
> +	if (!buf->cookie) {
>   		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>   		kfree(buf);
>   		return ERR_PTR(-ENOMEM);
>   	}
>   
> +	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->attrs))
> +		buf->vaddr = buf->cookie;
> +
>   	/* Prevent the device from being released while the buffer is used */
>   	buf->dev = get_device(dev);
>   	buf->size = size;
> @@ -185,8 +193,8 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
>   	 */
>   	vma->vm_pgoff = 0;
>   
> -	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
> -		buf->dma_addr, buf->size);
> +	ret = dma_mmap_attrs(buf->dev, vma, buf->cookie,
> +		buf->dma_addr, buf->size, &buf->attrs);
>   
>   	if (ret) {
>   		pr_err("Remapping memory failed, error: %d\n", ret);
> @@ -329,7 +337,7 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
>   {
>   	struct vb2_dc_buf *buf = dbuf->priv;
>   
> -	return buf->vaddr + pgnum * PAGE_SIZE;
> +	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
>   }
>   
>   static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
> @@ -368,8 +376,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
>   		return NULL;
>   	}
>   
> -	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> -		buf->size);
> +	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
> +		buf->size, &buf->attrs);
>   	if (ret < 0) {
>   		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
>   		kfree(sgt);
> @@ -721,7 +729,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
>   };
>   EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>   
> -void *vb2_dma_contig_init_ctx(struct device *dev)
> +void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
> +				    struct dma_attrs *attrs)
>   {
>   	struct vb2_dc_conf *conf;
>   
> @@ -730,10 +739,12 @@ void *vb2_dma_contig_init_ctx(struct device *dev)
>   		return ERR_PTR(-ENOMEM);
>   
>   	conf->dev = dev;
> +	if (attrs)
> +		conf->attrs = *attrs;
>   
>   	return conf;
>   }
> -EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
> +EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx_attrs);
>   
>   void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
>   {
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index c33dfa69d7ab..2087c9a68be3 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -16,6 +16,8 @@
>   #include <media/videobuf2-v4l2.h>
>   #include <linux/dma-mapping.h>
>   
> +struct dma_attrs;
> +
>   static inline dma_addr_t
>   vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>   {
> @@ -24,7 +26,14 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>   	return *addr;
>   }
>   
> -void *vb2_dma_contig_init_ctx(struct device *dev);
> +void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
> +				    struct dma_attrs *attrs);
> +
> +static inline void *vb2_dma_contig_init_ctx(struct device *dev)
> +{
> +	return vb2_dma_contig_init_ctx_attrs(dev, NULL);
> +}
> +
>   void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
>   
>   extern const struct vb2_mem_ops vb2_dma_contig_memops;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

